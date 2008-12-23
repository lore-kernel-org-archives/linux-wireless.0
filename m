Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:16903 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYLWTov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 14:44:51 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1015100fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 11:44:49 -0800 (PST)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: A couple of fixes to dynamic power save.
References: <20081223025735.GB11534@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 23 Dec 2008 21:44:44 +0200
In-Reply-To: <20081223025735.GB11534@myhost.users.atheros.com> (Vivek Natarajan's message of "Mon\, 22 Dec 2008 18\:57\:35 -0800")
Message-ID: <873agevfpv.fsf@litku.valot.fi> (sfid-20081223_204456_332404_F7AD0ED9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> a) hw_config() should not be called from siwpower() for the drivers which do not support
>    dynamic powersave.

I disagree. How else would we enable power save, for example for
iwlwifi? Power save should be enabled similarly for all drivers, I
have strong dislike of any sysfs hacks like iwlwifi has.

(Yes, I'm going to post patches about how iwlwifi should do it.)

> b) IEEE80211_HW_NO_STACK_DYNAMIC_PS needs to be verified in set_associated() also before
>    enabling the power save timers.

You are disabling more than timers here. More comments below.

> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/mlme.c |    3 ++-
>  net/mac80211/wext.c |    9 +++++----
>  2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c75d0ea..b23e62b 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -746,7 +746,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>  	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
>  	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
>  
> -	if (local->powersave) {
> +	if (local->powersave &&
> +			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
>  		if (local->dynamic_ps_timeout > 0)
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));

The test for IEEE80211_HW_NO_STACK_DYNAMIC_PS should be lower, we do
want to enable power save even if IEEE80211_HW_NO_STACK_DYNAMIC_PS is
set.

It should be something like this:

	if (local->powersave) {
		if ((local->dynamic_ps_timeout > 0) &&
			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS))
			mod_timer(&local->dynamic_ps_timer, jiffies +
				  msecs_to_jiffies(local->dynamic_ps_timeout));
		else {
			conf->flags |= IEEE80211_CONF_PS;
			ieee80211_hw_config(local,
					    IEEE80211_CONF_CHANGE_PS);
		}
	}


Your patch breaks the logic I was planning to have in mac80211.
Dynamic power save here basically means the timer running either in
mac80211 or in firmware, nothing else. If the firmware has such timer,
the driver can disable mac80211 timer with
IEEE80211_HW_NO_STACK_DYNAMIC_PS. For example, I'm planning to add
that flag to iwlwifi, it seems that Intel's firmware has this
functionality.

But having IEEE80211_HW_NO_STACK_DYNAMIC_PS set doesn't mean that the
driver does all power management itself. I have seen in iwlwifi checks
for association status before it enables power save, so it's better
that mac80211 enables IEEE80211_CONF_PS only after associated, despite
if IEEE80211_HW_NO_STACK_DYNAMIC_PS is set or not.

> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 7162d58..673c5d7 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -865,9 +865,9 @@ set:
>  	local->powersave = ps;
>  	local->dynamic_ps_timeout = timeout;
>  
> -	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
> -		if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
> -		    local->dynamic_ps_timeout > 0)
> +	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
> +			(sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
> +		if (local->dynamic_ps_timeout > 0)
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
>  		else {
> @@ -875,8 +875,9 @@ set:
>  				conf->flags |= IEEE80211_CONF_PS;
>  			else
>  				conf->flags &= ~IEEE80211_CONF_PS;
> +			ret = ieee80211_hw_config(local,
> +					IEEE80211_CONF_CHANGE_PS);
>  		}
> -		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>  	}

Looking at these changes it looks to me that widen the meaning of
IEEE80211_HW_NO_STACK_DYNAMIC_PS flag. I'm sorry, but I don't think
that's the correct way.

First, let's summarise what kind of power save implementations we
have:

1) null frame creation, dynamic timer and TIM parsing in mac80211:
   stlc45xx/p54, ath5/9k

2) null frame creation, dynamic timer and TIM parsing in firmware: iwlwifi

3) null frame creation and TIM parsing in firmware, dynamic timer in
   mac80211: I have heard about these :)

As you can see from above, dynamic power save should not mean anything
else than just about the timer. We should add a new flag which enables
mac80211 to create null frames and parse TIM values.

Oh yeah, there's also the multicast frames. ath5/9k requires host
disable power save for receiving the multicast frames, but
stlc45xx/p54 does this automatically without any host interaction.
Man, this is getting complicated :)

-- 
Kalle Valo

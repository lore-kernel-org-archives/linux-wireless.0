Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:45800 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZDAEPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 00:15:12 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3555950wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 21:15:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090302145030.GA4660@myhost.users.atheros.com>
References: <20090302145030.GA4660@myhost.users.atheros.com>
Date: Wed, 1 Apr 2009 09:45:10 +0530
Message-ID: <8e92b4100903312115l2f013083jf507b66f8449a63a@mail.gmail.com> (sfid-20090401_061516_790436_BCCC94C1)
Subject: Re: [PATCH] mac80211: Always send a null data frame if TIM bit is
	set.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 8:20 PM, Vivek Natarajan <vivek.natraj@gmail.com=
> wrote:
> If the AP thinks we are in power save state eventhough we are not tru=
ly
> in that state, it sets the TIM bit and does not send a data frame unl=
ess
> we send a null data frame to correct the state in the AP.
> This might happen if the null data frame for wake up is lost in the a=
ir
> after we disable power save.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
> =A0net/mac80211/mlme.c | =A0 =A03 +--
> =A01 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7f23858..ac10b21 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1457,8 +1457,7 @@ static void ieee80211_rx_mgmt_beacon(struct iee=
e80211_sub_if_data *sdata,
> =A0 =A0 =A0 =A0ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 elems=
=2Ewmm_param_len);
>
> - =A0 =A0 =A0 if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK &&
> - =A0 =A0 =A0 =A0 =A0 local->hw.conf.flags & IEEE80211_CONF_PS) {
> + =A0 =A0 =A0 if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0directed_tim =3D ieee80211_check_tim(&=
elems, ifmgd->aid);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (directed_tim) {
	                 if (local->hw.conf.dynamic_ps_timeout > 0) {
				local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
				ieee80211_hw_config(local,
						    IEEE80211_CONF_CHANGE_PS);
				ieee80211_send_nullfunc(local, sdata, 0);
			} else {
				local->pspolling =3D true;
				ieee80211_send_pspoll(local, sdata);

Although the above patch is a right approach, it opens up an issue
with pspolling.

In the above chunk of code, if the timeout is zero, instead of sending
a null frame to
correct the state in the AP, we may keep on sending ps poll frames (
And the ps state
in the AP will never be corrected)

I have not tested pspolling with ath9k. But this seems to be an issue.
Thoughts?

VIvek.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

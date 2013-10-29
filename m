Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58834 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J2S4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:56:24 -0400
Received: by mail-oa0-f47.google.com with SMTP id i1so348469oag.20
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:56:23 -0700 (PDT)
Message-ID: <527004D5.8050009@lwfinger.net> (sfid-20131029_195627_744665_8C9E8A5D)
Date: Tue, 29 Oct 2013 13:56:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linville@tuxdriver.com, johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 3/3] rtlwifi: fix usage of freq_reg_info()
References: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com> <1383071666-26817-4-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1383071666-26817-4-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2013 01:34 PM, Luis R. Rodriguez wrote:
> freq_reg_info() expects KHz and not MHz, fix this. In
> this case we'll now be getting the no-ir flags cleared
> on channels for any channel when the country IE trusts
> that channel.
>
> @@
> struct ieee80211_channel *ch;
> struct wiphy *wiphy;
> const struct ieee80211_reg_rule *rule;
> @@
>
> -rule = freq_reg_info(wiphy, ch->center_freq);
> +rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
>
> Generated-by: Coccinelle SmPL
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Cc: Peter Senna Tschudin <peter.senna@gmail.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Mihir Shete <smihir@qti.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---

This patch got some fuzz on my system in hunks 2 & 3 and failed "git am". With 
patch, it yielded correct code despite the fuzz.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>   drivers/net/wireless/rtlwifi/regd.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
> index 2e1642c..29d2813 100644
> --- a/drivers/net/wireless/rtlwifi/regd.c
> +++ b/drivers/net/wireless/rtlwifi/regd.c
> @@ -169,7 +169,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
>   			    (ch->flags & IEEE80211_CHAN_RADAR))
>   				continue;
>   			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
> -				reg_rule = freq_reg_info(wiphy, ch->center_freq);
> +				reg_rule = freq_reg_info(wiphy,
> +							 MHZ_TO_KHZ(ch->center_freq));
>   				if (IS_ERR(reg_rule))
>   					continue;
>
> @@ -228,7 +229,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
>   	 */
>
>   	ch = &sband->channels[11];	/* CH 12 */
> -	reg_rule = freq_reg_info(wiphy, ch->center_freq);
> +	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
>   	if (!IS_ERR(reg_rule)) {
>   		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
>   			if (ch->flags & IEEE80211_CHAN_NO_IR)
> @@ -236,7 +237,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
>   	}
>
>   	ch = &sband->channels[12];	/* CH 13 */
> -	reg_rule = freq_reg_info(wiphy, ch->center_freq);
> +	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
>   	if (!IS_ERR(reg_rule)) {
>   		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
>   			if (ch->flags & IEEE80211_CHAN_NO_IR)
>


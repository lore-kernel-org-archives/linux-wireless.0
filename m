Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4655 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3J3JLG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 05:11:06 -0400
Message-ID: <5270CCF2.70407@broadcom.com> (sfid-20131030_101113_771452_135C6B60)
Date: Wed, 30 Oct 2013 10:10:10 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linville@tuxdriver.com, johannes@sipsolutions.net
cc: linux-wireless@vger.kernel.org,
	"Julia Lawall" <julia.lawall@lip6.fr>,
	"Peter Senna Tschudin" <peter.senna@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: [PATCH 2/3] brcm80211: fix usage of freq_reg_info()
References: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
 <1383071666-26817-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1383071666-26817-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2013 07:34 PM, Luis R. Rodriguez wrote:
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
> Cc: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Arend van Spriel <arend@broadcom.com>

> Reported-by: Mihir Shete <smihir@qti.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/channel.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index c99364f..8272570 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> @@ -678,7 +678,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
>   				continue;
>
>   			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
> -				rule = freq_reg_info(wiphy, ch->center_freq);
> +				rule = freq_reg_info(wiphy,
> +						     MHZ_TO_KHZ(ch->center_freq));
>   				if (IS_ERR(rule))
>   					continue;
>
>



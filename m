Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2686 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab3HGKpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 06:45:19 -0400
Message-ID: <5202252C.6030802@broadcom.com> (sfid-20130807_124522_412379_1841EF08)
Date: Wed, 7 Aug 2013 12:45:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [PATCH] brcmfmac: use CFG80211_TESTMODE_CMD
References: <1375780399-1120-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1375780399-1120-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2013 11:13 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This is essentially the same, but written shorter.

I would have expected the macro to be called NL80211.. but no real 
preference. So you can add

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index b7d8850..f393828 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -4163,9 +4163,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
>   	.stop_p2p_device = brcmf_p2p_stop_device,
>   	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
>   	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
> -#ifdef CONFIG_NL80211_TESTMODE
> -	.testmode_cmd = brcmf_cfg80211_testmode
> -#endif
> +	CFG80211_TESTMODE_CMD(brcmf_cfg80211_testmode)
>   };
>
>   static s32 brcmf_nl80211_iftype_to_mode(enum nl80211_iftype type)
>



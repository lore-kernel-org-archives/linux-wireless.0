Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59022 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbbBHJj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 04:39:27 -0500
Message-ID: <54D72ECB.4000705@broadcom.com> (sfid-20150208_103933_331294_30B58DB9)
Date: Sun, 8 Feb 2015 10:39:23 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFT] brcmfmac: respect reason when deleting (deauthenticating)
 STA
References: <1423347787-8557-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1423347787-8557-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/15 23:23, Rafał Miłecki wrote:
>
Could say in commit message that reason is provided by cfg80211.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> index b59b8c6..a23bfaa 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> @@ -4272,7 +4272,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
>   		return -EIO;
>
>   	memcpy(&scbval.ea, params->mac, ETH_ALEN);
> -	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
> +	scbval.val = cpu_to_le32(params->reason_code);
>   	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
>   				&scbval, sizeof(scbval));
>   	if (err)


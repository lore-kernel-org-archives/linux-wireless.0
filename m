Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:19776 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbFALrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 07:47:45 -0400
Message-ID: <556C4658.7020007@broadcom.com> (sfid-20150601_134748_272009_F809BE3F)
Date: Mon, 1 Jun 2015 13:47:36 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: set wiphy perm_addr to hardware MAC address
References: <1433033546-19214-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1433033546-19214-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/15 02:52, Rafał Miłecki wrote:
> This allows e.g. user space to use /sys/class/ieee80211/*/macaddress

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> index 6fe2b75..955dd0a 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
> @@ -6071,6 +6071,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>   		brcmf_err("Could not allocate wiphy device\n");
>   		return NULL;
>   	}
> +	memcpy(wiphy->perm_addr, drvr->mac, ETH_ALEN);
>   	set_wiphy_dev(wiphy, busdev);
>
>   	cfg = wiphy_priv(wiphy);


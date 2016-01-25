Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:19521 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbcAYJwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 04:52:36 -0500
Subject: Re: [PATCH] brcmfmac: advertise frames supported for TX in AP mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
References: <1453295190-28404-1-git-send-email-zajec5@gmail.com>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <56A5F060.6050306@broadcom.com> (sfid-20160125_105239_451384_97A69791)
Date: Mon, 25 Jan 2016 10:52:32 +0100
MIME-Version: 1.0
In-Reply-To: <1453295190-28404-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20-1-2016 14:06, Rafał Miłecki wrote:
> Callback mgmt_tx implementation supports both: PROBE_RESP and ACTION.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This matches code I can see in brcmf_cfg80211_mgmt_tx, hope it makes
> sense.

As said in another response [1] this function was added for P2P
functionality. Hence I do not feel comfortable adding this patch without
subsequent testing.

Regards,
Arend

[1] http://mid.gmane.org/56A5EFBD.5070400@broadcom.com

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index ab431e5..8d9cff4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5948,6 +5948,10 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
>  		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>  		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
>  	},
> +	[NL80211_IFTYPE_AP] = {
> +		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
> +		      BIT(IEEE80211_STYPE_PROBE_RESP >> 4)
> +	},
>  	[NL80211_IFTYPE_P2P_CLIENT] = {
>  		.tx = 0xffff,
>  		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
> 

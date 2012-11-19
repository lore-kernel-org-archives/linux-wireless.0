Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3125 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab2KSRjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 12:39:19 -0500
Message-ID: <50AA6EBF.9050001@broadcom.com> (sfid-20121119_183922_910159_C3D90215)
Date: Mon, 19 Nov 2012 18:39:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Fengguang Wu" <fengguang.wu@intel.com>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH] brcmfmac: check return from kzalloc in
 brcmf_fweh_process_event
References: <1353340412-22757-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1353340412-22757-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 04:53 PM, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> index 1e4188c..fa8fc44 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> @@ -494,6 +494,9 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
>   		alloc_flag = GFP_ATOMIC;
>
>   	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
> +	if (!event)

My fix included a debug statement about the discarded event from firmware.

> +		return;
> +
>   	event->code = code;
>   	event->ifidx = *ifidx;
>
>

I will deal with the merge so:

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


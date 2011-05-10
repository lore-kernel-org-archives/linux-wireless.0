Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3059 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1EJKHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 06:07:16 -0400
Message-ID: <4DC90E45.2010703@broadcom.com> (sfid-20110510_120721_017508_1D343244)
Date: Tue, 10 May 2011 12:07:01 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	devel <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: brcmfmac: Fix memset using
 sizeof(ptr) not sizeof(*ptr)
References: <1304956289.19586.35.camel@Joe-Laptop>
In-Reply-To: <1304956289.19586.35.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nice catch!

Acked-by: Roland Vossen <rvossen@broadcom.com>

On 05/09/2011 05:51 PM, Joe Perches wrote:
> Found via coccinelle script
>
> @@
> type T;
> T* ptr;
> expression E1;
> @@
>
> * memset(E1, 0, sizeof(ptr));
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   drivers/staging/brcm80211/brcmfmac/wl_iw.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> index a16b46c..4b810ed 100644
> --- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> +++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
> @@ -498,9 +498,7 @@ wl_iw_get_range(struct net_device *dev,
>   	list = (wl_u32_list_t *) channels;
>
>   	dwrq->length = sizeof(struct iw_range);
> -	memset(range, 0, sizeof(range));
> -
> -	range->min_nwid = range->max_nwid = 0;
> +	memset(range, 0, sizeof(*range));
>
>   	list->count = cpu_to_le32(MAXCHANNEL);
>   	error = dev_wlc_ioctl(dev, WLC_GET_VALID_CHANNELS, channels,
>
>
>



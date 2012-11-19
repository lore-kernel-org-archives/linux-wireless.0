Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KSSr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:47:29 -0500
Message-ID: <50AA7EA6.9050905@broadcom.com> (sfid-20121119_194733_041931_CE8AA401)
Date: Mon, 19 Nov 2012 19:47:02 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 06/22] brcmsmac: Remove internal tx queue
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-7-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-7-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:07 PM, Seth Forshee wrote:
> The brcmsmac internal tx buffering is problematic. The amount of
> buffering is excessive (228 packets in addition to the 256 slots in each
> DMA ring), and frames may be dropped due to a lack of flow control.
>
> This patch reworks the transmit code path to remove the internal
> buffering. Frames are immediately handed off to the DMA support rather
> than passing through an intermediate queue. Non-aggregate frames are
> queued immediately into the tx rings, and aggregate frames are queued
> temporarily in an AMPDU session until ready for transmit.
>
> Transmit flow control is also added to avoid dropping packets when the
> tx rings are full. Conceptually this is a separate change, but it's
> included in this commit because removing the tx queue without adding
> flow control could cause significant problems.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  167 +--------
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |    3 -
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  189 ++++++++--
>   drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    9 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |  459 ++++++++---------------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h  |   33 +-
>   drivers/net/wireless/brcm80211/brcmsmac/pub.h   |   13 -
>   drivers/net/wireless/brcm80211/brcmsmac/types.h |    1 -
>   8 files changed, 316 insertions(+), 558 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 8abf39d..2b8987c 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -303,6 +304,18 @@ static const u8 wme_ac2fifo[] = {
>   	TX_AC_BK_FIFO
>   };
>
> +/* 802.1D Priority to precedence queue mapping */
> +const u8 wlc_prio2prec_map[] = {
> +	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
> +	_BRCMS_PREC_BK,		/* 1 BK - Background */
> +	_BRCMS_PREC_NONE,		/* 2 None = - */
> +	_BRCMS_PREC_EE,		/* 3 EE - Excellent-effort */
> +	_BRCMS_PREC_CL,		/* 4 CL - Controlled Load */
> +	_BRCMS_PREC_VI,		/* 5 Vi - Video */
> +	_BRCMS_PREC_VO,		/* 6 Vo - Voice */
> +	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
> +};
> +

The wlc_prio2prec_map was removed in patch 06/22. Some reordering of 
commits gone wrong here?

>   static const u16 xmtfifo_sz[][NFIFO] = {
>   	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
>   	{20, 192, 192, 21, 17, 5},



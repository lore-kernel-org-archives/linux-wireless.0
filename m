Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:46893 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762560Ab3DCRS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 13:18:29 -0400
Message-ID: <515C63E4.7020506@iki.fi> (sfid-20130403_191833_203252_F11F6030)
Date: Wed, 03 Apr 2013 20:16:20 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/4] rtlwifi: usb: improve RX performance and lower CPU
 usage
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
In-Reply-To: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any comments on this patchset?

On 17.03.2013 11:59, Jussi Kivilinna wrote:
> Patchset improves RX path handling in rtlwifi/usb.c by:
>  - change to use preallocated DMA coherent URB buffers.
>  - kill unnessasary skbuff copies.
>  - defer RX processing to tasklet.
>  - add proper alignment of skbuff early on.
> 
> With this patchset IRQ CPU usage drops from 37% to 25% on ARM system with
> 1Ghz Cortex-A8, when doing large transfer with rtl8192cu. Tranfer speed
> appears to be slightly improved too, from 29Mbit to 31Mbit.
> 
> ---
> 
> Jussi Kivilinna (4):
>       rtlwifi: usb: use usb_alloc_coherent for RX buffers
>       rtlwifi: usb: remove extra skb copy on RX path
>       rtlwifi: usb: defer rx processing to tasklet
>       rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when needed
> 
> 
>  drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2
>  drivers/net/wireless/rtlwifi/usb.c           |  220 ++++++++++++++++++--------
>  drivers/net/wireless/rtlwifi/usb.h           |    5 -
>  3 files changed, 156 insertions(+), 71 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


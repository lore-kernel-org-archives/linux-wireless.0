Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47240 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S938769AbcKXNQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 08:16:53 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Nishant Sarmukadam <nishants@marvell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH] mwifiex: pcie: implement timeout loop for FW programming
 doorbell
Date: Thu, 24 Nov 2016 13:16:37 +0000
Message-ID: <7c71dfb4c8c74c318e95a2bb2baecbe2@SC-EXCH04.marvell.com> (sfid-20161124_141741_967921_B122C1D0)
References: <1479868785-16263-1-git-send-email-briannorris@chromium.org>
In-Reply-To: <1479868785-16263-1-git-send-email-briannorris@chromium.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, November 23, 2016 8:10 AM
> To: Amitkumar Karwar; Nishant Sarmukadam
> Cc: linux-kernel@vger.kernel.org; Kalle Valo; linux-
> wireless@vger.kernel.org; Cathy Luo; Dmitry Torokhov; Brian Norris
> Subject: [PATCH] mwifiex: pcie: implement timeout loop for FW
> programming doorbell
> 
> Marvell Wifi PCIe modules don't always behave nicely for PCIe power
> management when their firmware hasn't been loaded, particularly after
> suspending the PCIe link one or more times. When this happens, we might
> end up spinning forever in this status-polling tight loop. Let's make
> this less tight by adding a timeout and by sleeping a bit in between
> reads, as we do with the other similar loops.
> 
> This prevents us from hogging a CPU even in such pathological cases,
> and allows the FW initialization to just fail gracefully instead.
> 
> I chose the same polling parameters as the earlier loop in this
> function, and empirically, I found that this loop never makes it more
> than about 12 cycles in a sane FW init sequence. I had no official
> information on the actual intended latency for this portion of the
> download.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 4b89f557d0b6..9f9ea1350591 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2050,7 +2050,7 @@ static int mwifiex_prog_fw_w_helper(struct
> mwifiex_adapter *adapter,
>  		}
> 
>  		/* Wait for the command done interrupt */
> -		do {
> +		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
>  			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
>  					     &ireg_intr)) {
>  				mwifiex_dbg(adapter, ERROR,
> @@ -2062,8 +2062,18 @@ static int mwifiex_prog_fw_w_helper(struct
> mwifiex_adapter *adapter,
>  				ret = -1;
>  				goto done;
>  			}
> -		} while ((ireg_intr & CPU_INTR_DOOR_BELL) ==
> -			 CPU_INTR_DOOR_BELL);
> +			if (!(ireg_intr & CPU_INTR_DOOR_BELL))
> +				break;
> +			usleep_range(10, 20);
> +		}
> +		if (ireg_intr & CPU_INTR_DOOR_BELL) {
> +			mwifiex_dbg(adapter, ERROR, "%s: Card failed to ACK
> download\n",
> +				    __func__);
> +			mwifiex_unmap_pci_memory(adapter, skb,
> +						 PCI_DMA_TODEVICE);
> +			ret = -1;
> +			goto done;
> +		}
> 
>  		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
> 

Patch looks fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar

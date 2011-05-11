Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65179 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab1EKQ2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:28:31 -0400
Received: by bwz15 with SMTP id 15so581945bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:28:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtlwifi: Fix panic due to memory allocation failure
Date: Wed, 11 May 2011 18:28:25 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
References: <4dcab6af.skkZ1nWg46gP0cdM%Larry.Finger@lwfinger.net>
In-Reply-To: <4dcab6af.skkZ1nWg46gP0cdM%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105111828.26261.chunkeey@googlemail.com> (sfid-20110511_182856_975818_D4E5542B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 May 2011 18:17:51 Larry Finger wrote:
> The PCI routine of this driver is allocating receive buffers of order 2,
> which causes an unnecessary fragmentation of memory. To make matters
> worse, there are locations that fail to check for allocation failures,
> or return success when the allocation actually failed. Kernel panics
> result.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>              [2.6.37 and 2.6.38]
> ---
> 
> John,
> 
> This is 2.6.39 material. I hope we make the cutoff.
> 
> Larry
> ---
> 
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
> @@ -996,7 +998,7 @@ static void _rtl_pci_init_trx_var(struct
>  	 */
>  	rtlpci->txringcount[BE_QUEUE] = RT_TXDESC_NUM_BE_QUEUE;
>  
> -	rtlpci->rxbuffersize = 9100;	/*2048/1024; */
> +	rtlpci->rxbuffersize = 4096;
>  	rtlpci->rxringcount = RTL_PCI_MAX_RX_COUNT;	/*64; */
>  }
>
Are you sure this change won't break 8k AMSDU rx?
[or is there some magic that disables disable_amsdu_8k
for pci devices?]

Regards,
	Chr

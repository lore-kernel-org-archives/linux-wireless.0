Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36605 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdINSFI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 14:05:08 -0400
Subject: Re: RTL8192EE PCIe Wireless Network Adapter crashed with linux-4.13
To: Zwindl <zwindl@protonmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "chaoming_li@realsil.com.cn" <chaoming_li@realsil.com.cn>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "pkshih@realtek.com" <pkshih@realtek.com>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <2WhCEttl4IJtrTB2AkJYmhbsu-kiR_5fU0A_Z7eWW05rbVE5tB86A_ZS8ek_FQFdgaZw1bfx0wFbxOa0Ydjv1T6BzBkIHtaWTbSptcpB_kg=@protonmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e8e75755-f8b4-e122-ea4a-99a691405d38@lwfinger.net> (sfid-20170914_200523_807959_1627D26B)
Date: Thu, 14 Sep 2017 13:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <2WhCEttl4IJtrTB2AkJYmhbsu-kiR_5fU0A_Z7eWW05rbVE5tB86A_ZS8ek_FQFdgaZw1bfx0wFbxOa0Ydjv1T6BzBkIHtaWTbSptcpB_kg=@protonmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 08:30 AM, Zwindl wrote:
> Dear developers:
> I'm using Arch Linux with testing enabled, the current kernel version and 
> details are
> `Linux zwindl 4.13.2-1-ARCH #1 SMP PREEMPT Thu Sep 14 02:57:34 UTC 2017 x86_64 
> GNU/Linux`.
> The wireless card can't work properly from the kernel 4.13. Here's the log(in 
> attachment) when NetworkManager trying to connect my wifi which is named as 
> 'TP', my mac addr hided as xx:xx:xx:xx:xx.
> What should I provide to help to debug?
> ZWindL.

The BUG-ON arises in __intel_map_single() due to dir (for direction of DMA) 
equal to DMA_NONE (3). When rtl8192ee calls pci_map_single(), it uses 
PCI_DMA_TODEVICE (1). I followed the calling sequence through the entire chain, 
and none of the routines made any changes to 'dir', other that changing the type 
from int to enum dma_data_direction. That would not have changed a 1 to a 3.

I built a 4.13.2 system. The problem does not happen here. At this point, the 
system has been up for about two hours. I did discover a small memory leak 
associated with firmware loading, but that should not have caused the problem. 
Nonetheless, I will be sending a patch to fix that problem.

I will continue testing, although I doubt that the problem will happen here.

How long had your system been up when the problem occurred? Your dmesg fragment 
did not show any times. What kernels have you tried besides 4.13.2?

Larry

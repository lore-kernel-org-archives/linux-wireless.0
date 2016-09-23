Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:60264 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1034492AbcIWSMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 14:12:30 -0400
Message-ID: <1474654333.1849.5.camel@perches.com> (sfid-20160923_201234_131283_B362EE10)
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jean Delvare <jdelvare@suse.de>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
References: <20160922115116.149c599c@endymion>
         <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 23 Sep 2016 11:12:13 -0700
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-22 at 10:09 -0500, Larry Finger wrote:
> On 09/22/2016 04:51 AM, Jean Delvare wrote:
> Hello,
> 
> 
> I bought an Asus PCE-N10 PCIe Wi-Fi N card to install in my wife's
> computer. This morning it stopped working suddenly. Investigating the
> kernel logs, the following error message caught my eye:
> 
> 
> rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
> 
> 
> It was printed twice, 3.5 hours apart, the second time at the moment
> the network stopped working. I guess this is not supposed to happen.
> What additional information can I provide to help you debug the issue?
> That's the device:
> 
> 
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> 	Subsystem: ASUSTeK Computer Inc. Device [1043:84b5]
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
> 	I/O ports at e800 [size=256]
> 	Memory at febfc000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: rtl8192ce
> 	Kernel modules: rtl8192ce
> 
> 
> Kernel version is 4.5.4-1-default x86_64 (openSUSE Tumbleweed.)
> 
> 
> Reloading the rtl8192ce module and restarting the network service got
> everything back up.
> 
> 
> 
> 
> Unfortunately, that message is not as helpful as it might be.
> 
> 
> Do you build your own kernel, or are you using openSUSE's supplied version? If 
> the latter, I will need to think how we might debug the issue. If the former, 
> please add the attached patch.

It might be better to add the switch value to all the
RT_TRACE(,,,"switch case not processed\n"); uses in
drivers/net/wireless/realtek/rtlwifi/

I'll send a patch.

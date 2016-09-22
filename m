Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53837 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935013AbcIVRFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 13:05:44 -0400
Date: Thu, 22 Sep 2016 19:05:40 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
Message-ID: <20160922190540.08bf6335@endymion> (sfid-20160922_190547_130653_A3335C8B)
In-Reply-To: <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
References: <20160922115116.149c599c@endymion>
        <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Sep 2016 10:09:58 -0500, Larry Finger wrote:
> On 09/22/2016 04:51 AM, Jean Delvare wrote:
> > Hello,
> >
> > I bought an Asus PCE-N10 PCIe Wi-Fi N card to install in my wife's
> > computer. This morning it stopped working suddenly. Investigating the
> > kernel logs, the following error message caught my eye:
> >
> > rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
> >
> > It was printed twice, 3.5 hours apart, the second time at the moment
> > the network stopped working. I guess this is not supposed to happen.
> > What additional information can I provide to help you debug the issue?
> > That's the device:
> >
> > 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> > 	Subsystem: ASUSTeK Computer Inc. Device [1043:84b5]
> > 	Flags: bus master, fast devsel, latency 0, IRQ 17
> > 	I/O ports at e800 [size=256]
> > 	Memory at febfc000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: <access denied>
> > 	Kernel driver in use: rtl8192ce
> > 	Kernel modules: rtl8192ce
> >
> > Kernel version is 4.5.4-1-default x86_64 (openSUSE Tumbleweed.)
> >
> > Reloading the rtl8192ce module and restarting the network service got
> > everything back up.
> 
> Unfortunately, that message is not as helpful as it might be.
> 
> Do you build your own kernel, or are you using openSUSE's supplied version? If 
> the latter, I will need to think how we might debug the issue. If the former, 
> please add the attached patch.

I'm a kernel dev :-) I'll test your patch and report, thanks.

That being said, I agree it's better if drivers have useful debug
messages... Makes things faster. So something like your patch should go
upstream anyway. And the same improvement could be applied to various
other messages of the rtlwifi driver family.

-- 
Jean Delvare
SUSE L3 Support

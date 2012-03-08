Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40918 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CHCRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 21:17:00 -0500
Received: by ghrr11 with SMTP id r11so2486ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 18:17:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
Date: Thu, 8 Mar 2012 10:16:59 +0800
Message-ID: <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com> (sfid-20120308_031729_116381_6AC50497)
Subject: Re: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

log:
[53614.238023] Compat-wireless backport release: compat-wireless-v3.2-1-s
[53614.244729] Backport based on linux-stable.git v3.2
[53614.368074] alg: No test for arc4 (arc4-generic)
[53614.402781] cfg80211: Calling CRDA to update world regulatory domain
[53614.498603] rtl8192cu 3-3:1.0: usb_probe_interface
[53614.503552] rtl8192cu 3-3:1.0: usb_probe_interface - got id
[53614.509920] rtl8192cu: rtl8192cu: Chip version 0x11
[53615.359336] rtl8192cu: MAC address: 08:10:74:f1:a1:0f
[53615.364575] rtl8192cu: Board Type 0
[53615.400583] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[53615.408918] usbcore: registered new interface driver rtl8192cu
[53652.483311] rtl8192cu: MAC auto ON okay!
[53652.887348] rtl8192cu: Tx queue select: 0x05
[53652.921326] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin

And I'm sure the function rtl_block_fw_writeN is used for firmware uploading.

On 8 March 2012 10:03, jerome huang <jerome.syno@gmail.com> wrote:
> Hi,
>
> I found a problem just like in the older discussion "Question about
> error from xhci-hcd",
> there was a xhci error "no room on ep ring" when plugin rtl8192cu on USB3.
> (it works on USB2)
>
> After applying Larry's patch "rtlwifi: rtl8192cu: Change firmware
> upload to use block writes",
> I still get the same error "no room on ep ring".
>
> But under the same compat-wireless version,
> rt8712 works on USB3.
>
> Does anyone still encounter this problem after applying this patch?
> or do I miss something/patches?
>
> BR,
> Jerome

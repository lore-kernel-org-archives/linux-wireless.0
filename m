Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:32841 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab2CHCfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 21:35:40 -0500
Received: by obbuo6 with SMTP id uo6so38251obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 18:35:39 -0800 (PST)
Message-ID: <4F581AF8.4080001@lwfinger.net> (sfid-20120308_033543_964084_12BE301B)
Date: Wed, 07 Mar 2012 20:35:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: jerome huang <jerome.syno@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com> <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
In-Reply-To: <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 08:16 PM, jerome huang wrote:
> log:
> [53614.238023] Compat-wireless backport release: compat-wireless-v3.2-1-s
> [53614.244729] Backport based on linux-stable.git v3.2
> [53614.368074] alg: No test for arc4 (arc4-generic)
> [53614.402781] cfg80211: Calling CRDA to update world regulatory domain
> [53614.498603] rtl8192cu 3-3:1.0: usb_probe_interface
> [53614.503552] rtl8192cu 3-3:1.0: usb_probe_interface - got id
> [53614.509920] rtl8192cu: rtl8192cu: Chip version 0x11
> [53615.359336] rtl8192cu: MAC address: 08:10:74:f1:a1:0f
> [53615.364575] rtl8192cu: Board Type 0
> [53615.400583] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [53615.408918] usbcore: registered new interface driver rtl8192cu
> [53652.483311] rtl8192cu: MAC auto ON okay!
> [53652.887348] rtl8192cu: Tx queue select: 0x05
> [53652.921326] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
>
> And I'm sure the function rtl_block_fw_writeN is used for firmware uploading.
>
> On 8 March 2012 10:03, jerome huang<jerome.syno@gmail.com>  wrote:
>> Hi,
>>
>> I found a problem just like in the older discussion "Question about
>> error from xhci-hcd",
>> there was a xhci error "no room on ep ring" when plugin rtl8192cu on USB3.
>> (it works on USB2)
>>
>> After applying Larry's patch "rtlwifi: rtl8192cu: Change firmware
>> upload to use block writes",
>> I still get the same error "no room on ep ring".
>>
>> But under the same compat-wireless version,
>> rt8712 works on USB3.
>>
>> Does anyone still encounter this problem after applying this patch?
>> or do I miss something/patches?

This problem is in the USB system, not in the wireless driver. Keep me as a Cc, 
but send mail to Sarah Sharp <sarah.a.sharp@linux.intel.com> and
linux-usb@vger.kernel.org. They will tell you what debugging is needed.

The patch was an attempt to minimize the number of writes needed to upload the 
firmware, but it had no effect; however, it was still a good change.

I'm confused about one statement you made. There is no rt8712 driver, but there 
is one named r8712u; however, it controls a completely different device than 
rtl8192cu. Do you have both devices?

Larry

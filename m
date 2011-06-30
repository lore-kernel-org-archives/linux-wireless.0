Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48087 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1F3PqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 11:46:09 -0400
Received: by ywe9 with SMTP id 9so924653ywe.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 08:46:09 -0700 (PDT)
Message-ID: <4E0C9A3D.8070405@lwfinger.net> (sfid-20110630_174614_053577_AB8D0688)
Date: Thu, 30 Jun 2011 10:46:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Beggy <chrisb@kippona.net>
CC: chaoming_li@realsil.com.cn,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192se from recent git pull
References: <20110630.015016.392442825.chrisb@kippona.net>	<4E0C6D52.7010207@lwfinger.net> <20110630.100849.491680599.chrisb@kippona.net>
In-Reply-To: <20110630.100849.491680599.chrisb@kippona.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 09:08 AM, Chris Beggy wrote:
> On 30 Jun 2011, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>
>> I added the linux-wireless mailing list and the other module author
>> (Chaoming Li) to this reply.
>
>
>> If the firmware file does exist on your system, then check the md5sum
>> for that file. It should be bccf9bf2276621770f101a60736b4004.
>
> Thanks for looking over my submission.
>
> The file rtl8192sefw.bin exists in /lib/firmware/rtlwifi and the
> md5sum is correct.
>
>> Finally, what is the PCI ID for your card as shown by the 'lspci -nn'
>> command? That info is missing from your posting.
>
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co.,
> Ltd. RTL8191SEvA Wireless LAN Controller [10ec:8171] (rev 10)

Please use "reply all" to respond, and do not drop the linux-wireless ML. Unless 
you want to make a deposit to my Paypal account, I do not do private debugging.

On my system running the mainline git kernel (git describe is 
v3.0-rc5-124-g60451cb), I get the following for 'lspci -nnv' run as root:

04:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvA 
Wireless LAN Controller [10ec:8171] (rev 10)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless LAN 
Controller [10ec:8171]
         Flags: bus master, fast devsel, latency 0, IRQ 20
         I/O ports at 2000 [size=256]
         Memory at c0000000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [70] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
         Kernel driver in use: rtl8192se

06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8192E 
Wireless LAN Controller [10ec:8192] (rev ff) (prog-if ff)
         !!! Unknown header type 7f
         Kernel driver in use: rtl8192se

For 'iwconfig wlan0', I get

wlan0     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=135 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:on
           Link Quality=70/70  Signal level=-40 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

The device is generating some warnings in the logs that I need to explore; 
however, it is working.

I have no idea why your device is failing. Perhaps Chaoming will have some ideas 
when he reads this.

Larry

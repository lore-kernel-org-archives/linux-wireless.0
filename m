Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36282 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbcIBLNb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 07:13:31 -0400
Received: by mail-pa0-f51.google.com with SMTP id fu3so31841120pad.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 04:13:31 -0700 (PDT)
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
To: Simon Wunderlich <sw@simonwunderlich.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <1586991.4QUcrJhXOm@prime>
Cc: sven@narfation.org, Pannirselvam Kanagaratnam <pannirk@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8cae6bb9-0465-9210-b543-61136836c263@broadcom.com> (sfid-20160902_131335_176125_EA87656E)
Date: Fri, 2 Sep 2016 13:13:20 +0200
MIME-Version: 1.0
In-Reply-To: <1586991.4QUcrJhXOm@prime>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-9-2016 10:50, Simon Wunderlich wrote:
> Hi,
> 
> we are trying to integrate a RTL8192CU based WiFi adapter (TP-Link TL-WL822N) 
> on a PowerPC based platform running a vendor-supplied/modified 3.12 kernel 
> using compat-wireless (I've tried 2016-01-06 and 2016-06-20 versions). While 
> the adapter works fine on my Laptop (using Debian 4.6 and 4.7 kernels), it 
> seems the firmware loading fails on the PowerPC box. Here is some output from 
> the kernel log:
> 
> [   36.945820] rtl8192cu: Chip version 0x11
> [   37.026208] rtl8192cu: MAC address: ec:08:6b:15:38:0e
> [   37.031301] rtl8192cu: Board Type 0
> [   37.035074] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [   37.040911] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
> [   37.049583] usbcore: registered new interface driver rtl8192cu
> [...]
> [  221.588911] rtl8192cu:_ResetDigitalProcedure1():<0-0> #####=> 8051 reset 
> failed!.........................
> [  221.637599] rtl8192cu: MAC auto ON okay!
> [  221.674610] rtl8192cu: Tx queue select: 0x05
> [  233.233554] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready 
> fail!! REG_MCUFWDL:0x00030006 .
> [  233.233566] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not 
> ready to run!
> 
> The outputs at 221 starts when I enable hostapd with a minimal AP-starting 
> configuration.
> 
> Do you have any recommendations where the firmware loading problems could come 
> from, and where we could start to debug? Any pointers would be appreciated.

Hi Simon,

Could it be an endian issue?

Regards,
Arend

> Thank you,
>       Simon
> 

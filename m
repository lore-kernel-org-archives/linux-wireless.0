Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40249 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab1KCPMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 11:12:08 -0400
Received: by ggnb2 with SMTP id b2so1418174ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 08:12:07 -0700 (PDT)
Message-ID: <4EB2AF44.7090102@lwfinger.net> (sfid-20111103_161212_014346_C112079E)
Date: Thu, 03 Nov 2011 10:12:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: roman-vl@meta.ua
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 scans wifi networks with old firmware only.
References: <48883.148.106.128.38.1320319313.metamail@webmail.meta.ua>
In-Reply-To: <48883.148.106.128.38.1320319313.metamail@webmail.meta.ua>
Content-Type: text/plain; charset=windows-1251; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 06:21 AM, Roman V.Leon. wrote:
> Hello Gents.
> I have problem with b43 driver 5.100.138, it's not scanning networks for
> unknown reason. I have broadcom wifi card PCIID is 14e4:4315, linux kern
> ver. is 3.0. When i'm trying to launch iwlist scan, i'm getting "no scan
> results".
>
> for example:
> sudo ifconfig wlan0 up
> sudo iwlist wlan0 scan
>      No scan results.
>
> With the older driver 5.10.56.2808, i see normal scan results. If you need
> any more information, i will send.

The condition you report is known. Broadcom changed the TX/RX header structure 
with firmware versions greater than 600, as shown by a 'dmesg | grep firmware'. 
Those changes are not implemented in b43 until kernel 3.2.

These numbers are not b43 driver numbers, nor are they firmware numbers reported 
by b43. They are the versions of Broadcom drivers.

If you look at 
http://wireless.kernel.org/en/users/Drivers/b43#firmwareinstallation, you will 
see that firmware should be extracted from Broadcom driver 5.100.138 "if you are 
using kernel 3.2 or newer". For older kernels you should extract firmware from 
the 5.10.56.27.3 of the Broadcom proprietary driver. Of course, 5.10.56.2808 
will also work.

  You could also get those changes by employing a bleeding-edge version of 
compat-wireless. In that case, firmware from 5.100.138 would work.

Larry

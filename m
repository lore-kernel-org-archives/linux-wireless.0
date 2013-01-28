Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46076 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3A1RLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 12:11:15 -0500
Received: by mail-oa0-f51.google.com with SMTP id n12so3012203oag.38
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 09:11:14 -0800 (PST)
Message-ID: <5106B130.2040404@lwfinger.net> (sfid-20130128_181122_727818_D77F00A6)
Date: Mon, 28 Jan 2013 11:11:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Doug Lance <doug.lance@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Linux USB driver for Belkin F7D1101 v1
References: <CAJFequifVCAz+3Jkd7hFrQUGeE=wxJdtOqaZdtBLg=MRtOiNVg@mail.gmail.com> <5106A201.9080005@lwfinger.net> <5106A52E.3090301@gmail.com>
In-Reply-To: <5106A52E.3090301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2013 10:19 AM, Doug Lance wrote:
> **050d:945a <http://usb-ids.gowdy.us/read/UD/050d/945a>
>
> Thanks so much for your help!

The RTL8188SU chip should be driven by r8712u in the drivers/staging/rtl8712u/ 
directory of the Linux kernel; however, it is not in the ID table for that driver.

Is that driver available for Android? If so, then try the following as root:

modprobe -v r8712u
echo "050d 945a" > /sys/bus/usb/drivers/r8712u/new_id

Does the device work now? If so, add that ID to the usb_device table and let me 
know so that I can submit a patch for rhe kernel.

Larry



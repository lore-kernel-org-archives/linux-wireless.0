Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34460 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbcCJQpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 11:45:33 -0500
Received: by mail-yw0-f176.google.com with SMTP id h129so72371227ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 08:45:33 -0800 (PST)
Subject: Re: New firmware for RT2870
To: quarkverse <quarkverse@gmail.com>
References: <56E08615.9060208@lwfinger.net>
 <CAC0d7Bi9VEN2zADV24DyhkZCp-mgLtDDXODUMfHoVzC0is7xMA@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>, dan.g.tob@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56E1A4AB.7040205@lwfinger.net> (sfid-20160310_174537_628562_E4EB9915)
Date: Thu, 10 Mar 2016 10:45:31 -0600
MIME-Version: 1.0
In-Reply-To: <CAC0d7Bi9VEN2zADV24DyhkZCp-mgLtDDXODUMfHoVzC0is7xMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2016 08:15 PM, quarkverse wrote:
> I have an RT5370 adapter from Panda Wireless and use it on my Ubuntu
> 14.04 laptop.
> It is working fine on my laptop.
>
>>From my laptop:
> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
>
> I didn't see the warnings reported in the Bug 114151.
>
> Just curious how to test version 0.36 on my laptop.\\

Go to https://bugzilla.kernel.org/show_bug.cgi?id=114151 and copy the attachment 
to your ~/Downloads directory. Then do the following:

sudo cp /lib/firmware/rt2870.bin /lib/firmware/rt2870.bin_old
sudo cp ~/Downloads/rt2870.bin /lib/firmware/.
sudo modprobe -rv rt2x00usb
sudo modprobe -v rt2x00usb

If your testing shows a regression in performance, then you can recover by 
copying rt2870.bin_old to rt2870.bin in /lib/firmware.

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1EYU1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 16:27:37 -0400
Received: by fxm17 with SMTP id 17so95994fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 13:27:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marius Ladegaard Meyer <marius.l.meyer@gmail.com>
Subject: Re: carl9170 fw 1.9.3 on the binary archive page
Date: Wed, 25 May 2011 22:27:25 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTinenbgnE0c8ZQh2wfBOjWNc=T++Dw@mail.gmail.com> <201105251445.11193.chunkeey@googlemail.com> <BANLkTikR9pRgvFEh9ahFSk1KpdP9Oxz1Yw@mail.gmail.com>
In-Reply-To: <BANLkTikR9pRgvFEh9ahFSk1KpdP9Oxz1Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201105252227.25812.chunkeey@googlemail.com> (sfid-20110525_222742_457487_E13FEA6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 May 2011 21:26:32 Marius Ladegaard Meyer wrote:
> I built the firmware again today. After building the toolchain, I ran the
> autogen.sh script and selected the default values on all the things I was
> asked about. The script completed succesfully and created the files
> carl9170.bin, carl9170.dsc, carl9170.elf and carl9170.fw in the carlfw
> folder. I have attached the output in a text file.
output looks sane.

> It is at this point I cannot figure out what to do. The carl9170-1.fw files
> on the mirror just needs to be put in the /lib/firmware directory, and the
> kernel will find them when I plug in the device. I tried to copy all the
> aforementioned carl9170.* files to /lib/firmware, but all I see from dmesg
> is
> 
> [ 5416.799516] usb 2-6: new high speed USB device using ehci_hcd and address
> 5
> [ 5417.092852] usb 2-6: reset high speed USB device using ehci_hcd and
> address 5
> [ 5417.257236] usb 2-6: firmware not found.

the firmware filename is important. The driver can only load the firmware if it
is stored in the firmware folder with the right filename: "carl9170-1.fw"

the "-1" was introduced as a result of a rather long discussion about
firmware versioning best practices:
http://wireless.kernel.org/en/developers/Documentation/firmware-versioning

anyway cd into carl9170fw-source/carlfw and
cp carl9170.fw /lib/firmware/carl9170-1.fw
[If /lib/firmware is the correct directory]

this should do the trick.
> and iwconfig gives me no interface. I'm 100% sure that the error is between
> the chair and the keyboard on this one, but I cannot find any documentation
> on this anywhere.
oh no, you are 100% right. This was not documented anywhere in plain English,
but now it should be [just pushed].

Thanks,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:62707 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXLFSw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 13:52:26 -0500
Received: by py-out-1112.google.com with SMTP id u77so760495pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 10:52:25 -0800 (PST)
Message-ID: <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> (sfid-20071206_185229_676084_03A134F1)
Date: Thu, 6 Dec 2007 13:52:25 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: lynx.abraxas@freenet.de
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071206170858.GA2008@drago>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071206170858.GA2008@drago>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 6, 2007 12:08 PM,  <lynx.abraxas@freenet.de> wrote:

> I'm  desperately  trying  to get a micronet SP907GK V5 (USB 1.1 WLAN-Stick) to
> run under openSuSE 10.3.
>
> lsusb tells me the manufacturer is Realtek rtl8187 so  I  compiled,  installed
> and modprobed rtl8187 for the 2.6.22.5 kernel.

You might want to mention where you got the source for the rtl8187
module that you compiled. Git checkout? Tarball from a website?

This driver is included in the 2.6.23 kernel, so you may want to try that.

> The module loads and iwconfig lists wlan0 as wireless device. wmaster0 is also
> created. I could not find any info on what wmaster0 is for. Some say it  is  a
> hint  for  malfunction of the driver. I did configure the device with Yast and
> also by hand (setting essid and key with iwconfig and using dhcpcd or ifconfig
> with static local ip) but had no success when pinging the router.

Fortunately, those who say the presence of the wmaster0 is a problem
are wrong. It is completely normal.

Your iwconfig output reveals that the device is not associated, so
naturally you will not be able to ping the router.

Also, you seem to imply that your network uses a WEP key (as opposed
to WPA), but please make sure.

Other thoughts:

Can you scan with the device? You will need to set the interface up
(ifconfig wlan0 up) before scanning.

When configuring the device manually with a WEP key, you will need to
make sure that setting the essid is the last step. Setting the essid
and then the key will not work.

-- 
Will Dyson

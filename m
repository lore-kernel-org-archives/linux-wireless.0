Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:29987 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXLGKVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 05:21:54 -0500
Received: by py-out-1112.google.com with SMTP id u77so1284371pyb
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2007 02:21:53 -0800 (PST)
Message-ID: <c68f135e0712070221x36cffd95q724d8ecb23f4e1cf@mail.gmail.com> (sfid-20071207_102158_177864_3D64FEC8)
Date: Fri, 7 Dec 2007 11:21:53 +0100
From: "Andrea Merello" <andreamrl@tiscali.it>
Reply-To: andreamrl@tiscali.it
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: lynx.abraxas@freenet.de, linux-wireless@vger.kernel.org,
	"Dan Williams" <dcbw@redhat.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071206170858.GA2008@drago>
	 <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
	 <20071206214807.GB1811@drago>
	 <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > lsusb tells me the  manufacturer  is  Realtek  rtl8187  so   I   compiled, installed
> > > and modprobed rtl8187 for the 2.6.22.5 kernel.

Can you please tell us which version of RF frontend and MAC processor
do you have?
You can see it in the dmesg output. I need the line where it talks about rtl8225

> > Also "ifconfig wlan0 up" takes a long time
> > to finish  compared to other devices I have worked with.

This is OK. Especially earlier version of the rtl8187 MAC need a quite
long procedure to turn on. It is not symptom of any problem.

> > iwlist wlan0 scan gives: wlan0 No scan results

Should the scan find a lot of APs or just one ? Are you close to any
AP? If you have other working cards can you please provide us a
indicative measure of AP signal strength? Is it possible that the
sensitivity of the card is not enough to find the AP? on which channel
is the AP?

> > Is  it  possible,  though  the  driver  catches the device and I don't get any
> > error-messages, that the Stick cannot be used under linux?

If the device is a rtl818L, and it is likely to be, since the driver
catches it, then it should work. If it doesn't not then it is probably
a bug. rtl8187B is not supported, but it should not be catched by the
driver (should have different USB id).

Oh, do you have an USB port 1.x or 2.0 ?

Thanks
Andrea

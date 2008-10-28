Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:26570 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYJ1GXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 02:23:17 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1315148wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 23:23:16 -0700 (PDT)
Message-ID: <a32f33a40810272323y4b15cc03o1b82730a6c93f60e@mail.gmail.com> (sfid-20081028_072321_628251_0D566FFA)
Date: Tue, 28 Oct 2008 07:23:16 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: rtl2860 driver in mainline?
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20081028061023.GA6568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081028004915.GA3442@kroah.com>
	 <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com>
	 <20081028061023.GA6568@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > So, on my quest to suck up every out-of-tree driver and get it into the
>> > main kernel tree (drivers/staging/ to start with), I've been pointed at
>> > the rtl2860 driver.
>>
>> in that case make sure you include rt2870 on your list as well then. ;)
>
> Do you have a pointer to it?

http://www.ralinktech.com.tw/data/drivers/2008_0925_RT2870_Linux_STA_v1.4.0.0.tar.bz2

But as mentioned the rt2800usb is underway.

>> > Does anyone know of a "cleaned up" version of this driver that is
>> > newer/better than the one on ralink's web site?  I found the
>> > 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
>> > start with that if no one else has yet.
>>
>> rt2800pci/rt2800usb development is in progress in the rt2x00.git
>> experimental branch:
>> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental
>>
>> The current status is that rt2800usb has working RX with some warnings
>> regarding the
>> RX signal, and a non functional TX. rt2800pci isn't complete yet.
>>
>> So far progress has been very slow because of lack of time, so any help with the
>> development of the drivers is welcome.
>
> Is this a port of the tarball driver to the in-kernel wireless stack, or
> starting over from scratch?

Starting from scratch, well actually hooking it into the rt2x00lib library,
so only the real register initializations are being copied. ;)

> As it's not really working, do you mind if I just dump the tarball
> driver into the staging tree for users to use now (hint, they already
> are, the distros are shipping that driver as a kernel module package),
> and then when this "real" driver is up and working properly, we can drop
> the staging version?

No objections, but who is going to provide support for them and maintain them
to make sure they compile?
I am already stretched in time, and I have absolutely no interest in maintaining
or supporting those old drivers. I understood there were quite a lot
of problems with
the drivers, so putting them in an "official" tree might lead to a
large series of
support requests.

Ivo

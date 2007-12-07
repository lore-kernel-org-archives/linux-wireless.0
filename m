Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:38045 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXLGURk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 15:17:40 -0500
Received: from [195.4.92.10] (helo=0.mx.freenet.de)
	by mout2.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J0jdi-0002oV-V3
	for linux-wireless@vger.kernel.org; Fri, 07 Dec 2007 21:17:38 +0100
Received: from p508e5b6e.dip.t-dialin.net ([80.142.91.110]:49147 helo=localhost)
	by 0.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J0jdi-0003oX-In
	for linux-wireless@vger.kernel.org; Fri, 07 Dec 2007 21:17:38 +0100
Date: Fri, 7 Dec 2007 21:17:37 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20071207201737.GA9192@drago> (sfid-20071207_201745_459920_2A20333E)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> <20071206214807.GB1811@drago> <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/07 20:14:11, Luis R. Rodriguez wrote:
> On Dec 6, 2007 4:48 PM,  <lynx.abraxas@freenet.de> wrote:
>
>  >  >  lsusb  tells  me  the   manufacturer   is   Realtek   rtl8187  so   I
compiled, installed
> > > and modprobed rtl8187 for the 2.6.22.5 kernel.
>
> CC'ing those who worked on that driver.
>
> > compat-wireless-2.6.tar.bz2 did not compile, which I thought would be  the
best choise.
>
> Please try today's release, last night's release was broken due to
> zd1211rw-mac80211 --> zd1211rw move, among other things. Let me know
> how it goes and what kernel you are using.

I'm  now  trying to get the device working on my LFS with 2.6.23.9 which seems
to be a bit to new. My other kernel 2.6.21.5 a bit too old:(
Well the current compat-wireless-2.6.tar.bz2 does not compile through  either.
Even with make -k rtl8187.ko is not created. make stops with:


make
make -C /lib/modules/2.6.23.9/build M=/home/lynx/compat-wireless-2.6 modules
make[1]: Entering directory `/usr/src/linux-2.6.23.9'
  CC [M]  /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o
In file included from /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:44:
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/b43.h:783:3: error: #error "Using neither DMA nor PIO? Confused..."
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_interrupt_tasklet':
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:1451: error: implicit declaration of function 'b43_using_pio'
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_one_core_attach':
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: 'modparam_pio' undeclared (first use in this function)
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: (Each undeclared identifier is reported only once
/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: for each function it appears in.)
make[4]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o] Error 1
make[3]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43] Error 2
make[2]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/lynx/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.23.9'
make: *** [modules] Error 2

> > No,  scanning  doesn't work either. Also "ifconfig wlan0 up" takes a long time
> > to finish  compared to other devices I have worked with. It yields the "wlan0:
> > link is not ready" message.
> > iwlist wlan0 scan gives: wlan0 No scan results
> 
> Best thing to do is to try to get you to use the latest driver, we'll
> be able to help a lot better that way. You can try wireless-2.6.git
> tree yourself or we can try to get the compat-wireless-2.6 package
> working for you.

Is git different from compat-wireless-2.6 package? It seems like it is a daily
snapshot.

>
> > I tried both an none worked.
> > Is  it  possible,  though  the  driver  catches the device and I don't get
any
> > error-messages, that the Stick cannot be used under linux?
>
> Well lets find out, I believe it should be supported and working with
> the current drivers.
>

That  would be great. I got a lot of things running with my LFS but this WLAN-
Stick is a hard one again...

Lynx





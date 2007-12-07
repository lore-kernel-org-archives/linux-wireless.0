Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:30143 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXLGUZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 15:25:53 -0500
Received: by py-out-1112.google.com with SMTP id u77so1759098pyb
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2007 12:25:51 -0800 (PST)
Message-ID: <43e72e890712071225p774a2f9bg92540905dbd19e66@mail.gmail.com> (sfid-20071207_202559_697263_E8B25925)
Date: Fri, 7 Dec 2007 15:25:50 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: lynx.abraxas@freenet.de
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071207201737.GA9192@drago>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071206170858.GA2008@drago>
	 <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
	 <20071206214807.GB1811@drago>
	 <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com>
	 <20071207201737.GA9192@drago>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 7, 2007 3:17 PM,  <lynx.abraxas@freenet.de> wrote:
> On 06/12/07 20:14:11, Luis R. Rodriguez wrote:
> > On Dec 6, 2007 4:48 PM,  <lynx.abraxas@freenet.de> wrote:
> >
> >  >  >  lsusb  tells  me  the   manufacturer   is   Realtek   rtl8187  so   I
> compiled, installed
> > > > and modprobed rtl8187 for the 2.6.22.5 kernel.
> >
> > CC'ing those who worked on that driver.
> >
> > > compat-wireless-2.6.tar.bz2 did not compile, which I thought would be  the
> best choise.
> >
> > Please try today's release, last night's release was broken due to
> > zd1211rw-mac80211 --> zd1211rw move, among other things. Let me know
> > how it goes and what kernel you are using.
>
> I'm  now  trying to get the device working on my LFS with 2.6.23.9 which seems
> to be a bit to new. My other kernel 2.6.21.5 a bit too old:(
> Well the current compat-wireless-2.6.tar.bz2 does not compile through  either.
> Even with make -k rtl8187.ko is not created. make stops with:
>
>
> make
> make -C /lib/modules/2.6.23.9/build M=/home/lynx/compat-wireless-2.6 modules
> make[1]: Entering directory `/usr/src/linux-2.6.23.9'
>   CC [M]  /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o
> In file included from /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:44:
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/b43.h:783:3: error: #error "Using neither DMA nor PIO? Confused..."
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_interrupt_tasklet':
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:1451: error: implicit declaration of function 'b43_using_pio'
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c: In function 'b43_one_core_attach':
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: 'modparam_pio' undeclared (first use in this function)
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: (Each undeclared identifier is reported only once
> /home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.c:3857: error: for each function it appears in.)
> make[4]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43/main.o] Error 1
> make[3]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless/b43] Error 2
> make[2]: *** [/home/lynx/compat-wireless-2.6/drivers/net/wireless] Error 2
> make[1]: *** [_module_/home/lynx/compat-wireless-2.6] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.23.9'
> make: *** [modules] Error 2

I just fixed this. I'll e-mail once I propagate the tarball.

> > > No,  scanning  doesn't work either. Also "ifconfig wlan0 up" takes a long time
> > > to finish  compared to other devices I have worked with. It yields the "wlan0:
> > > link is not ready" message.
> > > iwlist wlan0 scan gives: wlan0 No scan results
> >
> > Best thing to do is to try to get you to use the latest driver, we'll
> > be able to help a lot better that way. You can try wireless-2.6.git
> > tree yourself or we can try to get the compat-wireless-2.6 package
> > working for you.
>
> Is git different from compat-wireless-2.6 package? It seems like it is a daily
> snapshot.

Its a daily snapshot. Cron'd for at 06:10am CET.

  Luis

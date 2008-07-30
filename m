Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:64453 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYG3T0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:26:42 -0400
Received: by yx-out-2324.google.com with SMTP id 8so54023yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 12:26:41 -0700 (PDT)
Message-ID: <3ace41890807301226u432e18dbha32253420529e2f7@mail.gmail.com> (sfid-20080730_212646_794628_03FD1503)
Date: Wed, 30 Jul 2008 20:26:40 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200807301511.12267.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48900654.7030100@lwfinger.net>
	 <200807301413.53059.herton@mandriva.com.br>
	 <200807301946.41182.mb@bu3sch.de>
	 <200807301511.12267.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/30/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> Em Wednesday 30 July 2008 14:46:40 Michael Buesch escreveu:
>
> > On Wednesday 30 July 2008 19:13:52 Herton Ronaldo Krzesinski wrote:
>  > > > Yeah, I said exactly that.
>  > > > You protect the loopback stuff. Not any config callback or anything else.
>  > >
>  > > Ah ok, only protect the section, like this?
>  >
>  > Yeah, well. In theory, yes. In practice: Aren't there other races possible, too?
>  > I mean even races with other parts of the driver.
>  > b43 needs to take the global driver mutex in the conf callback to make
>  > sure nothing changes (device init state probably is the most important one.
>  > Device going down while configuring would be a fatal crash).
>
>
> In practice I don't get other problems, but better to stick to the patch posted
>  by Larry, like he said to avoid config data from one call mixed to the other.
>  rtl8187 is more simpler, besides this issue with configuration it all depends
>  on how mac80211 calls another functions, I have yet to see but doesn't look like
>  a general lock is needed.

I have been wondering about two things: (1) I occasionally have problems
modprobe -r (particularly right after a bit of use and the driver is
stuck), ksoftirqd just suck CPU cycles like crazy in some timer code.
It seems to be less often if I just leave it for some time before
modprobe -r. I am on a dual core system. (2) although Larry says
wpa_supplicant works, I can't get it to work for me at all, but the
driver is alright and quite useable with ifconfig/iwconfig, etc.

Had a look at wpa_supplicant itself and it doesn't seem to do much
more than the iwconfig/iwlist stuff, but obviously it does it job
faster (and potentially through two cores).

The wpa_supplicant issue is probably also about config data, but I
wonder if the shutdown also needs some sort of spin lock. Some of the
other drivers has spin locks,
and rtl8187 actually is one with the fewest spin locks.


>
>
>  >
>  > So in b43 we have a global mutex which protects everything (all data
>  > and all device state), except the data and state that's accessed in the IRQ paths.
>  > (We have more locks for shared device memory and so on... But these are nested
>  > inside of the mutex or the IRQ state lock)
>  >
>
>  --
>
> []'s
>
> Herton
>

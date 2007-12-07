Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:59736 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbXLGBOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 20:14:12 -0500
Received: by py-out-1112.google.com with SMTP id u77so1039402pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 17:14:11 -0800 (PST)
Message-ID: <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com> (sfid-20071207_011416_888655_86913B83)
Date: Thu, 6 Dec 2007 20:14:11 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: lynx.abraxas@freenet.de
Subject: Re: What's wrong if wlan0 device is not reacting?
Cc: linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Andrea Merello" <andreamrl@tiscali.it>
In-Reply-To: <20071206214807.GB1811@drago>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071206170858.GA2008@drago>
	 <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
	 <20071206214807.GB1811@drago>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 6, 2007 4:48 PM,  <lynx.abraxas@freenet.de> wrote:

> > lsusb tells me the  manufacturer  is  Realtek  rtl8187  so   I   compiled, installed
> > and modprobed rtl8187 for the 2.6.22.5 kernel.

CC'ing those who worked on that driver.

> compat-wireless-2.6.tar.bz2 did not compile, which I thought would be the best choise.

Please try today's release, last night's release was broken due to
zd1211rw-mac80211 --> zd1211rw move, among other things. Let me know
how it goes and what kernel you are using.

> What's it for the wmaster0?

wmaster0 is an internal master device used only by mac80211. It serves
as a holder for all interfaces we have, and represent the underlying
hardware. For example, when TXing your wlan0 STA interface will
actually add IEEE-802.11 header data to a frame with just Ethernet
headers, and then pass it down to the master device for actual
transmission using the low level drivers. Anyway, your wlan0 is an
interface, in your case a STA interface, this is the real guy you
would be configuring. The idea with is to be able to support multiple
interfaces at the same time using the same wireless card (say an AP
and a STA).

> Do I have to configure it as well?

No, if we could we would hide that from users, I believe there may be
patch coming for that soon.

(Dan:)

Using compat-wireless-2.6 I get my wmaster0 as 'eth3' actually and I
think that's making network manager angry (my wlan0 is actually
wlan0_rename too).

> > Your iwconfig output reveals that the device is not associated, so
> > naturally you will not be able to ping the router.
>
> This seems to be the problem. It does not catch the channel  of  my  WLAN  nor
> does it help to set the frequency directly.

I believe what Will was trying to tell you is that:

ADDRCONF(NETDEV_UP): wlan0: link is not ready

indicates to us that your wireless interface was not yet associated.

> No,  scanning  doesn't work either. Also "ifconfig wlan0 up" takes a long time
> to finish  compared to other devices I have worked with. It yields the "wlan0:
> link is not ready" message.
> iwlist wlan0 scan gives: wlan0 No scan results

Best thing to do is to try to get you to use the latest driver, we'll
be able to help a lot better that way. You can try wireless-2.6.git
tree yourself or we can try to get the compat-wireless-2.6 package
working for you.

> I tried both an none worked.
> Is  it  possible,  though  the  driver  catches the device and I don't get any
> error-messages, that the Stick cannot be used under linux?

Well lets find out, I believe it should be supported and working with
the current drivers.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:60717 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXLFVsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 16:48:12 -0500
Received: from [195.4.92.18] (helo=8.mx.freenet.de)
	by mout2.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J0OZl-0001Iz-PF
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2007 22:48:09 +0100
Received: from p508e6f25.dip.t-dialin.net ([80.142.111.37]:60185 helo=localhost)
	by 8.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J0OZl-0007z4-CW
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2007 22:48:09 +0100
Date: Thu, 6 Dec 2007 22:48:07 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20071206214807.GB1811@drago> (sfid-20071206_214826_225610_E098E480)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/07 13:52:25, Will Dyson wrote:


Thank You very much Will for Your quick answer.


> On Dec 6, 2007 12:08 PM,  <lynx.abraxas@freenet.de> wrote:
>
>  >  I'm   desperately   trying   to get a micronet SP907GK V5 (USB 1.1 WLAN-
Stick) to
> > run under openSuSE 10.3.
> >
> > lsusb tells me the  manufacturer  is  Realtek  rtl8187  so   I   compiled,
installed
> > and modprobed rtl8187 for the 2.6.22.5 kernel.
>
> You might want to mention where you got the source for the rtl8187
> module that you compiled. Git checkout? Tarball from a website?

I    mixed    things   a   bit   up.   I   compiled   rtl8187   from   realtek
(http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=16&PFid=14&Level=5&Conn=4)
on SuSE 10.2.
But I found no source that compiles under SuSE 10.3 which has a kernel > 2.6.19 where there is no config.h any more. So I used rtl8187-kmp-default-20070806_2.6.22.5_31-2.i586.rpm from ftp://ftp5.gwdg.de/pub/opensuse/distribution/10.3/repo/oss/suse/i586/ which was recommended in a thread concerning micronet USB-WLAN as well (which SP907 was'n mentioned). I also installed rt2x00... from the SuSE DVD. compat-wireless-2.6.tar.bz2 did not compile, which I thought would be the best choise. 


>
> This driver is included in the 2.6.23 kernel, so you may want to try that.

I'm  not sure if it is possible at all to switch to a different kernel version
in SuSE but I'll give it a test on my LFS-laptop.

>
> > The module loads and iwconfig lists wlan0 as wireless device. wmaster0  is
also
>  >  created.  I could not find any info on what wmaster0 is for. Some say it
is  a
> > hint  for  malfunction of the driver. I did configure the device with Yast
and
>  >  also  by  hand  (setting essid and key with iwconfig and using dhcpcd or
ifconfig
> > with static local ip) but had no success when pinging the router.
>
> Fortunately, those who say the presence of the wmaster0 is a problem
> are wrong. It is completely normal.

What's it for the wmaster0? Do I have to configure it as well?

>
> Your iwconfig output reveals that the device is not associated, so
> naturally you will not be able to ping the router.

This seems to be the problem. It does not catch the channel  of  my  WLAN  nor
does it help to set the frequency directly.


>
> Also, you seem to imply that your network uses a WEP key (as opposed
> to WPA), but please make sure.

Yes WEP for the time I'm here at my parents house because (though less secure)
my good old flashed orinoco card seems not to be able to handel WPA. The Stick
is supposed to be abled to do both WEP and WPA.

>
> Other thoughts:
>
> Can you scan with the device? You will need to set the interface up
> (ifconfig wlan0 up) before scanning.

No,  scanning  doesn't work either. Also "ifconfig wlan0 up" takes a long time
to finish  compared to other devices I have worked with. It yields the "wlan0:
link is not ready" message.
iwlist wlan0 scan gives: wlan0 No scan results

>
> When configuring the device manually with a WEP key, you will need to
> make sure that setting the essid is the last step. Setting the essid
> and then the key will not work.

I tried both an none worked.
Is  it  possible,  though  the  driver  catches the device and I don't get any
error-messages, that the Stick cannot be used under linux?


Thanks for any further help or hints
Lynx



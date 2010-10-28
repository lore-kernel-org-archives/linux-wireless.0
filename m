Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0J1WSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 18:18:03 -0400
Received: by fxm16 with SMTP id 16so2436942fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 15:18:01 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Fri, 29 Oct 2010 00:17:12 +0200
Cc: Lee <lee-in-berlin@web.de>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <4CC0D0F6.4080507@web.de> <4CC9C9A4.2020802@web.de> <4CC9D50F.5070403@gmail.com>
In-Reply-To: <4CC9D50F.5070403@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010290017.13174.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 28 Oktober 2010 schrieb Gertjan van Wingerde:
> On 10/28/10 21:06, Lee wrote:
> > On 28/10/10 10:23, Helmut Schaa wrote:
> >> Am Donnerstag 28 Oktober 2010 schrieb Lee:
> >>> On 26/10/10 07:40, Helmut Schaa wrote:
> >>>> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
> >>>>
> >>>> Do you see any frames from your specific client?
> >>>
> >>> Yes. I can see this:
> >>> # tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
> >> [...]
> >>> 10:10:03.013402 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 14 Pad 20 KeyID 0
> >>>
> >>> However, on wlan0 I don't see anything beyond the EAPOL packets.
> >>> Temporarily turning off WPA encryption let me successfully connect to my AP.
> >>
> >> Aha, could you please try if loading rt73usb with nohwcrypt=1 helps?
> >>
> >> Helmut
> > 
> > (argh, brown paper bag)
> > 
> > I went through the compiled kernels again, and I've screwed up at the last 
> > commit while bisecting (Sorry, Helmut!). The first bad kernel is a commit 
> > later:
> > 
> > # bad: [f1aa4c541e98afa8b770a75ccaa8504d0bff44a7] rt2x00: Write the BSSID to register when interface is added
> > 
> > On the good side, I tested 2.6.36 with nohwcrypt=1, and it works. Yay!
> 
> Hmm, the patch itself that seems to cause the badness doesn't look bad.
> However, closer inspection shows that the intf->bssid field may be initialized incorrectly.
> 
> I may be a long shot, but can you check if the attached patch helps?

Hmm, indeed that part of the code looks suspicious. However, setting the bssid
and mac always worked for me on rt2800pci.

Furthermore, the removal of the & seems to not make any difference in this
case. I've just tried the following:

	#include <stdio.h>
	int main() {
		int x[2];
		printf("%p %p\n", x, &x);
	}

Output is as follows:

0x7fff74cb1df0 0x7fff74cb1df0

So, x and &x are equivalent in this case and this is similar to the code in
rt2x00mac. I'm fine with changing both memcpy's as you've suggested as it
really looks cleaner but I doubt that this is going to fix the problem.

In commit f1aa4c541e98afa8b770a75ccaa8504d0bff44a7 "rt2x00: Write the BSSID
to register when interface is added" we've added the bssid passing to the
device in AP mode to fix hw crypto on rt2800 devices in AP mode. But maybe
the older devices behave differently and don't like getting a bssid set
in AP mode?

Lee, if you just revert the commit you've identified are you able to use
the device in AP mode with hw crypto?

Thanks,
Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44733 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZHXISw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 04:18:52 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
Subject: Re: Implementing wireless testbed on Linux
Date: Mon, 24 Aug 2009 10:18:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <029301ca2239$0ac9ad70$205d0850$@kaist.ac.kr>
In-Reply-To: <029301ca2239$0ac9ad70$205d0850$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908241018.13234.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In the case of using 802.11n chipset, which card and device
> driver should I choose? At the same time, which version of
> Linux kernel should be appropriate?

I'd go with Atheros based PCI cards. The cards are good, and the 
support is outstanding (Atheros people work together with Linux 
community on this mailing list!).

> Is there any difference between pci and usb interfaces?

Sure. Please read http://www.pcisig.com/specifications and 
http://www.usb.org/developers/docs/. The busses are VERY 
different in case of hierarchy, latency, max transfer rates and 
so on.

I fear, however, that this mailing list isn't the right channel 
to transfer this knowledge.



> Definitely, all device and software should be stable and
> up-to-date.

That's a contradicion. Especially wireless is quite evolving in 
the Linux kernel.


There's the possibility that you use a vendor-kernel (e.g. Debian 
kernel, Fedora kernel, or whatever distro you use). I personally 
won't do this, but I'd use a more "vanilla" kernel. The vendors 
usually put a huge amount on patches into their kernels, that 
will make results not as easy to compare. Also, if you have a 
specific questions, chances are way higher that the people in 
the mailing list know about the "vanilla" kernel or 
wireless-testing kernel than some random vendor kernel.


If you absolutely need something stable, you should go with the 
least recent stable linux kernel (see http://www.kernel.org/).

If you want to be more up-to-date, you should use 
wireless-testing. Expect new functionality, fixed bugs, but also 
new bugs there :-)    However, If you ever have to change some 
driver code, you definitely want wireless-testing. You cannot 
(usually) use the source from the stable kernel when submitting 
patches. More info at 
http://wireless.kernel.org/en/developers/Documentation

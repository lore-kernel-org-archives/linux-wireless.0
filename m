Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25288 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXGFHWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 03:22:09 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: monitor mode support for OLPC
Date: Fri, 6 Jul 2007 09:22:06 +0200
References: <468c3f32.081b600a.3817.5051@mx.google.com> <200707050842.01533.hs4233@mail.mn-solutions.de> <8e8340660707051037p56e10ec7u3aa4d76893e0b1ed@mail.gmail.com>
In-Reply-To: <8e8340660707051037p56e10ec7u3aa4d76893e0b1ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707060922.06110.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier, I've also put this thread onto linux-wireless, maybe 
people there are interested in this area, too.

> I use the echo-to-sys way because we are not setting any
> existing interface into monitor mode but creating a new one.

And that is the part that I'm not really liking.

> This is the way Intel ipw2xxx drivers behave and I think it is
> a cleaner solution to have separate interfaces, one for 802.3
> and another one for 802.11+rtap

The ipw2xxx driver is a driver that was developed mostly 
out-of-kernel-tree. I'm not sure if it is a good template on how 
to write a WLAN driver :-)

My problem is really that did create another interface, rtapX. It 
is that you also create a new API on how to monitor. And I have 
the feeling that we have an inflation of APIs for turning on 
monitor mode:

* there is "iwconfig eth1 mode monitor"
* there is madwifi's way of wlanconfig
* there is ipw22xx's way of a .config and of modprobe "ipw2200
  rtap_iface=1" and "ifconfig rtap0 up"
* and now you
  with /sys/class/net/{ethX,mshX}/device/libertas_rtap

Somehow I fear that tools like kismet (or others!) won't honor 
just-another-interface on how to turn monitor mode on.



Why not do it this way:

"iwmode eth1 mode monitor" turn's the device into monitor mode. 
That's what by far the most drivers use. In this mode, the 
device will send all frames to the host, e.g. all beacon frames. 
After all, user space can filter:

  tshark -i rtap0 -R '!(wlan.fc.subtype == 8)'

If you think that this creates too much traffic on the USB bus, 
then additionally you can use something 
like /sys/class/net/{ethX,mshX}/device/rtap_filter and expose 
your bitmap.

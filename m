Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24271 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbXKVOOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 09:14:12 -0500
Received: from lin01.mn-solutions.de (pD95F8740.dip0.t-ipconnect.de [217.95.135.64])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 09D1B5E45C5
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 15:14:10 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 33AFE1E00FD
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 15:11:15 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 15:14:37 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <1195736752.6323.97.camel@johannes.berg>
In-Reply-To: <1195736752.6323.97.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221514.37906.hs4233@mail.mn-solutions.de> (sfid-20071122_141421_164627_CF0FF330)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As you can see, it doesn't find anything that matches the
> current configuration.

Right.

And correct behavior.


> > $ iwconfig eth1 key s:11111
> > b43-phy0 debug: Using hardware based encryption for keyidx:
> > 0, mac: ff:ff:ff:ff:ff:ff
>
> You've now enabled a key, but not told it to associate using
> that key.

Wrong, because of an false assumption.

On first sight, you might be right. I haven't told to associate. 
But at the second sight, there is no EXPLICIT iwconfig-based way 
to say "now associate". For 6 drivers (see below) the "iwconfig 
XXX key YYY" command is an IMPLICIT way to say "try to associate 
with what you know so far. That's because those drivers have a 
heuristic like

  "If I'm not successfully associated yet, then I try to
  associate whenver I get a new bit of info".

And this bit of info might be ESSID, wep key, wpa key, on some 
drivers even rate or b/g limitations.


It's mac80211 that falsely thinks "iwconfig XXX essid" is the 
only (!) command that triggers an association. Something that is 
nowhere seen in "man iwconfig". Before many commands did trigger 
an association, e.g. "iwconfig essid", "iwconfig key", "iwconfig 
ap" and also several ioctl's used only by wpa-supplicant.



> > As you can see, I'm not associated. However, this sequence
> > used to work with non-mac80211 based WLAN drivers. However,
> > I can actually associate if I reverse the essid/key, e.g.
> > first set the key, then the ssid.
>
> Can't say that matters since wext is actually sufficiently
> undefined to allow both behaviours. :)

Wrong.

Of course I can say that the ESSID,KEY sequence used to work with 
non-mac80211 based WLAN drivers. Because it worked. I have proof 
that it worked.

I might not be able to say that it worked for *ALL* non-mac80211 
based WLAN drivers. But I haven't said that.

And as of now, I can say that 6 drivers didn't care if I first 
feed the ESSID and the the WEP KEY:

* orinoco_cs works that way
* ipw2200 (in kernel) also
* wlags49_h1_cs (an out-of-kernel driver) also
* wlags49_h2_cs also
* bcm43xx (sucky in many ways) worked too
* libertas_cs/usb8xxx (in kernel) also
* madwifi also

One can say that if so many drivers behave identically, then this 
is a behavior that many users assume. And, oh, by the way, many 
distros.

It's the behavior of mac80211 with wext-compatibilty layer that 
behaves unusually or out-of-the-order.



> That sucks, I guess debian's scripts need to be fixed.

No, it doesn't. it worked for many years with various WLAN cards. 
How should Debian suck if it doesn't work when done manually?

In this case: what sucks is in the eye of the beholder.

Surely your own baby never sucks, compared with other babies. 
However, some other moms and fathers might say that the baby 
that is out-of-the-order sucks.

But then, ALL babies suck (breast, thumbs) during their first 
months ... :-)

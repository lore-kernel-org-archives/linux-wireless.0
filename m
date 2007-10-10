Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13278 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXJJHnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 03:43:19 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: automatically re-associate
Date: Wed, 10 Oct 2007 09:43:32 +0200
References: <200710091404.31491.hs4233@mail.mn-solutions.de> <200710091713.35595.hs4233@mail.mn-solutions.de> <1191944257.20014.3.camel@localhost.localdomain>
In-Reply-To: <1191944257.20014.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710100943.33106.hs4233@mail.mn-solutions.de> (sfid-20071010_084326_649509_E25B3239)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Yes, with a HZ/4 rate.
>
> I don't care how _fast_ it tries to reassociate.  I care that
> it doesn't give up after some amount of time.

And I don't want that the driver get's stuck after some arbitrary 
time. *NO OTHER DRIVER* that I know of get's stuck. The current 
libertas code has actually a built-in denial of service attack.

Libertas isn't just used in the OLPC, where can make sure some 
userspace tools does the job. I'll using libertas in PDA like 
devices, which used to have some HERMES I or HERMES II chips and 
have to switch to some other CF card because you can't buy CF 
cards with those chips any more. And on those device you can't 
just arbitrarily change the rest of the firmware.

So, at least in the no encryption & WEP obfuscation mode a WLAN 
driver should work without special user space software, because 
that's how real-life dictates the operation.

And, as said, otherwise you have a denial of service scenario.


> That's fine.  The drivers should _not_ be trying to handle all
> roaming cornercases themselves.

Either the driver or the firmware should handle all corner cases. 
With a HERMES II chip and a wlags49_h2_cs.ko driver, I can 
nicely roam with WPA+wpa_supplicant, and also with plain WEP 
(and no wpa_supplicant).

I see no technical reason why libertas shouldn't be able to do 
the same and behave like all other FULLMAC drivers.


> Userspace must come into the equation at some point, especially
> with WPA!!

I don't see that userspace *MUST* come into the equation at some 
point. If it *WISHES* to come into the equation: nothing hinders 
it. Running "iwevent" while killing the station at the AP yields 
these events:

10:38:43.139777   eth1     New Access Point/Cell 
address:Not-Associated
10:38:43.389217   eth1     Scan request completed
10:38:45.161671   eth1     New Access Point/Cell 
address:00:1B:53:11:E2:B0


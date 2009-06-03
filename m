Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35893 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZFBXh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 19:37:27 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Subject: Re: ar9170 vs otus advice?
Date: Wed, 3 Jun 2009 03:37:26 +0200
Cc: linux-wireless@vger.kernel.org
References: <1243894020.1559.22.camel@bigfoot-m4a75t>
In-Reply-To: <1243894020.1559.22.camel@bigfoot-m4a75t>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200906030337.27448.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 June 2009 00:07:00 Jon Loeliger wrote:
> > > mac80211 drivers:
> > > 
> > > agnx	-> http://git.sipsolutions.net/agnx.git
> > > at76_usb	-> replacement already in kernel.org code at drivers/net/wireless/at76c50x-usb.[ch]
> > > otus	-> replacement already in kernel.org code at drivers/net/wireless/ar9170/
> > 
> > Thanks for the summary.
> > 
> > Note, whenever a "real" wireless driver goes into the tree that
> > obsoletes any of the staging drivers, please let me know and I'll
> > instantly remove it.
> > 
> > Right now the otus code is staying because the ar9170 developers want it
> > to.
> 
> 
> So, I'm trying to understand the current state of the ar9170 and otus
> drivers so that I may know where to direction some effort.  I'd like to
> get an WN111v2 running with 11n support, and am willing to start with
> either the ar9170 or otus drivers as needed.  But I've not been following
> along in too much detail so far.

well, otus is a dead end. However it does fully support all 11n features the
device has to offer. But you'll need a special and very old wpa_supplicant.
(see otus' driver page on wireless.kernel.org where to get it.)

ar9170 - on the other hand -  is only capable of receiving 11n frames.
( that said, enabling it makes the device unstable and therefore one can
  only _sniff_ 11n frames coming from other stations for now. )

> Advice on where I should start, what's working, what's not working,
> what needs help, etc?
a lot! first and foremost needed is the _final_ 802.11n specification,
which sadly will still take a while... (2010? I think at least...)
it's a really mess now... As other devices/firmwares are usually designed
after a different revision of the drafts which makes it complicated.
This is no joke and the original otus incorporates "workarounds" for all
11n vendors (including Atheros itself) to get it going.
( else, the performance can be worse than 802.11b )

as for the mac80211 stack... I'm still waiting for minstrel
(rate algorithm) patches for HT MCS rate indexes.

On the ar9170 driver site: there is a big patch
floating around, however its hit or miss.

> And should I start with one of the linville Git trees? Or wireless-everything?

linville's wireless-testing is where we put the most recent code.

Regards,
	Chr

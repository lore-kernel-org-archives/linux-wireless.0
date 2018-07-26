Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lorien.comfychair.org ([173.8.144.98]:61262 "EHLO
        lorien.comfychair.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731412AbeG0BIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 21:08:25 -0400
Date: Thu, 26 Jul 2018 16:43:29 -0700
From: Danek Duvall <duvall@comfychair.org>
To: linux-wireless@vger.kernel.org
Subject: help understanding HT capabilities bits
Message-ID: <20180726234329.GA28336@lorien.comfychair.org> (sfid-20180727_015016_083628_F55431C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm writing a library using the nl80211 family to, well, do basically what
iw does (I want a reusable Golang-native implementation, which saves me
from parsing iw's output).  I have most of the bits that I need, but I'd
like to fill out more of the library and make it useful to others.

I'm a bit stuck on properly naming and describing the pieces of the HT
capabilities represented by NL80211_BAND_ATTR_HT_CAPA.  While being
generally impressed with the amount of documentation in nl80211.h and other
places, I've been unable to find any documentation on this particular
field, other than what iw prints for each bit or bit combination.

My first thought was that it was the set of per-band capabilities for the
device (as defined by either the hardware or the driver, but either way
below me enough that I don't think I care), and for the most part I still
think that's right.  But when it came to trying to represent the SMPS bits,
it occurred to me that perhaps that wasn't right, since one of the
supported values gets printed as "disabled", which seems more like a state
than a capability.  Also, "static" and "dynamic" are not representable
separately, and set together, you get "disabled".  But perhaps "disabled"
is really "unsupported", and "static" and "dynamic" can't both be supported
on the same band?

Otherwise, how should I interpret this?  I could simply leave it as a 0-3
value and let consumers handle the interpretation, but I'd like to be a bit
friendlier than that, if I can.

I've tried navigating the code from iw into nl80211.c, the mac80211 driver,
and the various 802.11 headers, but between the transitions from one layer
to the next and the distinctions between things named rdev and wiphy and
sta, I'm a bit lost trying to determine what represents an underlying
capability and what represents some sort of current state.  I'm a complete
newbie to this, both in code and concepts, but I hope I'm not so far in
over my head that a little help won't be very useful.

Thanks,
Danek

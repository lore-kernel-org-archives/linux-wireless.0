Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:39427 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbXFDTag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 15:30:36 -0400
Date: Mon, 4 Jun 2007 21:30:34 +0200
From: David Lamparter <lists@diac24.net>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: nl80211 status? (implying cfg80211 status)
Message-ID: <20070604193034.GA16350@charon.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list, Hi Johannes,


together with a friend of mine, I recently pondered about making linux
wireless configuration utilities more friendly to use. He did some  
hacking to add wext to iproute2, but got "use nl80211" as reply. (cf.
http://marc.info/?l=linux-netdev&m=117305184005985&w=2)

However, nl80211 still isn't near any usable state. Worse yet, even
the API is nowhere near sufficient for replacing wext. So I was
wondering if anyone is working on this. (google pointed me to
pynl80211, hence Cc: Johannes)

As far as I understand, the first thing to tackle is converting
everything to cfg80211 and making wext call cfg80211 functions,
putting all the compatibility cruft into that layer while at it. This
could be done incrementally, step-by-step, couldn't it? Or is there
major restructuring planned? If not, I'd certainly like spending a bit
of work on this (my time is as limited as everyone's, but I do have
some wasted time here and there). However, a proper outline of the API
needs to be thought of first.

My very-humble totally-irrelevant opinion would be that nl80211 should
provide all neccessary operations, only much more cleanly than wext
;). So that means, at least a PHY configuration command (am I missing
something or is there none yet?) with attributes to specify channel &
co. The "set association" command might be extended to work for
interfaces. Proprietary/custom driver extensions could be handled as
special attributes and/or special commands. (that explicitly excludes
the PRISM2 cruft though, those are actually rather generic IMHO)


Anyway, I'm hoping to start a little constructive discussion and
planning here. Opinions?


-David Lamparter


P.S.: While I'm aware that changing kernel APIs is a very bad idea,
I'm really thinking nl80211 isn't frozen yet. As far as I can tell,
only iwspy and pynl80211 are using it at all. This hopefully won't end
up as a compatibility nightmare AGAIN?


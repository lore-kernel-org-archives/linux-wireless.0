Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:51978 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYGEVLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 17:11:01 -0400
Received: by ik-out-1112.google.com with SMTP id c28so765880ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 14:10:59 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error =?iso-8859-15?q?in=09adhoc/master?= mode
Date: Sat, 5 Jul 2008 23:17:30 +0200
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <200807052137.59412.IvDoorn@gmail.com> <1215286630.6848.24.camel@johannes.berg>
In-Reply-To: <1215286630.6848.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807052317.31163.IvDoorn@gmail.com> (sfid-20080705_231125_367919_E3B2F64A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 July 2008, Johannes Berg wrote:
> 
> > That problem is only in rt2400pci and rt2500pci who raise the beacon interrupt,
> > all other drivers have the template and auto sequence numbers.
> 
> Ok.
> 
> > But no sequence numbers for the beacons, I think that will definately cause
> > problems for those 2 drivers.
> > 
> > But the function ieee80211_include_sequence() is being called from within the
> > ieee80211_beacon_get() function. Only for the Mesh it doesn't seem to be called.
> 
> Well it's not called from where the IBSS beacon is set either, and the
> IBSS beacon isn't generated every time anyway. So I'm confused now. Do
> rt2{4,5}00pci not support IBSS?

Well it does claim support for it, but it has been enabled only since 2.6.26, so the number
of people who have tested it is very limited. And so far little to no success stories...

The main trick in rt2x00lib is that it doesn't care if it is an IBSS or AP beacon, it will always
use the update_beacon() callback function to write the beacon to the hardware. It doesn't
need to differentiate between the beacon types (as far as I know, master mode isn't implemented
in the legacy drivers, and the only claim about if it is possible cones from Asus who owns the
closed source driver with AP functionality).

So for the Ralink hardware it just needs a completely valid beacon which it can transmit,
only for rt2400pci/rt2500pci it requires that the sequence number is set due to lacking
hardware sequence counting.
After that those 2 will raise an interrupt every beacon interval to request a new beacon,
which rt2x00lib fulfills by calling ieee80211_beacon_get().

Ivo

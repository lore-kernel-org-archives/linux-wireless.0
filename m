Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:44490 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYHSOKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 10:10:48 -0400
Date: Tue, 19 Aug 2008 16:10:46 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Use only precedence level of DSCP field for frame
	classification
Message-ID: <20080819141046.GA5946@notlob.celestrius.com> (sfid-20080819_161051_733274_F105F5B4)
References: <48AA887D.5090307@monom.org> <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net> <48AA8E2C.4060303@monom.org> <48AAAD30.2080207@monom.org> <48AAB70A.4090402@monom.org> <20080819134435.GB11660@notlob.celestrius.com> <1219154378.3476.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219154378.3476.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 19, 2008 at 03:59:38PM +0200, Johannes Berg wrote:
> On Tue, 2008-08-19 at 15:44 +0200, Daniel Wagner wrote:
> > Bit 4-5 of DSCP should not be considered by classify_d1. The
> > 802.11 QoS Priority field is only depending on the precedence level.
> 
> Mind explaining a bit more? I don't even know what DSCP really is, any
> good reference?

Sure. Cisco has a nice summery:

http://www.cisco.com/en/US/tech/tk543/tk757/technologies_tech_note09186a00800949f2.shtml

In short DSCP supercedes the 'Type of Service' field in the IP header. 
It is backwarts compatible, that means prescedence field in TOS
maps to the DSCP precedence level.

The current code checks if the other bits of the TOS are all zero. This
ok for configuration which do only set the precedence level. But
RFC 2598 introduces the Expeddited Forwarding (EF) which sets some
of those lower bits. I think this test is not necessary and in the
case for EF even wrong.

daniel

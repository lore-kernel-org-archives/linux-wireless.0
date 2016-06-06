Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:57237 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbcFFRbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 13:31:41 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: Dave Taht <dave.taht@gmail.com>
cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues 
In-reply-to: Your message of Mon, 06 Jun 2016 09:55:28 -0700.
             <CAA93jw7fdZhQvgCx7PXdB9yOS7ssKQFv6RG=RR2Hw9rjeXDYNQ@mail.gmail.com>
Date: Mon, 06 Jun 2016 13:31:45 -0400
Message-Id: <E1b9yNN-0007RA-00@www.xplot.org> (sfid-20160606_193144_635305_8D97EDF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> And the patchset I was testing included your fq_codel port for ath9k
> but it was based on codel5.h. Michal's latest stuff reworked mainline
> codel to be generically usable, and it *is* a different variant of the
> algorithm.

I think you probably do understand what you are doing and which patch
is which, but I want to make sure that everyone else (and you, just in
case) understands that my patch to ath9k hooks ath9k up to the new
mac80211 per-station and per-tid intermediate queues and does *not*
have any codel or fq stuff in it, and is useful and worth doing even
if you aren't taking the codel and fq stuff.   (I didn't port any
fq_codel stuff to ath9k.)

My ath9k patch is a prerequisite for people who want to take Michal's
mac80211 fq and mac80211 codel stuff for a test drive on an ath9k
interface.  (Otherwise the ath9k uses the old transmit path through
mac80211 which wouldn't touch Michal's fq and codel tweaks to
mac80211's new intermediate queues.)  But it is useful and there are
some benefits to it (especially with Michal's IFF_NO_QUEUE) even
without the fq and codel stuff.


			-Tim Shepard
			 shep@alum.mit.edu


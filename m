Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:56341 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbcFCRiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 13:38:06 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues 
In-reply-to: Your message of Fri, 03 Jun 2016 18:51:41 +0200.
             <20160603165144.17356-3-toke@toke.dk>
Date: Fri, 03 Jun 2016 13:10:06 -0400
Message-Id: <E1b8sbm-00083e-00@www.xplot.org> (sfid-20160603_193810_064365_64692D8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> Reworked to not require the global variable renaming in ath9k.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>


Huh.  I wonder why you did that?  Is it really better to call the
ieee80211_txq a swq and call the ath9k hardware queue a txq?  I
thought doing the renaming made for more readable and much more
maintainable code (where searching for text strings produced much
cleaner results when trying to track down all references).


I am grateful to learn that someone has read my patched version of
ath9k at least enough to do this rework.   Any comments on the actual
work?

I've recently figured out that I botched something to do with flow
control from the mac80211 intermediate queue into the hwq.  With my v2
patch the ath9k xmit path via the intermediate queues fails to
increment hwq->pending_frames, making the hwq_max_pending values
(which are tweakble in the debug file system) inneffective.  I'm in
the process of fixing this flaw in my patch and hope to have that done
soon so I can post a v3 of my ath9k patch.


Now I'm wondering if there is some reason I should also rework it to
avoid the renaming, making it more like what you just posted.

Or was your effort to rework the patch to avoid the renaming just to
make things easier in the interim while we (some of us) are testing
this patch in various systems (with slightly different versions of
ath9k driver)?


			-Tim Shepard
			 shep@alum.mit.edu

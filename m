Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:59467 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbcFQRpL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 13:45:11 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: Felix Fietkau <nbd@nbd.name>
cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/2] ath9k: use mac80211 intermediate software queues 
In-reply-to: Your message of Fri, 17 Jun 2016 16:35:50 +0200.
             <b6a2f65f-193b-755a-0781-d7eaeb0354dc@nbd.name>
Date: Fri, 17 Jun 2016 13:45:01 -0400
Message-Id: <E1bDxpG-0004Ic-00@www.xplot.org> (sfid-20160617_194525_347741_EF7DE8B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> I think we should finish intermediate queues support first and then look
> into the rename later.


Hmm... if the renaming is going to go in mainline, I feel pretty
strongly it should go in *before* a patch to switch over to use the
intermediate queues.  The whole point of the renaming was to make the
code that uses the intermediate queues much more understandable
(avoiding the unfortuante collision of "txq" meaning two different
things throughout the code).

Once it is all done and everyone's done reading and trying to
understand this code, there's much less reason to do the renaming.


Toke, how do you feel about this at this point?

I'm asking because I hope to have a new version of my patch soon
(fixing a bug in how it handles tid->hwq->pending_frames and
hq_max_pending[*] ), and I need to decide whether I should do it the
way I did last time (with the renaming txq in ath9k first) or produce
a new patch that is more like Toke's reworking of my patch.

Hmm...

			-Tim Shepard
			 shep@alum.mit.edu

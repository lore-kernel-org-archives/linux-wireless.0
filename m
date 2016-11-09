Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:45690 "EHLO www.xplot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcKIDHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 22:07:48 -0500
From: Tim Shepard <shep@alum.mit.edu>
To: Kalle Valo <kvalo@qca.qualcomm.com>
cc: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [v5] ath9k: Switch to using mac80211 intermediate software queues. 
In-reply-to: Your message of Wed, 09 Nov 2016 03:22:30 +0100.
             <1cd07522568b40a6a3e2db6170153c74@euamsexm01a.eu.qualcomm.com>
Date: Tue, 08 Nov 2016 21:44:42 -0500
Message-Id: <E1c4IsV-0003Rk-00@www.xplot.org> (sfid-20161109_040753_206963_85151945)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> While at it, could you also add to the commit log some info how awesome this
> patch is from user's point of view and how it helps. For example, before and
> and after numbers and other results.

That varies wildly, depending on many details of the scenario
(including the wireless capabilities of the clients connected to the
AP using this patch, and how far away those clients are).  There's
really not enough room in a commit message to explain enough to make
any such claimed numbers reproducible.

And, BTW, this patch alone is not really where the big improvement
comes from.  This just cuts ath9k over to use the new
transmit-a-packet interface between the mac80211 layer and the
wireless device driver.  All the good work to improve latency is being
done on the new mac80211 interface to the driver to transmit a packet.
If you want numbers in a commit message, those numbers belong over on
those commits, not on this ath9k commit, IMHO.

And there's different patches that taken together achieve the best
improvement, and in various subsets differing amounts of improvement,
which again all depends on the scenarios.

And all this is complicated by how often real users are involved in
scenarios where this matters (hard to say).


This mainly improves things when you have an ath9k interface with
packets queued simultaneously to different wireless destinations,
which is typically when the ath9k interface is serving as an AP.

And I would expect similar improvements for any wireless driver cut
over to use the new mac80211 interface.  (This patch might be a
helpful guide to other wireless driver maintainers wishing to see the
same improvements other wireless drivers.)

I hope that the above paragraphs were helpful.

			-Tim Shepard
			 shep@alum.mit.edu

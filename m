Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:35414 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3JVEQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 00:16:39 -0400
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-2ubuntu2) with ESMTP id r9M47aem018102
	for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 04:07:37 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-wireless@vger.kernel.org
Subject: RTL8187B is racy
Date: Tue, 22 Oct 2013 02:07:29 -0200
Message-ID: <or61sq3q4e.fsf@livre.home> (sfid-20131022_061643_809201_2792208A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been at least a year since I first noticed that, on WiFi-busy
environments such as airports, hotels and Free Software conferences, my
Yeeloong laptop with a RTL8187B WiFi card will freeze or oops shortly
after I enable WiFi.  This problem doesn't seem to happen when I'm at
home, probably because of the low WiFi traffic.  The problem occurs
while running 3.11.* and 3.10.* kernels, but not 3.4.* or 3.0.*.

I couldn't find any changes to the rtl8187 module that explain this
misbehavior, so I suspect it's some new source of parallelism in the
mac80211 layer that has exposed the lack of synchronization in uses of
rx_queue and b_tx_status.queue.  Indeed, I found many uses of these
queues that don't take locks to ensure consistency.  Unfortunately,
adding spin locks around all uses causes harder freezes and/or complains
about scheduling in atomic contexts, depending on which race I hit
first.  Without any changes, the problem I get most often is a crash
within rtl8187b_status_cb, when skb_unlink attempts to dereference a
NULL pointer.  Testing skb->prev and skb->next before entering the
branch where the skb is removed seemed to make the error a little bit
less frequent, but surely not enough for the machine to remain up for
very long while WiFi is enabled.

Is this a known problem?  Any suggestions on what I could try next to
fix the problem?

Thanks in advance,

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

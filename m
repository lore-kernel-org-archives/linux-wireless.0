Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54328 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYFWXcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 19:32:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Weird oops in mac80211's skb_orphan call
Date: Tue, 24 Jun 2008 01:32:21 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806240132.21362.mb@bu3sch.de> (sfid-20080624_013254_826192_E5523D05)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a 100% reproducable oops inside of the skb_orphan
call of mac80211's ieee80211_tx_status function.
I could only reproduce it with the CompactFlash bcm4318 card, yet.
So maybe the it's somehow related to b43's PIO code.

Here's the oops:
http://bu3sch.de/misc/sk_oops.JPG

As you can see, I added some debugging printks.
So let me explain what is going on.
After fireing up wpa_supplicant, ieee80211_tx_status is invoked several times
without crashing. But then suddenly it crashes on the skb_orphan call.
The skb_orphan call will call the skb destructor. You can see the
skb->destructor and skb->sk pointers right above the oops message.
The destructor pointer is assigned to sock_wfree() and the sk pointer is NULL.
So skb_orphan calls skb->destructor with skb->sk as parameter and sock_wfree (which
is the destructor) will dereference skb->sk. That will obviously crash.

Any ideas why skb->sk is NULL while the destructor is not NULL?
They should either be both NULL or not NULL.

-- 
Greetings Michael.

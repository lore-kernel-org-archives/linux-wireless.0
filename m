Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47927
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbXBDMog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 07:44:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Sun, 4 Feb 2007 13:44:18 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702041344.19117.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current TKIP hwcrypto phase1+2 key support in d80211
seems to be broken. (At least for bcm43xx).

Let me explain what happens:
We need the phase1 for bcm43xx. We need to upload it to
card memory and we need to pass it on every TX on the DMA.

So, currently we receive the phase1 key on the first
encrypted TX. That's too late, as we already receive encrypted
packets before that. bcm43xx needs the phase1 key (and the iv32)
on RX. It uses the one uploaded into the card memory. But it
is not uploaded, yet, as we did not TX any encrypted packet.

I'd say the only solution to this is to implement the earlier
suggested way of having a library function call to generate
the keys. Of course, that needs some bookkeeping about the IVs
and stuff.
That library function would be called by bcm43xx before any
traffic to get an initial phase1 key (and iv32) uploaded.

I currently don't really know how to implement this. Any suggestion?

As a sideeffect, it would shrink the txcontrol by 16 bytes, again.

-- 
Greetings Michael.

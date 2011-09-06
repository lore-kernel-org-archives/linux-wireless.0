Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1IFU2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 16:28:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R12FU-0004Hf-G5
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 22:28:00 +0200
Message-Id: <20110906201703.703254041@sipsolutions.net> (sfid-20110906_222815_612924_D7D94DA4)
Date: Tue, 06 Sep 2011 22:27:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/5] mac80211 AP-side uAPSD support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, here's a braindump in the form of patches for today.

Basically, adding uAPSD support has two difficulties:
 1) we need to split the TX PS buffering into ACs
 2) we need to appropriately open an SP when the peer
    asks for it

Both are complicated by the fact that drivers might
buffer packets, e.g. ath9k on its software aggregation
queues and iwlwifi on its HW queues. This warrants a
separate patch in this set, but the drivers will have
to follow and implement the new API properly.

Also included is another fix, and a patch to notify
mac80211 about the end of the SP (EOSP) "out of band",
i.e. not with a TX status notification. I don't think
this will be used by ath9k since it can add the EOSP
status flag to the right packet when adding the EOSP
bit in the QoS header, but iwlwifi will probably need
this -- I'm not quite sure yet.

Please comment!

NB: I wouldn't try to run this if I were you, unless
you're interested in adding support to a driver. Since
I don't have driver support for any of it yet I haven't
yet tested this at all. It compiles and seems to make
sense ;-)

johannes


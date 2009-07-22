Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49239 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZGVHea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 03:34:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MTWLL-0000pM-Lp
	for linux-wireless@vger.kernel.org; Wed, 22 Jul 2009 07:34:27 +0000
Received: from d5153017D.static.telenet.be ([d5153017D.static.telenet.be])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 07:34:27 +0000
Received: from Gert.Boddaert by d5153017D.static.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 07:34:27 +0000
To: linux-wireless@vger.kernel.org
From: Gert Boddaert <Gert.Boddaert@Boditec.be>
Subject: rt2x00 : big-endianess broken for rt73usb (master mode) for e.g. xscale and powerpc
Date: Wed, 22 Jul 2009 07:34:16 +0000 (UTC)
Message-ID: <loom.20090722T072047-806@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was able to do some testing on the rt73usb driver.
As mentioned in an earlier post, the latest driver breaks the master mode.
Although a linux client (x86 laptop) can connect to the rt73usb AP, 
a windows XP client (x86 laptop) cannot. 
I fails to obtain a DHCP address. 

In order to reproduce the bug, you need a big-endian system with a rt73usb
stick, and hostapd. 
I did not test client mode for big-endian systems.

Breaking down the different patches that were applied since 8 april 2009, I was
able to identify the culprit. 
No solution yet, but I thought I should flag this
as a bug.

It is the following patch that breaks big-endian compatibility:

***
Some hardware require L2 padding between header and payload
because both must be aligned to a 4-byte boundary. This hardware
also is easier during the RX path since we no longer need to
move the entire payload but rather only the header to remove
the padding (mac80211 only wants the payload to be 4-byte aligned).

Signed-off-by: Ivo van Doorn <IvDoorn@...>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |   10 ++++
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   68 +++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   33 +++++++------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   27 +++++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   39 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   14 +++++-
 6 files changed, 143 insertions(+), 48 deletions(-)

(...)


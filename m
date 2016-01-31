Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:56822 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbcAaWYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 17:24:43 -0500
Date: Sun, 31 Jan 2016 23:24:41 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: mt76 tx status
Message-ID: <20160131222441.GA20283@sig21.net> (sfid-20160131_232450_520910_F7DD56FB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

I noticed in mt76x2_mac_poll_tx_status() you are reading
MT_TX_STAT_FIFO before reading MT_TX_STAT_FIFO_EXT,
however I have a hunch that reading MT_TX_STAT_FIFO clobbers
the corresponding MT_TX_STAT_FIFO_EXT since MT_TX_STAT_FIFO
has the valid bit, and both registers together seem to implement
reading a 64bit FIFO entry.  I.e. you need to read
MT_TX_STAT_FIFO_EXT first otherwise you get a mix from
two FIFO entries.

I played a bit with the vendor driver for the mt7610u
and confirmed that multiple reads from MT_TX_STAT_FIFO_EXT
return the same value until MT_TX_STAT_FIFO is read.
(Note the mt7610u vendor driver does not define FIFO_EXT_SUPPORT
but the FIFO seems to exist in hardware.  The mt7612u vendor driver
code reads the MT_TX_STAT_FIFO_EXT first.)


Johannes

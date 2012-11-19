Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:40899 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2KSTeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 14:34:00 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: FYI: "Failed to stop TX DMA!"  not fixed in kernel 3.6.7
Date: Mon, 19 Nov 2012 19:33:56 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10F39@RockMX01.rock.corp> (sfid-20121119_203405_497705_F506E7E8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just FYI

Kernel 3.6.7 change log says "This patch might fix crashes and "Failed to stop TX DMA!" messages."

I tried it on Dell laptop with ar9390 radio.
Still, I got error message like below

"ath: phy0: Failed to stop TX DMA, queues=0x005!"
"ath: phy0: Failed to stop TX DMA, queues=0x001!"

I am testing 802.11s mesh on 802.11a channel 40, no HT enabled.


-----------------------------

commit cd585fb70b89fb57f8dffb03a2a72c30f81f5da6
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Fri Oct 26 00:31:11 2012 +0200

    ath9k: fix stale pointers potentially causing access to free'd skbs
    
    commit 8c6e30936a7893a85f6222084f0f26aceb81137a upstream.
    
    bf->bf_next is only while buffers are chained as part of an A-MPDU
    in the tx queue. When a tid queue is flushed (e.g. on tearing down
    an aggregation session), frames can be enqueued again as normal
    transmission, without bf_next being cleared. This can lead to the
    old pointer being dereferenced again later.
    
    This patch might fix crashes and "Failed to stop TX DMA!" messages.
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64201 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab0JZIks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 04:40:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 01:40:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <greearb@candelatech.com>, <kyungwan.nam@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 0/3] ath9k: more PCU locking enhancements
Date: Tue, 26 Oct 2010 01:40:38 -0700
Message-ID: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is some more PCU locking enhancements I tested today
while trying to resolve the WARN() that happens when we
try to stop RX DMA and fail. While working on that I figured
I'd work on the TX DMA stuff too, here's a shot at it. I
can no longer get TX / RX DMA rants, please test and let
me know if you do. I only tried some basic testing like
rmmoding while scannign, which typicallly produced some
errors. Now I don't get squat.

Ben if you can test wit your super proprietary application
that'd be great.

This also simplifies locking considerably.

This doesn't break suspend so I'm happy. It also depends
on the last RX DMA fixes I had posted earlier. If you'd
like to get an all-in-one patch of all my patches pending
you can wget this file and git am it:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/tmp/pending-mcgrof-2010-10-26-v1.patch
sha1sum: 874a3cc1a57f7e26ad191cd7b5045315f94c5823

If they do indeed fix the rants, then great, but not sure
if they warrant to be stable fixes.

If this works trick was to not mess with contend on the PCU for RX or TX
and for resets, all together. There is one call not protected here
though, the ath_tx_start_dma() but not sure how to address that or if we
need to.

Luis R. Rodriguez (3):
  ath9k: simplify hw reset locking
  ath9k: move the PCU lock to the sc structure
  ath9k: content DMA start / stop through the PCU lock

 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +-
 drivers/net/wireless/ath/ath9k/init.c  |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   70 ++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 +-
 5 files changed, 34 insertions(+), 46 deletions(-)

-- 
1.7.3.2.90.gd4c43


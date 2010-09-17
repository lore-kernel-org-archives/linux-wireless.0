Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:15353 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752690Ab0IQCgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:00 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-011752957
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:35:58 +0900 (JST)
Subject: [PATCH 00/11] ath5k: Add multiple queues / QoS support + more
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:19 +0900
Message-ID: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now rebased to wireless-next and includes a fixup for a merge issue
of the crypto series and Bob's reordering patch. I hope you don't mind - I
will be gone for the next week, so I need to push this out now.

The following series adds WME QoS for ath5k by using four hardware queues
and adding the necessary callback function for mac80211 to configure the
queue parameters.

Unfortunately, if we use multiple queues, the hardware can get stuck, and we
don't know a better solution than resetting the hardware in this case. This
is the same situation as in ath9k and i have copied the workaround from
there.

bruno

---

Bob Copeland (1):
      This change reorganizes the main ath5k file in order to re-group

Bruno Randolf (10):
      ath/ath5k/ath9k: Fix crypto capabilities merge issue
      ath5k: Use four hardware queues
      ath5k: Fix queue debug file
      ath5k: Fix TX queues stopping
      ath5k: Move tx frame completion into separate function
      ath5k: Add watchdog for stuck TX queues
      ath5k: Count how many times a queue got stuck
      ath5k: Keep last descriptor in queue
      ath5k: Simplify cw_min/max and AIFS configuration
      ath5k: Add tx queue configuration function


 drivers/net/wireless/ath/ath.h          |    9 
 drivers/net/wireless/ath/ath5k/ath5k.h  |   13 
 drivers/net/wireless/ath/ath5k/attach.c |    5 
 drivers/net/wireless/ath/ath5k/base.c   | 1972 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath5k/base.h   |    9 
 drivers/net/wireless/ath/ath5k/debug.c  |   11 
 drivers/net/wireless/ath/ath5k/qcu.c    |   99 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    2 
 8 files changed, 1065 insertions(+), 1055 deletions(-)

-- 
Signature

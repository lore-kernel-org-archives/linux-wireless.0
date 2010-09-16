Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:16044 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498Ab0IPJu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:50:58 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-032788654
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:50:55 +0900 (JST)
Subject: [PATCH 0/9] ath5: Add multiple queues / QoS support
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:51:13 +0900
Message-ID: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series adds WME QoS for ath5k by using four hardware queues
and adding the necessary callback function for mac80211 to configure the
queue parameters.

It is based on my last series ("PATCH 0/8] ath: Move key cache functions 
to ath common") and Bobs reordered base.c ("ath5k: reorder base.c to remove 
fwd decls"). Please let me know if you have any merge issues and i'll resend
the whole series.

Unfortunately, if we use multiple queues, the hardware can get stuck, and we
don't know a better solution than resetting the hardware in this case. This
is the same situation as in ath9k and i have copied the workaround from
there.

bruno

---

Bruno Randolf (9):
      ath5k: Use four hardware queues
      ath5k: Fix queue debug file
      ath5k: Fix TX queues stopping
      ath5k: Move tx frame completion into separate function
      ath5k: Add watchdog for stuck TX queues
      ath5k: Count how many times a queue got stuck
      ath5k: Keep last descriptor in queue
      ath5k: Simplify cw_min/max and AIFS configuration
      ath5k: Add tx queue configuration function


 drivers/net/wireless/ath/ath5k/ath5k.h  |   13 -
 drivers/net/wireless/ath/ath5k/attach.c |    2
 drivers/net/wireless/ath/ath5k/base.c   |  322 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath5k/base.h   |    9 +
 drivers/net/wireless/ath/ath5k/debug.c  |   11 +
 drivers/net/wireless/ath/ath5k/qcu.c    |   99 +++++-----
 6 files changed, 302 insertions(+), 154 deletions(-)

--
Signature
~                      

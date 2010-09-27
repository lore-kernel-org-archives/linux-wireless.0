Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:35339 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757895Ab0I0DWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 23:22:15 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0586537731
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:22:12 +0900 (JST)
Subject: [PATCH 0/4] ath5k: ATIM and timer fixes
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 12:22:11 +0900
Message-ID: <20100927032211.8754.49870.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series adds a check for a hardware condition which can cause
an unwanted ATIM window configuration and some other smaller improvements for
TSF related things.

---

Bruno Randolf (4):
      ath5k: Remove unused variable for atim window
      ath5k: Check and fix ATIM window
      ath5k: Increase "fudge" for beacon timers
      ath5k: Disable interrupts in ath5k_hw_get_tsf64


 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 -
 drivers/net/wireless/ath/ath5k/attach.c |    1
 drivers/net/wireless/ath/ath5k/base.c   |   16 ++++-
 drivers/net/wireless/ath/ath5k/pcu.c    |   99 +++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 5 deletions(-)

--
Signature

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22869 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751902Ab0FPKL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:11:29 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0574623085
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:25 +0900 (JST)
Subject: [PATCH 00/17] ath5: descriptor cleanup series
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:07 +0900
Message-ID: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!

this series is a bunch of smaller changes i made while reviewing rx buffer
handling and some stuff i picked up while carefully reviewing the descriptor
definitions from the HAL against what we have. it's mostly cosmetics and
refactoring.

greetings,
bruno

---

Bruno Randolf (17):
      ath5k: more debug prints for resets
      ath5k: rename ath5k_txbuf_free() to ath5k_txbuf_free_skb()
      ath5k: fix some comment typos
      ath5k: fix rx descriptor debugging
      ath5k: print more errors when decriptor setup fails
      ath5k: reset more pointers after we free skbs
      ath5k: unify rx descriptor error handling
      ath5k: split descriptor handling and frame receive
      ath5k: move checks and stats into new function
      ath5k: use direct function calls for descriptors when possible
      ath5k: cosmetic changes in ath5k_hw_proc_5212_rx_status()
      ath5k: remove pointless rx error overlay struct
      ath5k: review and add comments for descriptors
      ath5k: update 5210/5211 frame types
      ath5k: take descriptor differences between 5210 and 5211 into account
      ath5k: review RX descriptor functions
      ath5k: report PHY error frames only for chips which need it


 drivers/net/wireless/ath/ath5k/ath5k.h |   12 +
 drivers/net/wireless/ath/ath5k/base.c  |  335 ++++++++++++++++++--------------
 drivers/net/wireless/ath/ath5k/debug.c |    5 
 drivers/net/wireless/ath/ath5k/desc.c  |  145 +++++++-------
 drivers/net/wireless/ath/ath5k/desc.h  |  310 ++++++++++++++----------------
 5 files changed, 409 insertions(+), 398 deletions(-)

-- 
Signature

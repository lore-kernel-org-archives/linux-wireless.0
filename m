Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1DRNfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:38 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/23] rt2x00: Fix stuck queue in tx failure case
Date: Mon, 18 Apr 2011 15:26:37 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com>
In-Reply-To: <201104181526.01722.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181526.37747.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since commit 0b7fde54f94979edc67bbf86b5adba702ebfefe8 "rt2x00: Protect
queue control with mutex" rt2x00 used rt2x00queue_pause_queue for
stopping a tx queue in mac80211. But in case of a failure in the tx
path rt2x00 still called ieee80211_stop_queue which stopped the queue
but prevented rt2x00queue_unpause_queue to wake the queue up again
resulting in a stuck tx queue.

Fix this by also using rt2x00queue_pause_queue in case of tx failures.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 661c6ba..4a1c41b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -158,7 +158,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return;
 
  exit_fail:
-	ieee80211_stop_queue(rt2x00dev->hw, qid);
+	rt2x00queue_pause_queue(queue);
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
-- 
1.7.2.3


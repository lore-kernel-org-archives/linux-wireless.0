Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab1CCSsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:23 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/19] rt2x00: Remove useless NULL check
Date: Thu, 3 Mar 2011 19:39:56 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031939.28091.IvDoorn@gmail.com>
In-Reply-To: <201103031939.28091.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031939.57117.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since tx_info->control.vif was already accessed before it cant't be NULL
here.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index bf9bba3..b32ca31 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -221,8 +221,7 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	unsigned long irqflags;
 
-	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) ||
-	    unlikely(!tx_info->control.vif))
+	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		return;
 
 	/*
-- 
1.7.2.3


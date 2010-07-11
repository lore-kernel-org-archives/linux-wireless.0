Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36634 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0GKKcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:04 -0400
Received: by ewy23 with SMTP id 23so640223ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/17] rt2x00: Make rt2800_write_beacon only export to GPL
Date: Sun, 11 Jul 2010 12:26:12 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111225.18986.IvDoorn@gmail.com> <201007111225.47409.IvDoorn@gmail.com>
In-Reply-To: <201007111225.47409.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111226.13314.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800_write_beacon is the only function which uses
EXPORT_SYMBOL instead of EXPORT_SYMBOL_GPL. All symbols
in rt2x00 should however use the GPL restricted export.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bcf50fc..afad3e1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -473,7 +473,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	dev_kfree_skb_any(entry->skb);
 	entry->skb = NULL;
 }
-EXPORT_SYMBOL(rt2800_write_beacon);
+EXPORT_SYMBOL_GPL(rt2800_write_beacon);
 
 static void inline rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
 				       unsigned int beacon_base)
-- 
1.7.1.1


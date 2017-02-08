Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754477AbdBHNIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 08:08:54 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 3/3] rt2x00: remove queue_entry from skbdesc
Date: Wed,  8 Feb 2017 13:51:31 +0100
Message-Id: <1486558291-1615-4-git-send-email-sgruszka@redhat.com> (sfid-20170208_140921_580809_0BB9E4C4)
In-Reply-To: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

queue_entry field of skbdesc is not read any more, remove it to allow
skbdesc contain other data.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 3 ---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 380daf4..e1660b9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -83,7 +83,6 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->entry = entry;
 
 	if (rt2x00_has_cap_flag(rt2x00dev, REQUIRE_DMA)) {
 		dma_addr_t skb_dma;
@@ -689,7 +688,6 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 		goto out;
 	}
 
-	skbdesc->entry = entry;
 	entry->skb = skb;
 
 	/*
@@ -774,7 +772,6 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	 */
 	skbdesc = get_skb_frame_desc(intf->beacon->skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->entry = intf->beacon;
 
 	/*
 	 * Send beacon to hardware.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index 2233b91..22d1881 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -116,8 +116,6 @@ struct skb_frame_desc {
 	__le32 iv[2];
 
 	dma_addr_t skb_dma;
-
-	struct queue_entry *entry;
 };
 
 /**
-- 
1.8.3.1

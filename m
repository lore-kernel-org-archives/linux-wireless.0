Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58501 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbZLDVg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 16:36:29 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Benoit Papillault <benoit.papillault@free.fr>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: Fix trimming of L2 padded frames.
Date: Fri,  4 Dec 2009 22:36:17 +0100
Message-Id: <1259962577-25135-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that frames without payload are properly trimmed in
rt2x00queue_insert_l2pad.

This should fix the bug reported by Benoit Papillault in:
http://marc.info/?l=linux-wireless&m=125974773006734&w=2

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7452fa8..3d8fb68 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -180,7 +180,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
 	unsigned int payload_length = skb->len - header_length;
 	unsigned int header_align = ALIGN_SIZE(skb, 0);
 	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = L2PAD_SIZE(header_length);
+	unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
 
 	/*
 	 * Adjust the header alignment if the payload needs to be moved more
-- 
1.6.5.3


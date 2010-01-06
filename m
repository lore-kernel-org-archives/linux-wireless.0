Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:63425 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493Ab0AFWw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:52:58 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.33 8/8] rt2x00: Fix trimming of L2 padded frames.
Date: Wed,  6 Jan 2010 23:52:49 +0100
Message-Id: <1262818369-16820-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262818369-16820-8-git-send-email-gwingerde@gmail.com>
References: <1262818369-16820-1-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-2-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-3-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-4-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-5-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-6-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-7-git-send-email-gwingerde@gmail.com>
 <1262818369-16820-8-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that frames without payload are properly trimmed in
rt2x00queue_insert_l2pad.

This should fix the bug reported by Benoit Papillault in:
http://marc.info/?l=linux-wireless&m=125974773006734&w=2

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 8f6dc8b..aad6e4d 100644
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
1.6.6


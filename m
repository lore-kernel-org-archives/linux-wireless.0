Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55862 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762610AbXLMG7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:14 -0500
Subject: [PATCH 49/48] libertas: fix use-after-free error
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2Q-0005qn-4n@shinybook.infradead.org> (sfid-20071213_065920_101073_DE68B89C)
Date: Thu, 13 Dec 2007 01:59:18 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Mon, 10 Dec 2007 12:19:55 +0100

Previously, the display of subscribed events could be wrong.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/debugfs.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index e8a24d7..f4858bd 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -409,30 +409,32 @@ static ssize_t lbs_threshold_read(
 	char *buf = (char *)addr;
 	u8 value;
 	u8 freq;
+	int events = 0;
 
-	struct cmd_ds_802_11_subscribe_event *events = kzalloc(
+	struct cmd_ds_802_11_subscribe_event *subscribed = kzalloc(
 		sizeof(struct cmd_ds_802_11_subscribe_event),
 		GFP_KERNEL);
 	struct mrvlietypes_thresholds *got;
 
 	res = lbs_prepare_and_send_command(priv,
 			CMD_802_11_SUBSCRIBE_EVENT, CMD_ACT_GET,
-			CMD_OPTION_WAITFORRSP, 0, events);
+			CMD_OPTION_WAITFORRSP, 0, subscribed);
 	if (res) {
-		kfree(events);
+		kfree(subscribed);
 		return res;
 	}
 
-	got = lbs_tlv_find(tlv_type, events->tlv, sizeof(events->tlv));
+	got = lbs_tlv_find(tlv_type, subscribed->tlv, sizeof(subscribed->tlv));
 	if (got) {
 		value = got->value;
 		freq  = got->freq;
+		events = le16_to_cpu(subscribed->events);
 	}
-	kfree(events);
+	kfree(subscribed);
 
 	if (got)
 		pos += snprintf(buf, len, "%d %d %d\n", value, freq,
-			!!(le16_to_cpu(events->events) & event_mask));
+			!!(events & event_mask));
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-- 
1.5.3.4


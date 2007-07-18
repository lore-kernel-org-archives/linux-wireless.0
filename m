Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19433 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754037AbXGRHak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 03:30:40 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] p54: fix firmware parser
Date: Wed, 18 Jul 2007 00:29:30 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200707180029.30935.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The firmware parser in prism54common.c does not check for the end of
bootrecs properly. This patch fixes it.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/mac80211/p54/prism54common.c |    5 ++---
 drivers/net/wireless/mac80211/p54/prism54common.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211/p54/prism54common.c b/drivers/net/wireless/mac80211/p54/prism54common.c
index f319282..08b7d1e 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.c
+++ b/drivers/net/wireless/mac80211/p54/prism54common.c
@@ -44,7 +44,8 @@ void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 
 	bootrec = (struct bootrec *) data;
 
-	while ((bootrec->data + le32_to_cpu(bootrec->len)) < end_data) {
+	while (bootrec->data <= end_data &&
+	       (bootrec->data + le32_to_cpu(bootrec->len)) <= end_data) {
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
@@ -85,8 +86,6 @@ void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 			break;
 		}
 		bootrec = (struct bootrec *)&bootrec->data[le32_to_cpu(bootrec->len)];
-		if ((u32 *)bootrec > end_data)
-			break;
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
diff --git a/drivers/net/wireless/mac80211/p54/prism54common.h b/drivers/net/wireless/mac80211/p54/prism54common.h
index 1520f29..3c67c12 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.h
+++ b/drivers/net/wireless/mac80211/p54/prism54common.h
@@ -18,7 +18,7 @@
 struct bootrec {
 	__le32 code;
 	__le32 len;
-	u32 data[];
+	u32 data[0];
 } __attribute__((packed));
 
 struct bootrec_exp_if {


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:50657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYGINEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:04:09 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2127384wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:04:09 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Add support for CTS protection in rt2x00lib
Date: Wed, 9 Jul 2008 15:12:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200807091511.14288.IvDoorn@gmail.com> <200807091511.45779.IvDoorn@gmail.com>
In-Reply-To: <200807091511.45779.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807091512.06678.IvDoorn@gmail.com> (sfid-20080709_150413_003584_0370033C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inform drivers about the changed CTS protection settings.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2 +-
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9ad3ce4..b32fedf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -434,6 +434,7 @@ struct rt2x00lib_conf {
  */
 struct rt2x00lib_erp {
 	int short_preamble;
+	int cts_protection;
 
 	int ack_timeout;
 	int ack_consume_time;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 48608e8..f20ca71 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -84,6 +84,8 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	memset(&erp, 0, sizeof(erp));
 
 	erp.short_preamble = bss_conf->use_short_preamble;
+	erp.cts_protection = bss_conf->use_cts_prot;
+
 	erp.ack_timeout = PLCP + get_duration(ACK_SIZE, 10);
 	erp.ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 84b51f4..ff853c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -511,7 +511,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+	if (changes & (BSS_CHANGED_ERP_PREAMBLE | BSS_CHANGED_ERP_CTS_PROT)) {
 		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 			rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
 		else
-- 
1.5.6.1


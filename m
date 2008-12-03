Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:40811 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYLCQab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 11:30:31 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1538556eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 08:30:29 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: Fix check for BSS info changes
Date: Wed, 3 Dec 2008 17:29:21 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812031729.21220.IvDoorn@gmail.com> (sfid-20081203_173035_468611_DE4E791F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix ERP configuration, due to a too strict changes
flags checking we never updated the short slot time
or basic rate mask when no other changes were made
at the same time.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index fa91ca5..dded680 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -634,7 +634,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & (BSS_CHANGED_ERP_PREAMBLE | BSS_CHANGED_ERP_CTS_PROT)) {
+	if (changes & ~(BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
 		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 			rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
 		else
-- 
1.5.6.1


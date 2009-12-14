Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:49600 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZLNWck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:32:40 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2.6.33] rt2x00: Fix calculation of rt2800 iveiv entry offset.
Date: Mon, 14 Dec 2009 23:32:31 +0100
Message-Id: <1260829951-27139-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo. The index should be multiplied by the entry size, not 'and'-ed.

Found via code-inspection.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c5fe867..1a7eae3 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1323,7 +1323,7 @@
 #define PAIRWISE_KEY_ENTRY(__idx) \
 	( PAIRWISE_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)) )
 #define MAC_IVEIV_ENTRY(__idx) \
-	( MAC_IVEIV_TABLE_BASE + ((__idx) & sizeof(struct mac_iveiv_entry)) )
+	( MAC_IVEIV_TABLE_BASE + ((__idx) * sizeof(struct mac_iveiv_entry)) )
 #define MAC_WCID_ATTR_ENTRY(__idx) \
 	( MAC_WCID_ATTRIBUTE_BASE + ((__idx) * sizeof(u32)) )
 #define SHARED_KEY_ENTRY(__idx) \
-- 
1.6.5.5


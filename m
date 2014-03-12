Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:58299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755569AbaCLRXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:23 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] ath9k: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:38 -0700
Message-Id: <b44fc68ea21f435c665dee1b2d1d89d6e53bd703.1394644825.git.joe@perches.com> (sfid-20140312_182414_362537_A08DD8A0)
In-Reply-To: <cover.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b8daff7..d7625ec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -23,8 +23,8 @@
 #define COMP_HDR_LEN 4
 #define COMP_CKSUM_LEN 2
 
-#define LE16(x) __constant_cpu_to_le16(x)
-#define LE32(x) __constant_cpu_to_le32(x)
+#define LE16(x) cpu_to_le16(x)
+#define LE32(x) cpu_to_le32(x)
 
 /* Local defines to distinguish between extension and control CTL's */
 #define EXT_ADDITIVE (0x8000)
-- 
1.8.1.2.459.gbcd45b4.dirty


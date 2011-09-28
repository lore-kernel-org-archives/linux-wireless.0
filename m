Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1I1Jba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 05:31:30 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCHv3] wireless: at76c50x: use native hex_pack_byte() method
Date: Wed, 28 Sep 2011 12:30:59 +0300
Message-Id: <e05a153fe0dfcd8f29be52eb8b8ea14a00f020dd.1317202208.git.andriy.shevchenko@linux.intel.com> (sfid-20110928_113133_628774_05B61B17)
In-Reply-To: <20110927154739.2cd368d5@mj>
References: <20110927154739.2cd368d5@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
 drivers/net/wireless/at76c50x-usb.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 2986014..39322d4 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -500,10 +500,9 @@ exit:
 
 #define HEX2STR_BUFFERS 4
 #define HEX2STR_MAX_LEN 64
-#define BIN2HEX(x) ((x) < 10 ? '0' + (x) : (x) + 'A' - 10)
 
 /* Convert binary data into hex string */
-static char *hex2str(void *buf, int len)
+static char *hex2str(void *buf, size_t len)
 {
 	static atomic_t a = ATOMIC_INIT(0);
 	static char bufs[HEX2STR_BUFFERS][3 * HEX2STR_MAX_LEN + 1];
@@ -514,18 +513,17 @@ static char *hex2str(void *buf, int len)
 	if (len > HEX2STR_MAX_LEN)
 		len = HEX2STR_MAX_LEN;
 
-	if (len <= 0) {
-		ret[0] = '\0';
-		return ret;
-	}
+	if (len == 0)
+		goto exit;
 
 	while (len--) {
-		*obuf++ = BIN2HEX(*ibuf >> 4);
-		*obuf++ = BIN2HEX(*ibuf & 0xf);
+		obuf = pack_hex_byte(obuf, *ibuf++);
 		*obuf++ = '-';
-		ibuf++;
 	}
-	*(--obuf) = '\0';
+	obuf--;
+
+exit:
+	*obuf = '\0';
 
 	return ret;
 }
-- 
1.7.6.3


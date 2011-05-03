Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2278 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1ECJhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:37:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 55/61] staging: brcm80211: remove CRC_INNER_LOOP macro
Date: Tue, 3 May 2011 11:35:55 +0200
Message-ID: <1304415361-7813-56-git-send-email-arend@broadcom.com> (sfid-20110503_114020_095520_CD63B47A)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the removal of hndcrc16 and hndcrc32 this macro is not needed
anymore. Also the crc-ccitt library functions provide an equivalent
static inline function for this operation.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/bcmutils.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index bcaf911..7337a75 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -564,16 +564,11 @@ static const u8 crc8_table[256] = {
 	0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F
 };
 
-#define CRC_INNER_LOOP(n, c, x) \
-	((c) = ((c) >> 8) ^ crc##n##_table[((c) ^ (x)) & 0xff])
-
 u8 hndcrc8(u8 *pdata,	/* pointer to array of data to process */
 			 uint nbytes,	/* number of input data bytes to process */
 			 u8 crc	/* either CRC8_INIT_VALUE or previous return value */
     ) {
-	/* hard code the crc loop instead of using CRC_INNER_LOOP macro
-	 * to avoid the undefined and unnecessary (u8 >> 8) operation.
-	 */
+	/* loop over the buffer data */
 	while (nbytes-- > 0)
 		crc = crc8_table[(crc ^ *pdata++) & 0xff];
 
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12171 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbcA1HQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:28 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/12] staging: wilc1000: renames u16index variable
Date: Thu, 28 Jan 2016 16:13:38 +0900
Message-ID: <1453965226-6158-4-git-send-email-leo.kim@atmel.com> (sfid-20160128_081634_983190_9C4D46CA)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16index variable to index
to remove the prefix variable defined name.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b769d3c..6f17e2b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -243,14 +243,14 @@ static inline u16 get_asoc_id(u8 *data)
 
 static u8 *get_tim_elm(u8 *pu8msa, u16 rx_len, u16 tag_param_offset)
 {
-	u16 u16index;
+	u16 index;
 
-	u16index = tag_param_offset;
+	index = tag_param_offset;
 
-	while (u16index < (rx_len - FCS_LEN)) {
-		if (pu8msa[u16index] == ITIM)
-			return &pu8msa[u16index];
-		u16index += (IE_HDR_LEN + pu8msa[u16index + 1]);
+	while (index < (rx_len - FCS_LEN)) {
+		if (pu8msa[index] == ITIM)
+			return &pu8msa[index];
+		index += (IE_HDR_LEN + pu8msa[index + 1]);
 	}
 
 	return NULL;
-- 
1.9.1


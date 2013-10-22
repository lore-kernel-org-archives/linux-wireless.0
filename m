Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44946 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab3JVWZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/6] mwifiex: fix invalid memory access in mwifiex_get_power_level()
Date: Tue, 22 Oct 2013 15:24:44 -0700
Message-ID: <1382480687-12720-4-git-send-email-bzhao@marvell.com> (sfid-20131023_002507_400631_D6CDE777)
In-Reply-To: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
References: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

With "while (length)" check we may end up in accessing invalid
memory in last iteration.
This patch makes sure that tlv length is not less than the length
of structure mwifiex_power_group when min/max power is calculated.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index bdf50fd..5edea4d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -341,12 +341,16 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 	pg = (struct mwifiex_power_group *)
 		((u8 *) pg_tlv_hdr + sizeof(struct mwifiex_types_power_group));
 	length = le16_to_cpu(pg_tlv_hdr->length);
-	if (length > 0) {
-		max_power = pg->power_max;
-		min_power = pg->power_min;
-		length -= sizeof(struct mwifiex_power_group);
-	}
-	while (length) {
+
+	/* At least one structure required to update power */
+	if (length < sizeof(struct mwifiex_power_group))
+		return 0;
+
+	max_power = pg->power_max;
+	min_power = pg->power_min;
+	length -= sizeof(struct mwifiex_power_group);
+
+	while (length >= sizeof(struct mwifiex_power_group)) {
 		pg++;
 		if (max_power < pg->power_max)
 			max_power = pg->power_max;
@@ -356,10 +360,8 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 
 		length -= sizeof(struct mwifiex_power_group);
 	}
-	if (le16_to_cpu(pg_tlv_hdr->length) > 0) {
-		priv->min_tx_power_level = (u8) min_power;
-		priv->max_tx_power_level = (u8) max_power;
-	}
+	priv->min_tx_power_level = (u8) min_power;
+	priv->max_tx_power_level = (u8) max_power;
 
 	return 0;
 }
-- 
1.8.2.3


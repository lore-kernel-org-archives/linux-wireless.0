Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5345 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaKDL6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:14 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/5] mwifiex: do not setup AMPDU/AMSDU with broadcast receiver
Date: Tue, 4 Nov 2014 03:57:02 -0800
Message-ID: <1415102223-7118-4-git-send-email-akarwar@marvell.com> (sfid-20141104_125817_041875_1CFE13E6)
In-Reply-To: <1415102223-7118-1-git-send-email-akarwar@marvell.com>
References: <1415102223-7118-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

It is observed that device sometimes sends BA setup requests for
broadcast mac address.
Its pointless to check for availablity of AMPDU/AMSDU streams
for broadcast mac address. This patch adds this check.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 2ee268b..f275675 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -84,6 +84,8 @@ mwifiex_is_amsdu_in_ampdu_allowed(struct mwifiex_private *priv,
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
 
+	if (is_broadcast_ether_addr(ptr->ra))
+		return false;
 	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
 	if (tx_tbl)
 		return tx_tbl->amsdu;
@@ -96,6 +98,8 @@ static inline u8
 mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
 			 struct mwifiex_ra_list_tbl *ptr, int tid)
 {
+	if (is_broadcast_ether_addr(ptr->ra))
+		return false;
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
 		return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
 	} else {
-- 
1.8.1.4


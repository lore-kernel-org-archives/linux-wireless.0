Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24603 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbbIRNc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOQIa027003
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:57 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe86-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:57 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 06/16] mwifiex: don't always include ht/vht info in tdls confirm frame
Date: Fri, 18 Sep 2015 06:32:08 -0700
Message-ID: <1442583138-2979-7-git-send-email-akarwar@marvell.com> (sfid-20150918_153301_301085_0A4BA49C)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

Current TDLS implementation always includes ht/vht information
in tdls setup confirm frame which causes teardown by legacy
peer station after TDLS handshake. We will inclue ht/vht
capabilities in tdls setup confirm frame only if peer station
supports it to fix this problem.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index b3e163d..9275f9c 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -204,6 +204,12 @@ mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, const u8 *mac,
 		return -1;
 	}
 
+	if (!(le16_to_cpu(sta_ptr->tdls_cap.ht_capb.cap_info))) {
+		mwifiex_dbg(priv->adapter, WARN,
+			    "TDLS peer doesn't support ht capabilities\n");
+		return 0;
+	}
+
 	pos = (void *)skb_put(skb, sizeof(struct ieee80211_ht_operation) + 2);
 	*pos++ = WLAN_EID_HT_OPERATION;
 	*pos++ = sizeof(struct ieee80211_ht_operation);
@@ -252,6 +258,12 @@ static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	if (!(le32_to_cpu(sta_ptr->tdls_cap.vhtcap.vht_cap_info))) {
+		mwifiex_dbg(adapter, WARN,
+			    "TDLS peer doesn't support vht capabilities\n");
+		return 0;
+	}
+
 	if (!mwifiex_is_bss_in_11ac_mode(priv)) {
 		if (sta_ptr->tdls_cap.extcap.ext_capab[7] &
 		   WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED) {
-- 
1.8.1.4


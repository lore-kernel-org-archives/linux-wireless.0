Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44965 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbbBFLMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 06:12:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t16B9VLB022069
	for <linux-wireless@vger.kernel.org>; Fri, 6 Feb 2015 03:12:49 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1scthm86ut-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 03:12:49 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<szli@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/5] mwifiex: do not process mgmt rx on uninitialized interface
Date: Fri, 6 Feb 2015 22:11:43 +0530
Message-ID: <1423240906-12951-2-git-send-email-patila@marvell.com> (sfid-20150206_121252_958587_CC664484)
In-Reply-To: <1423240906-12951-1-git-send-email-patila@marvell.com>
References: <1423240906-12951-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a crash which was happening because of RX of
management frames on uninitialzed interface. Now we drop management
frames for interfaces where cfg80211 has not registered any management
subtype reception or interface has no NL80211 iftype set.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 3085506..47e215b 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -367,6 +367,13 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 	if (!skb)
 		return -1;
 
+	if (!priv->mgmt_frame_mask ||
+	    priv->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED) {
+		dev_dbg(priv->adapter->dev,
+			"do not receive mgmt frames on uninitialized intf");
+		return -1;
+	}
+
 	rx_pd = (struct rxpd *)skb->data;
 
 	skb_pull(skb, le16_to_cpu(rx_pd->rx_pkt_offset));
-- 
1.8.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55752 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbbBKMNC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 07:13:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1BC91jp012010
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:01 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1set0u7k6m-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:01 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<szli@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/4] mwifiex: do not process mgmt rx on uninitialized interface
Date: Wed, 11 Feb 2015 23:12:25 +0530
Message-ID: <1423676547-5213-2-git-send-email-patila@marvell.com> (sfid-20150211_131317_043771_30158B2C)
In-Reply-To: <1423676547-5213-1-git-send-email-patila@marvell.com>
References: <1423676547-5213-1-git-send-email-patila@marvell.com>
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


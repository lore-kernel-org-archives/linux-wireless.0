Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5511 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbbLNMRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:19 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGRwU027094
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:18 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng01x-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:18 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 07/14] mwifiex: suppress "Rx of mgmt packet failed" message
Date: Mon, 14 Dec 2015 04:15:08 -0800
Message-ID: <1450095315-19927-8-git-send-email-akarwar@marvell.com> (sfid-20151214_131723_799552_C6F0D2DE)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Block ACK action frames are dropped in driver. This error
is expected in this case. Let's lower the priority of this
message.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_rx.c   | 2 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index d4d4cb1..00fcbda 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -215,7 +215,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
-			mwifiex_dbg(adapter, ERROR, "Rx of mgmt packet failed");
+			mwifiex_dbg(adapter, DATA, "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 74d5d72..52f7981 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -310,8 +310,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
-			mwifiex_dbg(adapter, ERROR,
-				    "Rx of mgmt packet failed");
+			mwifiex_dbg(adapter, DATA, "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
-- 
1.8.1.4


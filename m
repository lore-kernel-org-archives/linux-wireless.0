Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:38092 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757899Ab2FUC7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 22:59:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, "3.4.y" <stable@vger.kernel.org>
Subject: [PATCH 3.5] mwifiex: fix WPS eapol handshake failure
Date: Wed, 20 Jun 2012 19:58:33 -0700
Message-Id: <1340247517-4593-2-git-send-email-bzhao@marvell.com> (sfid-20120621_045908_028486_2920E48E)
In-Reply-To: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
References: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

After association, STA will go through eapol handshake with WPS
enabled AP. It's observed that WPS handshake fails with some 11n
AP. The reason for the failure is that the eapol packet is sent
via 11n frame aggregation.

The eapol packet should be sent directly without 11n aggregation.

This patch fixes the problem by adding WPS session control while
dequeuing Tx packets for transmission.

Cc: "3.4.y" <stable@vger.kernel.org>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index f3fc655..4f09992 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1221,6 +1221,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 
 	if (!ptr->is_11n_enabled ||
 	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
+	    priv->wps.session_enable ||
 	    ((priv->sec_info.wpa_enabled ||
 	      priv->sec_info.wpa2_enabled) &&
 	     !priv->wpa_is_gtk_set)) {
-- 
1.7.0.2


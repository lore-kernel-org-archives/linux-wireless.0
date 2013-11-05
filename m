Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34539 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3KEUVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 15:21:45 -0500
Date: Tue, 5 Nov 2013 23:21:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] wcn36xx: missing unlocks on error paths
Message-ID: <20131105202101.GD3949@elgon.mountain> (sfid-20131105_212149_352510_8D0F00CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several places which are missing unlocks.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index f8c3a10..de9eb2c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1286,7 +1286,8 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	} else {
 		wcn36xx_err("Beacon is to big: beacon size=%d\n",
 			      msg_body.beacon_length);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 	memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
 
@@ -1327,7 +1328,8 @@ int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
 	if (skb->len > BEACON_TEMPLATE_SIZE) {
 		wcn36xx_warn("probe response template is too big: %d\n",
 			     skb->len);
-		return -E2BIG;
+		ret = -E2BIG;
+		goto out;
 	}
 
 	msg.probe_resp_template_len = skb->len;
@@ -1606,7 +1608,8 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 		/* TODO: it also support ARP response type */
 	} else {
 		wcn36xx_warn("unknow keep alive packet type %d\n", packet_type);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);

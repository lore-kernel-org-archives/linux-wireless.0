Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39657 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab3KHRfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 12:35:03 -0500
Received: by mail-wi0-f169.google.com with SMTP id cb5so28581wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 09:35:01 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/3] wcn36xx: missing unlocks on error paths
Date: Fri,  8 Nov 2013 17:34:38 +0000
Message-Id: <1383932079-3791-3-git-send-email-k.eugene.e@gmail.com> (sfid-20131108_183510_541277_A6E2C3A1)
In-Reply-To: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
References: <1383932079-3791-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

There are several places which are missing unlocks.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 04df70b..de9eb2c 100644
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
 
@@ -1607,7 +1608,8 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 		/* TODO: it also support ARP response type */
 	} else {
 		wcn36xx_warn("unknow keep alive packet type %d\n", packet_type);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
-- 
1.8.3.2


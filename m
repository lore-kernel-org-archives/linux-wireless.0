Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34969 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbcDSFBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 01:01:07 -0400
Received: by mail-pf0-f179.google.com with SMTP id n1so2716412pfn.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 22:01:06 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/18] wcn36xx: Clean up wcn36xx_smd_send_beacon
Date: Mon, 18 Apr 2016 22:00:39 -0700
Message-Id: <1461042056-10607-2-git-send-email-bjorn.andersson@linaro.org> (sfid-20160419_070706_033356_CD1596EA)
In-Reply-To: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
References: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Needed for coming improvements. No functional changes.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
[bjorn: restored BEACON_TEMPLATE_SIZE define to 0x180]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v2:
- Subtract sizeof(beacon_length) instead of modifying BEACON_TEMPLATE_SIZE,
  which is used in other places as well.

 drivers/net/wireless/ath/wcn36xx/hal.h |  5 ++++-
 drivers/net/wireless/ath/wcn36xx/smd.c | 12 +++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index b947de0fb2e5..d713204f755d 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2884,11 +2884,14 @@ struct update_beacon_rsp_msg {
 struct wcn36xx_hal_send_beacon_req_msg {
 	struct wcn36xx_hal_msg_header header;
 
+	/* length of the template + 6. Only qcom knows why */
+	u32 beacon_length6;
+
 	/* length of the template. */
 	u32 beacon_length;
 
 	/* Beacon data. */
-	u8 beacon[BEACON_TEMPLATE_SIZE];
+	u8 beacon[BEACON_TEMPLATE_SIZE - sizeof(u32)];
 
 	u8 bssid[ETH_ALEN];
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 74f56a81ad9a..ff3ed2461a69 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1380,19 +1380,17 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	mutex_lock(&wcn->hal_mutex);
 	INIT_HAL_MSG(msg_body, WCN36XX_HAL_SEND_BEACON_REQ);
 
-	/* TODO need to find out why this is needed? */
-	msg_body.beacon_length = skb_beacon->len + 6;
+	msg_body.beacon_length = skb_beacon->len;
+	/* TODO need to find out why + 6 is needed */
+	msg_body.beacon_length6 = msg_body.beacon_length + 6;
 
-	if (BEACON_TEMPLATE_SIZE > msg_body.beacon_length) {
-		memcpy(&msg_body.beacon, &skb_beacon->len, sizeof(u32));
-		memcpy(&(msg_body.beacon[4]), skb_beacon->data,
-		       skb_beacon->len);
-	} else {
+	if (msg_body.beacon_length > BEACON_TEMPLATE_SIZE) {
 		wcn36xx_err("Beacon is to big: beacon size=%d\n",
 			      msg_body.beacon_length);
 		ret = -ENOMEM;
 		goto out;
 	}
+	memcpy(msg_body.beacon, skb_beacon->data, skb_beacon->len);
 	memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
 
 	/* TODO need to find out why this is needed? */
-- 
2.5.0


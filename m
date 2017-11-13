Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751391AbdKMK2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:36 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 05/10] qtnfmac: check for passed channel being NULL in MGMT_TX command
Date: Mon, 13 Nov 2017 13:28:10 +0300
Message-Id: <20171113102815.11254-6-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112928_337273_8894E15F)
In-Reply-To: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Parameters passed into .mgmt_tx callback may have a NULL channel in case
userspace wants to send a frame on current channel. Make sure this case
is handled, pass "freq==0" in case channel is not specififed to tell
wlan device to use current channel.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index a11278de678d..f5eb2cdefae2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -381,6 +381,7 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	const struct ieee80211_mgmt *mgmt_frame = (void *)params->buf;
 	u32 short_cookie = prandom_u32();
 	u16 flags = 0;
+	u16 freq;
 
 	*cookie = short_cookie;
 
@@ -393,13 +394,21 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (params->dont_wait_for_ack)
 		flags |= QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT;
 
+	/* If channel is not specified, pass "freq = 0" to tell device
+	 * firmware to use current channel.
+	 */
+	if (params->chan)
+		freq = params->chan->center_freq;
+	else
+		freq = 0;
+
 	pr_debug("%s freq:%u; FC:%.4X; DA:%pM; len:%zu; C:%.8X; FL:%.4X\n",
-		 wdev->netdev->name, params->chan->center_freq,
+		 wdev->netdev->name, freq,
 		 le16_to_cpu(mgmt_frame->frame_control), mgmt_frame->da,
 		 params->len, short_cookie, flags);
 
 	return qtnf_cmd_send_mgmt_frame(vif, short_cookie, flags,
-					params->chan->center_freq,
+					freq,
 					params->buf, params->len);
 }
 
-- 
2.11.0

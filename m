Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:64231
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965176AbdLSL33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:29 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 05/10] qtnfmac: check for passed channel being NULL in MGMT_TX command
Date: Tue, 19 Dec 2017 14:28:51 +0300
Message-Id: <20171219112856.22463-6-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122937_062425_D8A04DDA)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
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
index c026882bf9c7..be15d0ed362c 100644
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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62542 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2IHARf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 20:17:35 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so112366wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 17:17:35 -0700 (PDT)
Message-Id: <c6b79fb5ec0f7a874d29af328d2f43a77b6ae09c.1347062182.git.chunkeey@googlemail.com> (sfid-20120908_021738_408013_B6F8977A)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 8 Sep 2012 01:48:19 +0200
Subject: [PATCH 1/2 v4] p54: connect to 11w protected networks
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, it was not possible to connect to
networks which requires 11w to be supported by
the stations.

Note:

As all current (and old) firmwares corrupt
incoming, protected management frames, the
decryption offloading needs to be disabled.
This will be done automatically if needed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 2969d53..aadda99 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -515,6 +515,17 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 	if (modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
+	if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
+		/*
+		 * Unfortunately most/all firmwares are trying to decrypt
+		 * incoming management frames if a suitable key can be found.
+		 * However, in doing so the data in these frames gets
+		 * corrupted. So, we can't have firmware supported crypto
+		 * offload in this case.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&priv->conf_mutex);
 	if (cmd == SET_KEY) {
 		switch (key->cipher) {
@@ -738,6 +749,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
+		     IEEE80211_HW_MFP_CAPABLE |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54826 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2IGPxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:53:08 -0400
Received: by eekc1 with SMTP id c1so1259256eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 08:53:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 4 Sep 2012 15:19:33 +0200
Subject: [PATCH v3] p54: connect to 11w protected networks
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1TA0re-00059m-CD@debian64.localnet> (sfid-20120907_175313_270088_57887FD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, it was not possible to connect
to networks which requires 11w to be supported
by the stations.

Note:

As all current (and old) firmwares corrupt
incoming, protected management frames, the
decryption offloading needs to be disabled.

This can be done by loading the p54common
module with the nohwcrypt=1 parameter.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
v2->v3:
	- fixed modparam_nohwcrypt typo
	(Yes, v2 never compiled :( )

Regards,
	Christian
---
 drivers/net/wireless/p54/main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 5e91ad0..8ab5aef 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -739,6 +739,17 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	if (modparam_nohwcrypt) {
+		/*
+		 * Only support MFP, if the hardware crypto engine
+		 * is disabled, as the firmware's rx-path corrupts
+		 * incoming CCMP encrypted RX mgmt frames.
+		 * However, if no rx key is uploaded, the firmware
+		 * passes the unencrypted frame to the driver. 
+		 */
+		dev->flags |= IEEE80211_HW_MFP_CAPABLE;
+	}
+
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) |
 				      BIT(NL80211_IFTYPE_AP) |
-- 
1.7.10.4


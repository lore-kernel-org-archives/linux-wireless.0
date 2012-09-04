Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60115 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2IDNxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 09:53:24 -0400
Received: by bkwj10 with SMTP id j10so2656580bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 06:53:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
Date: Tue, 4 Sep 2012 15:19:33 +0200
Subject: [PATCH v2] p54: connect to 11w protected networks
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Message-Id: <E1T8tYj-00051o-3z@debian64.localnet> (sfid-20120904_155329_068789_67C1168B)
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
Johannes,

thank you for making me double-check whenever MFP really works!
Unlike carl9170 which generates and receives a great amount of
addba/delba action frames, p54 - being a legacy product - has
no such "easy to use" debug facilities. 

As you feared: the firmware is corrupting incoming management
frames. However, it does so only when a rxkey was configured.
So as a possible trade-off, MFP will only be supported by p54,
when the firmware crypto offloading is relieved of his duties
(disabled). 

Note: Strictly speaking, it would be enough to no longer upload
any rx key which could affect management frames, as the firmware
does not decrypt any frames unless there is a fitting key candidate.

Regards,
	Chr 
---
 drivers/net/wireless/p54/main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 5e91ad0..16b75ec 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -739,6 +739,17 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	if (nohwcrypt) {
+		/*
+		 * Only support MFP, if the hardware crypto engine
+		 * is disabled, as the firmware's rx-path corrupts
+		 * incoming CCMP encrypted mgmt frames.
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


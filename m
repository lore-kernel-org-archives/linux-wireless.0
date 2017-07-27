Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0046.outbound.protection.outlook.com ([104.47.41.46]:26496
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751582AbdG0XH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:27 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 02/12] qtnfmac: regulatory configuration for self-managed setup
Date: Fri, 28 Jul 2017 02:06:44 +0300
Message-Id: <20170727230654.30850-3-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010733_483026_71DB9D56)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regdomain information needs to be registered with cfg80211
for devices with REGULATORY_WIPHY_SELF_MANAGED flag set.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 7f70b0aae069..e288b1d4432a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -873,6 +873,15 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	}
 
 	ret = wiphy_register(wiphy);
+	if (ret < 0)
+		goto out;
+
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		ret = regulatory_set_wiphy_regd(wiphy, hw_info->rd);
+	else if (isalpha(hw_info->rd->alpha2[0]) &&
+		 isalpha(hw_info->rd->alpha2[1]))
+		ret = regulatory_hint(wiphy, hw_info->rd->alpha2);
+
 out:
 	if (ret) {
 		kfree(iface_comb);
-- 
2.11.0

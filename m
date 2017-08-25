Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754478AbdHYCbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:03 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 17/27] qtnfmac: do not report channel changes until wiphy is registered
Date: Thu, 24 Aug 2017 19:30:14 -0700
Message-Id: <20170825023024.10565-18-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043138_117882_228CB279)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 9befc9f..b2f6410 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -356,6 +356,9 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
+	if (!wiphy->registered)
+		return 0;
+
 	qlink_chandef_q2cfg(wiphy, &data->chan, &chdef);
 
 	if (!cfg80211_chandef_valid(&chdef)) {
-- 
2.9.5

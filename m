Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:64638
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdIUVfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 17:35:10 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V3 9/9] qtnfmac: do not report channel changes until wiphy is registered
Date: Thu, 21 Sep 2017 14:34:37 -0700
Message-Id: <20170921213437.27457-10-igor.mitsyanko.os@quantenna.com> (sfid-20170921_233521_383823_957D0079)
In-Reply-To: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
References: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Wireless device may send "channel changed" event before driver
registered this device with wireless core, which will result in
warnings.
Once device is registered, higher layer will query channel info
manually using .get_channel callback.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b1acc24..7481d5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -368,6 +368,9 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
+	if (!wiphy->registered)
+		return 0;
+
 	qlink_chandef_q2cfg(wiphy, &data->chan, &chandef);
 
 	if (!cfg80211_chandef_valid(&chandef)) {
-- 
2.9.5

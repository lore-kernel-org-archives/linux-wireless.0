Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:13344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751424AbdIBBpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 21:45:08 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 9/9] qtnfmac: do not report channel changes until wiphy is registered
Date: Fri,  1 Sep 2017 18:44:51 -0700
Message-Id: <20170902014451.17766-10-igor.mitsyanko.os@quantenna.com> (sfid-20170902_034512_087008_602F2016)
In-Reply-To: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
References: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
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

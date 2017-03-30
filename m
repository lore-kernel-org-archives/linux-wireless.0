Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47676 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933333AbdC3KlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 06:41:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2UAdP30029599
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 03:41:17 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 29h0ah81k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 03:41:16 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Ganapathi Bhat <gbhat@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: apply radar flag
Date: Thu, 30 Mar 2017 16:10:50 +0530
Message-ID: <1490870450-6601-1-git-send-email-akarwar@marvell.com> (sfid-20170330_124225_259771_01EC39C6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

When IEEE80211_CHAN_RADAR is set by cfg80211, passive scan must be
performed. In mwifiex,active scan is performed even though flag is
set from cfg80211. mwifiex_reg_apply_radar_flags() function added
in this patch correctly uses radar flag.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1e3bd43..44d0617 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -594,6 +594,24 @@ int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	return 0;
 }
 
+static void mwifiex_reg_apply_radar_flags(struct wiphy *wiphy)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	unsigned int i;
+
+	if (!wiphy->bands[NL80211_BAND_5GHZ])
+		return;
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
+
+	for (i = 0; i < sband->n_channels; i++) {
+		chan = &sband->channels[i];
+		if ((!(chan->flags & IEEE80211_CHAN_DISABLED)) &&
+		    (chan->flags & IEEE80211_CHAN_RADAR))
+			chan->flags |= IEEE80211_CHAN_NO_IR;
+	}
+}
+
 /*
  * CFG802.11 regulatory domain callback function.
  *
@@ -613,6 +631,7 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 	mwifiex_dbg(adapter, INFO,
 		    "info: cfg80211 regulatory domain callback for %c%c\n",
 		    request->alpha2[0], request->alpha2[1]);
+	mwifiex_reg_apply_radar_flags(wiphy);
 
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
-- 
1.9.1

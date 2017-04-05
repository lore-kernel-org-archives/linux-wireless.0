Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42264 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933102AbdDELjE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:39:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v35BYWut025039
        for <linux-wireless@vger.kernel.org>; Wed, 5 Apr 2017 04:39:03 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 29m7fdqshg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 05 Apr 2017 04:39:03 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2] mwifiex: apply radar flag
Date: Wed, 5 Apr 2017 17:06:20 +0530
Message-ID: <1491392180-11078-1-git-send-email-gbhat@marvell.com> (sfid-20170405_133951_161518_0344A87E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

When IEEE80211_CHAN_RADAR is set by cfg80211, passive scan must be
performed. In mwifiex,active scan is performed even though flag is
set from cfg80211. mwifiex_reg_apply_radar_flags() function added
in this patch correctly uses radar flag.

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v3: corrected author name
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

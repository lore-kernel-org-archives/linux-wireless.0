Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18331 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbbDNOtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 10:49:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t3EEntQQ016802
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2015 07:49:55 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1tpw0c8hsr-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2015 07:49:55 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: increase number of probes for specific SSID scans
Date: Tue, 14 Apr 2015 07:49:16 -0700
Message-ID: <1429022956-12016-1-git-send-email-akarwar@marvell.com> (sfid-20150414_164959_065629_FE6FF99B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that device sometimes fails to find AP
configured in hidden SSID in busy environment. We will increase
number of probes for specific SSID scans for getting better results.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index bf9020f..3783db5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2269,6 +2269,12 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	user_scan_cfg->num_ssids = request->n_ssids;
 	user_scan_cfg->ssid_list = request->ssids;
 
+	/* Increase number of probes for specific SSID scans for
+	 * better results
+	 */
+	if (request->n_ssids > 1)
+		user_scan_cfg->num_probes = 4;
+
 	if (request->ie && request->ie_len) {
 		offset = 0;
 		for (i = 0; i < MWIFIEX_MAX_VSIE_NUM; i++) {
-- 
1.8.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14326 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbcDEILA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 04:11:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3586bJi013891
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 01:10:58 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 222dkfh9gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 01:10:58 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH RESEND 2/7] mwifiex: add support for wakeup on GTK rekey failure
Date: Tue, 5 Apr 2016 01:04:35 -0700
Message-ID: <1459843480-25956-2-git-send-email-akarwar@marvell.com> (sfid-20160405_101105_296430_F984177C)
In-Reply-To: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
References: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

User can configure wakeup on GTK rekey fail with wowlan.
Added corresponding wakeup reason.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 7 ++++++-
 drivers/net/wireless/marvell/mwifiex/fw.h       | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ca8cdd2..49661e0 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3390,6 +3390,10 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 		break;
 	case	MANAGEMENT_FRAME_MATCHED:
 		break;
+	case GTK_REKEY_FAILURE:
+		if (wiphy->wowlan_config->gtk_rekey_failure)
+			wakeup_report.gtk_rekey_failure = true;
+		break;
 	default:
 		break;
 	}
@@ -3965,7 +3969,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT |
-		WIPHY_WOWLAN_NET_DETECT | WIPHY_WOWLAN_SUPPORTS_GTK_REKEY,
+		WIPHY_WOWLAN_NET_DETECT | WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+		WIPHY_WOWLAN_GTK_REKEY_FAILURE,
 	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
 	.pattern_min_len = 1,
 	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 8703d24..8e4145a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -620,6 +620,7 @@ enum HS_WAKEUP_REASON {
 	MAGIC_PATTERN_MATCHED,
 	CONTROL_FRAME_MATCHED,
 	MANAGEMENT_FRAME_MATCHED,
+	GTK_REKEY_FAILURE,
 	RESERVED
 };
 
-- 
1.8.1.4


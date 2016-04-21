Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35127 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbcDUPJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 11:09:29 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Wei-Ning Huang <wnhuang@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: avoid querying wakeup reason when wowlan is disabled
Date: Thu, 21 Apr 2016 08:07:56 -0700
Message-ID: <1461251276-14891-3-git-send-email-akarwar@marvell.com> (sfid-20160421_170941_538412_33530409)
In-Reply-To: <1461251276-14891-1-git-send-email-akarwar@marvell.com>
References: <1461251276-14891-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211 resume handler, we query wakeup reason from firmware and
report to cfg80211. if wowlan is disabled, connection is already
terminated during suspend. We don't need to query wakeup reason in this
case.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 734cf67..ff948a9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3355,6 +3355,9 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 		}
 	}
 
+	if (!wiphy->wowlan_config)
+		goto done;
+
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 	mwifiex_get_wakeup_reason(priv, HostCmd_ACT_GEN_GET, MWIFIEX_SYNC_CMD,
 				  &wakeup_reason);
@@ -3400,6 +3403,7 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 		cfg80211_report_wowlan_wakeup(&priv->wdev, &wakeup_report,
 					      GFP_KERNEL);
 
+done:
 	if (adapter->nd_info) {
 		for (i = 0 ; i < adapter->nd_info->n_matches ; i++)
 			kfree(adapter->nd_info->matches[i]);
-- 
1.8.1.4


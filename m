Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33721 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcCVEKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 00:10:14 -0400
Received: by mail-pf0-f178.google.com with SMTP id 4so160816713pfd.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2016 21:10:13 -0700 (PDT)
From: Wei-Ning Huang <wnhuang@chromium.org>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org, Wei-Ning Huang <wnhuang@chromium.org>,
	nishants@marvell.com, kvalo@codeaurora.org, netdev@vger.kernel.org
Subject: [PATCH v2] mwifiex: advertise low priority scan feature
Date: Tue, 22 Mar 2016 12:09:56 +0800
Message-Id: <1458619796-7694-1-git-send-email-wnhuang@chromium.org> (sfid-20160322_051033_447084_537429E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Low priority scan handling code which delays or aborts scan
operation based on Tx traffic is removed recently. The reason
is firmware already takes care of it in our new feature scan
channel gap. Hence we should advertise low priority scan
support to cfg80211.

This patch fixes a problem in which OBSS scan request from
wpa_supplicant was being rejected by cfg80211.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index bb7235e..7dafc5b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4086,6 +4086,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_INACTIVITY_TIMER |
+			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
 			   NL80211_FEATURE_NEED_OBSS_SCAN;
 
 	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
-- 
2.8.0.rc3.226.g39d4020


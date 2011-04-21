Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43161 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab1DUUax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:53 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:30:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>, <kvalo@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 5/5] ath6kl: fix operations for power management
Date: Thu, 21 Apr 2011 13:30:40 -0700
Message-ID: <1303417840-19605-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
References: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

The cfg80211 ops for power management were completely
broken. If we were asked for to go into power save it was putting
device in awake, and when we were asked to become awake we were
putting the device into power save... This fixes the powersave
operations to do the right thing.

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index d5e554e..e87d3aa 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1209,10 +1209,10 @@ ar6k_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 
     if(pmgmt) {
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: Max Perf\n", __func__));
-        pwrMode.powerMode = MAX_PERF_POWER;
+        pwrMode.powerMode = REC_POWER;
     } else {
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: Rec Power\n", __func__));
-        pwrMode.powerMode = REC_POWER;
+        pwrMode.powerMode = MAX_PERF_POWER;
     }
 
     if(wmi_powermode_cmd(ar->arWmi, pwrMode.powerMode) != 0) {
-- 
1.7.4.15.g7811d


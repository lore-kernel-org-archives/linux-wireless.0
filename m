Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43145 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1DUUaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:52 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:30:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>, <kvalo@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 4/5] ath6kl: fix scan operation while disconnect
Date: Thu, 21 Apr 2011 13:30:39 -0700
Message-ID: <1303417840-19605-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
References: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

If a scan operation is pending and in between a disconnect
event is received from firmware the scan results never get
sent back to cfg80211. This causes a scan failure and yields
a device/resource busy state upon retries. If a disconnect
event is received and scan is pending return the scan done
to the cfg80211 to enable futher scans to be issued.

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 1f799c1..d5e554e 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -627,6 +627,10 @@ ar6k_cfg80211_disconnect_event(struct ar6_softc *ar, u8 reason,
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: reason=%u\n", __func__, reason));
 
+    if (ar->scan_request) {
+	cfg80211_scan_done(ar->scan_request, true);
+        ar->scan_request = NULL;
+    }
     if((ADHOC_NETWORK & ar->arNetworkType)) {
         if(NL80211_IFTYPE_ADHOC != ar->wdev->iftype) {
             AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
-- 
1.7.4.15.g7811d


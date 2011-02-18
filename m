Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53977 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1BRVOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:45 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 03/15] staging: ath6kl: Return correct scan complete status
Date: Fri, 18 Feb 2011 13:13:04 -0800
Message-ID: <1298063596-2096-3-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return correct scan complete status to the cfg80211 module based on
the value returned from the hardware.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index b7742d4..bc5f6a7 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -791,7 +791,7 @@ ar6k_cfg80211_scanComplete_event(AR_SOFTC_T *ar, int status)
         wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
 
         cfg80211_scan_done(ar->scan_request,
-                          (status & A_ECANCELED) ? true : false);
+            ((status & A_ECANCELED) || (status & A_EBUSY)) ? true : false);
 
         if(ar->scan_request->n_ssids &&
            ar->scan_request->ssids[0].ssid_len) {
-- 
1.6.3.3


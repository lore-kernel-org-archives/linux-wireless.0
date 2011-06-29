Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4583 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736Ab1F2Xth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 118/119] staging: brcm80211: fix for reported log spam
 problem
Date: Wed, 29 Jun 2011 16:48:22 -0700
Message-ID: <1309391303-22741-119-git-send-email-frankyl@broadcom.com> (sfid-20110630_015252_045521_BFCB91A0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Every few minutes, this message would appear in syslog:

ieee80211 ph0: wl_ops_bss_info_changed: BSS idle: true (implement)

The message has been deleted, the driver requires no special action on this
particular event (). See: https://bugzilla.kernel.org/show_bug.cgi?id=38162

Reported-by: David Hill <hilld@binarystorm.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index caab99a..77b06d5 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -452,11 +452,6 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		wiphy_err(wiphy, "%s: qos enabled: %s (implement)\n", __func__,
 			  info->qos ? "true" : "false");
 	}
-	if (changed & BSS_CHANGED_IDLE) {
-		/* Idle changed for this BSS/interface */
-		wiphy_err(wiphy, "%s: BSS idle: %s (implement)\n", __func__,
-			  info->idle ? "true" : "false");
-	}
 	return;
 }
 
-- 
1.7.1



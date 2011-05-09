Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3412 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab1EIOdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/10] staging: brcm80211: wlc_aggregatable function
 prototype moved
Date: Mon, 9 May 2011 16:33:22 +0200
Message-ID: <1304951609-2493-3-git-send-email-arend@broadcom.com> (sfid-20110509_163742_030803_2CE616DF)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wlc_aggregatable is used by wl_mac80211.c. The prototype
of the function was placed in include file wlc_scb.h but the interface
for wl_mac80211.c to other driver functions is to be placed in wlc_pub.h.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h |    2 ++
 drivers/staging/brcm80211/brcmsmac/wlc_scb.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 3dc5b1d..44f6153 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -514,6 +514,8 @@ extern int wlc_iovar_op(struct wlc_info *wlc, const char *name, void *params,
 			struct wlc_if *wlcif);
 extern int wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		     struct wlc_if *wlcif);
+extern bool wlc_aggregatable(struct wlc_info *wlc, u8 tid);
+
 /* helper functions */
 extern void wlc_statsupd(struct wlc_info *wlc);
 extern void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
index 7326006..f07a891 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_scb.h
@@ -17,8 +17,6 @@
 #ifndef _wlc_scb_h_
 #define _wlc_scb_h_
 
-extern bool wlc_aggregatable(struct wlc_info *wlc, u8 tid);
-
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 /* structure to store per-tid state for the ampdu initiator */
 typedef struct scb_ampdu_tid_ini {
-- 
1.7.4.1



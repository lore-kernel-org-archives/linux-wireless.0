Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1527 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1DTIir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 04:38:47 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: brcm80211: better feedback to user on ioctl
 errors
Date: Wed, 20 Apr 2011 10:38:39 +0200
Message-ID: <1303288719-3036-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Messages are now logged that provide the user with a clue on what went wrong.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   44 ++++++++++++++++++++----
 1 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 46bf93b..dba6195 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -4141,7 +4141,7 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	     void *params, int p_len, void *arg, int len,
 	     bool set, struct wlc_if *wlcif)
 {
-	int err = 0;
+	int err;
 	int val_size;
 	const bcm_iovar_t *vi = NULL;
 	u32 actionid;
@@ -4151,8 +4151,34 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
 		dev_err(wlc->dev, "wl%d: %s unaligned get ptr for %s\n",
 			 wlc->pub->unit, __func__, name);
-		err = ENOTSUPP;
-		goto exit;
+		return -ENOTSUPP;
+	}
+
+	if (name == NULL || len < 0) {
+		dev_err(wlc->dev, "wl%d: %s name/arg error len=%d\n",
+			wlc->pub->unit, __func__, len);
+		return -ENOTSUPP;
+	}
+
+	if (!set && !(arg && len)) {
+		dev_err(wlc->dev, "Get MUST have return space\n");
+		goto fail;
+	}
+
+	if (wlc->pub->hw_off && wlc->pub->up) {
+		dev_err(wlc->dev, "hw is off but adapter is up!\n");
+		goto fail;
+	}
+
+	if (set && (params || p_len)) {
+		dev_err(wlc->dev, "Set does NOT take qualifiers\n");
+		goto fail;
+	}
+
+	if (!set && len == sizeof(int) &&
+	    !IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int))) {
+		dev_err(wlc->dev, "unaligned access on get\n");
+		goto fail;
 	}
 
 	/* find the given iovar name */
@@ -4164,10 +4190,8 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 			break;
 	}
 	/* iovar name not found */
-	if (i >= WLC_MAXMODULES) {
-		err = -ENOTSUPP;
-		goto exit;
-	}
+	if (i >= WLC_MAXMODULES)
+		return -ENOTSUPP;
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -4192,8 +4216,12 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 					name, params, p_len, arg, len, val_size,
 					wlcif);
 
- exit:
 	return err;
+
+fail:
+	dev_err(wlc->dev, "wl%d: %s(set=%d,%s) failed\n", wlc->pub->unit,
+		__func__, set, name);
+	return -ENOTSUPP;
 }
 
 int
-- 
1.7.1



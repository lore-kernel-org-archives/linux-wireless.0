Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44835 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0I1Qgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 12:36:39 -0400
Received: by bwz11 with SMTP id 11so4281968bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 09:36:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: fix rx monitor filter refcounters
Date: Tue, 28 Sep 2010 18:36:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009281836.24529.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a refcounter & commit bug when monitor
rx flags are changed by:
	iw dev moni set monitor [new flags]

while interface is up.

---
Is there a sane way to do that?

Introduced by: 8cc9a73914 - Jan 31 19:48:23 2008 
"mac80211: Use monitor configuration flags"
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..c156936 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -68,8 +68,47 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
+		struct ieee80211_local *local = sdata->local;
+		u32 changed_flags = sdata->u.mntr_flags ^ *flags;
+
 		sdata->u.mntr_flags = *flags;
+		if (changed_flags & MONITOR_FLAG_FCSFAIL) {
+			if (*flags & MONITOR_FLAG_FCSFAIL)
+				local->fif_fcsfail++;
+			else
+				local->fif_fcsfail--;
+		}
+		if (changed_flags & MONITOR_FLAG_PLCPFAIL) {
+			if (*flags & MONITOR_FLAG_PLCPFAIL)
+				local->fif_plcpfail++;
+			else
+				local->fif_plcpfail--;
+		}
+		if (changed_flags & MONITOR_FLAG_COOK_FRAMES) {
+			if (*flags & MONITOR_FLAG_COOK_FRAMES)
+				local->cooked_mntrs++;
+			else
+				local->cooked_mntrs--;
+		}
+		if (changed_flags & MONITOR_FLAG_OTHER_BSS) {
+			if (*flags & MONITOR_FLAG_OTHER_BSS)
+				local->fif_other_bss++;
+			else
+				local->fif_other_bss--;
+		}
+		if (changed_flags & MONITOR_FLAG_CONTROL) {
+			if (*flags & MONITOR_FLAG_CONTROL) {
+				local->fif_pspoll++;
+				local->fif_control++;
+			} else {
+				local->fif_pspoll--;
+				local->fif_control--;
+			}
+		}
+
+		ieee80211_configure_filter(local);
+	}
 
 	return 0;
 }

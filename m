Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2KUPYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 10:24:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/2] brcmsmac: Remove stray argument from debug macro
Date: Wed, 21 Nov 2012 09:24:31 -0600
Message-Id: <1353511471-5994-3-git-send-email-seth.forshee@canonical.com> (sfid-20121121_162447_461603_A9866DDF)
In-Reply-To: <1353511471-5994-1-git-send-email-seth.forshee@canonical.com>
References: <1353511471-5994-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the debug macro invocations ended up with a stray 0 argument
where the format string should be. Remove it.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 8c835cd..1710ccb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -570,7 +570,7 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 	if (changed_flags & FIF_ALLMULTI)
 		brcms_dbg_info(core, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		brcms_dbg_info(core, 0, "FIF_FCSFAIL\n");
+		brcms_dbg_info(core, "FIF_FCSFAIL\n");
 	if (changed_flags & FIF_CONTROL)
 		brcms_dbg_info(core, "FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-- 
1.7.9.5


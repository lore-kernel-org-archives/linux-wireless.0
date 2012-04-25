Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358Ab2DYW2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 18:28:07 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] b43: only reload config after successful initialization
Date: Wed, 25 Apr 2012 17:28:00 -0500
Message-Id: <1335392880-23250-1-git-send-email-seth.forshee@canonical.com> (sfid-20120426_002812_387798_48EB2EB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 2a19032 (b43: reload phy and bss settings after core restarts)
introduced an unconditional call to b43_op_config() at the end of
b43_op_start(). When firmware fails to load this can wedge the system.
There's no need to reload the configuration after a failed
initialization anyway, so only make the call if initialization was
successful.

BugLink: http://bugs.launchpad.net/bugs/950295
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/b43/main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 05ea95b..617afc8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4841,8 +4841,14 @@ static int b43_op_start(struct ieee80211_hw *hw)
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
-	/* reload configuration */
-	b43_op_config(hw, ~0);
+	/*
+	 * Configuration may have been overwritten during initialization.
+	 * Reload the configuration, but only if initialization was
+	 * successful. Reloading the configuration after a failed init
+	 * may hang the system.
+	 */
+	if (!err)
+		b43_op_config(hw, ~0);
 
 	return err;
 }
-- 
1.7.9.5


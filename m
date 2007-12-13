Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762661AbXLMHAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:04 -0500
Subject: [PATCH 93/48] libertas: make lbs_update_channel() function non-static
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3L-0005uc-Da@shinybook.infradead.org> (sfid-20071213_070019_271093_F4CAB45C)
Date: Thu, 13 Dec 2007 02:00:15 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 22:50:21 -0500

We'll want to use this for meshfrobbing

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c |    8 ++++----
 drivers/net/wireless/libertas/decl.h  |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 21a5696..ff976eb 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -163,7 +163,7 @@ done:
 }
 
 
-static int update_channel(struct lbs_private *priv)
+int lbs_update_channel(struct lbs_private *priv)
 {
 	int ret;
 
@@ -184,7 +184,7 @@ void lbs_sync_channel(struct work_struct *work)
 		sync_channel);
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
-	if (update_channel(priv) != 0)
+	if (lbs_update_channel(priv))
 		lbs_pr_info("Channel synchronization failed.");
 	lbs_deb_leave(LBS_DEB_ASSOC);
 }
@@ -196,7 +196,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	ret = update_channel(priv);
+	ret = lbs_update_channel(priv);
 	if (ret < 0) {
 		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
 	}
@@ -220,7 +220,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	/* FIXME: shouldn't need to grab the channel _again_ after setting
 	 * it since the firmware is supposed to return the new channel, but
 	 * whatever... */
-	ret = update_channel(priv);
+	ret = lbs_update_channel(priv);
 	if (ret < 0)
 		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
 
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 9b0ef16..45f081b 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -77,4 +77,5 @@ int lbs_stop_card(struct lbs_private *priv);
 int lbs_reset_device(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
+int lbs_update_channel(struct lbs_private *priv);
 #endif
-- 
1.5.3.4


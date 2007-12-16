Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49285 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758AbXLPW64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:56 -0500
Subject: [PATCH 115/48] libertas: fix return from lbs_update_channel()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42SK-000394-C8@shinybook.infradead.org> (sfid-20071216_232038_786707_919D68F8)
Date: Sun, 16 Dec 2007 17:59:32 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 16 Dec 2007 17:21:00 -0500

If we return the channel number in a 'ret' variable where anything
non-zero is later interpreted as an error, that isn't nice. It breaks
WPA, for a start. OLPC trac #5485

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index cd8e043..882e51c 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -167,13 +167,14 @@ int lbs_update_channel(struct lbs_private *priv)
 {
 	int ret;
 
-	/* the channel in f/w could be out of sync, get the current channel */
+	/* the channel in f/w could be out of sync; get the current channel */
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	ret = lbs_get_channel(priv);
-	if (ret > 0)
-		priv->curbssparams.channel = (u8) ret;
-
+	if (ret > 0) {
+		priv->curbssparams.channel = ret;
+		ret = 0;
+	}
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
@@ -197,8 +198,9 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	ret = lbs_update_channel(priv);
-	if (ret < 0) {
+	if (ret) {
 		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
+		goto done;
 	}
 
 	if (assoc_req->channel == priv->curbssparams.channel)
@@ -222,8 +224,10 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	 * it since the firmware is supposed to return the new channel, but
 	 * whatever... */
 	ret = lbs_update_channel(priv);
-	if (ret < 0)
+	if (ret) {
 		lbs_deb_assoc("ASSOC: channel: error getting channel.\n");
+		goto done;
+	}
 
 	if (assoc_req->channel != priv->curbssparams.channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
-- 
1.5.3.4


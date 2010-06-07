Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.184.110]:5511 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0FGOeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 10:34:00 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix function pointer check
Date: Mon, 7 Jun 2010 16:33:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201006071633.49820.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes "iw wlan0 dump survey" work again with
mac80211-based drivers that support it, e.g. ath5k.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 net/mac80211/driver-ops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-wl.orig/net/mac80211/driver-ops.h
+++ linux-wl/net/mac80211/driver-ops.h
@@ -360,7 +360,7 @@ static inline int drv_get_survey(struct
 				struct survey_info *survey)
 {
 	int ret = -EOPNOTSUPP;
-	if (local->ops->conf_tx)
+	if (local->ops->get_survey)
 		ret = local->ops->get_survey(&local->hw, idx, survey);
 	/* trace_drv_get_survey(local, idx, survey, ret); */
 	return ret;

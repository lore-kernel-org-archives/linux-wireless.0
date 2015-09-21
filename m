Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40457 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbbIUNgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 09:36:22 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 22/38] orinoco: fix checking for default value
Date: Mon, 21 Sep 2015 15:33:54 +0200
Message-id: <1442842450-29769-23-git-send-email-a.hajda@samsung.com> (sfid-20150921_153629_148131_97943C1C)
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thresholds uses -1 to indicate that default value should be used.
Since thresholds are unsigned sign checking makes no sense.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/net/wireless/orinoco/cfg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index a9e94b6..0f6ea31 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -220,7 +220,7 @@ static int orinoco_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		/* Set fragmentation */
 		if (priv->has_mwo) {
-			if (wiphy->frag_threshold < 0)
+			if (wiphy->frag_threshold == -1)
 				frag_value = 0;
 			else {
 				printk(KERN_WARNING "%s: Fixed fragmentation "
@@ -230,7 +230,7 @@ static int orinoco_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 				frag_value = 1;
 			}
 		} else {
-			if (wiphy->frag_threshold < 0)
+			if (wiphy->frag_threshold == -1)
 				frag_value = 2346;
 			else if ((wiphy->frag_threshold < 257) ||
 				 (wiphy->frag_threshold > 2347))
@@ -252,7 +252,7 @@ static int orinoco_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		 * the upper limit.
 		 */
 
-		if (wiphy->rts_threshold < 0)
+		if (wiphy->rts_threshold == -1)
 			rts_value = 2347;
 		else if (wiphy->rts_threshold > 2347)
 			err = -EINVAL;
-- 
1.9.1


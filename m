Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZLXU0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 15:26:12 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH v2 1/5] mac80211: fix race with suspend and dynamic_ps_disable_work
Date: Thu, 24 Dec 2009 15:26:09 -0500
Message-Id: <1261686369-12362-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 suspends it calls a driver's suspend callback
as a last step and after that the driver assumes no calls will
be made to it until we resume and its start callback is kicked.
If such calls are made, however, suspend can end up throwing
hardware in an unexpected state and making the device unusable
upon resume.

Fix this by preventing mac80211 to schedule dynamic_ps_disable_work
by checking for when mac80211 starts to suspend and starts
quiescing. Frames should be allowed to go through though as
that is part of the quiescing steps and we do not flush the
mac80211 workqueue since it was already done towards the
beginning of suspend cycle.

The other mac80211 issue will be hanled in the next patch.

For further details see refer to the thread:

http://marc.info/?t=126144866100001&r=1&w=2

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/tx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ac48c86..42bfd97 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1418,6 +1418,10 @@ static bool need_dynamic_ps(struct ieee80211_local *local)
 	if (!local->ps_sdata)
 		return false;
 
+	/* No point if we're going to suspend */
+	if (local->quiescing)
+		return false;
+
 	return true;
 }
 
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbZEMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:04:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] cfg80211: fix race between core hint and driver's custom apply
Date: Wed, 13 May 2009 17:04:42 -0400
Message-Id: <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its possible for cfg80211 to have scheduled the work and for
the global workqueue to not have kicked in prior to a cfg80211
driver's regulatory hint or wiphy_apply_custom_regulatory().

Although this is very unlikely its possible and should fix
this race. When this race would happen you are expected to have
hit a null pointer dereference panic.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 041300e..a5fe1f3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1554,6 +1554,13 @@ static int regulatory_hint_core(const char *alpha2)
 
 	queue_regulatory_request(request);
 
+	/*
+	 * This ensures last_request is populated once modules
+	 * come swinging in and calling regulatory hints and
+	 * wiphy_apply_custom_regulatory().
+	 */
+	flush_scheduled_work();
+
 	return 0;
 }
 
-- 
1.6.0.6


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:34227 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZJ0Pgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 11:36:32 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v2 2/3] mac80211: fix dynamic power save for devices with
	nullfunc support in hw
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Tue, 27 Oct 2009 17:36:17 +0200
Message-ID: <20091027153616.27827.46490.stgit@tikku>
In-Reply-To: <20091027153608.27827.70629.stgit@tikku>
References: <20091027153608.27827.70629.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

In TX path it was assumed that dynamic power save works only if
IEEE80211_HW_PS_NULLFUNC_STACK is set. But is not the case, there are
devices which have nullfunc support in hardware but need mac80211
to handle dynamic power save timers, TI's wl1251 is one of them.

The fix is to not check for IEEE80211_HW_PS_NULLFUNC_STACK in
is_dynamic_ps_enabled(), instead check IEEE80211_HW_SUPPORTS_PS and
IEEE80211_HW_SUPPORTS_DYNAMIC_PS flags and act accordingly.

Tested with wl1251.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/tx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c59ed84..66dab40 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1390,7 +1390,11 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 static bool need_dynamic_ps(struct ieee80211_local *local)
 {
 	/* driver doesn't support power save */
-	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+		return false;
+
+	/* hardware does dynamic power save */
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		return false;
 
 	/* dynamic power save disabled */


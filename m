Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46863 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZHLOwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 10:52:31 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/3] mac80211: fix dynamic power save for devices which have
	nullfunc support
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2009 17:52:10 +0300
Message-ID: <20090812145209.23691.82.stgit@tikku>
In-Reply-To: <20090812145200.23691.17281.stgit@tikku>
References: <20090812145200.23691.17281.stgit@tikku>
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

 net/mac80211/tx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 03005f9..0e7273c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1386,10 +1386,15 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 
 static bool is_dynamic_ps_enabled(struct ieee80211_local *local)
 {
-	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
 		/* driver doesn't support power save */
 		return false;
 
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+		/* hardware does dynamic power save */
+		return false;
+
 	if (local->hw.conf.dynamic_ps_timeout <= 0)
 		/* dynamic power save disabled */
 		return false;


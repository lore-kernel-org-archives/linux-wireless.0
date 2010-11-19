Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35167 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0KSVzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:55:49 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 4/4] mac80211: reduce the probe response timeout after beacon loss
Date: Fri, 19 Nov 2010 22:55:40 +0100
Message-Id: <1290203740-57124-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-3-git-send-email-nbd@openwrt.org>
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
 <1290203740-57124-2-git-send-email-nbd@openwrt.org>
 <1290203740-57124-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting for 500 ms after sending a probe request seems a bit excessive,
especially when doing 5 attempts. If the connection is bad enough to make
multiple requests time out, then user space should try to quickly find a
new AP.

Signed-off-by: Paul Stewart <pstew@google.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae99c0b..a64bb92 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -51,7 +51,7 @@
  * a probe request because of beacon loss or for
  * checking the connection still works.
  */
-#define IEEE80211_PROBE_WAIT		(HZ / 2)
+#define IEEE80211_PROBE_WAIT		(HZ / 5)
 
 /*
  * Weight given to the latest Beacon frame when calculating average signal
-- 
1.7.3.2


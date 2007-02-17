Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:48260 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946436AbXBQHmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 02:42:16 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIKBf-0004pr-57
	for linux-wireless@vger.kernel.org; Sat, 17 Feb 2007 02:40:51 -0500
Received: from localhost ([127.0.0.1] helo=dv.roinet.com)
	by gnu.org with esmtp (Exim 4.66)
	(envelope-from <proski@gnu.org>)
	id 1HIKCv-00005s-3L
	for linux-wireless@vger.kernel.org; Sat, 17 Feb 2007 02:42:09 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] d80211: fix incorrect hw.priv setting in ieee80211_alloc_hw()
To: linux-wireless@vger.kernel.org
Date: Sat, 17 Feb 2007 02:42:08 -0500
Message-ID: <20070217074208.348.69546.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw.priv is set twice, and the second time it's set incorrectly to an
area relative to the master device, which wasn't allocated for private
data.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 net/d80211/ieee80211.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 456beb3..4f77e27 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4550,9 +4550,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	mdev->ieee80211_ptr = &sdata->wdev;
 	sdata->wdev.wiphy = wiphy;
 
-	local->hw.priv = (char *)mdev->priv +
-			 ((sizeof(struct ieee80211_sub_if_data) +
-			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
 	local->hw.queues = 1; /* default */
 
 	local->mdev = mdev;


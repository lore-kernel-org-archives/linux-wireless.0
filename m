Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43611 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab0GTQpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 12:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: mark cfg80211_is_all_idle as static
Date: Tue, 20 Jul 2010 12:33:54 -0400
Message-Id: <1279643634-14556-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   net/wireless/sme.c
net/wireless/sme.c:38:6: warning: symbol 'cfg80211_is_all_idle' was not declared. Should it be static?

It is not used elsewhere, so mark it static.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/sme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 72222f0..a8c2d6b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -35,7 +35,7 @@ struct cfg80211_conn {
 	bool auto_auth, prev_bssid_valid;
 };
 
-bool cfg80211_is_all_idle(void)
+static bool cfg80211_is_all_idle(void)
 {
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
-- 
1.7.1.1


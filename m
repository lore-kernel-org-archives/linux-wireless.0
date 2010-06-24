Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41976 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0FXPaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:30:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: mark reg_mutex as static
Date: Thu, 24 Jun 2010 11:27:12 -0400
Message-Id: <1277393232-15412-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 994c7c5..1ac2bdd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -80,7 +80,7 @@ static const struct ieee80211_regdomain *country_ie_regdomain;
  *     - country_ie_regdomain
  *     - last_request
  */
-DEFINE_MUTEX(reg_mutex);
+static DEFINE_MUTEX(reg_mutex);
 #define assert_reg_lock() WARN_ON(!mutex_is_locked(&reg_mutex))
 
 /* Used to queue up regulatory hints */
-- 
1.7.0.1


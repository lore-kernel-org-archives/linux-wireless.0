Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49935 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZBYBO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 20:14:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 17:14:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: unregister ml groups on failure
Date: Tue, 24 Feb 2009 17:14:10 -0800
Message-ID: <1235524450-22624-1-git-send-email-lrodriguez@atheros.com> (sfid-20090225_021500_255045_7684E1AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not doing so before.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 04ef828..e5d9060 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2806,9 +2806,12 @@ int nl80211_init(void)
 
 	err = genl_register_mc_group(&nl80211_fam, &nl80211_scan_mcgrp);
 	if (err)
-		goto err_out;
+		goto err_out_scan_mc;
 
 	return 0;
+
+ err_out_scan_mc:
+	genl_unregister_mc_group(&nl80211_fam, &nl80211_config_mcgrp);
  err_out:
 	genl_unregister_family(&nl80211_fam);
 	return err;
-- 
1.6.1.2.253.ga34a


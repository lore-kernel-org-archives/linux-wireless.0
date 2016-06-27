Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36587 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcF0Obb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 10:31:31 -0400
Date: Mon, 27 Jun 2016 17:31:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: silence an uninitialize variable warning
Message-ID: <20160627143118.GB19889@mwanda> (sfid-20160627_163135_427087_80570121)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We normally return an unitialized value, but no one checks it so it
doesn't matter.  Anyway, let's silence the static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1c7d45a..b5d28f1 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1747,6 +1747,7 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	ret = 0;
 call_drv:
 	drv_tdls_recv_channel_switch(sdata->local, sdata, &params);
 

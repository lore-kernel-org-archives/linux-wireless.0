Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbeEPIs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 04:48:57 -0400
Date: Wed, 16 May 2018 11:48:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cfg80211: Use correct GFP_ mask in cfg80211_del_sta_sinfo()
Message-ID: <20180516084836.GB23043@mwanda> (sfid-20180516_104917_940347_F56166B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that we should use the passed in "gfp" instead of hard
coding GFP_KERNEL.  I looked at some of the callers and this would
probably be a bug for rtw_cfg80211_indicate_sta_disassoc() which uses
GFP_ATOMIC and a NULL "sinfo".

Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afbe5105bf7f..3eb645b81777 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14644,7 +14644,7 @@ void cfg80211_del_sta_sinfo(struct net_device *dev, const u8 *mac_addr,
 	struct station_info *empty_sinfo = NULL;
 
 	if (!sinfo) {
-		empty_sinfo = kzalloc(sizeof(*empty_sinfo), GFP_KERNEL);
+		empty_sinfo = kzalloc(sizeof(*empty_sinfo), gfp);
 		if (!empty_sinfo)
 			return;
 		sinfo = empty_sinfo;

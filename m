Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:39708 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217AbaEQSSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 14:18:23 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] iw: print expected throughput when dumping station
Date: Sat, 17 May 2014 20:17:12 +0200
Message-Id: <1400350632-2422-1-git-send-email-antonio@meshcoding.com> (sfid-20140517_201827_428745_4C86EA1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

This patch is based on the "Export the expected throughput towards a peer"
patchset sent on linux-wireless

Cheers,


 station.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/station.c b/station.c
index 07acdbc..ef8d405 100644
--- a/station.c
+++ b/station.c
@@ -226,6 +226,16 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\trx bitrate:\t%s", buf);
 	}
 
+	if (sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]) {
+		uint32_t thr;
+
+		thr = nla_get_u32(sinfo[NL80211_STA_INFO_EXPECTED_THROUGHPUT]);
+		/* convert in Mbps but scale by 1000 to save kbps units */
+		thr = thr * 1000 / 1024;
+
+		printf("\n\tthroughput:\t%u.%uMbps", thr / 1000, thr % 1000);
+	}
+
 	if (sinfo[NL80211_STA_INFO_LLID])
 		printf("\n\tmesh llid:\t%d",
 			nla_get_u16(sinfo[NL80211_STA_INFO_LLID]));
-- 
1.8.5.5


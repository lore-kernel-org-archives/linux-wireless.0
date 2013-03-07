Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49939 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3CGJIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 04:08:54 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: fix inconsistency in trace for rdev_set_mac_acl
Date: Thu, 7 Mar 2013 11:08:29 +0200
Message-ID: <1362647309-20389-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130307_100902_644078_C6585E9C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is NETDEV_ENTRY that was incorrectly assigned as WIPHY_ASSIGN
fix it

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 20ba224..89bd2f1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1778,7 +1778,7 @@ TRACE_EVENT(rdev_set_mac_acl,
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
 		__entry->acl_policy = params->acl_policy;
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", acl policy: %d",
-- 
1.7.10.4


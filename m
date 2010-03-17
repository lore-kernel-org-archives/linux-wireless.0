Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39519 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab0CQTpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 15:45:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] wireless: convert reg_regdb_search_lock to mutex
Date: Wed, 17 Mar 2010 15:33:22 -0400
Message-Id: <1268854402-2823-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
References: <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanse discovered that kmalloc is being called with GFP_KERNEL while
holding this spinlock.  The spinlock can be a mutex instead, which also
enables the removal of the unlock/lock around the lock/unlock of
cfg80211_mutex and the call to set_regdom.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/reg.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ed89c59..1ef1639 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -324,7 +324,7 @@ struct reg_regdb_search_request {
 };
 
 static LIST_HEAD(reg_regdb_search_list);
-static DEFINE_SPINLOCK(reg_regdb_search_lock);
+static DEFINE_MUTEX(reg_regdb_search_mutex);
 
 static void reg_regdb_search(struct work_struct *work)
 {
@@ -332,7 +332,7 @@ static void reg_regdb_search(struct work_struct *work)
 	const struct ieee80211_regdomain *curdom, *regdom;
 	int i, r;
 
-	spin_lock(&reg_regdb_search_lock);
+	mutex_lock(&reg_regdb_search_mutex);
 	while (!list_empty(&reg_regdb_search_list)) {
 		request = list_first_entry(&reg_regdb_search_list,
 					   struct reg_regdb_search_request,
@@ -346,18 +346,16 @@ static void reg_regdb_search(struct work_struct *work)
 				r = reg_copy_regd(&regdom, curdom);
 				if (r)
 					break;
-				spin_unlock(&reg_regdb_search_lock);
 				mutex_lock(&cfg80211_mutex);
 				set_regdom(regdom);
 				mutex_unlock(&cfg80211_mutex);
-				spin_lock(&reg_regdb_search_lock);
 				break;
 			}
 		}
 
 		kfree(request);
 	}
-	spin_unlock(&reg_regdb_search_lock);
+	mutex_unlock(&reg_regdb_search_mutex);
 }
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
-- 
1.6.2.5


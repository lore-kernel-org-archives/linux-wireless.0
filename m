Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48746 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0CPUAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 16:00:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: convert reg_regdb_search_lock to mutex
Date: Tue, 16 Mar 2010 15:49:00 -0400
Message-Id: <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4B9F86E9.2030702@gmail.com>
References: <4B9F86E9.2030702@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanse discovered that kmalloc can be called with GFP_KERNEL while
holding this spinlock.  It can be a mutex instead.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Hmmm...I think I can get rid of the unlock of reg_regdb_search_mutex
before calling set_regdom now as well?

 net/wireless/reg.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ed89c59..5f623ed 100644
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
@@ -346,18 +346,18 @@ static void reg_regdb_search(struct work_struct *work)
 				r = reg_copy_regd(&regdom, curdom);
 				if (r)
 					break;
-				spin_unlock(&reg_regdb_search_lock);
+				mutex_unlock(&reg_regdb_search_mutex);
 				mutex_lock(&cfg80211_mutex);
 				set_regdom(regdom);
 				mutex_unlock(&cfg80211_mutex);
-				spin_lock(&reg_regdb_search_lock);
+				mutex_lock(&reg_regdb_search_mutex);
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


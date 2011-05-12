Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1ELNDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 09:03:34 -0400
Subject: [PATCH] mac80211: remove pointless mesh path timer RCU code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Javier Cardona <javier@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1305203138.3461.24.camel@jlt3.sipsolutions.net> (sfid-20110512_142543_533404_D7A57FF6)
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
	 (sfid-20110512_142543_533404_D7A57FF6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:03:32 +0200
Message-ID: <1305205412.3461.27.camel@jlt3.sipsolutions.net> (sfid-20110512_150355_153502_BADF9461)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code here to RCU-dereference a pointer that's
on the stack is totally pointless, RCU isn't magic
(like say Java's weak references are), so the code
can't work like whoever wrote it thought it might.

Remove it so readers don't get confused. Note that
it seems that a bug is there anyway: I don't see
any code that cancels the timer when a mesh path
struct is destroyed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_hwmp.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/net/mac80211/mesh_hwmp.c	2011-05-12 15:01:20.000000000 +0200
+++ b/net/mac80211/mesh_hwmp.c	2011-05-12 15:01:24.000000000 +0200
@@ -967,20 +967,11 @@ endlookup:
 
 void mesh_path_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct mesh_path *mpath;
+	struct mesh_path *mpath = (void *) data;
+	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
-	rcu_read_lock();
-	mpath = (struct mesh_path *) data;
-	mpath = rcu_dereference(mpath);
-	if (!mpath)
-		goto endmpathtimer;
-	sdata = mpath->sdata;
-
-	if (sdata->local->quiescing) {
-		rcu_read_unlock();
+	if (sdata->local->quiescing)
 		return;
-	}
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->flags & MESH_PATH_RESOLVED ||
@@ -997,8 +988,6 @@ void mesh_path_timer(unsigned long data)
 	}
 
 	spin_unlock_bh(&mpath->state_lock);
-endmpathtimer:
-	rcu_read_unlock();
 }
 
 void



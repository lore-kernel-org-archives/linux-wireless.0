Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:39306 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYBYTHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:07:31 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1093613rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:07:30 -0800 (PST)
Subject: Re: [PATCH 17/18] mac80211: mesh hwmp locking fixes
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080223142017.846789000@sipsolutions.net>
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142017.846789000@sipsolutions.net>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:09:09 -0800
Message-Id: <1203966549.6929.4.camel@localhost> (sfid-20080225_190740_146369_5CABBE49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-02-23 at 15:17 +0100, Johannes Berg wrote:
> This fixes missing unlocks noticed by sparse.

Thanks for the fix. It would be easier though to just acquire the lock
later, since rcu_read_lock() is no longer needed to look for mesh peer
links, like in this patch (applied to the original version of the file
without the patch included in the mail I'm replying to).

---

--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -262,7 +262,6 @@ static u32 hwmp_route_info_get(struct net_device *dev,
 	bool process = true;
 	u8 action = mgmt->u.action.u.mesh_action.action_code;
 
-	rcu_read_lock();
 	sta = sta_info_get(local, mgmt->sa);
 	if (!sta)
 		return 0;
@@ -300,6 +299,7 @@ static u32 hwmp_route_info_get(struct net_device *dev,
 		new_metric = MAX_METRIC;
 	exp_time = TU_TO_EXP_TIME(orig_lifetime);
 
+	rcu_read_lock();
 	if (memcmp(orig_addr, dev->dev_addr, ETH_ALEN) == 0) {
 		/* This MP is the originator, we are not interested in this
 		 * frame, except for updating transmitter's path info.


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



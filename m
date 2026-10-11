Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9DF397E73
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711198; cv=none; b=FqowoTUjDETPuJ/uMfodgppUFVWYFkW9abpVxwHvyFY2CoSkIKfcz4VlHf3J3c2O+wslp7LC2clXHJaG24mkxeDmhn/mFZoyELys+eZeD8YnXC0il1rBf38IyPcKaqmZlnGLgULiBIejWtT9E9KYM1rRXRfAml2HhMFdVkAKE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711198; c=relaxed/simple;
	bh=bz3GIGSphugG6dOPkkxwZu0XWLjMr2/afhMrJi4w0c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWYj6XzkoIXgt/3Zz2SiZS0eNbNfACW1lisLuXRYUqP/H2zLv4IWKwKO9/KJaAwxpyx3t9gSpAzPXnhshUER/TNrMTvYSAmo+q8cKjJa8nutK0Yp7WcRiOK2yGPiLM/itnqABI647aV/zmftflmDeqtTKI7P2XUEU5qpWEFpaj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=WTr0hD7Z; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="WTr0hD7Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=omN31s1jH7yo32hCGebn/ucm+AHcftAIzufd+k2jUkM=;
	t=1791711197; x=1792920797; b=WTr0hD7ZCFaxUAKlDXHEBqILA2Vu46Lg6LKpRCEDF5unZtq
	8C6J2EMxrrSbIjmMRAh1HinbCvMMIn3NM6v5Np2aAtMTl0i+ewZorpx8v/SxXg7mH9AEuI7rTUoGA
	D+Pq2wk3IspoEwOTgRmIZT4B+HywnCcOuG0QGDrSm4/KCIPf6nXBpcHk1JWMg6cI11gMm0aGrTyL+
	ii0WAflY37ob4oqfpc3XJlPjlZ6atWZuHN+WkmBFZsAGmIWwLsGCdQP8r/jkp42mwskVYBB02leDU
	9yFKq/x/+mjDj/ZdEzXPdu+Xz3nRJVj4wxCut5p65tEx0o60iFwW14A1BXXC+H3w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvf-0000000Dk5j-1xBU;
	Sun, 11 Oct 2026 11:33:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 05/10] wifi: nl80211: avoid RTNL for wiphy/interface netlink dumps
Date: Sun, 11 Oct 2026 11:31:28 +0200
Message-ID: <20261011113308.d2b68635eeec.I42540f72c38c1bbb6edd2396d6dcc6199f1bc8c0@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011093308.49945-12-johannes@sipsolutions.net>
References: <20261011093308.49945-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The wiphy/interface netlink dumps only need the RTNL for
the list and, possibly, filtering by netdev. This can be
easily replaced now, do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46b72f3b5ea4..bf64cafa02fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3794,8 +3794,10 @@ static int nl80211_dump_wiphy_parse(struct sk_buff *skb,
 		struct cfg80211_registered_device *rdev;
 		int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
 
-		netdev = __dev_get_by_index(sock_net(skb->sk), ifidx);
+		rcu_read_lock();
+		netdev = dev_get_by_index_rcu(sock_net(skb->sk), ifidx);
 		if (!netdev) {
+			rcu_read_unlock();
 			ret = -ENODEV;
 			goto out;
 		}
@@ -3804,6 +3806,7 @@ static int nl80211_dump_wiphy_parse(struct sk_buff *skb,
 				netdev->ieee80211_ptr->wiphy);
 			state->filter_wiphy = rdev->wiphy_idx;
 		}
+		rcu_read_unlock();
 	}
 
 	ret = 0;
@@ -3818,18 +3821,18 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nl80211_dump_wiphy_state *state = (void *)cb->args[0];
 	struct cfg80211_registered_device *rdev;
 
-	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (!state) {
 		state = kzalloc_obj(*state);
 		if (!state) {
-			rtnl_unlock();
+			mutex_unlock(&cfg80211_mutex);
 			return -ENOMEM;
 		}
 		state->filter_wiphy = -1;
 		ret = nl80211_dump_wiphy_parse(skb, cb, state);
 		if (ret) {
 			kfree(state);
-			rtnl_unlock();
+			mutex_unlock(&cfg80211_mutex);
 			return ret;
 		}
 		cb->args[0] = (long)state;
@@ -3871,7 +3874,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 					cb->min_dump_alloc = 4096;
 					state->split_start = 0;
 					wiphy_unlock(&rdev->wiphy);
-					rtnl_unlock();
+					mutex_unlock(&cfg80211_mutex);
 					return 1;
 				}
 				idx--;
@@ -3881,7 +3884,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 		wiphy_unlock(&rdev->wiphy);
 		break;
 	}
-	rtnl_unlock();
+	mutex_unlock(&cfg80211_mutex);
 
 	state->start = idx;
 
@@ -4857,7 +4860,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 	struct wireless_dev *wdev;
 	int ret;
 
-	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 	if (!cb->args[2]) {
 		struct nl80211_dump_wiphy_state state = {
 			.filter_wiphy = -1,
@@ -4920,7 +4923,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 
 	ret = skb->len;
  out_unlock:
-	rtnl_unlock();
+	mutex_unlock(&cfg80211_mutex);
 
 	return ret;
 }
-- 
2.56.0


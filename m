Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136013F482F
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 08:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373650; cv=none; b=MnXxPgKspVeidC0Nc7+dIhVE4UJNhHzAEZ2VXmEWcIJwug/AwIBkP3Hz+XroNJCYQWOnYG8NtXhrwQfL0aSVEeRvfaCKyF23b1Xsk72QTA+mq1qTQZsX199PClajZxI3RobcfYWGsPJsjM1RcTIyQmL0BpwtCf18oZzvyDQoSno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373650; c=relaxed/simple;
	bh=1b4BpUoYwd7gTmoYqzAvY3yuIAVnE9sqr1w6QhiAyDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p5WzpIw6onYlVqRMtdPOVxdY1kne2ZIB0rYAkwrTUXKFb/7XzGrMIEh51ebLOqZfPYQQmsy3S/uqViPK3Jt3E+rVy5RTXx5o9d6dF2uCf32bqcgpcNmSFiX8P/LLZqtKj49daZrh7Nc82U6ZhvbE+IKgF1VhdzI2jrzAidnB1Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=Ag0r64ga; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="Ag0r64ga"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 14 Sep 2026 10:14:05 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	sst@poczta.fm
Subject: [PATCH v2] wifi: cfg80211: verify if AP_VLAN belongs to the correct AP
Date: Mon, 14 Sep 2026 10:13:50 +0200
Message-ID: <20260914081350.83484-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789373645; bh=jGa4RrGWo1KK+z/GtX6SiWwMhk+OP8oPCPxGTrf5OkU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Ag0r64gaBzZW4f0HKdOp1GWm3VubKFVaxQKuFrPJyqR7EiG1Q46CQ697sQNKomcn2
	 0WiLAlCRSiyz/1wVG/rk4K1047lKmkfmQhSGzNUuVmpiwFmS2PlsmanwfM6M1pcjW9
	 lUk01Q0VdsPVMXPtp86J78mRHMWnxtRqDY1A2KAU=

The get_vlan() only checks if NL80211_ATTR_STA_VLAN target is an
AP/AP_VLAN/P2P_GO interface on the same wiphy. It has no notion of which
specific AP a given AP_VLAN belongs to.

Fix that by comparing the ethernet addresses of the two net devices.
Given VLAN A' must have the same address as AP A. Otherwise, return
error code.

Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Link: https://lore.kernel.org/all/22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net/
---
v2:
* Move the logic to cfg80211 and use ether MAC address compare as suggested (from the beginning!) by
  Johannes
* Update the subject and commit message

v1:
* https://lore.kernel.org/all/20260910080454.725913-1-sst@poczta.fm/
---
 net/wireless/nl80211.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 899b6374c550..0f3388312ccd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8966,10 +8966,12 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 EXPORT_SYMBOL(cfg80211_check_station_change);
 
 /*
- * Get vlan interface making sure it is running and on the right wiphy.
+ * Get vlan interface making sure it is running, on the right wiphy
+ * and actually belongs to the given AP/P2P_GO interface.
  */
 static struct net_device *get_vlan(struct genl_info *info,
-				   struct cfg80211_registered_device *rdev)
+				   struct cfg80211_registered_device *rdev,
+				   struct net_device *dev)
 {
 	struct nlattr *vlanattr = info->attrs[NL80211_ATTR_STA_VLAN];
 	struct net_device *v;
@@ -8999,6 +9001,12 @@ static struct net_device *get_vlan(struct genl_info *info,
 		goto error;
 	}
 
+	/* Check if the VLAN interface belongs to the AP interface */
+	if (!dev || !ether_addr_equal(v->dev_addr, dev->dev_addr)) {
+		ret = -EINVAL;
+		goto error;
+	}
+
 	return v;
  error:
 	dev_put(v);
@@ -9296,7 +9304,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	params.vlan = get_vlan(info, rdev);
+	params.vlan = get_vlan(info, rdev, dev);
 	if (IS_ERR(params.vlan))
 		return PTR_ERR(params.vlan);
 
@@ -9597,7 +9605,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		/* must be last in here for error handling */
-		params.vlan = get_vlan(info, rdev);
+		params.vlan = get_vlan(info, rdev, dev);
 		if (IS_ERR(params.vlan))
 			return PTR_ERR(params.vlan);
 		break;
-- 
2.55.0


Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09F741D655
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027487; cv=none; b=csNnLFvcBODfnhaX67alKt9v4Itxzyf4sHuq3/7ODJ8tRTK0zIcGxe63dpbkWinvs4m0XGvlGW34MrEF1g4HCzuIiVvzvgnN+FJaYlaLWb3xMiAPVGJf27f/orvYOzHIUxT1mimGar0Zx539Ph5Ob3VWlKG9/i4EfrSrKmID8os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027487; c=relaxed/simple;
	bh=wuV6NokkP6dAaFyx8/noWjTCCEiqBAZTXB6LPKA4P6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0vfl52Z572dx17VIXuRkkBaE8/l+KWwYr5IUD02u0/xfpPm6ysDJhrOkq46VqXHkDUbBMf14tEoIurQ8tznEjVveg7SM+L/Z9NjJyALosgnwzGGHS0VW5fna5lR6uuBAgQflbfxCpFPEBnwE29DceZi4d4JCSFQ66ZFGD4DFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=OH9/kHjC; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="OH9/kHjC"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 10 Sep 2026 10:04:25 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	sst@poczta.fm,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH v2 2/3] wifi: cfg80211: move link_id validation earlier in nl80211_new_station()
Date: Thu, 10 Sep 2026 10:04:17 +0200
Message-ID: <20260910080418.725741-2-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910080418.725741-1-sst@poczta.fm>
References: <20260910080418.725741-1-sst@poczta.fm>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789027466; bh=wSU1URO8DdtqZq+r0L0uMzDl0xlKZkqoZaPFdVHWfb0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=OH9/kHjCq3TYg541LpmNVZIdDgvI+4FTxOrKOkxeZyNpajkETLzNt/ZI9WBwRt/LF
	 SkqDPR7DgZBX81nM7MOg9AO/T0UBaeLWtAsVK1UdVtcQgiwQRhru1RdVa+5kdfSJL2
	 vF+V2khG+nERJ4v7JdvnShORqI3XnP5yOVqKZcJU=

I do not see a reason why this check is so low in the function. Move it
up right next to param fetch.

This new position is more beneficial for AP/Link state check that will
be added in upcoming commit.

Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
v2:
* No changes

v1:
* https://lore.kernel.org/all/20260813090434.2071318-2-sst@poczta.fm/
---
 net/wireless/nl80211.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd784fa3fff8..8f7238415047 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9376,6 +9376,16 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	params.link_sta_params.link_id =
 		nl80211_link_id_or_invalid(info->attrs);
 
+	if (wdev->valid_links) {
+		if (params.link_sta_params.link_id < 0)
+			return -EINVAL;
+		if (!(wdev->valid_links & BIT(params.link_sta_params.link_id)))
+			return -ENOLINK;
+	} else {
+		if (params.link_sta_params.link_id >= 0)
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_MLD_ADDR]) {
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
 		params.link_sta_params.mld_mac = mac_addr;
@@ -9648,27 +9658,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	/* be aware of params.vlan when changing code here */
 
-	if (wdev->valid_links) {
-		if (params.link_sta_params.link_id < 0) {
-			err = -EINVAL;
-			goto out;
-		}
-		if (!(wdev->valid_links & BIT(params.link_sta_params.link_id))) {
-			err = -ENOLINK;
-			goto out;
-		}
-	} else {
-		if (params.link_sta_params.link_id >= 0) {
-			err = -EINVAL;
-			goto out;
-		}
-	}
-
 	params.epp_peer =
 		nla_get_flag(info->attrs[NL80211_ATTR_EPP_PEER]);
 
 	err = rdev_add_station(rdev, wdev, mac_addr, &params);
-out:
 	dev_put(params.vlan);
 	return err;
 }
-- 
2.55.0


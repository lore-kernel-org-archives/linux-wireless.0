Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A329737C936
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533862; cv=none; b=d8KVTbKcS338T04nTy352I54DBopWha4FxvMsfG5dOFnQnll7J8/AVZ8QjbONhwoqxRLvGw+H3/usIWNVBC/zuQW6JneTLxO8TFw+hGXov7q6brXbl73Mj/uKU+aOByswzAhwJKUyy/LdqUROXFVeeHtBjd8liqwnz2ZKiqcK9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533862; c=relaxed/simple;
	bh=vxHE2y63CUIiTtn4y+MsMv3dXl8YD/LJ20e0un7acrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SueU6KfRe55jKOMFZ9tqUeA3tbUl9WfncTzG0lVicNk3SEcvUHu9NwVtQijEKbfHC8aUsleyqA+9FMshPIcwryv/l0dTAOCxbg5ZKt32YSQTDHJt6ef5UUccLIcsuJYIAPJapW5vVX6sXBEdTlFSZG1JU83xWed1e6htQ0KyAv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DbvdIR3F; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DbvdIR3F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VqDormsw4zqzgvadml3fiQ4UCDN23CfsrAavQYRljqM=;
	t=1788533860; x=1789743460; b=DbvdIR3Fb92ihDtVCNc9125ODWACw2J5EVinAg23tAL8G5q
	CxPGs7sv+Aj+VPZAKBvEqV4el9z56z1DVJJj3MKqcD+Oq9J2Q6QxBdc2ZFqt2bT5kVTWtwNJoOmFf
	LIYBdCcKc8vAtHPLyCsfxmjJj6DhUiLgSzMFN6kXVVNnVxWEyJRbbAAAr1gwhYYTKX0nRx0HK6lQ8
	Sp/WdsqN63bavBzRH9DWizaf0vlL572b6xQJ5HVYt9FKnJ5lBQ49a+qkCcnDj+maaKve5vQDD+w7V
	hzQg/BQrcr95wGCAGnD9TtWAK/idjQp5W4F1ryy/g/BI+2/vx5+9EKTvFAMxiW2w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VMB-00000001SWk-0A4K;
	Fri, 04 Sep 2026 16:57:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Subject: [PATCH wireless 05/10] wifi: mac80211: don't offload TC setup on AP_VLAN interfaces
Date: Fri,  4 Sep 2026 16:57:09 +0200
Message-ID: <20260904165722.726cc076cecb.Iccfd88b13635425e850ce031376eb60a4ce5f4f8@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

AP_VLAN interfaces are purely virtual, so don't try to offload
TC setup to drivers. We can't really use the AP interface either
since we may not know it all the time, and it could technically
even change.

Just reject the TC offload so things get done in software.

Assisted-by: LLM
Fixes: 61587f1556fe ("wifi: mac80211: add support for letting drivers register tc offload support")
Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..8c300e045fdf 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -935,6 +935,9 @@ static int ieee80211_netdev_setup_tc(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
 	return drv_net_setup_tc(local, sdata, dev, type, type_data);
 }
 
-- 
2.55.0


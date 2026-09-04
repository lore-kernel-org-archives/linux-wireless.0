Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95404EE858
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534150; cv=none; b=XcU5qIsmAVx/BUpnT9g9zWmSnAyt6hE/FGt3qoU2woVlt3cx4PW9zai6snvSvgcePCzPR5FH/JlJAWuJ4sFgg0HDJR4/v6i6HP1f7nUdEV9NtGU0KQ2nQ2RrHq8W+hAJnXpYXCncjInvEbsrz+OuMCmnwkjlXT4joUXUuQSd5a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534150; c=relaxed/simple;
	bh=S7aksQo8Xz4++Y6kqmEGyuD/yi706P1ddGjVxdZKQDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckN9fuc/vWiM1AwIqx+Uax/sF0fUWfWICtJ7fksqW4nWqB1RxwgpWdT+yjKqF1wSLg7cFjDlPdk0XAGH/1ctMMi0802Egb4866BFi28D+cO8ixfSqLDO+MGv+fAgKITnCSNy7h+pWLMmB+AHv0R/bRnvQJCiAo5Z+1NTa/baDwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=W9sAlN1u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="W9sAlN1u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EOFNdXE5zb3zy+OAQOeuMcPBM1FHnCsuG4PDw5ob700=;
	t=1788534148; x=1789743748; b=W9sAlN1uzkVe1TrUANedphHDKuqDjTdC32hC4TTGpy3LS7X
	kK/OaHKriVQYzzfjaNJHVayseRQ4xPcKvrrDxOZBqWAuy5YwtmXQSAYu3sMdjyd4VdQYUUK/bLYzK
	E5JPEHCSSTKUYgp0xB+o0PMT30ZokY4BA1iOibYcdpWSHlab2tqlV5dlzelZuU3m1Kk/D2QMt03BM
	XKBpl89EYjJbezggy1d1uXDrcHJA8A0jam7IXYSkg3KlZcqujBVonIaH8OXfgTi9AH8geE7NW9Jkv
	svW1Zkx+dYGzmBaW5YTwqqDLtDBGnC+RLsB4fKncMr2OpT4vQd6Hf9r50/tWQsKg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQw-00000001Sh8-1PBX;
	Fri, 04 Sep 2026 17:02:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless 3/4] wifi: mac80211: unlist vifs when their netdev is unregistered
Date: Fri,  4 Sep 2026 17:02:01 +0200
Message-ID: <20260904170220.038ad73e6c04.I990abca78483e058746b6f42b4796717c3028164@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150220.427345-6-johannes@sipsolutions.net>
References: <20260904150220.427345-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

mac80211 only removes vifs from the local->interfaces list when
an interface is removed via ieee80211_if_remove(), before it
unregisters the netdev. However, it's possible for a netdev to
be unregistered without going through that: When the netns that
holds the wiphy is destroyed, the wiphy is supposed to move to
the init_ns, but that can run into allocation failures.

Then, mac80211 has an interface listed that doesn't exist, and
will eventually hit

  BUG: failure at net/wireless/core.h:141/wiphy_to_rdev()!
  ...
  _cfg80211_unregister_wdev+0x24/0x36a [cfg80211]
  cfg80211_unregister_wdev+0x15/0x1d [cfg80211]
  ieee80211_remove_interfaces+0x1ff/0x257 [mac80211]
  ieee80211_unregister_hw+0x73/0x1d1 [mac80211]
  mac80211_hwsim_del_radio+0x114/0x166 [mac80211_hwsim]

Remove the interface from the list in ->ndo_uninit if it's still
around to avoid this.

Assisted-by: LLM
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ebe3b068c7ea..889c32fd8de1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -926,9 +926,33 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+/*
+ * The netdev can be unregistered without mac80211 doing it, e.g. by the netdev
+ * core when cfg80211 couldn't move it out of a network namespace that's being
+ * destroyed. Drop it from the interface list either way.
+ */
+static void ieee80211_unlist_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *iter;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(iter, &local->interfaces, list) {
+		if (iter != sdata)
+			continue;
+		guard(mutex)(&local->iflist_mtx);
+		list_del_rcu(&sdata->list);
+		return;
+	}
+}
+
 static void ieee80211_uninit(struct net_device *dev)
 {
-	ieee80211_teardown_sdata(IEEE80211_DEV_TO_SUB_IF(dev));
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	ieee80211_unlist_sdata(sdata);
+	ieee80211_teardown_sdata(sdata);
 }
 
 static int ieee80211_netdev_setup_tc(struct net_device *dev,
-- 
2.55.0


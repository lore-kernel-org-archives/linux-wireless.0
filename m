Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B4A4582E6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195076; cv=none; b=V+dYqnYf3j5h4ImUzAzuw1IGlDyF8aaCNvG7n7mpr9UdY8e+TTDLYBl0AiDBMRMou64W8yw85FacdgCcvi443LsFu4ICZHo6yIt4AleCCcRt+ODoU69yF+e2HGxD35Gu6nxT6vk0m2OrIwQzKuV/NDwkR6iZ63sTsR9LSSfOseY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195076; c=relaxed/simple;
	bh=qL4fU8I5N4X9t8LLn4Crt3PkY96P5EAamW16AcaF+R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UA3pMHs4x+8lzHSYKRcydXZEFZoVST6jBeUBlkeOLqb2H0bcibcaDEVtoaWZWiW8KvWA0Y4pqai3AFsrWHvgPGxOwWCMhdDgilWeQiu+M8BE37ySGroWaHGdusDFZOt23r8CB+irxj0oL9AWuTJHBhD+t2xiUiyg/7Hrt2OL2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=r5R1Ea9v; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="r5R1Ea9v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=31EETAx0XEBT6M7TTzJ1h6hpOGS562q6eTKB5pou79w=;
	t=1791195075; x=1792404675; b=r5R1Ea9v41EsM578BB0n3DWalSPdCkLUb64O76hLzDSRGh4
	3ZRRDQsv/ue+4AMY+4W8L8XPGZe0KlLCjb3WDzhSmvOCeuVJe5N/++izb5l0RVW3QLVjLQF1W7obJ
	bOzoYYoMlw9+pM//jcuVGC41e0Ix0rByaz3nnF6ah71j6kkAXk7dRE17r3jCz+yPT/IX9RYPGAjmp
	nMuE2MqhIjVI8Gr2wZy3ydLqeznhGyC+0CBPQxlyKX/RqEwRZqkT8Lf1+rp31LzHByLfy6S7dd3UR
	fuMXP0XRW9+J9XJOF7q5P7NRlJLw/YKAhXrcVXgKwh5vAgnZm/NrfkPk6rDifRJA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff6-00000005CGx-2j0n;
	Mon, 05 Oct 2026 12:11:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 12/13] wifi: mac80211: don't require wiphy mutex for control port TX
Date: Mon,  5 Oct 2026 12:06:28 +0200
Message-ID: <20261005121058.4ffa997d40b8.Ica8bba30018704a7c776f2ef08e6f2571cd8f8c4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The wiphy mutex was only required for the cookie counter,
but that's been in cfg80211 for a while. The rest is just
datapath, so can work under RCU, just need to be careful
to handle interface type changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1953ec35c783..46134bda1e8f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6600,9 +6600,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags = 0;
 	int err;
 
-	/* mutex lock is only needed for incrementing the cookie counter */
-	lockdep_assert_wiphy(local->hw.wiphy);
-
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
 	 * or Pre-Authentication
 	 */
@@ -6661,6 +6658,14 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	 * AF_PACKET
 	 */
 	rcu_read_lock();
+
+	/* do_stop() synchronizes RCU before the interface type can change */
+	if (!ieee80211_sdata_running(sdata)) {
+		dev_kfree_skb(skb);
+		rcu_read_unlock();
+		return -ENETDOWN;
+	}
+
 	err = ieee80211_lookup_ra_sta(sdata, skb, &sta, true);
 	if (err) {
 		dev_kfree_skb(skb);
-- 
2.55.0


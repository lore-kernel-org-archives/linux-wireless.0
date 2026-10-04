Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A91A4AA1D4
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150320; cv=none; b=oBHjBKqAgYUmZy83o0EQtwg4kZqcD5ag03uEAFUoHYKpc+e1lnH04VKX6v/yUyxWGAun0skmhB3HLezQNek8jHbjCFPpYZPUncoxOk4hEJUFPVDfumTT4Rj5prWmuL71PYvCQMFo2vuXps46ZHca4OU2jfIYpkaJ059bbW3g6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150320; c=relaxed/simple;
	bh=n2A9ADFh3qfeczIKSMZoN/gi3vd1ga082aeuXpihhjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iylxc0oJduc/pLnvmlBeartUmqo2XguLnil01/+M03rGdGklGzazchjIBDg6ZJfJjFgCrjf5ZnLdtVu1bJQJuAldY/M64xzp/ppJjLjsRidr5OiTPkT0ZnP06d0tY2AhQ/V1lVl3Gl4SvHOk//4rVr8fp8fWt4C0uT6OO2WHldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nGTrfyR/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nGTrfyR/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+uxURoaRfPcMqNU9o1ThewZduZeX8KrZZ9wzQcw4qdg=;
	t=1791150318; x=1792359918; b=nGTrfyR//kru/5xZWyKxnJ8IxVXVrKmWAJmT6lQ2hJdr3Hn
	yGTgWx+xGQSTDQGZ5w0eM1XvBGXxdkb23p2v7Zk2Psb99FMOyHNroZJ73YE5NqnhbGC0usfM4GCgq
	AUcyBtQD0qKa/jbvRkkRdGKioFogfwQm1Sd87ux9k9SNwBDJBCvFJMRr0XU3Jf0z+oTpYzKZLqHbk
	dCnC+nzBpINiReI4F6rXQGrViamCAS73CHqVVwrUXJeK62mdAbBLaSRjWTHa9Y2jMl0W0SaAt9j12
	zwax4h9r958/cuvj/v1hKaUsZtZA61JInloGD6SYz6Iy8uHjw5hRbk13DQYS8mhw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU1D-00000004OqT-1d9f;
	Sun, 04 Oct 2026 23:45:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 10/12] wifi: nl80211: probe peers without wiphy mutex
Date: Sun,  4 Oct 2026 23:40:56 +0200
Message-ID: <20261004234504.af3ec3165d9d.I2f462bfffa96feb8dcc4386bc35ebc25d877a92f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

None of the drivers implementing probe_peer (mac80211,
wil6210, nxpwifi) need the wiphy mutex for it, so we
can just not take it. Document that as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 5 ++++-
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f227b702b38a..5c33e31bea49 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5138,7 +5138,10 @@ struct mgmt_frame_regs {
  *
  * @probe_peer: probe a connected peer (AP: STA MAC required; STA: no MAC),
  *	must use the @cookie as provided which is later passed to
- *	cfg80211_probe_status().
+ *	cfg80211_probe_status(). Called without the wiphy mutex, so the
+ *	interface type may have changed/be changing and the MAC may be
+ *	%NULL even in AP mode (if runtime type changes are supported),
+ *	drivers must check for that.
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ae3f4da167c5..b8da2df8d9cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20765,7 +20765,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_probe_peer,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
 	{
 		.cmd = NL80211_CMD_REGISTER_BEACONS,
-- 
2.55.0


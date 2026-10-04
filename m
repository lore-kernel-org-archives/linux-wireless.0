Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4094A8FD7
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150316; cv=none; b=YhKjO+nw8N1iw3WdsAFOfLqHiUCC7w7zBprRWyUOJs3g9WD5397ODeyD5lIRNLmTRGMdSvbI9f84vMwuXZh41hCriWA77Aut2Q6Ao+xYxiGq8PeOfsWhTVlKFFIgEjyZs8EP/2Hds/NR+dk5wrK0m/hzjJZQYfDcuzl84pvm/ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150316; c=relaxed/simple;
	bh=nr9SLKKESDPNUWDkJ6tW7JYxrU8FoCM9XImjgb75f/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu9BhLaK6khtqOp9QDH44QpjTnhWAlJylru/42lSddlkzz2aRm0aVTqbg8cEflt57wYU3UVfqr1d5G3AYCgjXGBPnRDF+xYf9EGlcD4kgp97bkkORaFDxoPCQGNqSO/qxozWbOrisEwZ8+ut4w+RKHylnWNkQui6qEIDR14aYKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RvtWcQjN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RvtWcQjN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SIfHjfwtmJey6uk5PIHxyZwaKEwLbiY75xNGqy2PXxs=;
	t=1791150314; x=1792359914; b=RvtWcQjNp2O5uOBqyEZk+D7uv3oEzhOgrY1c7odjRUqiNDk
	K/qN75dBPqW7dueWVJQQPLuBGC9eaHnhaqkOmuMbwgtLPGoLhylD5P8rDIiS+MVvY8O3Pp/DFJtD6
	IKaBg5TrLQ8i+Ka0+gR0GcrDXu35lTelR+saKfjXlyf8SdRySTnc2l27wBBabCOkPPGXk2oRdKui/
	uR15OMsj0QFQI1e4XHJyAFCheBQ4jf69Dy4hEiQDHKwqDrsd0GQhmBSIOXabphZ30KuFlO5c0voDN
	puGkYocb5twkqR8xzODxl1bmZNK4O9ZiQ4iKmGO7XJgxkF9lqAg2aR4igSVoDKpQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU18-00000004OqT-35qM;
	Sun, 04 Oct 2026 23:45:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 04/12] wifi: mac80211_hwsim: support lockless beacon updates
Date: Sun,  4 Oct 2026 23:40:50 +0200
Message-ID: <20261004234504.33769a084c1c.I811ea72fc189eb20bbc07b27cfaf9ffd420a70c9@changeid>
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

We just use ieee80211_beacon_get_template_ema_list() or
ieee80211_beacon_get() here to transmit the beacons, so
there's no need to implement update_beacon() and we can
just set NL80211_EXT_FEATURE_UPDATE_BEACON.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 59c540d2677b..c93c8d61d1c0 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -6010,6 +6010,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_EXT_KEY_ID);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_UPDATE_BEACON);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
-- 
2.55.0


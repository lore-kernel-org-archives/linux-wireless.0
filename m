Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F359647044B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195069; cv=none; b=ZprdXx+PFndvGUh9O1ghEsexKffwDWiSvoiGZ2jvb54NUg2n06Hd2964JFmu0f7iO9oTlXtSZ4FXyoH+1ZwAgCPEefbWhY8Po8gI3NLjiTAW/02Xs4aRIytqErst+/pkSwbX+kSy7TS5waIarIvXpHW9h+ydrr2Ey8dCePttENE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195069; c=relaxed/simple;
	bh=nr9SLKKESDPNUWDkJ6tW7JYxrU8FoCM9XImjgb75f/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/iaKsgnbmhbKSHPrwNMesaq3GZhAQ3rlChZLLt3uoXU12JV66ftyURoPbryg4qaWcEC8kb+l6r5s9RBB2D5e+wpPA8cPcmfusVd55rYsjrxsCPtKtrrT0R/R+L607Vf5SbTik0NCZpGg35E8AhSZjsbOoBy1bEluRQuUvZl6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=K7XRG9Bz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="K7XRG9Bz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SIfHjfwtmJey6uk5PIHxyZwaKEwLbiY75xNGqy2PXxs=;
	t=1791195068; x=1792404668; b=K7XRG9BzrHaBGWXrRVY1Srq8UPO8/MoVjo8KCj3M5yMRqNI
	Ah+Rwy1xZAkHg2/EHjxTZaHj1FmCBF5oYv/IEVQgLiyhNVayJ3H19W4jb2iS45Di4MkeUjV5Y3lWq
	7gcDS1ww8JVYraxuzk5m5cOcNRVn9IIVq94ncEYxupMXc+UfLu9KaCtMLMfralsVpSPCazNz3WqBx
	4/V0tHMjO+3bOKqkYyuJgTXaMYFaZhyODFadSNmDBxfRtJSRXgLNoJvQ1V4ORJA4sMfraDwbCNBQA
	VAcWeWlN0GQTsS3ZFq1B9CPky7olAF7h3F6ebU665x+AcmK+Z+3oybYaxpRe9Z6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfez-00000005CGx-3dNV;
	Mon, 05 Oct 2026 12:11:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 04/13] wifi: mac80211_hwsim: support lockless beacon updates
Date: Mon,  5 Oct 2026 12:06:20 +0200
Message-ID: <20261005121057.633cf161a918.I811ea72fc189eb20bbc07b27cfaf9ffd420a70c9@changeid>
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


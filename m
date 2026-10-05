Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58A4756A3
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194756; cv=none; b=C0ckGz6eA7ZtFh+k8qFLLK9lSuI0A9PB359iPyFOCd6g6Q0ACOk9VxzVu9wMW4uHlrOQ49YbhDIgeWJITcFZcAhlYTEBEnqxPUu4O3N43d5u5CkbNUIbid+wWP28qMAeQVlJHIfR+IEd45Vs+0E/qpcG8CSYqhc3dMhJ0DlRbRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194756; c=relaxed/simple;
	bh=fhMmqK5pKhUoFBjUNThqN/fhk0h0K2+j1sjsDCZRb1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJPpdErBtFRqmMGGo8KpXbHqSHa8snceg7seTUTXO1v3oCgcsID3lKrIqZRz7U35RtqwyH/ur11ne4C9iOzUMpm1I1RTp8fWHQ+47lV++cTvV9vlSGAhvzMFicaYWIrN1MxTVqfIjQ6Xflu5v3zDlKt7Gp4wKpUZyVQ9HwLJ0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OYh0M8Ud; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OYh0M8Ud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NaSwJvL5ze54FqAOYoqO/zi/nSwWJokytBVL1/ekY/0=;
	t=1791194755; x=1792404355; b=OYh0M8UdPC+Zs3YnfAL87sROpKn0qdV21n4y5NyHphb/Q+X
	olc1KHwaLZjl0Qz4ofID6rl32p2fw6YXVh2sAHcmzIowSypE8TJqY2cqU4g6C9l/d8s8weApEIBD6
	lgd+IQ/gqJFABTC7PnIBqSewBAxbbIL0vqB3hlBgcSD+1OYpXajE0O2x1NLOW/tpCmhfjsF/2YSn2
	0XElsjAlk3jrRnOgQyjC4S9TN9j1NV7tsLNlRsIgfgNqMCRU9Z8zXzIz0ISQ4o+pthJG0VRxjEkJQ
	TJspMB9f6KLFuQSzpcjJ42DRJlYjQFMLjRsOrBX48ASDQJ/p1G2TbRwgVpwnX68Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZw-00000005Bml-0iku;
	Mon, 05 Oct 2026 12:05:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 14/18] wifi: rtlwifi: use freq_reg_info() under RCU
Date: Mon,  5 Oct 2026 12:03:41 +0200
Message-ID: <20261005120526.e441bd68ac9f.I556a1b30d7d7fee64edeeefa26996d62be14cfca@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This will soon be required, because there won't be the
RTNL to protect everything. Use RCU for freq_reg_info().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index fd967006b3e1..503625b50fc3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -150,6 +150,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				guard(rcu)();
+
 				reg_rule = freq_reg_info(wiphy,
 							 ch->center_freq);
 				if (IS_ERR(reg_rule))
@@ -212,6 +214,8 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 *custom regulatory domain.
 	 */
 
+	guard(rcu)();
+
 	ch = &sband->channels[11];	/* CH 12 */
 	reg_rule = freq_reg_info(wiphy, ch->center_freq);
 	if (!IS_ERR(reg_rule)) {
-- 
2.55.0


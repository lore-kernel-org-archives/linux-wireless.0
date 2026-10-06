Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6F93DCDB0
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281240; cv=none; b=MhQNf/BOMQw4wnIVZvfwNZ/YlDzo486T7FERnSTs/4//bYY5FE5DJmRLmLwQ+6cUbjI9h7iCHFj+NGjHx9XCL24hX8wJSl8E6iwUoqbzd7G4/I0cIpMsE4YfZaNRAUJ9rMIM6mllR2XLjCwhf1lsDBHD9fsuLwfD039vKrJtzRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281240; c=relaxed/simple;
	bh=fhMmqK5pKhUoFBjUNThqN/fhk0h0K2+j1sjsDCZRb1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbxmGsi3HDBxPjAD2zMbG5PP7TMBqYiWjtHfQHukvrUfI4pgay3s4joN1QZRF9VLLsFdXBbQKdGasRJisb7/3BeihCK+cbRxuyKi8NZqvJpTGJUGkZwbvo/OR+FoXFWi6yWpinRu3+HgCNEy6a4CvE7mOseEPEwemPOKsaLrGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FcHIhG5m; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FcHIhG5m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NaSwJvL5ze54FqAOYoqO/zi/nSwWJokytBVL1/ekY/0=;
	t=1791281236; x=1792490836; b=FcHIhG5mJeh+OwBvCq7v5hjOy77/+TeE6GqpuzAHUNptL12
	wHO9Oz2RwfhETKcaPhaVrKMn1LKpwB1W4IjjDdRa+qSc3pIxJtCU24StFCB0X3TirDnM/fnucIDdW
	Y5Fbg5dgHKHB00ptvmt2k9uIRqCmUOiPHXh6MgtZSCmjXzoXE6pCuEindVltG1x1Rn9n/9Ttr96cH
	D0qcFTxeOpDB1EaFPsHVEbnNLKsCwaOWdLLa4038VhukCKqNOJf1vmzg8ry2t8XJBDDsQoMWAK3qH
	xsuBNi6YxggF5V9xzMknx/Q4NnIeNcLgbeXdbUkOZoM0kcR1/NganltxMzA6GdWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24n-00000006XqW-1Cag;
	Tue, 06 Oct 2026 12:07:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 15/19] wifi: rtlwifi: use freq_reg_info() under RCU
Date: Tue,  6 Oct 2026 12:04:13 +0200
Message-ID: <20261006120655.2faed090a837.I556a1b30d7d7fee64edeeefa26996d62be14cfca@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
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


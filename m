Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B334490C1D
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140504; cv=none; b=XJjzL3KWv+7YeLEuvc29yZI2RX3EhwiIlLFpvBLx/0xL2al6loDSIktKQ5a4wtEP12cFs0uP8ptVwKZiOnSRBWL1faBBYvgoPnveg7hdZ7tZKgBccdJzfsjdObrn2ebbkkaeJN0LwMJoUGutlWHtpejIpq3W13zreyV3FVdTE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140504; c=relaxed/simple;
	bh=fhMmqK5pKhUoFBjUNThqN/fhk0h0K2+j1sjsDCZRb1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNwsOfIxguzbR4N+PiWc51r4LfuzOf50PXMnCw7+YjAbxNsmXoZfeOkWDeOPLuSSZT/NURTyows5NkGgDPMixpgFJVmAQXnpJsnJhMzwuOmW2OAR/hptVAjUIIREoiJ+6o2EtBsIcF8b1etIzzd2gO8jMdxbZqwv7lU5i/Lvpu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xxJ5AVbb; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xxJ5AVbb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NaSwJvL5ze54FqAOYoqO/zi/nSwWJokytBVL1/ekY/0=;
	t=1791140499; x=1792350099; b=xxJ5AVbbPqtB5OA+StuuiOgvMDSyhus5p9w4h0jNTYjzjrO
	FAg6scBMefY1DM4HTE6r4z5yaJkHAhmT7H9j7RAVjARwb50U3tFp8mfPnsTlkbQT91wKOozBoCfl0
	o/v491JHa8ql9woYN9TyeDGsuz3vooDtdXzR2RWCGVzo0hdbYErvhl9nhywMRSLoUpv3gB8gl11sr
	FPnz1RlNzOXpU0UV5bR3Miok46TyQgD3ge3d5hqRmb5HlyhmvDnUUNh36X34FpH314OTXmwaERuPG
	LnJ1C1iaxFVwX4IYOpEvogdHQJuBG7vi00uGX5y4HEKSDZawQoBWFl+g/DI92hPw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSp-00000004Jlo-0z3o;
	Sun, 04 Oct 2026 21:01:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 14/18] wifi: rtlwifi: use freq_reg_info() under RCU
Date: Sun,  4 Oct 2026 21:01:28 +0200
Message-ID: <20261004210122.036379a3ae8c.I556a1b30d7d7fee64edeeefa26996d62be14cfca@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
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


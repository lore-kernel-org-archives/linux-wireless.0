Received: from sender-of-o58.zoho.eu (sender-of-o58.zoho.eu [136.143.169.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C87937DE99;
	Fri,  7 Aug 2026 11:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786103582; cv=pass; b=JBSXSJ0kuiciL9XrG4kIbgEGJx5iLQ1cQcbXAK+DDZsbxgie9dSBbP+/1zyKYvGbzK/pduXNKmEVqvGZCobTcuKMDuQ7LVfsk71AUIJTWQvhELZ811UGdeh8mEnJc/qumRpLnZi3XBQ27ew87UT4iE2OhzmWkT5ZFeP00FGlLcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786103582; c=relaxed/simple;
	bh=ZiO4oQuYjubGClhyudjZz1i/d+fNPHT5q0R4OrUg4nc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+OpBBSrAkhm1t0x6xaoHvGR59dN/dZbhiHZlu5klxgk7KCaAa0DMoFgj2klhFdLBK9mCCQRLBmMuM1h4Ecf2hldpLEd2TfNL/YiOzf2tRZIAWe6qpFxkkdyMQ02OAD0SufU0i/wqN5hUDiDOu9HfVJhZdwCISEBdB79xo2slmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=K5FzlWIR; arc=pass smtp.client-ip=136.143.169.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="K5FzlWIR"
ARC-Seal: i=1; a=rsa-sha256; t=1786103565; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Y4zlc5f0kxRW2kpN35sGTnZEGPaRB015sPgY7SosLXT7ZkOYrZOuKyh84CDM4Rk9MxTmVbrNqoFk4wucLShwFbSlCJla5gLd3fJkmhZYUMPkvcbyZhgb3Bo5RVE5+2LF0RJmx1Whuee2fUSD3WSVdphkfs/aS3W1w/W6wJAexjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786103565; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=o8H3NO69JdBjLs2Z5ukxlQG+UUvzduh0eVugBp94kgA=; 
	b=g3ApPLRozRwB5EEQMf8215Ph0GumTO3mbAmpbY7VtVr+2tB3V/HWbJKQjZAcW/xyuL4/epxpyOjzZJHKKDCfcVQzHgL2Fi+v/l31D8O5uMtfbYPJ3v4B+KRyoRPHo+0W4sXME2sir9gSlBo0L/df4xisCJbhpG2ISCW+f235wh8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786103565;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=o8H3NO69JdBjLs2Z5ukxlQG+UUvzduh0eVugBp94kgA=;
	b=K5FzlWIRQ++oYIf1j0Tk30KjgPUvndwxFb77HSZkEVwn1OzIwvqXT1rUTVdXOuly
	53YQmSnbIwKP9UyXmH00/vIResGQ5VzN8lHHBh9jmn74lgtQpmM6ZzaKZC27tgDv6zY
	U23TU0ybVerxEgSB8ecJgiL2f7/iQUc+UEicl4xk=
Received: by mx.zoho.eu with SMTPS id 1786103561267961.2475917661083;
	Fri, 7 Aug 2026 13:52:41 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: wilc1000: fix out-of-bounds read in P2P public action frames
Date: Fri,  7 Aug 2026 11:52:30 +0000
Message-ID: <20260807115230.136767-1-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

wilc_wfi_p2p_rx() and mgmt_tx() start parsing a frame once
ieee80211_is_public_action() returns true. That helper only verifies the
frame is long enough for the action category field, that is
offsetofend(struct ieee80211_mgmt, u.action.category), 25 bytes. Both
functions then read the P2P public action header up to oui_subtype at
offset 30 and pass "size - ie_offset" to cfg80211_find_vendor_ie(), where
ie_offset is offsetof(struct ieee80211_mgmt, u) + sizeof(*d), i.e. 32.

A public action frame of 25 to 31 bytes passes the check but is shorter
than that 32 byte header, so oui_subtype can be read out of bounds, and
because the length is unsigned, "size - ie_offset" underflows to a value
close to 4 GiB. cfg80211_find_vendor_ie() takes an unsigned int length,
so even the size_t subtraction in mgmt_tx() is truncated to the same
value. It then walks far past the buffer searching for a vendor element
until it reaches unmapped memory.

In the receive path the frame arrives over the air and needs no
association, so a nearby unauthenticated device can crash the host while
it is in P2P listen. Reject frames shorter than the P2P public action
header in both paths before dereferencing it.

Fixes: 4fb8b5aa2a11 ("staging: wilc1000: refactor p2p action frames handling API's")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 6654fce4ded8..2737f3b72684 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1058,6 +1058,13 @@ void wilc_wfi_p2p_rx(struct wilc_vif *vif, u8 *buff, u32 size)
 	if (!ieee80211_is_public_action((struct ieee80211_hdr *)buff, size))
 		goto out_rx_mgmt;
 
+	/* ieee80211_is_public_action() only validates up to the category
+	 * byte, so reject frames too short for the P2P public action header
+	 * before dereferencing it or computing size - ie_offset.
+	 */
+	if (size < ie_offset)
+		goto out_rx_mgmt;
+
 	d = (struct wilc_p2p_pub_act_frame *)(&mgmt->u.action);
 	if (d->oui_subtype != GO_NEG_REQ && d->oui_subtype != GO_NEG_RSP &&
 	    d->oui_subtype != P2P_INV_REQ && d->oui_subtype != P2P_INV_RSP)
@@ -1207,6 +1214,13 @@ static int mgmt_tx(struct wiphy *wiphy,
 		goto out_set_timeout;
 	}
 
+	/* ieee80211_is_public_action() only validates up to the category
+	 * byte, so reject frames too short for the P2P public action header
+	 * before dereferencing it or computing len - ie_offset.
+	 */
+	if (len < ie_offset)
+		goto out_set_timeout;
+
 	d = (struct wilc_p2p_pub_act_frame *)(&mgmt->u.action);
 	if (d->oui_type != WLAN_OUI_TYPE_WFA_P2P ||
 	    d->oui_subtype != GO_NEG_CONF) {
-- 
2.55.0


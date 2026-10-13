Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F61E5013AA
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898614; cv=none; b=AjuB1SMMdrUtcMMpUSzHjAIvFxzQRIv0h+6VCtAIb8e4PJpQsG/UIoV9MZ9xR4T1LGHdSrvylVZkpzJ/bQVQyJV1bCKakQ4xPxOrAfE7HuLOux8WO3WJ9tBKO5zZSCF/6IBMadzrdQt3U+Sv6BHNAXW6v1Ciw40h7madoCLgl8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898614; c=relaxed/simple;
	bh=WgDbsMNDWPHPitP2i9xQxsOurKG8F/5UK4L6uWRQ9TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abzG230HIlVpRpoWj3Q8cPJtUSsL3qm36kJn5Z+FvPRalgVpyCKoQ0g/qgR/ODfUHc89Axvj4NHIi5x3WYvwJ0CrrXbvFhHn5lS3z3LE31Zv4sZmU27lpsDYEYD3m4Pi4Gss7JP1RN9uzzMTaYi3h+3J2wFRboaPUjGeKNV2lBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=IrcOfdTg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="IrcOfdTg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1oMgXcb/xvBjQnb2yQxw6PFgUrRSyrxzSlbCKXsEkXo=;
	t=1791898613; x=1793108213; b=IrcOfdTgIH+JbZkNqD930c2ntQb21cjMX7IpL7WYYKfFckk
	5H8pBo6MnNQmcy90QJONVfdw7jlscnqPEfhu7nFpVgV0iPOWlliloWwYsf/iKN9E53WlA+JLU5Abo
	UtTWJyUG+amK8E6aWJlH7mdq+kx5lfpOjYJeIev+d7ybq460yRV28AI2u9pDcbta2mCUaG9CNUwl+
	Mv1znrKk5R1gOB/7ec1Rubv8UzhvYpuRNKyPbPSh8Qd+ttsfsztfsCcIKmFOQ2Imr3LxjnsgaLDoA
	m1WNp37I4wlw3A1zaUAwhaHewk95CNoJ5vZgnmH+s3x2rKKtSnYbnJjonEPY8IFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgU-0000000HRBK-1EaS;
	Tue, 13 Oct 2026 15:36:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 09/10] wifi: ieee80211: fix MAPC element name
Date: Tue, 13 Oct 2026 15:25:21 +0200
Message-ID: <20261013153640.6761a1472057.I1c40fb9f59325b9ad6f8b2b97de740497036b576@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013133640.270974-12-johannes@sipsolutions.net>
References: <20261013133640.270974-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

It's MAPC, not MACP, fix the typo.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 66f9ebe79c61..01ec40599ec7 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1831,7 +1831,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_CIP_CAPA = 150,
 	WLAN_EID_EXT_UHR_OPER = 151,
 	WLAN_EID_EXT_UHR_CAPA = 152,
-	WLAN_EID_EXT_MACP = 153,
+	WLAN_EID_EXT_MAPC = 153,
 	WLAN_EID_EXT_SMD = 154,
 	WLAN_EID_EXT_BSS_SMD_TRANS_PARAMS = 155,
 	WLAN_EID_EXT_CHAN_USAGE = 156,
-- 
2.56.0


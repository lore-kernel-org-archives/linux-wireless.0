Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2CD38C406
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896773; cv=none; b=ZCHGodDH637zUGnHUnqTDS+MR6soXi/MJxLc9mWMk6lVt4viWT20jla1hQu4r6CowfUY+5xwM4XbatwUeSY2xrVLOJiVr+wKwBXPyRew3uFCunJRQOd8M+LbTAqR/3BxUtfx+xjgtJAXYfT+UdGrEQEqcjqmNQb2w52VP4elxNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896773; c=relaxed/simple;
	bh=8y6TkSwF7zNek1JTUogtywdbAJRCqnpe0fNjDB7c9DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oreCUCUGU+78Mwv0MjqWvuYEXLWXsbKqtkqASA657kj2cI0yUP5LU/cFKW6d8QHB5LxMkJp7yPJIPIZGy3FCGDdCeesufuklrM9CqEcGEmtsb0iyKVxWxAFLzqTfReI9pDrz0uWC8mmOZURqWdmj9l4ppC0hXkhUNzDuIPdqDx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KdhP+ZmJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KdhP+ZmJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=buMOho4dHnzjt9+SjazvhJOb/fVdsIGWRExt4/4Xr/Q=;
	t=1791896772; x=1793106372; b=KdhP+ZmJDZNs+zxeLYRU7XvzSdIZBvsUtx9r1OnS/MdCAHx
	y/h55HFkyrpl6dNVOBuFulZJnCuukaBqk2lDAA2VyfxNkVOgODMdjPFK/icZymKmGgeYvuStRcZRG
	Q8tGyFkEq7cLiqzAAxdpTPS+k9bfQ/YEi8xRm3d3p2HNrEjtDFwRhdlZWjSMA+56OTOk7p2jXZ6YI
	OaaO/U/zA4BF9YTJlmRRIWqxLcLP/ocsNHbjLbQzCJpfth2h/NhvIjE1RPdIpH5Rm93kEwXzmv0Yq
	HausWtciDL1dnza4p0dGZj4PLw5X/WeEhqYxq0OtFfaF7v4uU6vSwwQlsXh4fx9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCn-0000000HPRi-135J;
	Tue, 13 Oct 2026 15:06:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/11] wifi: cfg80211: reject WEP/TKIP with multi-link
Date: Tue, 13 Oct 2026 14:59:03 +0200
Message-ID: <20261013150604.d37bf448de30.Ib47bf264ac9d2502312158503d1ca8aae99496c0@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is not possible by spec, so check and reject it in
order to avoid being able to hit such code paths in the
code later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9d5456defc90..59912f4a93c8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -426,6 +426,17 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		break;
 	}
 
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
+		if (wdev->valid_links)
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+
 	/*
 	 * Per Wi-Fi Aware v4.0 section 7.1.2, NAN Data interfaces
 	 * shall only use CCMP-128 or GCMP-256.
-- 
2.56.0


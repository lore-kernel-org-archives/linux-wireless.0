Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8DB223323
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571117; cv=none; b=d7A6ywyjcokewA+vR5IRHKF8bU2LjukQ5o6Om4bD8pGKE+98tq3qamsk6wbHNTCdNAGBffrvbYuXP1PNJeLThtKVMB3SdUOlKGdxxkF/AOBDCfVdOmFJYzZhuZiqFfSHjLNgmMO8ENsz/cPSAQF+UlBRtYsHxQJKmMdxArQfycQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571117; c=relaxed/simple;
	bh=Q8J9WkfTLJ9pVvsOk5CyIZigJfjd4r1thqXCwrtS8LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzEINH/o9xhx677N/zrml8YHXUjmP20dcGU6/jHs7DfaEWAJNf5LAuq8JPZ3jrJiptoE2b6Qz0Igg9YM2frXxtMD+9DGSLbYOI8OwoVWkiu4bKXjk9K823Ctbr+g+PHhUN/Rb8ey5zNXmose4HLhHONUa1b0FakPxXvb4Agv0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v/BcIijp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v/BcIijp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=q/dCKkRD6g4NO0ILg/4ofw/LUNDg2rPG4FK5Iqmlelw=;
	t=1785571115; x=1786780715; b=v/BcIijpEAD9AoKzDXe/PHTJOesk8EwcZxFGhegrF223iST
	Qpf1p1r2Fx/yO4V1FsvNjap/lHPrpfbF3WJf6i8y8qsJflvwQ9sQP7ycr6uYkFseELqOqUThrQG43
	nSNQbv6wxo6hFZb4RZU0TIDUYMHj0iH3RSh3l5+Cy+h+Oimek6bO0f5iss0ZCGczRulWPtyFAWbA3
	RhASKFt0HrARfn/yIu9C96eLYznKM9GSOAb0LCRL4L+mGExZ+2wUKYERWukmFKR9NJRSIVliPgCuZ
	64Kl+xAXhqQuH0vVODt4lkdfUuBmeiAt0mtmFoTIm6SJozaSr4Kd/eUnH1jgJS+g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c4-0000000ErOv-100Z;
	Sat, 01 Aug 2026 09:58:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 08/12] wifi: cfg80211: reject WEP/TKIP with multi-link
Date: Sat,  1 Aug 2026 09:58:24 +0200
Message-ID: <20260801095822.aab89c29717a.Ib47bf264ac9d2502312158503d1ca8aae99496c0@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
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
index 41f83577f9e7..f075e96c994d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -469,6 +469,17 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
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
2.55.0


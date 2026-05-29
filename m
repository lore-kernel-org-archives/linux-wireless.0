Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377933A0E8B
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 08:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043221; cv=none; b=DPtEba9JsmbuknaTy1fwVSoG1y6T1zWhwivzQl9Ip6I+pBWYcqww//HgMRg4yzgNuj+ry1W6qfrJlKEnA4N9GTTniKET/arnIHKhQsfi6fbYOFe+aUi14mE2P8ymUI3hetzjvmcx0plNTH8QIHg94CF2tfVUTzYcY9HeZvQIZlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043221; c=relaxed/simple;
	bh=z8zekIrVRvrE2XRygUW3jTyYmix31u8upC4wkT3eEUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZGw74BgP4lSbMLxJIsZ0uCVPnyIImp1LjZji5Md+aLB72cXYhNBO3eIcx+mll0oygrtwtW8D2v5X5Ze9tyFGiJQKqKc9N3b0g0mqCPqsdpHpfsSqSyIxd2uj3ljGq2+iRRjDmfDti+wi8tPnd3qWSd4RGwAuomwq9iWZHi8Rds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TS4YjgBv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TS4YjgBv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9tduRuL9ZDCdKFgAarIEqcY/lTRZpJKCv/nDOB6FH5E=;
	t=1780043220; x=1781252820; b=TS4YjgBveCZYLyhBU4nODDm0PsKE1Rysk2CqBplp8c3FBUW
	0R87NPJOieJo+/FqrWo7KiblaWFl2JGiLSrqKpMQF0z9P6XZ2/P3iiX+ZAyCLVuVoRN0zssV37Pk8
	Bs6yjBRuZKvVeMpRcr0SSFwbiNKxGdMR+Iqy/QH2iDoY1BFpv7fYNnxyxU27JoGg4T0poAym1Nf8l
	MenHMq/myCmUDmuVlzup9K8UDqpl20lWndTmDYj25WWAaOPOxsu+8HUvSOMvGOtrkh07PWQCtQTR7
	3U4yUkNDGsT2YVryJzhZhjOaPIobfekPc8osYslBcaBMmztazomH+sKkEsrmqocQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSsYT-00000009bVp-2lj4;
	Fri, 29 May 2026 10:26:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 12/16] wifi: Update UHR MAC capabilities to D1.4
Date: Fri, 29 May 2026 10:25:05 +0200
Message-ID: <20260529102644.6e27c54cfceb.Id395c07ffde286011494fc75190dc6060117436e@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529082644.106145-18-johannes@sipsolutions.net>
References: <20260529082644.106145-18-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

There are now 8 more reserved bits in D1.4, update the code
accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 120993897490..0c1715280fe7 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -398,7 +398,7 @@ enum ieee80211_uhr_dbe_max_supported_bw {
 };
 
 struct ieee80211_uhr_cap_mac {
-	u8 mac_cap[5];
+	u8 mac_cap[6];
 } __packed;
 
 #define IEEE80211_UHR_PHY_CAP_MAX_NSS_RX_SND_NDP_LE80	0x00000001
-- 
2.53.0


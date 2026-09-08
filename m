Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E993E4C69
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870533; cv=none; b=ABriui7XZ3D8+gm8ixvNSV1NrWmlPoh54wsgmNjTBLp93f7X+9FPANR1FYnRjaV7Y4/7sQDtNXaYJQGCXrTsCqqfnMLmRKplZuVuLWUoV9yM8LSlD0A+aqYuhZmJrCcqPK/JQKIsFvHQRl423LtPdOM7nBuGjUe7lR//RQmVcd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870533; c=relaxed/simple;
	bh=mAXj8I+sgSlx4IziHxu9Z68/gSZ5citL691YEAg9gUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhKO/mdMd89fHenVzQFlh0Trm5QQwk66pjvJha4ag+3eJskNvLQ5XnfQH8q6CFoUzpLXTa3QsZ50GyYQn6CMI7GyKbKb22tggDrh+cHpV7EqyOk3Zv7OXIZVtnTyHv9gMLITWSKfD6B9zhomkvLRHDLBKAKCnZ7Mf6qNMObIswQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qUgeoMe7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qUgeoMe7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=0BIhff+s1/XOnxKCCICrnt8+wotgOb3oy+AAtzCkg9o=;
	t=1788870532; x=1790080132; b=qUgeoMe7XOGSzdzlDbfBCCUz6s+xbtaErcaNPHYfnOeUIh5
	tLOml2VqJ0cuFgsJsuux2joPZUJq2vO6ECen0NVUXAt40NKYqMqJ9tI598djOdbx8Lobi5kYo/GKI
	BOJ5CIMGGRHxOq0PDQ/C47vwdOa1ymhIgHVXaOnbpI1W30LfRYluuAQqAT6GoSQ/VP+pNjVBdXL2K
	RPoUjfTyrc1jgObeiO5CtlckGC7yRIXl6MxHFWXWHRWBhJn3wRez6XAInb+OdDjm8Ci5Yhw6/1kLp
	p9QR4aaT5PFX30V13PVG2HJkex2dyDFbGEvgz86BD/lUOP1M5so2VAOz4ly9I2Xg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwT-0000000670J-2ZED;
	Tue, 08 Sep 2026 14:28:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 07/10] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Tue,  8 Sep 2026 14:28:18 +0200
Message-ID: <20260908122838.201719-19-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The HE 6 GHz Band Capability element is in the probe request for
every band if 6 GHz is supported, so add the size to scan_ies_len.

Otherwise, building probe request elements can fail, triggering the
WARN_ON in __ieee80211_start_scan().

Assisted-by: LLM
Fixes: 2ad2274c58ee ("mac80211: Add HE 6GHz capabilities element to probe request")
Reported-by: syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f961b9f94edbc266f1f8
Link: https://patch.msgid.link/20260904170057.c08c4965ccd2.I5ccc4ffcbccce7e33f038bffa27bb5d215e982ee@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..6408e8464338 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1453,6 +1453,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			sizeof(struct ieee80211_he_mcs_nss_supp) +
 			IEEE80211_HE_PPE_THRES_MAX_LEN;
 
+		if (local->hw.wiphy->bands[NL80211_BAND_6GHZ])
+			local->scan_ies_len +=
+				3 + sizeof(struct ieee80211_he_6ghz_capa);
+
 		if (supp_eht)
 			local->scan_ies_len +=
 				3 + sizeof(struct ieee80211_eht_cap_elem) +
-- 
2.55.0


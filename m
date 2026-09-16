Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C321B4AF148
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552969; cv=none; b=ts1478/jo8uN3YNJmiLAuqFM+8usBtiaFovZZtpR1tbkmNYY6GItf1RnwcNBog2MZdrbaipXMmT73RffRdHrmiKwQXAXIqyYUew3Wir7KlY0RIX0FnrncAtjylueKXO5+vbi6M95lIkn5pUVdNJSpO9NI45ewnJV4gzaYy6dtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552969; c=relaxed/simple;
	bh=3w6Qot6pAJcZe/C7/hIv60H0Qb97DhtqZwL9MUZn9Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hw9X3dAzAALCWCa1PVQh5ndDVDzaJmlje2YqXDcl41+Yjfc8+bUV/SjPWkNOcvWfTLJh7558iwFi9u7tSYo+zH1sm9kXc3iniKaSmzqlWIyWCC6NcvlKK75RGdT3wcdk5FpHfkXGzQEQvztJ/u/CxDohAuKpPSF0/BW9zmmzug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=otNXSoNJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="otNXSoNJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Ectv11QsDquZyfdRgNfPtcpO6/9qQ/cN93ZUqo8X8Ao=; t=1789552963; x=1790762563; 
	b=otNXSoNJSZ0RzXjmue7g0s6j70I3umDo7g89i6af4YQleStugQlCgB9lFKeYlAJ54Nj+OKrrDQ6
	bE+RRCVDyOokMjrSUyc/M/RXWvTO2Xje/9FMaXpNZoYqQbfC72fULIKHQ/u/9qrV64WQJfmlZisRJ
	NyrdGDjqD3fqyLt2GlFXB35IdKLXxscaiqt/ZfeVYNR842Cu8NsE+rBWBLs1sNxSyoHIcIgjxeMuN
	W0GPqT6UKbOPcFbmttXvzVdg1j+1NPnX2aa6W2jvm2/lhTfrxsY4qAbdwFVDse5KF4GlpNfkyTU+r
	pBMo2v1HPYExoRyMgzOZm+BDgPeYSqMAahdg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mTL-00000000bXG-3OMn;
	Wed, 16 Sep 2026 12:02:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: ieee80211: fix FTM bufferable check
Date: Wed, 16 Sep 2026 12:02:32 +0200
Message-ID: <20260916120232.d3c05305173e.I3855653e49311b0752b9fcdf9d5c6373408a14da@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The FTM action frames don't have a protected dual, in
fact their numbers are assigned otherwise. Remove the
wrong check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 26e674038865..7fbc51f873ff 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2421,8 +2421,7 @@ static inline bool ieee80211_is_bufferable_mmpdu(struct sk_buff *skb)
 
 	/* action frame - additionally check for non-bufferable FTM */
 
-	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC &&
-	    mgmt->u.action.category != WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION)
+	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
 		return true;
 
 	if (mgmt->u.action.action_code == WLAN_PUB_ACTION_FTM_REQUEST ||
-- 
2.55.0


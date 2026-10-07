Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC844F57E
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389848; cv=none; b=OleVHJUqk312f9AuDEFpcmspX4nNxxhInrvErxg4tc77HQL0hU9OpC9LOvbSkJNUl5Xj85XJuRT65Z4fhOznnm8AMfC0MwqJYWnY9g1kQx/gX9LAQgJYV2qrkFQK1eZtDtEurimAWz9hs2MtSHdoX1/5JEnBsUjXtshvufe5xLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389848; c=relaxed/simple;
	bh=a89fgaBK7g9X0Q9p3i7HU0eZuNNDuBA7NFi5fgWdtzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biGMlidwxM15tT9IkCI5JZtdd+1BVi+rIJkwEl2QT/mhJNsRwgMQ+jg/lzsQWK/M4uomhb0b+bAilC7ORKJYSXiBXCTe5lniLSMDyMw5C8Wx2aJXi1RbshOTLzuNJMWqU46bqF2rlpBXVF4aGRGTRi7tj8Nw53Rwv3+l5rPIv5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MnewXcSr; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnewXcSr"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a168355946so18947015e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791389845; x=1791994645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m8p7v3GmFSxW6TAqCAy75L7noVc64c91U1hmvayd/Cc=;
        b=MnewXcSrkmX/H8djIkSszfqYGhZkwfV8o25HAavqwjEV6cunuqj0e2FgnEPDVNcHoQ
         rmQ4Dfzs0Jy42cvMmqHwTLgaQRZBYxvv/TfkbdegO3k41ml2FbQhxhh+kDDOVtuHCur3
         FXS962Z870PeiAjjfXHOyB96rz2CNBCmo24XCXd6D0cGk/f91vj9IbJmz90cVs+JB5cR
         +q5gXtXRQTDN/Jmf9a+aOJtBE2PxB6p6yMdxOJ+/l7V+77FwfETDJ1wSlP9llEjP/N1Y
         QOdtOBmODz1Icm6FTiOtezvEsICqqEnshXi9NsDExc+QYBC6WI/yX4f7KkgubRoTFnBG
         K93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791389845; x=1791994645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m8p7v3GmFSxW6TAqCAy75L7noVc64c91U1hmvayd/Cc=;
        b=lNRU8EA5QWcYd1yYYsMaC673VnnTW6KxXzF9z/9WgMdIwjc5F54Svbf6moEXVBth8o
         Nz04Kv9qdhdXDi6Vw1wwZhbp8f9LgpSwsKFi3elmMCNbKhi2Ar6dq0hkFYmpAgtn/snG
         wewP5+k9FKWVubMEbYaGLXgqHfmiiXOVvaQ6y8PwBUesh8igdGDZ5HGqHUa4ufn3CiY6
         QO8fPf0jkPm9OOz60Cxf6iy9gnXQjSddEbcMZf4i//z1D2ZidZr61yMKVpE/iBAB90Fe
         0Vf+lQD28lvXRsC1njnsX6ntZi/1VtiaGF9VGeK1+2lZ72tTrXoTx5nTIIjtXb57S7Qk
         pSDQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1p9l2lCO9OKHGHtrdEaqcOur5aEJPauZDCIb+T40U2HjcCD9092ogC2jYB85BxdVXDvhT7XpUb7wwftcU2A==@vger.kernel.org
X-Gm-Message-State: AFuF++mCPWmAwCSvvpZWD56Eag7JSy4zDdfTpK70seQquRf3iwtVuUUG
	kYeTbPJ7kiaPAQeJ0hLOsGPInLX+7yFiruAcR5nJx4LVZpnnn5vJN+SnKqws
X-Gm-Gg: AYBFou3p7j/a52oW0Go132laTV1ybSwuokpL+xmEPTNJWQdQEgsvpbfotw+GmkoLji2
	CwbKDbK2tynkMNR/u5Xyk3F3QtqP7+XtuvWMDSvxqitJJV1LHlKSiDxNWnnHHa03vthXBRbgJIh
	LizoNijqmV1MypjDvQL7kw5k+I44EUpg29VSYsJzkj4vuXAX/9Cj3UIN6u6e+tdsRjiLqTa1ObC
	Yh0y2bTo5pH/NOXPZhhphEejNVLjLsgsZ0ybOCzdeTIgU6A4vLRy8RoCoVhXYrdOVkpFhIqisoz
	2YjA7CM85ir6iNhYvFyE9u7bDl/OwWVmvA8QaDkrUVzv+6J4SHtJeRKwxXb7xk875HRE43W040i
	nF1ju8W4GRPGsYCofv2xfZWZj3buNolz1//sxGAc0MRd8smfp+WIyFYTXi90B1f4EvyfgJSABkI
	PL/bbE6xyZItHoRM/3sZAWV3MrXTArYg23GCxla2I=
X-Received: by 2002:a05:600c:8b6e:b0:4a1:78da:d271 with SMTP id 5b1f17b1804b1-4a18064be59mr47434215e9.30.1791389845063;
        Wed, 07 Oct 2026 09:17:25 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843aac98sm2685295e9.9.2026.10.07.09.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:17:24 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Po-Hao Huang <phhuang@realtek.com>,
	Chin-Yen Lee <timlee@realtek.com>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless v2 2/2] wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM
Date: Wed,  7 Oct 2026 16:17:21 +0000
Message-ID: <20261007161721.261452-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007161721.261452-1-tristmd@gmail.com>
References: <20261007161721.261452-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

__rtw89_wow_parse_akm() computes a pointer to the IE area from an
association request frame:

    ies = mgmt->u.assoc_req.variable;

but then passes skb->len as the IE data length to cfg80211_find_ie().
Since skb->len covers the entire frame including the 28-byte management
header and fixed fields, cfg80211_find_ie() may read past the end of the
actual IE data.

Fix by computing the correct IE data length as skb->len minus the
header offset, and validating the minimum frame length before parsing.

Fixes: 480dd4dddfc5 ("wifi: rtw89: enter power save mode aggressively")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 2dfa24c54e7d7..178c59692b13f 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -16,10 +16,14 @@ void __rtw89_wow_parse_akm(struct rtw89_dev *rtwdev, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
+	size_t hdr_len = offsetof(struct ieee80211_mgmt, u.assoc_req.variable);
 	const u8 *rsn, *ies = mgmt->u.assoc_req.variable;
 	struct rtw89_rsn_ie *rsn_ie;
 
-	rsn = cfg80211_find_ie(WLAN_EID_RSN, ies, skb->len);
+	if (skb->len < hdr_len)
+		return;
+
+	rsn = cfg80211_find_ie(WLAN_EID_RSN, ies, skb->len - hdr_len);
 	if (!rsn)
 		return;
 
-- 
2.47.3


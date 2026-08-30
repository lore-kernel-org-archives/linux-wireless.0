Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFAF3B4EBD
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788100320; cv=none; b=e0Q42CDAMiGjqv90+nMui+calEWiZyIYPz/tFHM6Grgg+LQx4CC+LGFTHwm+BhYxBvRpuDJS6YbRGSRL/vmdqbSBWDugYqsKh31/JHyRCDYiZTO9G5FCxJ9ESFPqL7PaaPAVoy4IjsyXsHJ2nvF2pqNmDqtbrupcqB5kUl1mGok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788100320; c=relaxed/simple;
	bh=iBtDbzrrA3Qi8QxtdfsPvuAnJBG8zTYXvzy5zSQWvOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjkczpILhUP7p3YoRKfSc3iWZptB+tgdfNVH+v16Kf8k4OCPY6+Gwo7M2b6a0eLugqBNYA6z5+0/mCCju0GGkQjfhBKKY4xv0RTr8ShmXAbLEqKgXL65VfO4Ak9Vi1VvX+oYlmmdHmLhfd95j4nuhYXVWO55ndfbHd/ip0Z61sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTyFbtz7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTyFbtz7"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso19210355e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 07:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788100316; x=1788705116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KUdIs7pWN4w8RxbVLOKOg8qp85Eaa3COSA27rxG/j3g=;
        b=bTyFbtz7wlhFI/uzIj32F0+37cH4qLVqSnP10Njswz/4Fy3LXjopcSo8rgZirKNQ8m
         dzpv8IhE9NU18y29wCjDFXuwOFwZX39WCwdfSK5CP8yOrWkP7u2g74LeUPKg3ufna5Uu
         gpdSEpBDJI+7UsoaEoV9AkOWa+xlb3gN+4EQ5EPw7hmb9iqnqTr7QioGSXJkj5R6npEC
         w7wR5UMaK5TqHqep4iA5MjKb7RspcBrMiWbKmdaMv7bJTOQwShrZDr6uWgsfqqbFY5wc
         L3RgH6Sce6EC1/UlNlgOjxGSUcwtm5yYlca8eM+SkghpRAB78ZC3dHrlpiAOVGsE75jS
         obwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788100316; x=1788705116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KUdIs7pWN4w8RxbVLOKOg8qp85Eaa3COSA27rxG/j3g=;
        b=Wntb0e16EOpH6dxKCNUnP/x36aX2emYmwm09F8v+F1M9swBFpQQQVu0KuR+PoYfB2z
         I2JGkNKVgn7NdxVgy4OQKKOSZHRR4dExVAHHMnWW8+/UPQZ0rRXhuTyfVnCNlIM8DNBr
         dngj9FBCDx6IHozn5bm3Gj6nrW33W3PC4Dkr6JmESKG3hpqMZKG+YHZEFcxvJXLmyolO
         /Zq+GYn0JHXTTyZJJpwohZihi7+zKhSgYiZqaF9nrRFj9fMPMiYlaTYuk3yhmr7JIToF
         ZmtdUUBPPrMPXNaAnsCIzF13R0nkqn1dvce63BAK46Cotofrw/qcc6tZAzdkVR/P6FHK
         IOiQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1/zXA9+NxH39w7u9mYxdwOxtlTP8ZRjjjvh5Jst3atMLcCSqhy8u0UoykWjhpjbvn1xnPOBBHYxscjRBCgA==@vger.kernel.org
X-Gm-Message-State: AFuF++nYXkCq60UySxR04+b8raAZ0Rq/SbTznBo+xFQJbzkVHEiv/9zV
	OeClQkveaSNsB0Sh4CG8wIwnLmEWhai3OsZYyTqquBSUYMKwqLcg/io=
X-Gm-Gg: AR+sD10zmD70LX6oOh+vdDix/CLS4d3MPuYe8lnPyPYFGnCe2GJNfHNMj9P+G33kXen
	YL1G81TSLUUTFRzUVnatbM1yD2XcM40GdG8JtKfYb4LAxNaissxj1aE2+rD0aQdQqZrDki5DuWP
	QYIn1pfT68e2gq7Q0167B8puRSl727scZjL3jUGaI2CV4lT0Tp0sXtlKpQh0ahgYH+vgWjoCz8r
	NjffM2Ekgce++n3C0WgsmTMxF0rm2tmhpTcjySoIKalY02y0p31tQ7BUR9tPOfSaI7UDdt/KMWw
	q352K1zcMeVJW8lcF4rR/Cw7uzQhWSocXYXLQAuCVA3ZUAQxAAsepXW2koGSpdVPa1oZOWEQh6j
	CYWw57fVaUNQJJiqOi/frbvz3upG+gicHxjhY7Z3ATSB71BQgeVSM2JqWE8bnNRz1WtujfkqYJj
	F78txTU1Ox3g2rn9HQPLIgkNCSaD3BVQ==
X-Received: by 2002:a05:600c:1f82:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-49b91c19d37mr304483175e9.2.1788100316464;
        Sun, 30 Aug 2026 07:31:56 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccae954f9sm146319065e9.13.2026.08.30.07.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 07:31:55 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@kernel.org>,
	Po-Hao Huang <phhuang@realtek.com>,
	Chin-Yen Lee <timlee@realtek.com>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 2/2] wifi: rtw89: fix OOB read in __rtw89_wow_parse_akm()
Date: Sun, 30 Aug 2026 14:31:53 +0000
Message-ID: <20260830143154.1751910-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830143154.1751910-1-tristmd@gmail.com>
References: <20260830143154.1751910-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

__rtw89_wow_parse_akm() computes a pointer to the IE area with

    ies = mgmt->u.assoc_req.variable;

and then passes skb->len as the IE data length to cfg80211_find_ie():

    rsn = cfg80211_find_ie(WLAN_EID_RSN, ies, skb->len);

skb->len is the total frame length, not the length of the IE portion.
The IEs in an association request start at offset 28 (24-byte header +
4-byte fixed fields), so the correct IE length is skb->len minus that
offset.  Passing the full frame length causes cfg80211_find_ie() to walk
up to 28 bytes past the end of the skb data buffer, triggering a
slab-out-of-bounds read.

Fix by validating the minimum frame length and passing the correct IE
data length to cfg80211_find_ie().

Fixes: 480dd4dddfc5 ("wifi: rtw89: enter power save mode aggressively")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 8dadd8df4fc65..82b74ded68631 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -16,10 +16,16 @@ void __rtw89_wow_parse_akm(struct rtw89_dev *rtwdev, struct sk_buff *skb)
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
+	rsn = cfg80211_find_ie(WLAN_EID_RSN, ies,
+			       skb->len - hdr_len);
+
 	if (!rsn)
 		return;
 
-- 
2.47.3


Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A0C446822
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514039; cv=none; b=qgXVwPafuTfPcl+erv41TwDDcLrwz4EHm6hzGfMgrlC2lDKqxCHy19w2OZHo2zYNadJ9RQgNkgS3wkA+oOeaKdMVkxrl9ZS/EvP86NWyhnSnW2u8kGxZv3dhldoGRpafpcl8/z1eKURIXZdZd8v8Yo4ybU6Nh2h6o6oqGyKJx2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514039; c=relaxed/simple;
	bh=DmsA+3I5O345ejfdJMX1ludXGRJbR24/40vzzaBvEHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWqb32o0lOs0iUbRa8wwSUe97XP9xogsPVXLrhjI8QfTKfeilAbwm4xKobOlXgtXBj54OlGds2Bn3vKS3Rmb2MSMUFx7CUJTff6v/8IrdT6pBBOQL5lWfuUvZYY1PyuHt7oOXoIDSbK8xsE09GpdIwGDu5UKdHmZdRF61rSEyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQm0uBGj; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQm0uBGj"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cf49dc28ccso1503365ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514036; x=1786118836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ha6wWqh8e5w28XKTvBv40AUTfoBMdtclGObPHlJlp0Y=;
        b=TQm0uBGjkzoIJ4u/c3kQhaHzOl4KyGxbxI2/VgOO5innIdJkWL/NRbGaLNjxOR+gwW
         iL6qXprxYJzsVNv3UNEHHI6ZHb28CC9K4QYytSVEok8mkeRC5kVsQZ4YUxk3p+6bz8si
         2QAQII+P1iWD4Xf6b1RFwDVwk2ye/MmLIkNo7MxFcnER+r5BtJBv+BS+uATGlr4Yvy+l
         BqD5izNqwXMQoi3P584MlihjK+UTypuyEq6V/zTlIQk+/tbsscxscQdm33acMEzZNz4e
         ezgk/YamTVK4bOMt/o0iMIXi+fBQwt8JPjsu4Amssrk6EtBzHyyOR5SLRGiiPZWDvf2p
         X65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514036; x=1786118836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ha6wWqh8e5w28XKTvBv40AUTfoBMdtclGObPHlJlp0Y=;
        b=d+fL4y3vjFs4hruYFtJTS8sXmUbC8qAaKEQXdO1lCAdoz0hQMQSx5PEKe4igYsMNk3
         3NQ7uTEtbhjIg+K29HZqwY+1NYlD3D/bjDg4DmU4UqggUCYWKyG468hsVwjm8X7Kyv47
         MF9xxzLITFOPy2a0SUKm+SeYOo4iZgrKgSItG8CChjS1JdVS+uLHHgTd++5mJ/xwbq16
         cwwlATvLWP4CbZuFrmhdT9xJG4krI1rVn5cA44sHOHn7ysfsrYY7RCSN0EDXDV2ikduX
         EK+0Y09kODWzUKsCYvUUa+gdRMZvwd9SDCa81YDKTSijc277j/rMt+yn1TofDP2o9Zwt
         KS4Q==
X-Gm-Message-State: AOJu0YzWxYNeTeSVXEQZZmAlZXr9T8D59JuKt9Ju1kLiTvPm+mR3fuOi
	DlHZq3ttiQqqoPa6cJZKmRYpSdD4pLNVuh4FWdqYQH8LQihP1+6OqO9L
X-Gm-Gg: AR+sD13r4832cX0xWHgj50EH1gSBL2gGH51JNJuMmFBjcO4fj+vga4obM3d/4PCisaR
	7jb59ClyiwUwkIcmyOCPTmdWsbm1aAvfrvyOzobVakc7v42zScwWNIgfUK47MuFwsAJnT9ttgys
	EOU1bqtf8inuy8Ro4NNG3DRGnU2YpOjD4V/Rc6cj3oSQR+pOoGMsBPax0JDFHpBl60jXkT2Q1R3
	g26eIeJyvgNiDdyHSFVLGmsSKGtmcDWtG7709xWYa1tAZRprBlroaIVOUS96C8hnCHkdITGyOwU
	OY2UnUkT7nu7dklgjVQEc1L0S1WC+DaDs0MyXvPSpSQId2ZaneXfqWZIBWDdH8cIPMH3t2EV/Ir
	pDespXTO4SCJnY6+CBTr+FQIzoYNMvRzdZ1Xpiqg8BMBLD0sSMfL5Q4TBZQxJYKz7PNFoc2EHkX
	1iZcrNCjEdvv03iTyGrAgfEx0MyMEsuOHevo+pAdy+GieoAsF4ogj1KfKYF691NBZ44pfnVY4Sx
	lHeNO+QiQ==
X-Received: by 2002:a17:903:1450:b0:2c9:d298:6c0a with SMTP id d9443c01a7336-2d05246fbb8mr8606555ad.2.1785514036370;
        Fri, 31 Jul 2026 09:07:16 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:07:15 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 8/8] wifi: brcmsmac: ampdu: document IEEE 802.11n TID requirement
Date: Fri, 31 Jul 2026 16:06:25 +0000
Message-ID: <20260731160646.3812-9-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An XXX comment in brcmsmac_ampdu_tx_add() questioned whether it is
necessary to reject frames whose QoS priority differs from the current
A-MPDU session. IEEE 802.11n (IEEE Std 802.11-2012, section 9.10.1)
requires that all MPDUs within an A-MPDU carry the same TID; mixing
TIDs would violate the Block ACK agreement and cause receiver-side
reassembly failures.

The existing behaviour of returning -ENOSPC to close the current
aggregate and start a new one is therefore required by the standard.
Replace the questioning XXX with a comment referencing the standard.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   |  1 -
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 +++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2375c2f9d97a..dc4228fb31c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4464,7 +4464,6 @@ brcmf_pmksa_v2_op(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", list, sizeof(*list));
 }
 
-
 static __used s32
 brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index fc7a5dd2e5d8..3fd8bdbd35e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -516,12 +516,11 @@ int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
 			return -ENOSPC;
 
 		/*
-		 * We aren't really out of space if the new frame is of
-		 * a different priority, but we want the same behaviour
-		 * so return -ENOSPC anyway.
-		 *
-		 * XXX: The old AMPDU code did this, but is it really
-		 * necessary?
+		 * IEEE 802.11n standard requires that all MPDUs within an
+		 * A-MPDU belong to the same TID (Traffic Identifier).
+		 * Since priority maps to TID, a different priority means
+		 * we must close the current aggregate and start a new one,
+		 * so we return -ENOSPC here.
 		 */
 		first = skb_peek(&session->skb_list);
 		if (p->priority != first->priority)
-- 
2.53.0


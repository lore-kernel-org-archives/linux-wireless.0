Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197356;
	b=jr3bCWKQrRAqN6uVVFvf9IT8XkISg7dwgWD2fkKmgRyhxYvd7UCsj+GF4li6zHkRKN01
	 BziyWc8d8Qc9vJC7lxslMoEn6bELqTvwdOhBdlqqnYzTdM0X2h/u16eiA8BCPtwiS3aPp
	 WUVGlpQcCqutC01hjyYXdW1Zxca4PpJr/XY5tgP2Y0bSkvTONTvC4huMs/Cdo8Hnp2B6I
	 ipORkZxg9PPiV1ly6cVnEpFdYCvO9eSnDy6B/gYkbXC3ai3YICqRdHx0JXSvBFC/kVU1O
	 wlFG1wVgAh+2FT/q/jvCQ2ngmNaTuSNSIgYo7OCY81vMcT91qlTX1Ka0k1YiOV03qxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R/mNeciGEDV4oliH8vu2vu4EuuS7Y9Kms2mXuzaoLDE=;
	b=yyDWHqKKMGKXg9oSztfCjO8Yd1zHHpY+oYj2jy5l1iPanjCR18a+5+Cs6evAEnBcbgyN
	 a51peVBeQSmiua4Gm12rXgZqnSyMFenNaBQ6hDzGz1SI/HAN5c8Ho4YRrX0UTsEi6dzr8
	 vNgPQXrJAtQ8m/IQRDt/vUj6kNVzefRIsL7awrdVfh00dWoaxLsljrPKbBQAkmtzatou0
	 FUQ/Qlr4OA+aX9Ph8KJDhmPmMe32b3ElQujJ0ewsD4okxXdvgNhL+pSKvWhZVSJIXRUDq
	 xRrmLK25a08GtY8WT3uM09WFoY4RGh7vnGhYupQbAXfViryeb9mAps0Gow0MS79sgwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G+B9NVDk;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2477F606A321
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2477F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G+B9NVDk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so846873a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197355; x=1793802155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/mNeciGEDV4oliH8vu2vu4EuuS7Y9Kms2mXuzaoLDE=;
        b=G+B9NVDk35WhIetAeOybgWF5FUaVx4PLG54HD67lQ+AB9SFBfBsLJ5qsiuhIJCKZiu
         E2zE29XFq3TMc4dc4HVw2SsISFGT30LsXCL9Hu+xtBhwOTXru0BJRqd26LmexPZQlRjo
         uEFruBiTze1LG7QV3EkRWIU24AwrEroLcjLJryAPk7GC2viNF2+DuyKqvV8N4xEiGId0
         f1tr0Vcfs5Se9zzStoE14FYUd78LkBnu+GfrnxqtGB1k0SjLtbWi6UCi54+cAJwFRsVz
         /HagYHytdWo2ObgfDZ0nsdduG0hRcGCk4ixMuATQrzPp76vab96/Et9Ishw25yN/L41F
         dDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197355; x=1793802155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/mNeciGEDV4oliH8vu2vu4EuuS7Y9Kms2mXuzaoLDE=;
        b=MNxbXRmS1xJmRX67A8KPDUqw+PWfy9tlznRboKbSf0YwcITmZvLTs65h9tVDs3su/w
         8A2Y1yqNR5xHU2uK7fMUyPOJPwVYlbLoUTyBz4/nhKiRVa8IWuJ7FX8hn/8m5p3w51+c
         IH0C42Ei5RIYCyvSl7mwMJTs8qZa59JAL8B09Dooo1dIFt6rBN1npFhg1PYUvXE8ZjVQ
         QHM4+g9ukI36b1xRuW5R5ArhUEgUcY45nC444if0898E0JVZpop6Ysmt9RdAPoHZgVOb
         OO6Mh45LslQf0fDV17RoyzohAdGNMV1lnNVuxkYBVQtpU1tZdYFyArNs7G+4Fqwj3ptB
         lnBQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1s/465PpjO/wiDy30PNZ3+b/lVe+0KY0cABi698/OzunjOnZ1ap975ri09Ll/ZE3YDV/v50fMy2YTKcErjQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLVY749yfp+aJuwghWamm92UoMogcpA5FCeBF/k8zOEs+OsY1Yt
	gNXYphL/nw9rx7qOIM/tVYDEuOBtHx9+snUx1ZlGX1O7YmYHLbn7+ZsQ7NER+YeuDUw=
X-Gm-Gg: AYBFou1cY/Qslbi6hso2sKDPXDt0rE/lbAnmVK4JTP1tCHEJa40F78oRNY389Gvzi2O
	x21axXuj+tNSZd4409IZjVRBz5WAQFsK/W/t4mVtkQFNtG6cccnTxl2v0G/PBzLWKsto/riC8cV
	lm+WhWGYLW6xCzpAd9SDh7eaUva3qwIXeH6W18MrUJI5G/3mDoke8CPBNYqjnSTUUfV2z6ZmpdR
	ccytY2FLnOfSuq/j5qasOqRZdOPhRLb7Imc3OTUCEcvIaSmdGidqFY6pHXqPdIyWDtxsJBSgQV4
	50mFlL9Hp7foHSHXSTf/StK/fM7LVP7SfDiVyX0d5ZyDxUEPdKicOXghcaqf3/hkHFGT489xJbN
	W3UrRjNQ73PTfvuj4lNFOZYbVimcxbGNaPHzoRMkouYK/uPy5O/ZPDCGaHaeVdLaimG5Dvw8F0z
	TBJSVRqzF9tx2UekA/QhMVklced/0mUoOdS0OYLKiuqvfXS97cAK03RdpHeKrx/PK8yGZQ7wSWx
	u+K4S1vwjZELJ0p/BqiA8P8r7zIrCl5xKSHRkLRH6dL/pE6t8vFfBGAJcT5wZaYkkLjihLv2fOV
	qspOuZc46U5RGhCSblT0GOP1IhQ5jx0IME8zs/XNMpzsRCqS0gE+BsABfYSPhX/ayk99
X-Received: by 2002:a17:90b:264c:b0:3a8:10e2:ad08 with SMTP id 98e67ed59e1d1-3ae580dd95fmr2042875a91.48.1793197355157;
        Wed, 28 Oct 2026 07:22:35 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6453ea6sm23723645ad.10.2026.10.28.07.22.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:22:34 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: reject invalid EHT guard intervals in airtime estimates
Date: Wed, 28 Oct 2026 22:22:12 +0800
Message-ID: <20261028142212.14523-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An invalid EHT guard interval can select the wrong airtime group and, at
320 MHz, read beyond airtime_mcs_groups.

Guard interval 3 advances EHT_GROUP_IDX() into the next bandwidth group
at narrower widths. With one spatial stream and 320 MHz, it evaluates to
264, one past the 264-entry table. RX rate parsing rejects the value, but
the common TX-status validator has no EHT check and last_rate_info can
carry it to the airtime helper.

Reject values above NL80211_RATE_INFO_EHT_GI_3_2 in the helper. This also
protects exported ieee80211_calc_rx_airtime() callers that do not pass
through the TX-status validator.

LLM assistance was used to find the bug and review.

Fixes: 3702a33216e6 ("wifi: mac80211: introduce EHT rate support in AQL airtime")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. A QEMU
KASAN guest calling ieee80211_calc_rx_airtime() with a synthetic EHT status
changed 8 global-out-of-bounds reports to 0; guard interval 3 returned zero
instead of a wrong neighbouring-bandwidth estimate. A real device TX-status
path was not run. A reproducer is available on request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/airtime.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index a4e1f33c0377..c31540ff42e0 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -550,6 +550,8 @@ static u32 ieee80211_get_rate_duration(struct ieee80211_hw *hw,
 		group = HE_GROUP_IDX(streams, status->he_gi, bw);
 		break;
 	case RX_ENC_EHT:
+		if (status->eht.gi > NL80211_RATE_INFO_EHT_GI_3_2)
+			return 0;
 		streams = status->nss;
 		idx = status->rate_idx;
 		group = EHT_GROUP_IDX(streams, status->eht.gi, bw);

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0


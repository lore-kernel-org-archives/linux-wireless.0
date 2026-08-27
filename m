Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC61632E7
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809833; cv=none; b=Na1EyZtmjTfG02mOdLi1Z/ZHML++WSX3dbNXAk9Cr23xKPnYZk47296yBvJbsYe3FjEmWg71O5QP+kpKof8jCkgOCdskGCyonFKFOcNO9TeonehF6TipkdXDTAqcwfYFLHYA4TMlSQYsi7qSzb5z+SHn9i50jFM7D/yiJdR9iMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809833; c=relaxed/simple;
	bh=es6EmhUC+2+bq7KUntR0s9wjohDWeatJ3HDSybcc0eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BolIauBrc5FpxV7Y8CXYMR2FxnN8mpETi9AwZuXON47Enquh7ClFE3h3KSwplwSoSeiXQV+8IQnAgaNgKVwxYbkgcBNsloZQeOg6xbdZhddaBsymEMOuLreKYLpUdM9WBEx9MhPDBCQSX+kxTlea5g2++cG/8p1RyzhCgmdnQ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=oPWQKRkt; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="oPWQKRkt"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-853c947bfefso560361b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809832; x=1788414632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z3Q1UJObAbhtT6DouMqxi+V1C1P0oErZpdeFC2TS4lY=;
        b=oPWQKRktJlOJqmlegq7gpIx0dqeAW93+zavwX+fdDvKzLRjAKLOpuMq5m+RwrjGoA0
         ArtVKD2s7vRWKkTskA4YvmcDwsf3d5MK92xm3VZcUQ3gRgubBEfQq2p+U9gMeP+wjHzS
         yzeJuzZy4YJ3tXlqGBa7auJiO5pgkFgYp9BB0BElGIEvSvWKX1cnn9+mXx9Cu0UQgVLb
         +pcRVyX2IsnSTekCHeYl3PxA5OyhtMrcc100iD07okRKXYWhD4xvQeUoxCP6fqex7Yrw
         pfPYd2vVcz8gtlj8F1Zfa3O2eAwqED11K9jxVmle5A5ymIn/1flU7jFdjK2BR35YXU/W
         rcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809832; x=1788414632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z3Q1UJObAbhtT6DouMqxi+V1C1P0oErZpdeFC2TS4lY=;
        b=fY6REiHPlpCoQ8Mr4M/XUtDPZsqfM1VWQ1QQ4jhH5Nvr5TsYlogDsRyya/2afPFnfO
         bSndUIq2coEDIMxHqoRaZ3lFeL3jyRXhMnbJJY76HXqwqYkZp0hRg+liBOhRHb2FJ8b0
         LnLK4+TLLMwxE14EdLqVi24ELbf4CjZLXcn2SfDUw0ydxLsKChs4HpLac3l9Vw1Mmrzd
         V+RgDJLzRBc9yuI4YENnSf7d2gtQYkl6p13siCxUPc4gAwnX9w9p3be14B+vMXscXB1V
         PmFAuLwK+SW9Xwitvha79xKxVi8Sp+fvgAE+eH9yZn5imZAZftQlNB0qz4LTU1hou02F
         pyzA==
X-Gm-Message-State: AFuF++mhnY0+NXQ4roJF4lyFWrvEwdeerx4mBbeKkfeWP8ol4YNp0dgn
	uyk3CA+OJ/yHl2E0ln0uPZC+CxEcwyrUFQwe6udl0nWUnVqHTdvYMjP2eN8QsheMeCw=
X-Gm-Gg: AR+sD1246RRpdHMTCj/Zr/9+Ydtz+CoFJxSwkmaR1ok45iAJtXvt8p81gXCxMvttbuY
	Yo6BNlcILtdZGlZjPO4Bgmk6MnfI+pgzn4nm18lrhUkWwwS7zm4DZ38lZ0cW/tICFfv03Hj71lR
	bp9J6YOdQP4Fz4fOmnyTzMYcLG25XXa3hvOBP8zLYCQud4X9fqSC+sOIkhZOKflQRN4KzwuiD68
	BywPIEyra6DmJi2N2BY+dS9Ouqo0NNai2fnaef0EEZIepm0G6O8Vfxc8Bj0xqDVBxazasBZM2p1
	bccUKS40GagY4ckf+g6yQsev+ee3Ysedy5wOtI2xnujY/xG5Amdf2XwtUzY6EJ0s00vIx5Jo/7C
	CL8xCUTgGDZu8Y9hv2Z0ezJcspEu9OCqmvM3Crn1x/x2XLQvx2Cbbg47f+OJjrdVWA0tk4LXKDs
	KB5W/oaQFMebUabDlgYwYiHENSEFrbfYJlVYlmy47A6tom70FRwN2jBVqKiltFVUm5F1DJrv2c+
	x3gQz+a4uv7NQ4N5vrsL3nQOCUDIdCI/As0OVgM88VMYIFMBZVAPlXVcw5QCkqCkdCgdeJCq7rB
X-Received: by 2002:a05:6a00:1404:b0:848:4c3a:a359 with SMTP id d2e1a72fcca58-854c930ffddmr4718080b3a.19.1787809831611;
        Wed, 26 Aug 2026 22:50:31 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:31 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 6/8] wifi: mm81x: tx EAPOLs at primary width
Date: Thu, 27 Aug 2026 15:49:15 +1000
Message-ID: <20260827054917.255584-7-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now port control frames such as EAPOLs are sent at the operating
width which, within noisier environments, can lead to increased
association times and at higher attenuation potentially prevent
association from occurring altogether. Make sure we send EAPOLs and
any other port control frames at the primary width.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 1444db98351b..fa3b0cfccffe 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1247,13 +1247,14 @@ static int mm81x_tx_h_get_bw(struct mm81x *mors, struct ieee80211_sta *sta,
 			     struct sk_buff *skb, bool is_mgmt)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mm81x_sta *mors_sta = NULL;
 	int tx_bw_mhz;
 
 	if (ieee80211_is_probe_resp(hdr->frame_control))
 		return 1;
 
-	if (is_mgmt)
+	if (is_mgmt || info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
 		return cfg80211_chandef_s1g_pri_width(&mors->chandef);
 
 	if (sta)
-- 
2.43.0


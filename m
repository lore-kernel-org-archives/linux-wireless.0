Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C441A922
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501341; cv=none; b=tlCUSIPIrvX9H5uW5k2rs8hsMvY6Kew4Z7+hFAduXKhrvniTDxkHSPGpdW7RS1/yCe8brjmp7GzbGvZvZlGfcsSaMV9q0aHnYadv1sQtc9vqhys/HeE77YDDa36Vt4uKuC0nZP4tqYsXb1V5Iqx8yyvIFCcIsx1g6BUe+8TMpdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501341; c=relaxed/simple;
	bh=YN70RHjCwmQ83vx3SX+04RYNQVnGpUEZQcVazfzYY2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqynWDThjBmvJXYrvM3ZHEw356sFoFe/eWA95dC0wdDbYBnDfiqRFUha+Ato4zzSFgigNQxPXx+oErGGwbPsxqdea9iYiPIyWw5zw2z2hnvAAfaUy3z/yt/cVrKrUgMmD+Q6+9Q3+mdM7xRmy4tOL8oexDCxt5fWF97DNDkwo/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HtbV7OiF; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HtbV7OiF"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so757284a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501339; x=1786106139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=h4F0UKlnFHd+VYygjGfrat8tsVC3HGvEHa166xK4bnIRJAPd/ZY0klI+oepl4yNc5Y
         LJG/rNQRtGAIBuLQ/gaHMK2yiTGuJUZ8m7zneLH18cmrxiSKoTI5NXXv/Hpv8qN4dA3B
         IJItr8YFgFWK3SS2+HtxgBwamcGByaL0QtjSxmRjvRQkAM6tKhNoNpbWYtuutjpmsJ7v
         egRKyHX1sJNg4CDiTfV7+dOPO6NNi2GLjcJ4/CelsIpwSV0S75KoIL+kOeeQFkWHA9V5
         hct1v4XgFwkKLNKyMKkEq92LFT/u+QxoH2D4AlImDJ4yCC6RhI1aKsx2/xxdensYlJEH
         IoHw==
X-Gm-Message-State: AOJu0Yz/X6a/2EzPAadOvTuc7euO1PGp9AW04Xbhney4+xPznKcF9nx5
	K4Prz78LeXKuQZr5UVtWfLvbYZfCL9JSIFp5aUHkaWglovfgJm4vv11/FWmCC1TE15V+IR61zbf
	N0zNjrq7uHqrc+7+xEPGVJi+d8uUVwCXSgUJFQjeLHZhzuNrUUAuwp7X1y331xFvpqZc6fDaOe+
	yDSgt0Ne4BCUu8umuHoihQnEy/Z3TcDIqTiz0niBVo8RLVhlhS8/7q7X5TwibFEOLtV6hh4O/Rk
	tflv7Po16tZ1IRibncUtN44QwLm
X-Gm-Gg: AR+sD11nwryz+ePiKFt4MXSQ8apdHMWyZelOd8QBFXKkzEc79C4DqLcygNWg1+wc/kw
	VT0RMuchM8pn2oawBjiond9nK/0+ugpYzfjtgJHaWMQdzC3zJdz3OmJev3BxyHcl1Tp/nQbxBp6
	iooUTukNK9Z9NXQNaEWv1/GVrmVwvdgQ1/do8PD4aRVDKlMyY+D3B5fuy8ZJ1Ve1+ORU7F7i7Je
	y42Gc7DubGh9K6g1uZ1OTw09thUD4BzZu3yfRaJ8e48EZT98aAte7L+O6fbQJxMwugAxXJ3fP8f
	slKoWrdSah6l+SgsSM7AWD5T7fPLHqtqVQrQHxNJxV9Off62uo40FMPOmyDIuHv2oZX5lP6DZaU
	J0u4ec7cAQEiq6I7BvUZzbKqkzyiDfVlaJXy/zu4WAT7fXzctdCt9ecMiCQlKG0kNyRZxhuiEz5
	aRsVJRV5ogdcaFramS9GQMqPJ8DUsoZNPoOElIPeA=
X-Received: by 2002:a05:6a20:7fa6:b0:3bf:6c08:fba4 with SMTP id adf61e73a8af0-3c91b38a739mr1909242637.56.1785501339001;
        Fri, 31 Jul 2026 05:35:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-13fab4ed5ecsm9962c88.7.2026.07.31.05.35.38
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so1614398a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501337; x=1786106137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9mAAQLzPAI07RqkNYsgKLJ0dCN5z/oc54+anUQNCXX8=;
        b=HtbV7OiFShGFd5pz2xmTsGVp7JgVWbwZtbn2Zu6N4VeMeNmb515++wkUB/HuInywCz
         SFAKVwIc6vHkK8D397Als4HBZpYEQHWgpsEp4FFYcXUm8vY/5G4pukWPAUNPgpNkapIC
         wMdR1qXJoMUohFIuj+a5gDpN/virvHcKBQnXA=
X-Received: by 2002:a17:90b:2b4c:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-38fb10f0faamr1832846a91.4.1785501337087;
        Fri, 31 Jul 2026 05:35:37 -0700 (PDT)
X-Received: by 2002:a17:90b:2b4c:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-38fb10f0faamr1832830a91.4.1785501336596;
        Fri, 31 Jul 2026 05:35:36 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:35 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 09/13] wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
Date: Fri, 31 Jul 2026 14:35:05 +0200
Message-ID: <20260731123509.1975281-10-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop overwriting *cookie with a random value in qtnf_mgmt_tx(). The
internal firmware frame identifier (short_cookie) is unchanged.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 9e44c85d2051..284bc61c46d0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -454,8 +454,6 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	u16 flags = 0;
 	u16 freq;
 
-	*cookie = short_cookie;
-
 	if (params->offchan)
 		flags |= QLINK_FRAME_TX_FLAG_OFFCHAN;
 
-- 
2.54.0


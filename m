Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97462EC0A2
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249972; cv=none; b=Q8bnLydou6BJHnvuR2WTG6rLRLzCjJR+XlAMAuI/rzQ81xgqN3CuPWrP36gppDDB70wdwJI2sT3ix5cRQC+dd69oAywr1mHm5I49LdgVRP2RjSU3jM3qr6+FZkDwxPOeNfguEjowdoLPxRiJaXEwud02EpgnMcb1u4rEAgf4xOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249972; c=relaxed/simple;
	bh=jjqnCmv9oDXIrOl1pvHuk1P9Bb5JrIDTD1Fg/jxkKco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDAZV9TBSEkBSTTUoIjax1xCGhS8piE1s9xo+Vs/fziWQbh9nx3fEHNoBb2md63K+v4rOXegljrjRE5B7q3/t8K8sFX+F2B/DjKSWaSHHAw7N0gauj4fc5I6OvmrC3yG2jxcQqCP9S4gFjKA8ZQamSBDI6GHdUW/ftjPOy6NRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=F0cLx0Bd; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F0cLx0Bd"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2cf41bab353so57959015ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249970; x=1785854770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTM33pxTJFajE0VLj8hw6g6BzNrwABVCyMkeqZSn7Oc=;
        b=DUg6XdzIW2M7QTihCd0ZAxcpqGc/sVVowveWXiCFO5i3EudYNUVcPM6Vajx5H5IGIl
         WNZLVmSJ6nXp4juBIwly+lWe8gfSc9cshpV9X8Qbyo1zSdFnReTGAzCrz2CQl8FTva41
         UJHSQC3tpuYXds8wSMPc9YdKZPy3Dgpce9hOiwTohO5psw1I9L1IQuWX1e0lwyuGpHiY
         O6SodF1P8K1BjhS0k28GwojjhMLidSyeZFUXEmtP9as3A6ZDX2/UCglZnOh+LoC1ZW/R
         yPIx9gxCPGRmWT4a72izKRg6R0ipudz6cRLcuI7eW0rDK1drQtsrAOZY5pGpLYrtg4GT
         xtUw==
X-Gm-Message-State: AOJu0YzDhw6h5ALqelgXuXvgDRZm7SR3rQ8R9qIO8S+9iMZDgOgC+cne
	+i7o33zsTW+6N2nxvI2I3+v4y+HaPrcmDagLy1R3wWBSmsgggLPdI6CV5fUTmu77IXRUyspZPTb
	fcWadDJQ68wMYlVwyQQmX67wjnpQ0Ok6VvdTyUjGZLk46eDmcqQmZSTv1toyLKBvfw3kbibi7M2
	D0CBGjocinnpVCkhc44oV2gZKMy/3pUBjl7VTr8Aum3PoD2Ef9QW3FfNAZqG75LBGje1vFCwuuz
	LBk/38CTNImoNjyzC5MgR3Q+B43
X-Gm-Gg: AR+sD11WWlhRCJZDGPEJj36/+DVgsrmKJYUb6xUqEoVEj2Lo07bvIexScUN2tL3MkZx
	a0FErF55sRdQ4Tir8PsnuyiNodVFzyFr99mC/YJgjz5h63z30EY/4ocRdHrPK/xT+C5C56k7D7A
	BktxfgI7FGQpwc/lLco22NRrQRYm9O6RzkKZV3TZ1mw6XVR/5clOunk6N2uE2KgmlEtl0uTgFfe
	UKozxg7WRMWqalU7YUlnlk8aUwVA9TweKNunw8M5DCnZK52g6QZgjRRKCR1j8RzsTQNHHgwR/vh
	Xhv7P17CBqDcTwzVrAPqmfRhnrMv/SLqMuFHSLQ3D2nbZ2G4SRKp8gUGS5163QSfK6iDO+czC1P
	me4qyFYoY1/oJeLtMWghk38KplrY6pGnmtfX6v+AMNQthhVP9ZZ7zQTmyciZ+e3S73xCCAf+ZAZ
	aYCVsHKZAKascn/sGzhPVvTG5N8yhwlIgmFoRm0x4=
X-Received: by 2002:a17:902:da81:b0:2ce:7563:70a5 with SMTP id d9443c01a7336-2d015b16335mr34055065ad.6.1785249970056;
        Tue, 28 Jul 2026 07:46:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde7a81f5sm11251075ad.38.2026.07.28.07.46.09
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e53b8a302so449230185a.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249969; x=1785854769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BTM33pxTJFajE0VLj8hw6g6BzNrwABVCyMkeqZSn7Oc=;
        b=F0cLx0BdPakC1WwwXu/Sc1VqXTvReRXsz2zXJFAwRxiPdYIoYhE8GTfTaaJ/teRir/
         u33Ak5RLulF1dNsOCka/7QgrFJlV4i8NnW4mC0T1+r2IQYKWzwpYetxVGmBZEhFtzI4D
         IrzqpTDzyKz5pnqRXtymO+VqSwlNHZdkNBeUY=
X-Received: by 2002:a05:620a:2604:b0:92e:4927:1ff9 with SMTP id af79cd13be357-9330271f9bbmr276842785a.40.1785249968572;
        Tue, 28 Jul 2026 07:46:08 -0700 (PDT)
X-Received: by 2002:a05:620a:2604:b0:92e:4927:1ff9 with SMTP id af79cd13be357-9330271f9bbmr276836385a.40.1785249967909;
        Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 06/12] wifi: mwifiex: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Tue, 28 Jul 2026 16:45:43 +0200
Message-ID: <20260728144549.2207061-7-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop generating cookies via get_random_u32() in
mwifiex_cfg80211_remain_on_channel() and mwifiex_cfg80211_mgmt_tx().
Use the pre-assigned cookie from cfg80211 instead.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 99d96088e364..7f446a22a370 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -259,7 +259,6 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	tx_info->pkt_len = pkt_len;
 
 	mwifiex_form_mgmt_frame(skb, buf, len);
-	*cookie = get_random_u32() | 1;
 
 	if (ieee80211_is_action(mgmt->frame_control))
 		skb = mwifiex_clone_skb_for_tx_status(priv,
@@ -326,7 +325,6 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 					 duration);
 
 	if (!ret) {
-		*cookie = get_random_u32() | 1;
 		priv->roc_cfg.cookie = *cookie;
 		priv->roc_cfg.chan = *chan;
 
-- 
2.54.0


Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846C0377AA2
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093966; cv=none; b=Nh7jxyp+sgReyffb2OyfmyUyJVXBmEx4s5ygKS6HmgvCO07sJxbydzLyoCVptOkJrOkKRoaKKaGk9PcEUt7NhVIpL7+tNDoGCF+zU3ujGXwhshkUgacElPK4yAo42SBSkxHBdP10m01z4QZJtXEyGnO92k/HH5Zq1OaAgA/MHQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093966; c=relaxed/simple;
	bh=jjqnCmv9oDXIrOl1pvHuk1P9Bb5JrIDTD1Fg/jxkKco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDsHmM2Pc6kRezMGLM2hcPZcjmrSGtDi1Q6mUFD0EF2HxxpH02EgQg5mtLlk90sCnCKf1SG7T9RV35XahYBVQ8Wt6fURS/Kzvpc1mHvY0e7Wr4ARH/m4KvNqfDXJrVgUJ6820tw9DkfFKw77Ntx8bxAbkkc/Xml+PN5H925u4+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ft+mQw6j; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ft+mQw6j"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so21326055ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093965; x=1785698765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTM33pxTJFajE0VLj8hw6g6BzNrwABVCyMkeqZSn7Oc=;
        b=ZboqscL7NGqAjlYOF9NCnUviyjue1nnoJsY3QWhMAYLVQhiLurXiZB0bKiWrEW0/C8
         CNKp21baG28O8RX8Ur2Uo8DCJOQOC59tBzvPaSN9mgTIIf17pzxPTwVt9+S4H9E1f4Yh
         Apwb8EMK65nOp2cdV4zXrrTiNlnzcgKKH14Auhc3DJZ757DLn1OAh3mree6juONUpXeo
         6Wl/ue8DyOA2R2An7ibxSsCsID9GKA5FM5eBAPm+8e2S+zgW79WFFKN9WehwbD7EO7zu
         J53uvJIpfy65NZBw5h07Yx8d8dTL7ach2kkxwk32p4k0yj3Hn+2ZYcSw7R02QkKFHwHT
         KCMA==
X-Gm-Message-State: AOJu0Yyh7UXTiTmXBKFMkgitRxtBUGM6KU2z97tqAaIy61VyR+qY+g7m
	yop+spSy0luZ+ssPOwoHQ+wa6WQwEFf0noQkK6TCpUjqr+L41HicMTz32dZ36wAccKhR0TBt44O
	zjCaD2gFsNqXKk0M8MmqUyk9H5gjPYrWIF8UgkYi1cyNrM4FP/HlRDevwtxVFXoEyqDAKAuDiT/
	CXBc0IgDTIW5NG7LO1ceT8zrLMl4qg4vLihOV+j5t2tCHgl8aU5N7JqG0eoZSy3eoud1vlCtjBQ
	HGjYnPoiSWMKrDhsJYW0hw7wgs8
X-Gm-Gg: AR+sD12VsrE2jFVDViMDw9hHUUv5M5Fny51qE4v7aQLbugFepbJ6IAYCgBvXqmXRc8Z
	+fK/x7DKxiVxZXZiLE6fkRZ0xtcV1Iu0kGcC0ScIMe8tOsAU678qTHlZcnj21fMwLXyJLxgYAuq
	4qLVT58U1cipvaBLg5Vbs5+btr7EsWHB8HD9PlGsvFnxlX8dumuLZdN8bxBxBme3ihswfRMTkSy
	xrAmrS+QSxfjyLS7iRBiZOlFOF1Gh78PEzK/OoB62YZauKuwXHORS9lSD0xXFL5L8CLuRCkfu3H
	pujcKYFgbo8sSjKEWw78Kki8Q6W8DwfobwJ2lYbR69VO27gKXI9CZOcgJc0q0AciwRczqCoKoXt
	LVY4nkxZQydSWqnocf3hXXBdiH3BSEwacklFz6uCAgjX3PARh1r5BUt4CTxWU+14x4XIbbEvTI2
	7PK1xtf33vqBrY1RBukYVj61PJV3L7Ae8ZYa3imQk=
X-Received: by 2002:a17:902:e546:b0:2cc:aa38:4df3 with SMTP id d9443c01a7336-2cfde78ffb0mr54539775ad.13.1785093964982;
        Sun, 26 Jul 2026 12:26:04 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde78fffcsm5214675ad.33.2026.07.26.12.26.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:26:04 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so3304262a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093963; x=1785698763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BTM33pxTJFajE0VLj8hw6g6BzNrwABVCyMkeqZSn7Oc=;
        b=Ft+mQw6jLNOdaLpC5CLHXMxz1xWfBshvudYRfoWLLg7y34NJcS5QQEhPkTkK0/Pews
         RomV/7Wz+3NHdx54hEFfDcU2vBMujoayjDVJw2ErGMkDJ+TW2nvY+/nV2YwIda7RaUrS
         FLH5upPXJOp5nVq7++WvuLNG15SWwzVla49r0=
X-Received: by 2002:a17:90b:3946:b0:38e:6a30:4bbc with SMTP id 98e67ed59e1d1-38f296089bfmr5394634a91.21.1785093963069;
        Sun, 26 Jul 2026 12:26:03 -0700 (PDT)
X-Received: by 2002:a17:90b:3946:b0:38e:6a30:4bbc with SMTP id 98e67ed59e1d1-38f296089bfmr5394628a91.21.1785093962624;
        Sun, 26 Jul 2026 12:26:02 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:26:01 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 06/10] wifi: mwifiex: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Sun, 26 Jul 2026 21:25:37 +0200
Message-ID: <20260726192541.2816743-7-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
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


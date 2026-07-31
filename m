Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com [209.85.221.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6665358D32
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501334; cv=none; b=pTVapX13VyFyTNp3y3UeGWE+6B280wLPS6AIxbO/XHK/0wIZZh9OoEOl89v+koS7n7y/pFM85pxxbYlQuRpnfyj//QBtHVC54ZDyK6SASo4PtryNo+qEz3eB6gAkqHCWg7FCEahX0PU7qjt7D9OCrr5Du/w31yBU3wxs5hUKVqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501334; c=relaxed/simple;
	bh=I3aadDL+9qPkWnU0DtywGPXm6Z+XaLqLu1JHFcrTfHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpQNW6pPxFQz4Oiz7yLeW/g1GRWV8YCzH0ObCmc6RkXcJ3kcIk9rCPcqa43qGk2ulsJlg8kvf+1AN11/BfKxX9UwsCW7GY5WW8BPZBuCneXATyKbUqKO7xthV9FtRGoysuPBPYNOn+CXV8A5RMSslM0k5JtliBdx2DFSthDIFRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YGKSB4+6; arc=none smtp.client-ip=209.85.221.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YGKSB4+6"
Received: by mail-vk1-f228.google.com with SMTP id 71dfb90a1353d-5bf5370d38fso364608e0c.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501332; x=1786106132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EHW+hZWYhkatdbcvERYAFF4nyTSnep77JL8vaFLl32I=;
        b=g5RHqvNtlfYli1iszgp9i1BnMarX5w5sGNnRBC+2+s2c1/l23pqE/yE8lmMvgj/D89
         nRlWVXFvAr4sEwqbjD9f9y7gD45mdVTL+EtyRGtMi9XAMWNUrTzWLaXJ+Oxw5uq1sTim
         1HLu6tNVpKRKXgW3NzKBPWrt5C5NZyN0RNzxS55+Xfk9Vv9rp5XiwCKSKZcm6w5dZjLv
         B2q56Q8rHXpjYv7jkuu/QQxnFN9RkBzKBimyMcwYOldhVXXv9YTKn4HDEYws2o9mmaGg
         HQpbhQMKe5l46hkBL2bpaKsmWYnrb2cE5CDh/DFGpkfr8BN2DJ+qTSSUpj3Ro52jStTK
         zjeQ==
X-Gm-Message-State: AOJu0YxlKey7u8lDl1Y1JXPdRkDIZf7Mlfy+xPXQO9YIGUiwEFN1c7kR
	3MFNc6u+BjtHp38KCvU1b6rg5N0XzS+Ql6XWT1Bj2KCzo0aSPfDysws20BTdoDu7GnTeHtLPtQq
	iYJnQ6gmQigGJqMWlN2pfZz7ounhl1hEEwbGN0RkFVLSjh3lZQOTdzj0ptQYlU9GySg+xt+3v+n
	sq5WSIWGoKJcdnqvMp3hYVgUryeBB5JQN+NXJ7jFaQa6jWPiCHOjSIXV1EzssS8HMFKL/fDss5Z
	FAw+oJKDt89a5PuNvtZFmBjVcm2
X-Gm-Gg: AR+sD10Wh52yatLQeYm1kSSnLpzGwbdWWVsKFI29m25ZkkdpuPxYpxxo/uim4NL5Nt6
	PIPyp0mBvULnY5tuv525sHo8yv059/vrFty2JfkbbpyHklpZ4noIso+2NTOG2quLApsQRggiVqk
	0MdgbTWrP/FOPGWqT4DQlRHM0xGG6uyUkX+1B4Yj8zkzziTsPhgA0Ptk264zpb+mLc3nEjfapbv
	QeurMMFmjrckdMGfpZWM6HCgHBVSa/kGRXBi8LERD3M+hjKbrYnTx166nEmG5j3WACFkTsy7SJL
	2tPCyTfaUz4UeJhyidFD66exEE6SvS1Tsa8lckNiLa5K/1JC1SzgHvdPA1KqDJhs7I3kQxdjk7u
	LmX8KzgdpmtfwDEEMm06s+AYdwBu0JkL8fUCkiNfZ5pu3ZvRXJthnrIVUzrMhlP7/msA22r8/Je
	cVJ3Tuj0h7zFHsIF3D/MHtFXWX1CVsI1d0911EdJg=
X-Received: by 2002:a05:6102:158d:b0:73e:605c:405c with SMTP id ada2fe7eead31-758f755b12cmr818357137.12.1785501331467;
        Fri, 31 Jul 2026 05:35:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-759b8e20872sm88818137.7.2026.07.31.05.35.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab041eced3so1415575a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501330; x=1786106130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EHW+hZWYhkatdbcvERYAFF4nyTSnep77JL8vaFLl32I=;
        b=YGKSB4+6ExmAv/DYeWCTLg2VyRPBxXCGlDuvCeeJbj8a9OSAk+lc0WtDHGI3FE8f/m
         35bQNjSkP/YnJdhswuyaVL2VWIRd9Dy0xqbzpnOulsXL8peiFf5vgEedym8L0YANqmU2
         3jXrFs20p7FBnOKaxxjrwW4CP1mDnIjJHUatU=
X-Received: by 2002:a05:6a21:3941:b0:3bf:82c5:ed13 with SMTP id adf61e73a8af0-3c91b319392mr2001271637.38.1785501330343;
        Fri, 31 Jul 2026 05:35:30 -0700 (PDT)
X-Received: by 2002:a05:6a21:3941:b0:3bf:82c5:ed13 with SMTP id adf61e73a8af0-3c91b319392mr2001244637.38.1785501329904;
        Fri, 31 Jul 2026 05:35:29 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:29 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 06/13] wifi: mwifiex: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Fri, 31 Jul 2026 14:35:02 +0200
Message-ID: <20260731123509.1975281-7-arend.vanspriel@broadcom.com>
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

Stop generating cookies via get_random_u32() in
mwifiex_cfg80211_remain_on_channel() and mwifiex_cfg80211_mgmt_tx().
Use the pre-assigned cookie from cfg80211 instead.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 8ec2d22a8c33..102321cf8542 100644
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


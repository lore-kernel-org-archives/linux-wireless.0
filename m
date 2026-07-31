Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2AA313E34
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 04:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785470571; cv=none; b=Eu/HUfo8QI/iBgD3TRWZSI52Ishfx5VzN/3WwBm5aZTABUZb8vPJexiiRuTfB6v+U04X21SDp3GkxBtKAP18SF1KXokYojZRSdkdhyXqGh67nUHQT7WORtvAlRXsiVMO5sC2umjv28qM6lcWbMmVLTrm53dRaxa5d8pQG/ehlxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785470571; c=relaxed/simple;
	bh=6npZXLzNQr37pTaiGSaPJ5r4nLsZGtGLxTdImvdkLFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7qYUh6wavclBP5e9LtsFk/txa7j03FDLwMFXxMvuNI+JEIetTfbTGp6n7koQt5ncP8Zyqy5SnD42+EUjLsA0J1nkFceHs9mxapfrKXYekwZlonXVxqgjlYn63/fNTGPF7hYONl++g6X7VZYL503vdWXhjks0aSAlLxwTrd9k/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWVYqgB7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWVYqgB7"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ccf2360620so3863425ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 21:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785470568; x=1786075368; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PYkQ0n9kKm10UHa2kbwd97pMEj1kJJgLqDvtDkUzJFw=;
        b=DWVYqgB7IqXh8vf+0kBIuzCGMs5hk9sKYY3/Qpi9FkSshAC2V1pAtYW//oA3cW2kp5
         X3ijfKuNxZUchq9N231iU9qcCydzoiWNYGJKHlED7Rg8IXFqj1wzu4/l6xG8byFqm0Sx
         wqMSMR/hJEMgdBOzRYIqf9kg0qMJ1eeacG5AYX3Oghk/ThoybFbbJkr5NXyDrzzRqd0C
         ql/2zn8HXsXS8KxqBfE4UlvWv+RDGdrVD5bHswKtPN6EFQufJtfwGXbcxfYWLE3mey9+
         UKv/oT5j+5tN73sqFckRAuOuC2L8i+aafRCsqzg6riZlfItmK0SsJfppUj8c4tVl0qdZ
         rJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785470568; x=1786075368;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PYkQ0n9kKm10UHa2kbwd97pMEj1kJJgLqDvtDkUzJFw=;
        b=qqsHeb6aCwsunQ3PiyLNQHZGNQPCDuj3d8nmjSW0nDitGmMZFkPOvWfXuHve3TrvcY
         NuLQLpLcVXQ8f8xcU6icSrLjjG74ZanSuF36CX15LsOKm641D69WfL4eAypNcMIIvTBi
         uGpPg4g604LuRbpeZm4JeQq9rA0c6jUULfY+0n+3zrsW2HRrT4ft40oxzbfgJUc6cnMd
         Es89HKTqjyoXA+q/oFbHbW2+yr5xGeH80XOVkQ3HCO95fwdLeo4eAuLhvqrYDu9ZMibB
         niReHWNMFwhl2ss1NmHv1aXay6x8ooRxLu6bY4d3VFtkiEhe+7x7jSPTQBRfUn/mnkf5
         cgwA==
X-Forwarded-Encrypted: i=1; AHgh+RoO7ddiIqDEALk6I0c+4ntAu92Zpa3OnHI/L0T+wvY6s/H/v7Ca6J7jIXHxKjLsOkfJ9cwWSiFsvOSydtQpzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx4J4Eb5+RSNe/YIKeRNnlAfYZ0filQfaNeoCX4ASmysskCv1K
	bMsH/AgkHvXuR50ygB7qLFXElMIlU5UZrBHJP3hE3SryPx57V7UrJgz+EXHJH8gmfcQ=
X-Gm-Gg: AR+sD13BORPxphIq9XNGlu8GjrS2AlJpWtwPhQHs4U1qjKH6geKDBmrAhNVg9uEOLbz
	1XD6Bzg/Z7LpoSlB+xpKXKgeMkatWW+aOwn4fdyQrH17NtNINpgLXIt82TAr/nGJSP0hi2mtimv
	IJ3X0AqNS7hWbWDzUsBZawnc1/lmaSYX7umLJStG2pUjpFbEqveYjShwlaMPIjRKVM++Y1SN9AL
	HuWH8lTyqA8gGK6pfFzqsqezhnEixHHDGZMrk+AEWUQVeVH8ynpmpPdVQV1XNidnM1r69i3gztb
	IpAQYy/6TZeaB7ZtuUQ/KE8zIm5TB5jna44nfuqBfjbrdYIdb9yUlBFGKtq62n5WcZEU9LVhlKz
	sazX7FczGu8mwnQdSYP+QQdlNXvs/ToJyAFrhVimcosNv2mSg6L6XGv/iE8FdXtQtm6uHUdhMT8
	PRgzuosqfsDoUoAFIoBvYuSjYqaZSK5H0fxOXfLdDOWs01Sg==
X-Received: by 2002:a17:90b:4c0e:b0:38e:4e62:f998 with SMTP id 98e67ed59e1d1-38fb140c630mr478058a91.23.1785470567450;
        Thu, 30 Jul 2026 21:02:47 -0700 (PDT)
Received: from [127.0.0.1] ([2407:cdc0:d002::264])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e044912sm355977eec.15.2026.07.30.21.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:02:47 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Crispin <john@phrozen.org>, Aloka Dixit <quic_alokad@quicinc.com>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: nl80211: clean up color-change beacon data on errors
Date: Fri, 31 Jul 2026 12:02:44 +0800
Message-ID: <20260731120244.82628-1-enderaoelyther@gmail.com>
In-Reply-To: <450be3831c5e0234c309d4c04641a42c6ac4f2b0.camel@sipsolutions.net>
References: <450be3831c5e0234c309d4c04641a42c6ac4f2b0.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

nl80211_color_change() calls nl80211_parse_beacon() for the beacon_next
template, which can allocate params.beacon_next.mbssid_ies and .rnr_ies.
A parsing failure returned directly instead of using the out: cleanup,
leaking any allocations completed before the error.

Allocate the nested attribute table before parsing beacon_next. Its
allocation failure can then return before beacon data exists, while a
later parsing failure uses out: to release the parsed data.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
- Allocate the attribute table before parsing beacon_next, as suggested by
  Johannes.

 net/wireless/nl80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5adcb6bd0fc5..755f8fe711fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18750,15 +18750,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->links[params.link_id].ap.beacon_interval)
 		return -EINVAL;
 
+	tb = kzalloc_objs(*tb, NL80211_ATTR_MAX + 1);
+	if (!tb)
+		return -ENOMEM;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   wdev->links[params.link_id].ap.chandef.chan,
 				   info->extack);
 	if (err)
-		return err;
-
-	tb = kzalloc_objs(*tb, NL80211_ATTR_MAX + 1);
-	if (!tb)
-		return -ENOMEM;
+		goto out;
 
 	err = nla_parse_nested(tb, NL80211_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_COLOR_CHANGE_ELEMS],

base-commit: 57aa1718d5953dd532137d43b696c68545c2e0b3
-- 
2.50.1 (Apple Git-155)

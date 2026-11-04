Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793775853;
	b=q4EDT8gUnxEBm0cfqcLElGFk2+SaVC2EhzFwkxzWFsqwezJ/1OCwNuxXouTB/XcWEHzD
	 ByUewJrVk319K6oKiuVax6lSWhH1/2C+JyYfZdSAI78sougLM9YvADAsBp7G+StCmVO5w
	 76tTz6X2s2wMPwQjjlAxDU0t/pJkQnGQmVCctydUNAc6X/evNdiaUzWP58k22dTpbAEIZ
	 NYxAQ82BlRixAHkwyMLHgrJn94zRr3mzBE74e/ST+nxTqROArY9gvqsyaz9RcmVS9PvUg
	 LH/7C3QfDgtS7FC3oQKbj7SgoZazLIDz5cQDFCSX8NxYQUo95bEwuoqtw31DOvuk6jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793775853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IXAUK4sDTB9f9pYauIm1MiHVji3hCgX1G0yE+uzLzBg=;
	b=v8PCcLa1HPI/YBN3VogHH6pl3VDNd1XaziVOD4OX1iQMvasp6YxxX6ui8a5goIRxHpFV
	 pwRBASgx6Z2nbm/fdkwifS5JULhkidJ0P/Tymf4wbaG4KNle3bhHYTc1FzUKboERjr+i2
	 dm+vjth1Dfotvy+oUL6yCIn7HdluhT+N83EQw7CtSJaYsvBbHtnulTDqWddfMISum6dMw
	 Yx2uJiZp8BystRAkKL+jm3k82i9FDMOHgFRsK8lxV4GX0KIBhaIoPAfrKPNlUsbFWDYRo
	 hW7rcaeEWC2l0rcUTINi9RA/8AdazJi52ZOoiAcKiHavuZI5/dYE5JlYVJaoq9Cz+CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w3XMnnPw;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D654606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D654606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w3XMnnPw
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ab3f899c8aso72437a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 23:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793775852; x=1794380652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IXAUK4sDTB9f9pYauIm1MiHVji3hCgX1G0yE+uzLzBg=;
        b=w3XMnnPwDt5ZGpKTcGO0GKwSlE3EAV/t0H6pVDd+UHKhxQK8vYqm4Onz6dtZePU158
         RRE8QEtYrB+fkqQ+CU9ISj9FOfNn5BXijhgDueb5lMXD84mcIN20l5wxnK7Z8Y8lVbNb
         w+/eRDdbQRIvMnOqztLU7TM9s0uj7hGkUEmq6X8K5MPdX7Aj3wmBpYlZoPopX/b+BvFs
         aXDz+Fj4N3czi0zdz1jkF9VRltSL6CcaS1fHdVp7iFjggAALShT4UBwb1CfCO7n2Bq5x
         eEZ71euuJ/XIuod/EGxeP9GHNzpT87Cnok4517j/0z8aSii5nhXLds9HNU94kfxgRT3P
         guMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793775852; x=1794380652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IXAUK4sDTB9f9pYauIm1MiHVji3hCgX1G0yE+uzLzBg=;
        b=dbpIKCZ6/1gLNshI3BQ/+ZSo++W+ns03Jzg3IbFxjV0OcscHMyzIvEf3Si9ICW4pTA
         wpKRu8DqSts/2uZSGQxfASDwRkmAEysmwkfRK5DvrC2R71BHPaoTpQlO3SR2mrDjh2iv
         8q16K+UEU26OFeAmQn4SzJnzSB/xb/LOVaGSUyl7DhHjoqUq1sALPf2mddmlPqNYHbPe
         25xwTZ+uic5mWtWdwKSxIlq4R3PholTIUalLPpwRkokCEMYUkwxbSoC1Mf3sRcpWCwWJ
         U2iGF2GHJswWjIwO3gXlN5gp/cSg0o8mNW4Svmn1hpuI/eBlsGcWSNiAvd5xaNfa3TEL
         5KvQ==
X-Gm-Message-State: APuU4Z93nM6D++H+TVbxgmqGmb4TLIxr0pLyNsEc7B7a7P/NeQELb5t7
	11ggF62kt4QekxypMIACjdREOKA4/A+Cj3G+wuxvVKLIVhswZh2MO+3N
X-Gm-Gg: AYBFou3KGjKUfsRDlzCAySyItLTcbbWtYLBO3JZlgtAzC91zSIjggqskSYJUTdSWlUa
	a3Lq+ArntrzzsPgNXSGXejd8d+dC3TU263BgcMMVL3UvKB+jKneuoCd8bUbzkLzmVgzQG1R/zHu
	q5T4USVsxTValdceCDbXiPLZPAa7TxKJ9zfkLaXDLRxi38+J2xEOSJngAtltHL2/aEkBxu3HsOM
	KvH+fWgzkK1a+2YOGzimie6MTP4ez9oBJKeKZjVmcNZsP3SZ8iaJHf8J7rk/GSq08ijec/bK60/
	O5/FR3ENTIFRHXO4mHwbVli5YCWx53hbjxGBaJTCTD4OUBOrnksCOlKOFIcrTByCruxl/U7P8VH
	psySEY6iKtcd5BftlEBdXUWMBQhy1wgYoVmS2XUB2ycvikymZrcJ+DU7/Kf9RkZ7sSw/m/+GreK
	XYuHY/Avig9EKecsIEv/EP+1KYF4ctnosMizS4L29Y4GOlrRvrPgA3yGDiJXni1P6GiWk7JEjBG
	s86nwrENVKgDK7wClqZRdAGsfCHDcrWhHbpG6WFkk/BLOODzaZSbpnn4IEv10XiwF9826Rp/B6Z
	IUDkffPk/LA5U+GnXujDPzBS//8hNe11qcsikZlbaA==
X-Received: by 2002:a17:90b:53c4:b0:3ac:9e5e:d1a5 with SMTP id 98e67ed59e1d1-3ae8988339dmr24038504a91.6.1793775852097;
        Tue, 03 Nov 2026 23:04:12 -0800 (PST)
Received: from CRASHEDROM.localdomain ([142.249.36.161])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm2580737a91.5.2026.11.03.23.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 23:04:11 -0800 (PST)
From: Chengyu Liu <lui2012qwq@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chengyu Liu <lui2012qwq@gmail.com>
Subject: [PATCH] wifi: mac80211: unwind via out_err when ieee80211_vif_set_links() fails
Date: Wed,  4 Nov 2026 15:04:03 +0800
Message-Id: <20261104070403.1617277-1-lui2012qwq@gmail.com>
X-Mailer: git-send-email 2.25.1
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

In ieee80211_prep_connection() with assoc set, the station obtained by
sta_info_get() is owned by this flow for MLO and must not survive a
failed connection prep: on failure the interface is reset to non-MLD,
and a station tied to the torn-down link triggers the
use-after-free/double-free on debugfs recreation fixed by
commit 283fc9e44ff5 ("wifi: mac80211: remove station if connection
prep fails").

That commit put the station destroy in out_err, but the
ieee80211_vif_set_links() error path returns before out_err, so a
set_links failure still leaves the station behind and keeps that bug
reachable.

Route the failure through out_err like the later error paths do; its
extra ieee80211_vif_set_links(sdata, 0, 0) is the function's
established unwind.

Found by static analysis.

Fixes: 283fc9e44ff5 ("wifi: mac80211: remove station if connection prep fails")
Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c31c16860..24fbdaabff 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9633,7 +9633,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	err = ieee80211_vif_set_links(sdata, new_links, 0);
 	if (err)
-		return err;
+		goto out_err;
 
 	link = sdata_dereference(sdata->link[link_id], sdata);
 	if (WARN_ON(!link)) {
-- 
2.25.1


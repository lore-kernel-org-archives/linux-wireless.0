Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008459;
	b=CZI/OjrnsbYsaHev0ohj6bjuRGqOqhdg6+bkTKwMSH5ihsw4hFw/4YdR4y5oYckiNwnf
	 PamkOa3IUL8rbg78fYo9dAtsf6zz7e0XKB1814EtABPFfjXrFetxGoFnNds597v56cd0S
	 wZTrX97Fklgbx4xKBQvG91YSHDvyyVN+rV0lnSkHEiUTiNa7zq2Fb8HiZ/5B/MJ6LiMVx
	 K7/I7LOtBtKdRC7CgpckTSTxqGPTbr/Za35lxx+4+qr24YEUyH/ealMwnlNZmginShfyj
	 HYqHQwm09TpO4KgFbfcd2RlZeFmo1v7lLiRQEZ2tiJDtakVasI9P72+C0XgFjtdT5Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008459;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=D/VaSOMcUlwPUAdjntA1Q0HEeOmbUij0t3BgSN8ccDo=;
	b=jfB7pfmSNPPyXlyrSOEHuC1HMuUWInhLYaXqAspr9GPfBl7sC3LKsuK9EPd7+njDUYc/
	 0CUkFMIZsxVpPyo3/MbOK4bX/Gfu9B1NZKek0cwbHZjQvj/pxyY34rI/a0/7rEORQXgyo
	 FFUccc9QFxLb2OGSvKPfTf+F4Zp6pSCooeCIQxlGNQ6btCPhxE/jIRLLYnWtR8xvHtV69
	 tlmaQZxdIV0+7saxIk7unuGHcp47D7CYkREsOBEaMnCG5kQ6mah2VplZvHp17NP4f4dox
	 d6S5Obt1r8n10i+SoeRctPHK03PqbkYtDsoHhNDJ4XTgjsNkRMpe7GhI58Vw2qHG0KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aaTnvn64;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94312606A323
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 09:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94312606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aaTnvn64
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e00eee27dso1718148f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 02:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793008457; x=1793613257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D/VaSOMcUlwPUAdjntA1Q0HEeOmbUij0t3BgSN8ccDo=;
        b=aaTnvn64/QBcpX/pHFhqq2YhMDxBaXebWmQjWa05pDNGjrYYJSz7ukx2+UyEWspfO/
         SWEwMIz46wRXbwn236vYnsnUm8QvS8vdWVGXSlKGz7giEK4fcfgGmBFxnxMQaEUTZkHm
         5nftAGEnW/xkjsWtPaDFtCOAfV3qTUybKuV/ERwvD9QIzBAAiWB2rd5OgA7aPBhlOIRL
         GuLCZ7S0ay24QIuil3U+mat2FrT08g7aQUlQoTf69SrYAF7lttN2x72dylaK/L3jJIEe
         nS1b3nTg45aDowTu42xQeLLkkK/kykgetHearnFCnYd2p932Pgz1SIlN15FLlzpxkM/+
         61ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793008457; x=1793613257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D/VaSOMcUlwPUAdjntA1Q0HEeOmbUij0t3BgSN8ccDo=;
        b=J7ZoGTW3wDKbVCFudanp6OblwQhqEOR/ppWLN4iih/E5OKkdXuEbdCTtDLmFkNhp9S
         zLOqq9Te+7hXUvQDV41Hq6r9vKGMIWbdXuysZLdsae2yG0rLdx/r700v3ixwi3zCxIJN
         WYsqsv1htOQlEYCEykff2dZl4W6Vcso34/CZzALsDl4l6D+AwaKeCK2sgLj+n1L7Fa50
         q1FIUNpLInKZDL4mvS5jdLNs+40zD09p7wWwn87f3EhJqKHqPebGr/O6wW4jtyDI2GMz
         lNsmIQVEUPTNEiFyILcVmKJTTyC11Y/SZIdgGCkFYOvSZ0TMKtq/h0+ZtD8TBdPvKc/9
         QJ+A==
X-Gm-Message-State: AFq9FYKBXHCOtvELVt9tKEAo2cD0WKOfZtdB1lhu3jlLdFcZYD6DYM0r
	ZizpJq157/NXZXK7wdOiH+MFvMYxka1BYUGFkfVkT7hY2AeGiXghQNSL
X-Gm-Gg: AYBFou0jHbtnWAFmJ+/Pd4z8wHnJ8MYB/q2/tR2AqajuYkpebEuRgTbRjMh0aQ8/kYr
	Taq32G7K5ojC4wrKqpytIKS3YjuichhX/hFzzPytjC54+XBtkekVFhG2gU38QVAGad6Axk6yYPb
	9c1S60xkc+xuFvEqQ/4l/hVPsjRgx4hZxmIvgQl5v/ZbL2inE6mpxphpD46CPNPggKVhebBxGxr
	ArV3w1SijwEr/nzeonB0wiP+ip37c0JaKUTrbFaIFRRWZEHcduZ1WSTmv2bM7Sx63tJKS+oYtYd
	UWw7BlxxqIl9QWzclnVtxsHIJpBGU4nbHVJn159T4WsoKxSaUXgu1gtlx4676SNTzTBkQa1ZZoU
	FAdzc61rkoA7ZAvN2QE1FSjsCyD5Zk8H85jQfwSmrOK+XI91ZzVS4HvvFkSGjh9o853x4p2Rb/Z
	GoVpLYq9ygm/OwRU54MFMREQRlSFnOk9gc9P4xbqx67y1Vu3HX7WquWaYO41mSb61Dx2SZ+Nhm1
	qrI4si6n+1sT7r1O0Z9YEfJa19UOb8IIBI15nNuR9Hl5DV6i74Vvn3Q3/BAAIZdXdXYLdgElK7O
	feAoolQ6JTcKU3A8coPKi8CliHaf7jA2NdqQwg==
X-Received: by 2002:a05:6000:2312:b0:48c:557d:ab24 with SMTP id ffacd0b85a97d-48e3eb2cdbfmr11414765f8f.4.1793008456800;
        Mon, 26 Oct 2026 02:54:16 -0700 (PDT)
Received: from localhost ([217.150.74.224])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdf9bdsm14960572f8f.55.2026.10.26.02.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:54:16 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+c38f93f387ac25eabf68@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211: use owner vif for AP VLAN station TXQs
Date: Mon, 26 Oct 2026 19:54:14 +1000
Message-ID: <20261026095414.149334-1-hackerowskiy@gmail.com>
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

AP VLAN interfaces are not added to the driver, so their station TXQs
must wake the queue through the owning AP interface.  Keep the AP VLAN
interface in skb control data for key selection, but associate its
station TXQ with the driver-facing AP vif.

This avoids calling drv_wake_tx_queue() with an AP VLAN vif that has no
IEEE80211_SDATA_IN_DRIVER flag.

Fixes: e937b8da5a59 ("mac80211: Add TXQ scheduling API")
Reported-by: syzbot+c38f93f387ac25eabf68@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c38f93f387ac25eabf68
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
---
 net/mac80211/tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415..7446c8d9d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1571,6 +1571,13 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	INIT_LIST_HEAD(&txqi->schedule_order);
 
 	txqi->txq.vif = &sdata->vif;
+	if (sta && sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		struct ieee80211_sub_if_data *ap;
+
+		ap = container_of(sdata->bss,
+				  struct ieee80211_sub_if_data, u.ap);
+		txqi->txq.vif = &ap->vif;
+	}
 
 	if (!sta) {
 		txqi->txq.tid = tid;
-- 
2.56.0


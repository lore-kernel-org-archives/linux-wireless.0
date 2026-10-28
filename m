Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197127;
	b=salyYQu3MgA+3zGZJkGtPaZar3KEuBbERJ4cLcWpI0zn+GYxhXzDbMyKVnX+jTnJZHi4
	 TJJAQKTwyr0OYYrsiBakWThTHBpbMjawYxI3EHW81wxRXBStGYLIilYvTD8htZQSXorix
	 L7c0ERSYJiAKV4viASq+YVXKbnouG4fslG3QKx0m753bwaS2Xy28i1N+tPOv0tkoOhqhA
	 O44yuGv1XgqNo0k8fBBKmDZ8+tOhK6Bfum1K8t0CzmPJZkJZmIPikwGEVW2xbfiN87Ut1
	 VEgvS0oYkNIyBYAxn2TUJYK5UrhLdRXc2mi/JkHD6JzTJcLUVu+IDYLZ3ej0BUqWilg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x5pMrzNqhnU/C2P6XLQ8m6/Y72S3deTQkrwYq1kdoTA=;
	b=RRJ8M3fIp7teWEWSk+GX/kNdimaZucxPKKhYwi/tc1MJlMps0ff4MJ2p+Kwvs2c3Bbcb
	 603XI6BEyZixXeYTHxfbbL5GC+4l/49+u09rPAdi8jGgGsV1igwwRPh9S4h3BGPnWLfuJ
	 QbYKoJTxwVHdJ8UbsnFdlaU6knUI4goSya/7A79DzGp4LZ+qIdDoZgCNz+tgjSxuopEWY
	 ynj6Zsu/iX3k0/HWG4R62Jvbf4vIWI0knz9r8Vw13MzMQdEDvOaeIO2dVVIe7rQsfNiwF
	 0pIQUiLAhZ4bBW3zsOGAFLq8UgleHbc1yEkDTinMx//pNFlECR6zemTOqaf/xfZMY/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D7TLlDew;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363A7606A323
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 363A7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D7TLlDew
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ae57dc1ea9so435458a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197126; x=1793801926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x5pMrzNqhnU/C2P6XLQ8m6/Y72S3deTQkrwYq1kdoTA=;
        b=D7TLlDewfvGsFRADJTjmPF8rrR4n6LzIhjICYp/le+3pDRjbxkiD4agzf5lGE7L7ND
         YR0c6Y1GYict88qgmGuJFRmPWpJ12Z5k90qpP0gvG9o5eXazBhdgN9mGxuEh0bAJuu7c
         FdK3z4RCRPFa6tTjPWCYRIBB9qhxHMaqiYS2BQLZ+YSJfQDtW9VZIDblnPsOFRInnDbq
         mpth9IY/s1EJ3Q5oKkSz5RLa1wlru717pLCc0xzU5BE8nHJR0faQRHSl3Q0d4U5tmJzi
         3OndwlReYc5K2q2wXK1BkqnvkmjjeGTyspnt9Kn1T37Cxy7XuABQhZwNDcwwGFd5q7ZD
         zG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197126; x=1793801926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x5pMrzNqhnU/C2P6XLQ8m6/Y72S3deTQkrwYq1kdoTA=;
        b=Ig1jk7r+vzVsgLkRiQyU7ILUVDTDbYpUyY8bVhpFHDq+WqU2MIGUgR1ARrN/4dDgY2
         C2yD+QVjnyae49IYlh3x9dD11jFN7HGm+XdiHxuM0UH4+95sR8JN5s5YIlxXXzSi4nb8
         +Paf72tL8wlF5o4N75PPQFHTErx8Cnu30HuJMBwb/c5GcT2h2nC0F/PA5LJPvQZJwC4E
         eg9gwMtUYIAfwu/t4X4JPZ/Zrj6HiPyblkATL18Z+tn4lZ83tiPzRbw9PphM6IrJ6+6Y
         Et28kZ9H8+cL60qzNBuBnauKlSQTB+fsbzxGzvMnnyBJ9fVfx8t9xW803HjD7beau4rY
         isWA==
X-Forwarded-Encrypted: i=1; AKwUvBzXYScejyIHW2LLLlPOya3APGwTRPK5SG9C4qvNQuVBnnEQz6FV9HBYz/1SXizoPiFP9hj3FAMFU3StKDckyg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL+6lprcndr234BwWuP4J1u9Hf38ODCIcort5WKM2nQeUsc4oon
	HB2EgNdVRJUSxS06WhHB3irBkg7CGvcghVS0dwdFPDauPiBkE0CrSK0v
X-Gm-Gg: AYBFou1cEFxiAVZqHvoT4ftxYfXiujfpMrhzq89t8SVV38wkC2h7jsgUFTC9bvhYlLd
	GC7//cfp1KUHK4WkjWZh1bVsSRRUjACdM36f42EDxOAhTDF1hGryDHGE/4QSFwSReU/mua4p7Lc
	eKHCdTfDtjiWir8j86VqFHWvaJ5jd/Bmy7bIFWjIoFE2VaW+3clpXLpOfLQJgz4fuyX6aI75LMB
	f4wEceDVfGNxIb+dEDcSH/jkkz10V5CVJcWaYO/oD/mBtHKZmbljXV8Q9Pz7p3fIEpZjoKu0H29
	3rtE8OwIgzMW7ROgPMIaPCDwnM2I4EzUhkNAi6diaB6jg9uQotxdRMdwA91ktRuYSB1MIjp3UTT
	6wWi11pfEjC/ZN7euH3vxzF5JqwPfiTWPsqQGjt4R8bIZ6Hu0/iMzxvTVqorq6zgfDQqTeS6LXm
	ampA4HdPKQUIMmx9HFwIcpegcL173b9DvEGld5QbHTxeDRmWOOtJYPsUaX9A+BoAPpfLZFiSUaT
	4LjFNYP6OqHUH0GvrXskqg0anIiL9TPfeGwC0nBp6G3MtM256F/X04+Tg2HKq0Kn3m8ILYIadC+
	1E6PD03f39aSbHU5TiIho6Fr3bge8aZibGuYat7YuvIcchjaenMnCXkF46xY87HPjLiVlA==
X-Received: by 2002:a17:90b:2886:b0:3ac:9d14:feb2 with SMTP id 98e67ed59e1d1-3ae581d5d09mr1702502a91.35.1793197126435;
        Wed, 28 Oct 2026 07:18:46 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a0482e9sm3437223a91.0.2026.10.28.07.18.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:46 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Linmao Li <lilinmao@kylinos.cn>,
	Kees Cook <kees+treewide@kernel.org>,
	Rosen Penev <rosenp@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/4] wifi: nxpwifi: cancel channel switch work on teardown
Date: Wed, 28 Oct 2026 22:18:16 +0800
Message-ID: <20261028141819.7556-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028141819.7556-1-enderaoelyther@gmail.com>
References: <20261028141819.7556-1-enderaoelyther@gmail.com>
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

Stopping an AP while channel-switch work is pending leaves the delayed
work armed. After driver removal, the callback runs on freed driver
state. If the AP is restarted first, the callback switches it to the old
target channel. Reusing the interface slot can also reinitialize the
work while it is still pending.

Cancel the work when the AP stops. Interface deletion, type changes and
driver removal all stop a running AP first.

LLM assistance was used to find the bug and review.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. Not
reproduced; IW61x hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 473e81304ca8..384ba69dd058 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -1638,6 +1638,7 @@ static int nxpwifi_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct nxpwifi_private *priv = nxpwifi_netdev_get_priv(dev);
 	int ret;
 
+	wiphy_delayed_work_cancel(wiphy, &priv->dfs_chan_sw_work);
 	nxpwifi_abort_cac(priv);
 
 	if (nxpwifi_del_mgmt_ies(priv))
-- 
2.56.0


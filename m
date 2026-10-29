Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281702;
	b=hTSev9z204bP8UJmzTjLwg5BkTtAhtqH71UHewjjDmDBwp01fReBaJtlLSsDIQjV85MW
	 8d1GcrdKj7SgKLNIxmvHwMj6yoN7qktSrViYg7soSB8BvJkXQsec5wF/eW/rWptfrhucY
	 ToNIBQO0jsR4KqVLErqBmSuIpA9BeaG50yFieazfTLTgFHfki5nVsFGWU/2jgd25f6Q5u
	 mnosNwtslMFlkcHOULS3ODoryXfv9nDriPkI1jCQnRnImAK5mpMIsQaI52x/LoRe6Mnep
	 hcg05MX5anTfNU5uWvNzNiHLeYeK9k9aNtDXc75wvv6AuT1RG7DSEsFPJ90VXhso3Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281702;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KZ/vad9IsSdNkgTxCuZTyRICFik/6Xp9Vhh6TPx5p/4=;
	b=1kVmjl7VwfHngb4voyLTbzcTgB6cHVkDJXY+WhtGqoDYB1+LC67ZddpA2DizoqHcmPMI
	 cuBZV2UJAB+fdDe7fLHbgIGTia7cAbFNyz6rCsnjlv4Fp/TvfgUyjeYliqSoX6Vl9CBZN
	 6vDRf2mlrs825neQSgtDFJlaTHHKhoHZXQLazBNLm38HOqFMBCGBTqDe6KJ627X5r/UYh
	 BPB38Xm0NDvOaW6c8M5SHd3zB6nShA434VhQgv87kfInkrWtWkGblgIf1oNRFhx1FAhQV
	 VAVdl9/0DvDQ7MdUVGgLbETaD4rSYU77nRwx7FKHraYeH0DxJ3qw3RYbiAQu+RJWUFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jh8mqqX3;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CBB606A31D
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93CBB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jh8mqqX3
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-886e61fa30fso1061556b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281702; x=1793886502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KZ/vad9IsSdNkgTxCuZTyRICFik/6Xp9Vhh6TPx5p/4=;
        b=Jh8mqqX34qiCPK91ZPzdXZBX/dOudyqlszhjv9Ry1Ugq014jQSAw57u9vloIVIPiry
         ARjxxhl2HwQVmklhGwghpg7MZQ2mJ3WohFxiTN+9JvpzQEtMlIhVgbPKWqteXHKozIPn
         UUV8LKJ0jnOvRP+QdmGhmhGk8rbPQOZKW/irRA8qkeNCTnzHX1JDVPFhsdW1mWDLJRU6
         VgfY/EMXFEKOcFBq8PRAPEn5u1paTyRhLiVGYFisqb0HqJGcurczRl6x/nEjao6eG1Bq
         t6/hqEbjAWSWhXCKFy0eAxcCGH5O2cZpSgHtzOi28vgks5m9ZoLgn+w5HunkMLEakTMb
         e6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281702; x=1793886502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KZ/vad9IsSdNkgTxCuZTyRICFik/6Xp9Vhh6TPx5p/4=;
        b=Rzgku6itCw6W+E8w/Wp133fAXYVvHhOOG2f9VUmccYSDp1BUg1gqIzrZuDyBHg6kE1
         jM00ch/FZYqM/7JQLjI0M77vOrjMtA1TextleBdj+nZD3nRRgbfsRWBuY/ORQn7H3A2J
         y2hbZuGowPg1UobjZ/3JIdxlu11p/688v+YqZxSrUHaQ2zAC2gSn+uzh9yeoU4zvD4x8
         QltZ5CBWFGy4UjVlERUT8PYwfQKAqkBv1d44gMuUY0ocXnm/6sQGpbncOxWl7SwxuUQ9
         rdl+iBbSk7vs+0Zn1FJdkF7br43PpCItYXgHqPnK0zh6/yHxOJiZtSb472InaaiR94cL
         P7Ng==
X-Gm-Message-State: AFq9FYLL3pNIQetJtU5Mzjh/Tu392dTK9n3HUYuIkj4Wtkwx+X/1yrSw
	qoEfNCgme0CgdCPB2uLuXgZyllwC2OlW/ecGSkBGUP660NHHtnDFLJOZ
X-Gm-Gg: AYBFou1ff9EAulyPakwRF+1Oq0cdmcRdk2Nvc6YjJW3hlvEswJdQLl1gGoOWNm/U9G9
	F5gkD5Q5bdIhTimcmAUp2iEXel0Ed7q/K6L3uXjhffgeAoyrcpNlR1gf+Eg1Dh5l4zlMoH9Oasl
	vPAqudUT23lEtR48yJdIP/OX5WiCDJ6uR5mKbTBH/G1MgfJgESBFxGRaZAKzzPdY4Y4hg1ttu8u
	Puejyrb39Z1d/5aHKKszY9IqUlkU4HYm8F3VQYNKUvjHG6GtjOd9SSYeLhT61yAcU3klJmwBXy6
	XkT2QSPT8WL5haz3976BlJDrMvVTTdOTrcTFCmg3tB/h3M3JpfPbjrxYjsMmp3PvZL4X/LMhI9n
	cUfnsB8ww26lHmedIRFh/FRLLkoqU4u4CHZsXGqN5wTbYS8YhWfwa+u/JKDLX5ngZDkgyBRRkNj
	jxKaOGplWnRhybf87/gGZ6B5zOqFxO7y+vChM0MiLznn82inemVMcn+OGZAnvOQJhDPaBRymEj4
	V071IKSkJAvlgqsbNXRLDtlPKWD3+CJgD5Y21sjq5jVcKbNvoreWmsfUq3jw8UM40MxTqEeekuV
	53b1b59gBV2551ZGiiLePoJJvq0+Ohsdeq2w9joIdRYM8n3Pxve+QRgVya/mTDRhVdwlysmElB0
	0qbMJWgBI
X-Received: by 2002:a05:6a00:4b54:b0:8a0:3172:bd86 with SMTP id d2e1a72fcca58-8a6e6536e02mr4691471b3a.14.1793281701838;
        Thu, 29 Oct 2026 06:48:21 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:21 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 1/8] wifi: rt2x00: start the link tuner when an interface is added
Date: Thu, 29 Oct 2026 21:47:42 +0800
Message-ID: <20261029134752.1299130-2-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

rt2x00lib_start() enables the radio before mac80211 adds the first
interface, so rt2x00link_start_tuner(), called from
rt2x00lib_enable_radio(), finds no station or AP interface and returns.

Start the link tuner again when an interface is added.

Fixes: d96324703ffa ("rt2x00: merge agc and vco works with link tuner")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index 3bc0c1c906c91..d9e323ccc6d62 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -264,6 +264,12 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	rt2x00dev->packet_filter = 0;
 
+	/*
+	 * Start the link tuner again if the radio is enabled before the
+	 * first interface is added.
+	 */
+	rt2x00link_start_tuner(rt2x00dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
-- 
2.53.0


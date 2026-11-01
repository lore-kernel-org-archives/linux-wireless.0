Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566696;
	b=3fyU7vxOzExxI23ugufWPAFraapRl5x8FnE8T84pdfHuBq26YvDegdCFlztjEzODpcXR
	 Vns5XAmdNq39rL2eK8ERSyzGUGZSRnpnNY7/BOu7ijddI/jiCZvl0ufOCwceWUARyr7xr
	 QT8TdLw8IgSGeVLG+j4tLgr30yaxsMJPI0V/0BF/g6TGDx6JDAEsQxGSzQqemz7oFtB92
	 ynH4UuN2VIOztwwPA8442M8NBQnrYfQvs1XLHRa90PkDNaOWd0GBsso1ZUdHf+vjCRYUc
	 TUDiQLbmqT0lgiewYr54RdMi4KpXhtvROcaBh4pKBKAbTeEP4DhlYDw8FrtxRzzAFCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5YZdVqt9El4/LjkqbBF/qbEkQUH1givqEV/QNHg9rPQ=;
	b=P4A6b4vmWbeZoLnzUXY2ht1UNT4pcCXGo9C2mtvnGi98JWemAkJIvd81x4A+xBc2qnKq
	 kibcPWeQEzzThinVznruFoRHgDvGHe88L1VaEAnj52He+YDm+aXTE8EvGTM6lfqiB8pF5
	 uy/vzmcG29TP+n8UzztjO01BOaXs2MYRey0jL3X8Wn35RzlrZhWz10zfdpJJJ+E83gDK1
	 wniBe6BDp5S5JDexY/yyN7hBN5Huu0ZsNFPTDfYn3M7MTdwLpdDknwK0j3VDLS803TmU2
	 4ITZbodloaqDorgg59Zn0ABSlOtOie6/oZlb5qX3lcqxeBTbOtIyrFKlGFOfkSJhUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=li1hA54t;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E549606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E549606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=li1hA54t
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so19634035e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793566694; x=1794171494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5YZdVqt9El4/LjkqbBF/qbEkQUH1givqEV/QNHg9rPQ=;
        b=li1hA54t772AfCwaUmbOU/09wYLHdi0laF1xPX2Cf+pZ6owDoSWL8fXAyK7GSzCfIS
         KM1Kx/xGGMOjw1tpJZVO7BkMSOtAECuuP9YzZHfUJEnR4lCVkD07wcL8FCMLYWByZhHe
         DS6l7C5ooZdFgSSOXMeP5dNuRXa0tmK+TDm6t2oWpr2JXdvDlJhMkUWN/AZZ6V2Rq2HU
         CzYgKxtIzAElmQoUCTk3wH24qRxVUzv6BVv37tPOfXmkKTeJnKPYN68aeyxQMePlFc9y
         FwbkVpH7Y8s7FWy6zCQVfczWn3RpQHYPktACx0XzD9NNfYCU+rnd2o23XAMokkQAzyeI
         5Vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793566694; x=1794171494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5YZdVqt9El4/LjkqbBF/qbEkQUH1givqEV/QNHg9rPQ=;
        b=gjWwJJwiaHG+oEqsEC6g7QhiLEUlX+nTfcVKt/XNkb0Blai/9EcEUdv/e2Jh116tKx
         92Lbb4mvPB6CETdHYWD5589ok3iFE4Pke/jBUccp/xyJtOLMhcxcn+8r6+WZI4xjD3xa
         AxvHnrQxbC5G6NfElHTzrIBO1ZRnyD7J/v/3W1lPW3mNpoJfZlNlQZsiWC5yC30utg4N
         4+QxsqjkjmYALxmnOhH5v9GorOwXkwLZfaZOWCrnceTKg7TafL2Cr/LbgcKkYm7S5IDS
         nCZ4ef/qIqQr259TB8G1Ust+gJlKdg7euZu/DfncqU2sEt7pD7U2HSiTldhLzrfWfiWB
         sUag==
X-Gm-Message-State: AFq9FYLkZk2eMywvQZDFO/e8lqdrSH1DFn8fgSYjzk2kApbUogZgiTw5
	w6/CnDjIdwK2yDFg7rxbhamVRe0+GnJBx2IvX33bAMP5Co2kVM8b2tw=
X-Gm-Gg: AYBFou3vErHsFTtcUfU9hekMHe+hG93E8kQNtMPl2PDneahwo1WMsV4sdN/XmEi9WQm
	siPTJeWvL4rZbyoRqvbSjT5wvV370tIddup6vX8tvZVl/3yoIOn/H79tTmektpvAtclp85TfMLh
	YE0anb39zOSThc2ibRUgHWcNgDTRGwTxD2W+MUruH9SPCQGR68V6reXxs80lMkuM2SQzILFSIFG
	ht/mgapuMYijrzf9U+zpNzQNhOf8hICsf+O1H61j1vbGqbELwyy5k3t925UHJUqpqAEO7ddKRHw
	VavHkVnjfUDw6rSikdwM/zHsSlH0QWFGtL7xCJ/grlqqvHHroQsEFJhFJ5AfNdMt3wzjvYfHge2
	gGPNLPYvr76XBgku1TkmyMmXeZQLBMBOzDI0CyjJkfDjJXG1g06L/WDwmcrLZWe0ErynoCmpCjp
	qAqkMTEMV7uu3lFZaOc6ExeKabZhbiP2zMF/BmZFy4RUNJJRbQYhkXJsk1BChkLTYs7D3qo7Ld8
	zTfd2ntj13SG/7eOBAKMUSpDeBz2SlSoWms1amtUtafOKerIW/rQS856Dz9L9ll9gzdMlP0ww==
X-Received: by 2002:a05:600c:a107:b0:4af:e04f:cbaa with SMTP id 5b1f17b1804b1-4afe04fcd89mr44737415e9.29.1793566693776;
        Sun, 01 Nov 2026 12:58:13 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9eaeesm16002280f8f.49.2026.11.01.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:58:11 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 2/3] wifi: mwifiex: validate intf_num in multichannel event handler
Date: Sun,  1 Nov 2026 20:58:01 +0000
Message-ID: <20261101205802.2909524-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101205802.2909524-1-tristmd@gmail.com>
References: <20261101205802.2909524-1-tristmd@gmail.com>
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

From: Tristan Madani <tristan@talencesecurity.com>

The intf_num field from the multichannel group info TLV indexes the
flexible array bss_type_numlist[] without checking whether it fits
the TLV data. An intf_num larger than the available data causes reads
past the TLV boundary.

Add a check that intf_num does not exceed the number of entries that
fit in the TLV data.

Fixes: 8d6b538a5eac ("mwifiex: handle multichannel event")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index fecd88967ceb84..1f746e8f6b3e18 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -450,6 +450,10 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 
 		grp_info = (struct mwifiex_ie_types_mc_group_info *)tlv;
 		intf_num = grp_info->intf_num;
+		if (tlv_len < sizeof(*grp_info) - sizeof(grp_info->header) ||
+		    intf_num > tlv_len - (sizeof(*grp_info) - sizeof(grp_info->header)))
+			break;
+
 		for (i = 0; i < intf_num; i++) {
 			bss_type = grp_info->bss_type_numlist[i] >> 4;
 			bss_num = grp_info->bss_type_numlist[i] & BSS_NUM_MASK;
-- 
2.47.3


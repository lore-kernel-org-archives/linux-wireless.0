Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A0D4E236A
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449800; cv=none; b=gId/2spj+5msB7TrhIykhWxANUcSFkY8WabQSVtrdnw3HcY8NDDUnUPmp/FYScF6uWgldQwAMV+q66cQk2bZwAZll1LVbobE82A0Fi+QIWT6bqCprF8ZqYAfRqbujYhxHv+N/qvxEY4mh3N/sYNvHifMNDTOd+QPz6+k7PtWDeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449800; c=relaxed/simple;
	bh=SM0mRtUxaHoxR6ZHIxi0dRk/J3NkAPKmE+EazTtEt88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HEPg6NvQUHcEREmdhcfMn2ztFdqwFZskSIwENo4R8XYZuC8AMsyGW633d/agnABF4LuTyKLY+dh0vEpBd4GSGWu5IIj0gqCl36XkD2NdnqjBRF/hWtaqXwO896RLcFmr3hN6ONqjedWTqXqHWhRXnX2vTUryEwEIAlTAL0rCN4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfIYQpDU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfIYQpDU"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49557167508so52345e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449797; x=1789054597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TcouK0eCsqKz/evCB2s76zDGRnZRiqQtBAWxyElcQTY=;
        b=nfIYQpDUdPN9+QqD5muayaGfO+WUMkhGizlhLwjC6a5jjnHXEW0UlkfVeuuM02YAd/
         SwaG6brUpB3wSi3wcNvJBrzSKsjr6UcAVTs47fpGR2BNS3FEQVR13CQ91TQ2DjI9EMGL
         OowL7GH+8R4QNAMzC5cmbO1RzVht0tSbVfdI17cp8xO08Agm/AUwO7qncyApXtCXUul4
         XF0Hn9Sw5BzTvJ+/PPeZg2azF9LxRlJoQzRozy9IbpZaD42/zcc5VjxcjQd97Yzo2v3U
         GYVLrmCZNQCQZbVpZ/6mn2RSOTkP79rUT6KZB7mff2f22WuasLEAviJqlJKXGlEAjihl
         /r3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449797; x=1789054597;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TcouK0eCsqKz/evCB2s76zDGRnZRiqQtBAWxyElcQTY=;
        b=EMBsSLzX+PQX1obUlo9Nacrxx7LFgxmjlxbWMSwPCp0wVDf+Tsyuu9+Tf0My2P17d8
         IwVQ1QdKlgCldbjT4R6znoXmD2ehZnkBcSg2SaCMOnD6IamofW0EyuBDns+54yvQS7Wz
         CXpa/eVQSE7n3ppt3ZSTs4OmBPAz9pF08SQJ9ps2CXjK8SnVXEdzXvZFBL3G9wXF52Xe
         2plzrWQx4RgmgyWpc8/6eldC5+udfsl4R51vnpcAuBmYPZPcbdoaosMX0pbr//7NFsTU
         SO9t3+7XzTGWAgvnfD3VqL3x0d0DMI0+00LhLJtl+0ZxSI09hxwL+b5Io8ijGqmT8Cb7
         kuOA==
X-Forwarded-Encrypted: i=1; AKwUvByM1vJa1arfrU8i6367QsgpNVvxkEp2S5awiwHgHZyKa5mtvGOq1OjwDrL3M9ItqpgBLoPStmo/Qa2+77R5kw==@vger.kernel.org
X-Gm-Message-State: AFuF++n5rVq7OvG+p0bnDDQPlIOidgU+ZIPEW1zpxR3VVzyuxGl1Nxam
	IUwfmKr+SjdjIFAKLpSCjiNIXBzrI58hy4jPVboSG3HlNbPLMRJUxZUiVPyl
X-Gm-Gg: AYBFou3jjCPMsUW8LILwGpNjx7/ky8/JzabAW3V4gAJ8SBRIlGE/fbvBwjM339UnQhS
	6u4hjSSKOlM9egoH3SIavLWtZuONaI5bVkjyjyuf9V6JV7I1Ey0jjDPe6kOdWp/anTO8g2oyii5
	WfR9VDnQ1AuTJ9BoydSUETYl2/AeRqqC7p0YSrLUsQ8ya3XcBFFvzzob53KgUot454MtVnZxLdc
	DOWO+ArrMTC5DGKeT2BHbIFzlAZt1W9bFaRI8wuPjBBZQLJFqFIWjxt5nwssYotaXixHDUe9W8y
	Qlspe8p9hdzMeq3WEWV79ri6le9NikAsl93enkxVZmd2x5fbbyt3hSuxxK64EwyvDfCSpeZYRmk
	ZUYHb4uOpZFov/DpuHCL+1Tm37S+FYJZkzZAVl8LcN7LWL9af/fKFFB5x72kVq1Sa/XOq9oEmyb
	poUk+LsBowsYwtf8d0t4Wly3mjWe1OvY89FQiUGieXo/okIZmWU2v8fiQTfvrSjfUyR1iEPJelI
	fx1vbOUtLLT0KfGp+8MtcULHBVs4x0hiVp/Or3dwF1m9CZ8Uyw4cED9CfkJWc4ZS4jIt8Pmma9/
	YOxm
X-Received: by 2002:a05:600c:5306:b0:49c:c9ac:a4f3 with SMTP id 5b1f17b1804b1-49ce5810b6amr270638835e9.1.1788449796652;
        Thu, 03 Sep 2026 08:36:36 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm75568425e9.1.2026.09.03.08.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:36:35 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] wifi: ath9k_htc: report a failed multi-read as all ones
Date: Thu,  3 Sep 2026 18:36:14 +0300
Message-ID: <20260903153617.990995-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
References: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_multi_regread() logs a WMI timeout and then copies its result
buffer out regardless, so the caller receives whatever the stack held for
every register it asked for: the ANI MIB counters grow by random amounts,
an EEPROM block read at probe turns into noise, and ath9k_hw_read_array()
hands back values that never came from the device. ath9k_regread() reports
the same failure as -1. Fill the caller's buffer with all ones instead, so
a failed multi-read looks like a failed single read and a register value
that means "busy" or "pending" is what a timeout produces. The next patch
relies on that for the tx queue status.

Fixes: 09a525d33870 ("ath9k_htc: Add multiple register read API")
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7fdec25c76ef..bfde58c5965b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -276,6 +276,9 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 	if (unlikely(ret)) {
 		ath_dbg(common, WMI,
 			"Multiple REGISTER READ FAILED (count: %d)\n", count);
+		/* Callers expect what a failed single read returns. */
+		memset(val, 0xff, sizeof(*val) * count);
+		return;
 	}
 
 	for (i = 0; i < count; i++) {
-- 
2.55.0


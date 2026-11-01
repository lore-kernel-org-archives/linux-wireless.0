Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793569882;
	b=I7rBYfe6Lwn/3B2FALNGZ4AG6VLSVieTuVmPIuUY3Gp1rmEx827OWMn81jPUTc8pXaLe
	 S+OU0KzAzvVfM7k/IkLgLuMapSd7qSvAnk8YmsOo7yMvSxFwvEos7c7Z1cj9mpIZ3LeCR
	 Z5WDHpi3d6FBv/V8ZYPSHAObhmsSqv66bnYwiVofPjTvJbktihjEaoKpIFBwPIs00lYvM
	 UIcObyOCPzFPz70a6cGOXatyU0eN3Lpj8UVRA5YivBZATVqAeUyN+QLY1H1mKCnM1MSch
	 LFSpboaOfG5stj3a9Y/SlDBqtP7e12ehCB0NtCR+UENcHy/kP+eQRU//NhwoEHfXcYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793569882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gXbCJ+Z4Wlm8GkoiAeg5stJ+hb5LXK7yuiODoWXbq4E=;
	b=3gEI0CbIyl564XNGRElpXG4KTZIAdI1bMkDm0ISdtx+rblTbtDbQktZV9KI75+CkQePE
	 Cf+3YsVouKmSFX5kquxcYgBr8jE4UwmOkVyFQzq70jbabeXPkxxJ+Uopqefa+o0T+lqtZ
	 DRVDCHl36b0JHFRVLvo+IGNrMLFgTD64CXzcW4e8F3l/MEspMuy/8yvEigj7jDSyyGEUG
	 wW7yE+12N20weKr0tus8iicdObBLMwc763iFq2GS/q2P04c9XDXbaAzG9y+DGATJRcDla
	 +ALpgIBi3D7U3GJpPSMFZknVO0oNmjLL43WiGvFw+1+HAIfY4d3L+zheKFtT4uwOKkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0UlB7U4z;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA5606A32E
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 21:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ECA5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0UlB7U4z
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so27176485e9.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 13:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793569875; x=1794174675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gXbCJ+Z4Wlm8GkoiAeg5stJ+hb5LXK7yuiODoWXbq4E=;
        b=0UlB7U4z8EPZoo87aj+uGyErmzAju9AXIJqWYcxdkHWWDjaj7u+VJqzpFrh0Qa4yrH
         ExXB/uYXubhbjIYdDON5wDB78kL//bgXTF7c5MFqTlfWHSqRmBrTrTwzn6X2tdjfjoUG
         mrOxgCM89gw172sFDIn5v8ewHvNbFUTkredsUAizHBskDxdw4t8c2WWvV7gN3PMwVW9T
         6snABxlqEchBwhfFgPtVyAnmta8GObGNOwyRPC9l1guNv9DwVttc93IarxTK4bG1DENm
         9zDmyEVbELYdVGcebvtK5RMve8g3clLLx/nCbfNgXUY5mUsTKDgklVRqHPGNUKXS9AYF
         WknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793569875; x=1794174675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gXbCJ+Z4Wlm8GkoiAeg5stJ+hb5LXK7yuiODoWXbq4E=;
        b=oR4MkCGztmoT34zsPql2KQzOZtJ7QP5VjOa3398uR3L1VXzVuzbr5EPUY0qKXwC8+7
         43YsIpU55peUzSWf4d8w3jQCsuMUn3AhLNG4DXeInQ6HiRkj1U8cOl2M/OtLFzWlcj86
         /7lHqNP4yl9NKRBBhYzeZ1gaP5fvas8k4PVWPgDpsrjJAK8q3MdWyZ5f83EbqhDrp8tF
         ZyAqeeOOdzgRwS37lFeblQZov5E+Nc8tpJRjC8iI37p3KT4Aihq5hlDf3sAzRpaAoW8W
         fsqiV4etnncGK+iuaehbmTHFiqgWwZn5oJTrBQ9tabGTBSIlQysnXTugpk/LJh21AYsG
         2O+A==
X-Gm-Message-State: AFq9FYKqYyNZxncryKRi+AvlZkZ/S/GPCA01+fxniIZYa8FHVJXJN89S
	qo29NcmnUaPPMT5EOrSiRjaYbxuBtMoyvHj5e9cGcUdQfFrOeOxK93M=
X-Gm-Gg: AYBFou0Kk73iG/yTQSoCT9bgOBt+uEn5qDJ4qAMqZw45EkuZbEnIgSBYSkB2/Vgv6GS
	VyEHdMxmt/g+bkhIJQuOZXmBBLwyyU0yQ3mw97WGjpTGVo8JDkJ+OdTTu0fgiLT4VA1Xe1Hg+J8
	ooA5nV6GyQyMYpYvvM4n2acAzGU7OGf2obO3aAcy2ffV+xS8b7YyuiewbG4gr/5A0wTRw2TkySI
	isu7Qxurg9ca/xD2JsiuFsqUTO+91lWlndhE1jgrehgoFkIRIN2HaUn8+7QKY9iD8LQ0Mgn6CEc
	d4DPGVHd355zQcompQggi+Wxc4JhyRuVtUWTbFQASox1ZPBDzhQoYrkjYloao/ZapX2XulMzNxx
	7+EhSTkuTkgXj32XbdHj912jpMvwumEm0svHUC2HMkEe+pG2AX8Tc6m9EDJEjXC4ofXVlwrAnTH
	3YkcHMFUb2SM4cyX1zqV/gEqyusRmkmD2VeFsGqF55a2tN0VG7/QK3M/IFPhuoTIjAQzJNdtE3w
	pLJuqbIXFtrXYnIgd/jDjC5mCK66rqJfhcQBBrQopxaurFWkUcO5hqlTHi+8m14HvNmivp7ZQ==
X-Received: by 2002:a05:600c:4e48:b0:4a2:150f:1610 with SMTP id 5b1f17b1804b1-4ac183d16eemr180666545e9.23.1793569875535;
        Sun, 01 Nov 2026 13:51:15 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad5ff8sm157249425e9.4.2026.11.01.13.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 13:51:14 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/2] wifi: mwifiex: validate WMM queue_index in firmware response
Date: Sun,  1 Nov 2026 21:51:11 +0000
Message-ID: <20261101215112.3199197-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101215112.3199197-1-tristmd@gmail.com>
References: <20261101215112.3199197-1-tristmd@gmail.com>
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

mwifiex_ret_wmm_get_status() uses the firmware-provided queue_index to
index into priv->wmm.ac_status[] without checking it is within bounds.
A firmware response with queue_index >= IEEE80211_NUM_ACS causes an
access past the end of the array.

Add a bounds check before using queue_index as an array index.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/wmm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 841505e83c7fd8..158e4a2ec0dd69 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -943,6 +943,9 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 				    tlv_wmm_qstatus->flow_required,
 				    tlv_wmm_qstatus->disabled);
 
+			if (tlv_wmm_qstatus->queue_index >= IEEE80211_NUM_ACS)
+				break;
+
 			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
 							 queue_index];
 			ac_status->disabled = tlv_wmm_qstatus->disabled;
-- 
2.47.3


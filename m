Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4147E548569
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988356; cv=none; b=h7uO9NeMpJ29G0dfEF0+5mKVVjFD3vYgkFVmglbv4ZnIyfjxsVZy1vSY91XEVgFiuuwLy0s0o+GEd9Y/woCuCIcV6Ew3Mq/GVRYiZBHbAMvKEhmkVUIua5wGA6dVU7byvVCekcb3XWAS33UDE/vvoJnL1HofIOnd7XbKeufcL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988356; c=relaxed/simple;
	bh=IrBBe6wvpDw+PWFsNwUGn4Qo/WOIBQJLb39g7kajDwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B56OdMkKbdSYibI0dwr8GGKbzX2W0c0rhQPdedav+UN7SHr4yBA+lW76reozpv09XavErx1Q3X5B9AczbGE/UXSnQFNcLeangYWj7x6lNtc0d51bkqqkYl5+tkpC/wHhTU1YGDtJioNo+nPPKRB9WkUEh7yBg1ms6g2KKo9IIGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q8/lGz5g; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8/lGz5g"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso9441385e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791988353; x=1792593153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xqLL0uNLKZj4KMkwSgRoeTHN6JTbSA0psPY/Eu+4Wi4=;
        b=q8/lGz5gKacVSwIOKdGuY3olis6dAOM4V/V9BYOEzr8dd0Wi00MQS34SPnO4PEQItQ
         62BHcM68dS8eLNZ+718cYQ7PBMavqnM002dkCym5tLNfsmP/INJTzxMP4xEcacA2ZYGr
         yR98zZA+NBE4/MEvG78v95nwbVhqKY3mel9in+/BoyFG5zY3RbiwrJdtkzYwKLuHG050
         VyovbLenh5fRXLxw/5nRS3/Nf0P7rlqLk5K7CLRa4ZvlURnNptodv+cxl2lPKQn0R/cI
         1ctDqAniePR4gKwHtRE91MF5YjidGPWfdaOzGoC/RcPuGgX7AIvZqr6y3PLanFYLL7JR
         Foww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988353; x=1792593153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xqLL0uNLKZj4KMkwSgRoeTHN6JTbSA0psPY/Eu+4Wi4=;
        b=adaKS+vcPEceSCdf1Iflw1dWzYtcxHa0V49rtH1IAhk/IbCfTrdZJAVbAnp+fD05E8
         Vs7QOlkdi0b7kz+6pblJYAyyn5rxv/lR+iG+jdvRoZHn9jsm9OffMmC779mIHFrIKBfk
         8UrS7grgT28eX8tJoVctU4kCl1t8dILhayVY4HaBWh2y5NYUVw3TeqQTN0xMeR2Y+f0U
         wk0fViw02T4AsxbDXqkKinl5fNY+p/7OGCgUp9A8p1zgEuykLWs8aWjRr5b5Tgw3yRmO
         aS7gqhOWs0YhqGgOsnOpJwPSoQ7F1ayAb1wr3GuPX5gkDCay2ljuAIJzJnfRczaOSaA3
         xQNA==
X-Gm-Message-State: AFq9FYJwWUvSa+XQLrOeU7crO/8uSDZjJjzblByamwaRgNdL/z5ybPeU
	iohimNMGERjYLy/L1cIakz3E3FJdXMYlGYA35n8ePZ7UZVqVzOnx4xucdCI2iT3t
X-Gm-Gg: AYBFou00evUdgb0FOJqY4Bp7pns9r3+NLYRVNHPJJQ5XXqG287H9gqZQXaJiES02IOv
	snDwO4HXIy04TwHUZZDDlf5qyvgDU6H57ecBMGKsycQCrpnudL4F/8v59v3zl/Y6O457fV84GgP
	YxroazJtFlGjrdsesjJC/rUqSo2vK4JarfgiXjlI0Ascj6tjTWEPHbF5mhZxMn3m8Tyvco6yR+8
	oBYFdM5WsFwTXFkPUkQ67B9p44aSZaKdzCD8G4eLr1n17DwGNYx2p60yezRML3nrLHNwu2cDzSI
	aud6dO4Lxh97YGdQil8Vk60ugvtQj0JzSlCXleKQrrKDVxM1W9qDUDT97Pb2qXEj56wxt6/+rVz
	HnVHnoEKvEhoPvDDLoX2elqM+x988+p7g9Ku7eJzeZCKiSZJl5vQi8IEaVpo9b7sZiva9ETzoCQ
	sy4kpV5WIbsEoO0Nplb5uozETFbi9/A7pHMt8ri5yCwulCDGRxpeqVquf4JHI8JcOaTMTI2nwoh
	3VOHiQu534QVrmzyAms5thpJSZRMMKI9N9+XZ9g2pv8ZbGp4EoutAngsuGlt9P6xkd/jvgWdAcB
	Era8fro9Ql64q+dnOpZ9F+97qgWwPt8WtT/GaJeTjaniMGc57YB3pqB2UYKPiKWXgdRN33/L8AM
	=
X-Received: by 2002:a05:600c:8106:b0:4a0:c02:938c with SMTP id 5b1f17b1804b1-4a18e4d683dmr311693125e9.25.1791988353360;
        Wed, 14 Oct 2026 07:32:33 -0700 (PDT)
Received: from zitrone ([2a02:810d:a1:6000:62d3:e68c:3175:a538])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd068126sm3411345e9.11.2026.10.14.07.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:32:32 -0700 (PDT)
From: Andreas Wendleder <gonsolo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	b43-dev@lists.infradead.org,
	Michael Buesch <m@bues.ch>,
	Alessio Ferri <alessio.ferri@mythread.it>,
	kvalo@kernel.org,
	julian.calaby@gmail.com,
	jpeisach@ubuntu.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 1/2] wifi: b43: reprogram the MAC filter after an interface restart
Date: Wed, 14 Oct 2026 16:32:24 +0200
Message-ID: <20261014143225.82149-2-gonsolo@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014143225.82149-1-gonsolo@gmail.com>
References: <20261014143225.82149-1-gonsolo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

b43_op_start() clears wl->filter_flags, but mac80211 computes @changed
for b43_op_configure_filter() against the flags it cached from the
previous run. After a down/up it can report no change, so
b43_adjust_opmode() is not called and MACCTL keeps the cleared filter.

Compare the requested flags with what the hardware was programmed with
and add the difference to @changed.

Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 8f4aff3..57a5935 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -4318,6 +4318,14 @@ static void b43_op_configure_filter(struct ieee80211_hw *hw,
 		   FIF_OTHER_BSS |
 		   FIF_BCN_PRBRESP_PROMISC;
 
+	/*
+	 * b43_op_start() zeroes wl->filter_flags, but mac80211 computes
+	 * @changed against its own cached flags, so after an interface
+	 * restart it reports no change and MACCTL kept the zeroed filter.
+	 * Compare against what the hardware was actually programmed with.
+	 */
+	if (wl->filter_flags != *fflags)
+		changed |= wl->filter_flags ^ *fflags;
 	wl->filter_flags = *fflags;
 
 	if (changed && b43_status(dev) >= B43_STAT_INITIALIZED)

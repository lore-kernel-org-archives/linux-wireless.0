Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA879486410
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789162309; cv=none; b=tXUVrVNDWLsZjy5wjPaxrQsrHFxvcRJAJaf3Oe3oyeHsbEBno9FdLYtGn/Zmb1AJeMqkNHNhGV46esNs6vyJjDA2v+6MtrHbaqU3k2+gAQ8Z4nqqtbmvNKjXqpwnbtWaVZjhCOMQg2msdIReHwBfjmg6YCDaUe1NBq+/q/U7rYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789162309; c=relaxed/simple;
	bh=FRLkAE1TRsicRIjs12TClJYKr9IHrbJZhraLwHHugyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kjLmoaXY0NtiA2JVnHdnrnmSiaEjekASpbe3P6jgul0G/yuAnEd6sRvcTHCxPFjEOia3xZ9wsc9ifU/7ilPu7VNEr9rtf+QAGUzjKVTFr1NeLhz/od7IdJWL51tZWIPqzpvYlZs276I0xAC0NiPs+UXk2aqO7E1RWtiqYt8O1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJ/8TFsT; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJ/8TFsT"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-398a5aad413so1494825a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 14:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789162306; x=1789767106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EZHEbamxrCKNFud4RphEOhfi3p8kiH9hSf8teP/HbOI=;
        b=nJ/8TFsTS7MxmufBz1DiI5YpEsH+JlaJ2FYLfc/PwjZ/HWXOhArWnKoICLKT6Evaes
         ox1NrvppSW2QVCFEA+s0xhQdWR/4QznHHT0L1S+uLnmQmHtH3/0Z8cBYEJsltTakrDcF
         M5uSv4Bebv5c9oFoluZbIvstDQy7hDb8UNT6ZHV/ZwEdpne9NIhMZvrw6mcUHgaOWqPC
         1GGAz7//BwhckjUJgvr08o/r4Dez0zCzsS5GRcY/XbmNlC7QRkaFTrS9rrAm5MeUPYgg
         83vvrZt0FMGy1NCn1nL1FCjTlmiigcJ1wQCOGLhWEufKsQXjclX6874hM2wnBDR7UY1l
         4yjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789162306; x=1789767106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EZHEbamxrCKNFud4RphEOhfi3p8kiH9hSf8teP/HbOI=;
        b=HE7mxaX71eEVk6mNDzc4Sx0XpiLiiGm7CFPtnB/27fhZ/zQL3EWDyYcHVHYM+WlOIV
         nX6T4shDHlh5Xo0guEvx95s4Xx8HO+1im4k9sWO81AM8t0MVNCiukbesq7xXQ+hc8s3h
         OcAY9vrmRFfnZRxFGgcz213xy02fRoM53rTusBYZPQVVi8GLDpdubg+GJtTaXpnO2eYd
         xE2hv1uEuj16Th6QrNuKz2deIlna09dhBKPa1MQPPnvfvTjnNdo9rnmJBg9tpeYhdmtQ
         L+TgXdx8OkiOelexEud/KDkH6jyxAacOKanY+eOdOo9vvWKN/hgfrHNnnwc8wkWm3Jp3
         Lncw==
X-Gm-Message-State: AFuF++mvyurQWsO3VczM1J0UhtL7hIe/91hw3o0fGOk1j6sLErw9Xfmc
	d8jGHKM93xuqVbxz50s1fTTv/c4yuLNSfSV4NZQTz49O6ufyeJJBkBVl0IFTfg==
X-Gm-Gg: AYBFou2neMZafRHv1cbFNe7rbEZj0GRmF+gmiOImOAKE5gadsDYK8LJgd5LU6Ty1pPX
	SZ8ja5qCXSrKITnCWI5wXAJWNjakkMLe4WR8Hku1gMV4lJh1zFq91TreqkBLg7NvDv9U6wXn23w
	AYXbPrC8pxeD6d4Sx0mc0A2JGKH4qDhQeZmB7nQs1X/Lkkxw1zmI33boBEic3JQOOuRrCEObYJL
	yK5gQZjpMskEI4TOlXx/ZQIkFagMdZ9Sj5FEPVIjMFuE6XDmSbIaBK5ownEpClVnIgSceN3mzG1
	K5aW+eZzaAnYT53cdVqQi8Tkh+lv9zsw1N1r5qj35paFA4iZLjltkSepCAVCovB6NbXF6sb8s80
	hMxr+v7yie5Vbmr2uG7fBMmMZjDrWaA+DLdFz7j5lMYGCN6ooIDuv6mxv1ehW22gmrkZha0GFcd
	jo7tpVgy0K3rd2mWqO3QLe1VSgeSfHszxqcxTK2sriFtnn2zvG4FwygAwyT79mDpjOZer2/s6p8
	qoTSVZOPYYMNZ2sG3CPOC68bAYtmLQXD+/14ahG6hGatUyZZcvffDxQkNlrNrRM9aFf5K5jnYrC
	QqK1gGlZsYmht+JrXmM/SMVbYOPYsV83jCO1UZ1rw78/ZfUt
X-Received: by 2002:a17:90a:da8f:b0:38e:c232:9d3f with SMTP id 98e67ed59e1d1-39d9bc1007dmr8846016a91.5.1789162306195;
        Fri, 11 Sep 2026 14:31:46 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da6016718sm4261752a91.15.2026.09.11.14.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 14:31:45 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 ath-next] wifi: ath9k: delete channel-context timers on deinit
Date: Fri, 11 Sep 2026 14:31:44 -0700
Message-ID: <20260911213144.130192-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath9k_deinit_channel_context() cancels chanctx_work but does not delete
the offchannel and sched timers set up by ath9k_init_channel_context().
If either timer fires after deinit (e.g. during driver unload or
suspend), it accesses sc->sc_ah which may already be freed by
ath9k_hw_deinit(), causing a use-after-free.

Delete both timers with timer_shutdown_sync() before cancelling the work
item.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: use timer_shutdown_sync()
 drivers/net/wireless/ath/ath9k/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8b27d8cc086a..cfb1c90eb4b6 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1363,6 +1363,8 @@ void ath9k_init_channel_context(struct ath_softc *sc)
 
 void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
+	timer_shutdown_sync(&sc->sched.timer);
+	timer_shutdown_sync(&sc->offchannel.timer);
 	cancel_work_sync(&sc->chanctx_work);
 }
 
-- 
2.55.0


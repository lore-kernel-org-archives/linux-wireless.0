Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647083;
	b=jjLgeQslU+PYVjv++F5yyMeweAbOky4GywthrK/GGtqs1rknFbh1pybSA2O6sfcb/jYw
	 YElC5WnBQlU5mR7wWxAQkgMN09dphcOHCK3w3ZTVkfGHDpt6cZ5aoAj9Lsi+RZ5N0S2e3
	 RG4OeK4a8b5ymfqZRfo8gw+P7FMNOZXBEKZ8qzkZcn4NEjEhFXeg3oXeH8aAfxeRTvd33
	 k/H4vSAePZ0pehJGdQJH+ai1+BSHL12GoC92TYXj1hYNRBD6wlODmHdsaloTTXqwBI8Dr
	 +A+G7ZtReti4ZPhIObaEt0WWKBrGPogBpxNMvMe9XSabgImYMb+Ug9EDzEmNUtSxyMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647083;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOqLSFlmXa9VNiEma0WSAldud1u92mwnEYoycTmoyt8=;
	b=Og+u524Enjo/zWqLTvTw2NmNKnCiLI6fUnDHYd8ZDaRDV5KHwAzbEvlfd0SpXWPHlLmm
	 Y2aQlG9OY7Rvl2v2HghUxP5yCUcPvbnreqZRObfg/T0MIQKTmw6SF7Zg6rDnSZI3Oad5z
	 BZUE7WAXeSFuDKWycBOH8GVkSaDz4XlOhPbr/FGbaXrdSMRTdMP/iGQxn+Qu1nje4ohBw
	 pSOP5TGcIrWk1vd7qwQp2SBZbJtyjVrFPv4+Sb6Jhnhwq2+XNSN33EvbAhv8RUiAB5uY3
	 C9abVlkYs/rObO+zeAYdru5mFNOX+mTcEvyWCCS3Tybj62/Ywn3Z7uAZduZpYeSDxiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PhHLn3xy;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11757606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 19:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11757606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PhHLn3xy
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so22512095e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 11:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793647081; x=1794251881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FOqLSFlmXa9VNiEma0WSAldud1u92mwnEYoycTmoyt8=;
        b=PhHLn3xycdnqVLb3UZxNFCI2+foitR+doRurslWo5zWx+ZuP9erhNAZazc5g1O0AA7
         X3Dj9KyynQ72xjN8X59OjfADJ4n8/IjNB89lhHSMIcWx9E+B06bZJh/zJyZf85Hz7VWi
         jEN2gJX70m2yjwrEpabO7JETQPqER6gctdfhUkRYvHjGFzm5T9Jl0xuz5CBEgPwNgfQ+
         PetEMH5SSAwzoMGT0s3FOrcikTWDIo+yHfkifKuKR1f+a0h6P/q/Tun6Q/0rbYobI3rp
         //3gM2yDju/NXhqa6VVeP0xHKMpS7vEj2KfNgt/mWHDl8M/CYit+OfEsHgX2YTM00UVt
         c+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793647081; x=1794251881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FOqLSFlmXa9VNiEma0WSAldud1u92mwnEYoycTmoyt8=;
        b=ZcGYVz/4OIky1eAgzuOrBuq/AqxyJpYwyMlYxexVtdF2QBVKW0y1Ml/qfdukzLSfD9
         tH5a3MEL7Lu7ooITMqxlQFmvAYZHKjhxSfEwRAwUUIVB27NXoKQ4Clkd6qoKT+AoxNLe
         7pDCIcD6h67RXvpbxVcwauW7vG1tM+Vswwx5Oni0cCzOq8aO2XW2saQca5yX6BI0Dyk4
         8LwqL4Wr5n/bo97pKQQgpqIO/gyJ3Op/HZSpQMGA4RAJJ3uzYtJ+cLjiaE2YZzXLzRkU
         +YOiwD5xYZ6gfQ7tf4rBgs9vH/R+EsXuV+/PTjOcGEqmzSQIXs40z9Xmlq00GIXMY9oi
         Ntdw==
X-Forwarded-Encrypted: i=1; AKwUvBwr0omUVS020Clt4+Ix1+pg/Td2olTj+pK3QJuaWTTIeIW8wSIJf5fE/8h4/RrPf1ezluyekTKpvhEaEW5pgQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIoP+yyKbEZookQ14QQSyNiMD4oEcxIKqSr2V/0g2PELj7HydSB
	FiMoRr0KGUhs4cvAkfgrdch3FCCDSVoKYr3qcy+aKggJRNFtiyHO0rg=
X-Gm-Gg: AYBFou35vqMi7rjKqG4SkS6VaeQRR+LMW8F8LFc0ERkyhDUFPNlM7V+DnpO94n+rHyc
	hRdf/YG+nuAENyRgYKXuVHcDW+6oI5PUT58TJcVD8tTRZLMPwSMB8PsGtBpPeXcbifeKoXGr7At
	kZtO1qyK6sBYDfBro7SbYhzYHZagjnTPkbLf7A1X40jvTQ9g/NxKWCy17rHjoI9fGbAkTK6waRF
	aLP5murm2DvPmipvMYZTmO7U9Mhy0TKfH3IgldkR8HjbEnBWE97LtRxOH0LL42uXWWpSqgZU1Gc
	ZmESwoDu8RHH7APoskg0K9+/4Y8dGVIiFgw6jK/CoVYDGtE8xUiVk5zD1EfXyMsWsfyyIhPhnZb
	bR77cW/HTRtgO/wPY0b0o+MUxXFpGOTrnvIm8qZV8mDlBf/Xt7piQiGwU/PHWYyRpPgH6btMvUC
	B/8yO/nmwDs72rt5KR1+VeWcAkift34kq3QSTha1uwCOdworpMYmANTweV0kgmhr6+IDy3rM7or
	Ws02AdkkzO05X7OCNkIyFJIWz9xnREv0vL4GL0kElmEKuDIU0PS06GXL5PgV/ywNJP9dzIUz7k6
	nb6Az5Ivwq0yGmO5x33fzS/B2HvMWPQc
X-Received: by 2002:a05:600c:3554:b0:4a1:e7ce:107b with SMTP id 5b1f17b1804b1-4ac150b20eamr267450095e9.2.1793647081411;
        Mon, 02 Nov 2026 11:18:01 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm21054948f8f.47.2026.11.02.11.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:18:00 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless] wifi: mwifiex: cancel DFS delayed works before destroying workqueues
Date: Mon,  2 Nov 2026 19:17:59 +0000
Message-ID: <20261102191800.2309205-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

mwifiex_del_virtual_intf() and the error path of
mwifiex_add_virtual_intf() destroy dfs_cac_workqueue and
dfs_chan_sw_workqueue without first cancelling the associated
delayed works. Since destroy_workqueue() does not cancel pending
delayed work timers, a timer that fires after the workqueue is
destroyed runs against freed memory.

Add cancel_delayed_work_sync() for dfs_cac_work and
dfs_chan_sw_work before each destroy_workqueue() call in both the
error cleanup and interface removal paths.

Fixes: 85afb18621be ("mwifiex: add cfg80211 start_radar_detection handler")
Fixes: 7d652034d1a0 ("mwifiex: channel switch support for mwifiex")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 936939ea9c472..1fe366b89a2c2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3196,9 +3196,11 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	return &priv->wdev;
 
 err_reg_netdev:
+	cancel_delayed_work_sync(&priv->dfs_chan_sw_work);
 	destroy_workqueue(priv->dfs_chan_sw_workqueue);
 	priv->dfs_chan_sw_workqueue = NULL;
 err_alloc_chsw:
+	cancel_delayed_work_sync(&priv->dfs_cac_work);
 	destroy_workqueue(priv->dfs_cac_workqueue);
 	priv->dfs_cac_workqueue = NULL;
 err_alloc_cac:
@@ -3245,11 +3247,13 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 		cfg80211_unregister_netdevice(wdev->netdev);
 
 	if (priv->dfs_cac_workqueue) {
+		cancel_delayed_work_sync(&priv->dfs_cac_work);
 		destroy_workqueue(priv->dfs_cac_workqueue);
 		priv->dfs_cac_workqueue = NULL;
 	}
 
 	if (priv->dfs_chan_sw_workqueue) {
+		cancel_delayed_work_sync(&priv->dfs_chan_sw_work);
 		destroy_workqueue(priv->dfs_chan_sw_workqueue);
 		priv->dfs_chan_sw_workqueue = NULL;
 	}
-- 
2.47.3


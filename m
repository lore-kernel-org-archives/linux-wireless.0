Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792704585;
	b=plNAYIhhnr/oMUaw5d66eUM2kKrG4ANQR/5tVCaHNn0EadtVcBxJsHXfWPqmvq07Jis+
	 iuWsbIRet4sZbIYo6Ze/3K9je8ydq1juecJxT0CMbbuNa9Ty92pR1VwY07SPKi55/0JpI
	 rOhfwDrOjdRlLlzf2mrgk2XB2dOJya4rHQuyIfdOq4N3aYv+egaASmeytrbYJFJP9PiU+
	 25jd0aQA6t2hr4TTKTzKe9LPzk82QQZqkjoEx9xI6VvHUF7Q8pQ5pkVWSZ4y3UZonKZEO
	 L/2+0nhsEtIu2jPQxFnPh4U5MOOe0k7l9zibzg4Tbiq7lQs4+GDZMr9mRxOFgLDzqyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792704585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=7J25Ol6OoVWSYnoEuI8c8YQySc1v4KBrwsp24rZ47ZI=;
	b=aCPfwB9ZwMeHaAQbf3dWg28Anj4lsXbl+uLxMHw9Kmzsw31pw777df92LtyuTTj/t1UH
	 f6HIxhdXLAZ2e9hI5ttl9NVYhzdzr6GIn1bSIeuId9xKIsT1oDTaH7/UQJvAT+NaJK8pz
	 6mCqgT+3DlpAWl0/z3TF7Wq/p+VWTBJ1G4gkLecRowW1Cs840mgBc76VGxmaVEzP2lLhL
	 Nc28A7e+yp304xTNPmfVjgbClJ0dxoIHyrg2SDgTO8U+ss5xpPsbERGmSOPN+gt8cBJjP
	 FjlP7miI9rsznxJNADdQAoA+feHU0a8nIjO6K3g5xJdZyblG2JUu4dsQhxtCPXtFOPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KeHky5D4;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C34606A31D
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 21:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3C34606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KeHky5D4
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso1231395ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 14:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792704584; x=1793309384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7J25Ol6OoVWSYnoEuI8c8YQySc1v4KBrwsp24rZ47ZI=;
        b=KeHky5D4w1jTNabuJnhEKXIjEGl39SlghNWMWb0j6R5A8Qnk9REYC7g1bxUVpe7Qi4
         gecwTVCzi1vTPBYBYXT4mAJjBVb4o5kRVGOvqy/+C0g1tiKF57y9RC0gZp706CsTzwJx
         /ZaqEdGN3EprOAlATAR9c0XPIVuiCE4NPy+BJiQYphKIc0oYeh7GuJG2rXMSAP55ZYj3
         bo2ZF6kDYUtazOBZdUO9fPG+Xh7LdJ+4xafYiWF5OeO+eyLUcpX1zZuHDYlFjBDk6w+B
         MrEBwkF3Y028tBcnR+AIphPMRXQzQ0bEBWVd/MRE4+Flq+TfSwttnAO23JGBHiIodhtP
         Hefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792704584; x=1793309384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7J25Ol6OoVWSYnoEuI8c8YQySc1v4KBrwsp24rZ47ZI=;
        b=Uy092kC55aSEMoikY5o1pRn1SF/YdKAfWAJN6WHYJFAYj8aKdmievgOivD3E572VXK
         WmYPszn1/ChjinVvqTfvta95ySNiSwmJ9ataddYTBX+6SFB7R8oeV7m92GJtDo7Ni1n1
         wuyEPPVDxib4PnhXBs+EIAeMu63SmmJ4xY05d6bHCvJQBTAXAOpK9WxGlfnYK8xzxZR1
         J9wsRrJNJpd+RaXLELwxCpDBkCtQWcw7DFOc1+xxWPGcCS/r30H/vigfJVVWGlFk5SXK
         RYUtEBwfwAX24YRl+PVjC7JpSkV+1bUi7+sBctyDIBf7v9bet9Hh5C7HVsaG5JUSspSC
         JRsA==
X-Gm-Message-State: AFq9FYK5vMQpSJzcwiRHkSrEkOE3ICk5T4BlZyQG0dlJAlk267HmXAdU
	krbfStGbpn4MOqVeJT08vR5YUE4MD9DtfiX6SA9XjF5CRgCELXWysjQjXd+aPTFr
X-Gm-Gg: AYBFou2xPg/M7jL64Oyik62GX8DAlVp2TU3K+jBrW/zc8CYXjhxJyrYtGo86Uiw0S1Z
	INjKpH+9l1UM37OiDvfSq8ZYVGL30jJBMRKlt0l5A6bLEb9nkU5jgxPbxJSLL+yIbyNhAQk4iuF
	zeo6qU/mW6PESMEBRwiMaAW+FxDTgQ98VEi0A8auBQap/5AEwOo2tyNsI2K3LFH5NqOn5IdBOAv
	RhpeR4TUNgcGgAlSLB+gI7j7xJE5358psPMsvtBmkrtX8XL7H+wEvjLib9PETmLvAQxMizIx/yT
	jZqhCXSEMO7avO2Q4xXmAH9fASyhn8F2QPzLi10XeGRXw//1QuO/pxZoJm7iE9q/mBKWQDkesBe
	VpQQZ4JokE1SIQN9FkHScqJcZcUIh0C9PZqOrVlYysiXqme83A5FWW5KdsJ43/8XbwH35JDBS4N
	FzikqyKm376XpVTzS/gB5LnijoxP28ftPFY8DEZhkdg+Z0N67DQ9z8voHzDnl6eqO2ZKxCpVbPu
	d9FfKo7yJOzmqvaQuuQ5431Ohf4FF785gZ/+U253f58R2BdBP1f/CalK9MmkqIxIA+wj435+Cpa
	c0EH/4F7dvBuWLP3bIQRA+4woy6B1g7TacrXk8NmMzBcGOgIzsBIBBr/q0x+BVIz6+uysct4g33
	O+sSlGxp0M6P/O0+PBM+MIc4=
X-Received: by 2002:a17:90b:3806:b0:3ac:7842:bd50 with SMTP id 98e67ed59e1d1-3adcdfdb688mr169990a91.15.1792704584283;
        Thu, 22 Oct 2026 14:29:44 -0700 (PDT)
Received: from ryzen ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adca08e785sm606547a91.0.2026.10.22.14.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:29:43 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support)
Subject: [PATCH wireless] wifi: mt76: mt76x02: restart mac_work after a channel change
Date: Thu, 22 Oct 2026 14:29:41 -0700
Message-ID: <20261022212941.3666724-1-rosenp@gmail.com>
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

Since the channel change code moved to the core, mt76_set_channel()
cancels phy->mac_work before calling the driver's set_channel op. The
mt7603, mt7615 and mt7915 set_channel ops queue mac_work again, but the
mt76x0 and mt76x2 ones do not, and they only queue it in their start
op. After the first channel change, which happens on every interface
up, association and scan, mt76x02_mac_work never runs again.

mt76x02_mac_work calls mt76_tx_status_check() to time out frames that
wait for a TX status report. Without it, frames whose report is lost
stay in the wcid pktid idr until another report happens to sweep them.
On an MT7612U station sending 25 Mbit/s of UDP, 48 such frames piled
up within seconds. They kept their AQL airtime and their socket memory,
and the sender blocked on a full socket send buffer for up to 30 s
until a connection monitor probe swept them. The work also collects the
survey, A-MPDU and EDCCA statistics and checks for MAC errors.

Queue mac_work again at the end of the set_channel ops.

Fixes: f4fdd7716290 ("wifi: mt76: partially move channel change code to core")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a5c40d350612..a2763cf648b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -26,6 +26,8 @@ int mt76x0_set_channel(struct mt76_phy *mphy)
 		tasklet_enable(&dev->dfs_pd.dfs_tasklet);
 	}
 	mt76x02_pre_tbtt_enable(dev, true);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
+				     MT_MAC_WORK_INTERVAL);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 550644676201..ab4d0e3f79bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -49,6 +49,8 @@ int mt76x2e_set_channel(struct mt76_phy *phy)
 
 	tasklet_enable(&dev->dfs_pd.dfs_tasklet);
 	tasklet_enable(&dev->mt76.pre_tbtt_tasklet);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
+				     MT_MAC_WORK_INTERVAL);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 66b06a493d95..57550ab3b7da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -45,6 +45,8 @@ int mt76x2u_set_channel(struct mt76_phy *mphy)
 	mt76x2_mac_resume(dev);
 
 	mt76x02_pre_tbtt_enable(dev, true);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
+				     MT_MAC_WORK_INTERVAL);
 
 	return err;
 }
-- 
2.56.0


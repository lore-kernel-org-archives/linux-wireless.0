Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23838223DCE
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781390535; cv=none; b=Qd2PpsiMKyw6sQN9zDxb3HpWqqL+mby5JHFzdJRVrTh660pQ1SOofyORyI/dL11O5LJ1v+3LbTjolF90/NUe5PLihCsIcAFOeHmyftI4/aFaujSUpRyKb0HyVAJ00hOAcAK+5QtMOwbc0SMnTx/N4gbzG0wyKyLCJvUcOJ8B2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781390535; c=relaxed/simple;
	bh=7Hb61hUpIlorKhPGhSNO+jy+7lDYP0YbLcdWej6iBos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNu6i28UxFGkSqTBwDD8LXvyUimzZB5VVtrLnbZz3exJ+AVCb9SVgK4ovdVNPeRKCOJ0c/KkU7VuDcnBtYJV9JbVAO+iEW9uTgOhRXMN9SEc0etLLddlk/UcLu6j8MFp5FcI4WPm6HMXwT7lJLew2msVd3qQN1Av/IZxjY8p1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-304e83724bfso3151026eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 15:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781390533; x=1781995333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CGAauM4goitFf+TF2tRvx0vwIDbDusIIWxEKPxj1h7U=;
        b=TSmJg9MInK5GoIIX3gyE9FyLk2Iu39jbGwemQ9ceW6NkS5FQvfZC9/JHrFLnTLGkZF
         zehkPY2rsfB9sc8i1IL8M3otiexzKEhO8rSVN70s/CFUpl0/nwAKXLjoW2h7SBCbumea
         RFQkfDFS4W0s66bhxOyyJ55PrN5vP+4IpobbdugRHtC8Lutv2D29oFzPPyp+nbGRwb2U
         9SpHzDJbfNRilMGzt0lAuacOS1sPSi/3Aj69wimJyVYGs30S6cdUy3a61pskBEB6zzv6
         jBAUE02aKF9HbcnKuLVh9FGyRFi6qW18XkRcDbwdm7HkFFmdk6N+gg6tBjUfi1ycgg5t
         JtTA==
X-Gm-Message-State: AOJu0Yz5i+WHvAuNi9Yim5P/2pjGORqPqAynXOmYyU15tHDG422NOPQg
	6iiNBevLYnNn8oItH2ocaJbt1KLhqBOy1Kczsmi/7PlmnNcc/FlckAp6
X-Gm-Gg: Acq92OEII80XszuHIz2WaOoXrDmxdecpx2w4ZK0JhTHe8HCg73+/f9f5DfsPAMQpUtw
	vgVbCU+o3z6b2JCO+Kwlp+b+0ghcphDLfeUb2kiDwrfyRMVhMbkkolaVA3bOmqE7Vkko62xUB3A
	zTqZebULP5A6JX/oPuVC+VBDxY1/keNNGMTyLoc1O1sW/5Nx55bTot3p7b32QAPA0Z/3ciuX4uG
	huWPyuGtBv0B64e7kAJgOpeM9SztlHMnpqjVMzxSTFR7glGGjeHvY5lIzFIm4+y8tmXMzt1VTeh
	cOK+NnycCoPcvYkpep7Hr6Z2Ieie9crLSxtFhWZz0ND3x8MbaD4agm09lQsZg0L2rx//knVgKeo
	gWBLD69r0iCbVQ10SJo/QQBMhYXLGzlN7JqtVtB4ELFolzIE9DyuiQUoObCuJk8wwmvehRcwzSg
	NEZ+4bCknil3wtwdzYao29cF57L1UAlr91rIzuxaRcIquGRQEvRdlWIcSO74Y40+KrGQ+kH10fQ
	zRpmcsaLNDmYh4uIUt+wTk45L/+DEuYLZGofv8q
X-Received: by 2002:a05:693c:3b09:b0:304:819f:5029 with SMTP id 5a478bee46e88-3081ff3dc01mr4163594eec.2.1781390533196;
        Sat, 13 Jun 2026 15:42:13 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081eb95450sm11104825eec.28.2026.06.13.15.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:42:12 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 2/6] wifi: mt76: mt7925: skip reset work on hung bus
Date: Sat, 13 Jun 2026 17:41:27 -0500
Message-ID: <20260613224131.2396026-3-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613224131.2396026-1-sean.wang@kernel.org>
References: <20260613224131.2396026-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Skip mt7925 reset handling once the bus is marked hung.

A hung bus cannot be recovered by issuing another device reset. Continuing
the reset path may only send more failing MCU or register accesses and
delay teardown. Return early from reset work and the USB reset path so the
failed device can be torn down quickly.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 0641a7131d7c..d7e4ebe92342 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1310,6 +1310,9 @@ void mt7925_mac_reset_work(struct work_struct *work)
 	struct mt76_connac_pm *pm = &dev->pm;
 	int i, ret;
 
+	if (atomic_read(&dev->mt76.bus_hung))
+		return;
+
 	dev_dbg(dev->mt76.dev, "chip reset\n");
 	dev->hw_full_reset = true;
 	ieee80211_stop_queues(hw);
@@ -1327,6 +1330,9 @@ void mt7925_mac_reset_work(struct work_struct *work)
 			break;
 	}
 
+	if (atomic_read(&dev->mt76.bus_hung))
+		return;
+
 	if (i == 10)
 		dev_err(dev->mt76.dev, "chip reset failed\n");
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index e9f58492bf7d..49ad4fe9eb1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -81,6 +81,13 @@ static int mt7925u_mac_reset(struct mt792x_dev *dev)
 {
 	int err;
 
+	if (atomic_read(&dev->mt76.bus_hung))
+		return 0;
+
+	mt792xu_reset_on_bus_error(dev);
+	if (atomic_read(&dev->mt76.bus_hung))
+		return 0;
+
 	mt76_txq_schedule_all(&dev->mphy);
 	mt76_worker_disable(&dev->mt76.tx_worker);
 
-- 
2.43.0


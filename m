Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254178;
	b=0goe1eDaCDWJrvfLVDciT+tVXdF26/syEUh/ONTMCnJQpfbnrQHJfV2QrZ0krKD1Xyn2
	 SykSSp/gFb83VD/aiFghv9TdewjiflXnPqsUCDLqtwK+aHxP1GRZtl72PuQY7/UZZ0/Lo
	 UJFDQ+G2s2NANhSzyUvNEPQGoAvPcxfyPB3BjVTxTx2a170xjGEqzR/3W/Cow/AfyRmkP
	 c2JfJin5sN8/cJ4pDTRDw6SIEtWRJYqCfQOZlXALZaghvEhZpzUbjY1H0cgLX9opEytRU
	 DtjF1vrNHjqghoWHJGke6R6NMvyqezdHgUhSKqIGCuh1yQIpM+CtuIXvdLUAgrSpxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T6/N8Sdo415avv22xbVSdAnDJryYd8Tk8nbP0Dlim1M=;
	b=AueDJuewY60/eqF4oT7xIfRyQB7+u0vccZiIZwDpUg3Wh3VdK7zdO0aLOaub2gLWMtM1
	 GhRBfumn8FfQ1sMgNbQH6yFYNN79Ozq+iycaSIA/Px3Pa+kT6VTQ8+YY5bdrtSFlEGpAn
	 tITEGOuXznr2RMK9PVWuBi9tabZwIKBS9i3Rvw5ZQdZihDwQ/ESTQEI/O1v2NgaUQTvqZ
	 7OFcf9gH8EPfdJKKWGoYH3h9BUzvacLoKewjcisjy3R3ZXAFM/FlCNct7PYiHFEgiEGT0
	 +msueGoD0FoleudPHcl+LKkNkS6wE+b++Abf5kaH/BPNxazV/8LoYE/rwIneRMuB/sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AkawrUEV;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0044606A31E
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0044606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AkawrUEV
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso808220a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793254177; x=1793858977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T6/N8Sdo415avv22xbVSdAnDJryYd8Tk8nbP0Dlim1M=;
        b=AkawrUEV4fnKBbg7X0/iyZreUp2uxkbyYheAYid/ZVeFDG7BNHBlCbVEh+nFRECJuX
         CFyA+vDKLRr1F7xGR0J/1Qc94druxWe8POaeqUctnGKelaGL0Ax+PCZsq381XjNBFTLo
         3gUgRinQh9GrBcyf6QxACh5fjlm5/CJ/CGV081JNwuYKTUvyK6T3j1IxA2mcJJuVOLE7
         OCnJ2EgiEazE8QvelotJvj9h5MeFumDq7b8HXZ7dU2SbYL1grSEc3MRwH54UxJNEdHpH
         CKs29fnQDeVevjgEi8MMtV5U0WBIRCxgsTV13gqHyuBorvLEaMNYFYcezEhdrOFu3TbU
         i14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254177; x=1793858977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T6/N8Sdo415avv22xbVSdAnDJryYd8Tk8nbP0Dlim1M=;
        b=mrtk/YeKEOM2+qy8OKXZTqwac1vFMbqOxERaBCVU9kQL0U2c/mQS5xiUP6Wy0uMFQg
         /KqkRCoGfSZS3V/mazgm1sqdGM8amUKYqk42bCo3d4YN5QJlhtvLADdzeEMET6cQiQ28
         7j1BG4PC9oXXyYOoUhJw4cxSv7UjZ85GprDEs/29im6Qps7kGCb+kb7u45LjZRBqUO/Q
         Hw4oAuFu+cmeSk6bj9SBqIw3WI4E4DVGXBzBLlL3darzxuDAFds229AAtgHyCJHLUWag
         wToqCrb6ldimRPB/lbFw+OF0vWfYLIqDLhb/fqD4HyjaYl71xYFPMGu/6Oj/LJXcaTYt
         k3kw==
X-Gm-Message-State: AFq9FYJk1SOD9az6O7SJoADkgOuyDRAnKlskTjiwP76SscNHG2B929Im
	UTlHQBYla+f5aV2LKIESfbId6ZwR4wV4ueSESHuIgF3yjqo2c2MggTQc
X-Gm-Gg: AYBFou1lGlkN+KPjGwBMj2oyabfUZHHBD0ThqLZ+cpg0AEBC47PYm85gsi/fty2FMUa
	iqssClQK8unbqWy8CvwiIT9J8ffi3KIC8PpE2LkJuEXzM5+3X5rWvJ45qaeBVGR/5HVX/Fyz9fx
	Cg611JiQR3DDVONmEMB/MyFuXeo9rubIZJ2GoftvP9I4cAzChAl0+QCSzXXakCiFXH4d1Sx/zwS
	vkhvXb3orCLaTIk/7mmWvWqLwTOb9ptnOm8YGXT4s8LgxQTJb99lQKRKYWV7FEvhsAqjXWF8iZC
	nujdH8jx6FRqGQXZQyFh8aBy5PHl3gkO54DN1PHaz3X/qOHtRd/NYf+nPgyYNX4TQb/vUqdBwSO
	NvU58aa8yBF0O1G2/mFLQq1kX2Sap/jBtCzHI1q0t2gvOPl4HONtj82PvtI3/OvJB83ir9Rgjtc
	lYuX8+SY4ywjzITFH4jJn/PNjSijYbGn7JC3NAMbnwlT80amaOjjqkAhkxp9NmuvNtU5l0Kiobq
	b/NIx3TUmKtRDtcRF5r+keHsTMH3mHZrx2O818kjQ7SX7hGJ5omX3rOJ6O2YK/CLb81EtWoRUJm
	pKB+D0Ads1lM7u47DSl/0/X6zqgRzz3gjswxQ/46STBlIfZFeEEpCMxmq7itoJSonGsnz9E/+b0
	tUDs8
X-Received: by 2002:a17:90b:510f:b0:3ac:7378:be04 with SMTP id 98e67ed59e1d1-3ae57ba6c8emr3359982a91.0.1793254177241;
        Wed, 28 Oct 2026 23:09:37 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e83a4f1sm2697459a91.12.2026.10.28.23.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:09:36 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: rtw88: allow driver-owned TX buffers to bypass mac80211 TX status
Date: Thu, 29 Oct 2026 14:08:56 +0800
Message-ID: <20261029060859.90002-2-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029060859.90002-1-hjf3108@gmail.com>
References: <20261029060859.90002-1-hjf3108@gmail.com>
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

Add a flag so that the driver can flag certain frames that
skip reporting back to mac80211. This is used for driver
generated frames that aren't a TX from mac80211.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/main.h | 1 +
 drivers/net/wireless/realtek/rtw88/pci.c  | 6 ++++++
 drivers/net/wireless/realtek/rtw88/pci.h  | 1 +
 drivers/net/wireless/realtek/rtw88/sdio.c | 6 ++++++
 drivers/net/wireless/realtek/rtw88/sdio.h | 1 +
 drivers/net/wireless/realtek/rtw88/usb.c  | 6 ++++++
 drivers/net/wireless/realtek/rtw88/usb.h  | 1 +
 7 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf0..7bd2e224e845b 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -637,6 +637,7 @@ struct rtw_tx_pkt_info {
 	u8 hw_ssn_sel;
 	bool nav_use_hdr;
 	bool bt_null;
+	bool drv_frame;
 };
 
 struct rtw_rx_pkt_stat {
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f514447..5f6df521e9c16 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -848,6 +848,7 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 	tx_data = rtw_pci_get_tx_data(skb);
 	tx_data->dma = dma;
 	tx_data->sn = pkt_info->sn;
+	tx_data->drv_frame = pkt_info->drv_frame;
 
 	spin_lock_bh(&rtwpci->irq_lock);
 
@@ -992,6 +993,11 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+		if (tx_data->drv_frame) {
+			dev_kfree_skb_irq(skb);
+			continue;
+		}
+
 		info = IEEE80211_SKB_CB(skb);
 
 		/* enqueue to wait for tx report */
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 8ffdea11378f0..37d90caf8269c 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -171,6 +171,7 @@ struct rtw_pci_tx_buffer_desc {
 struct rtw_pci_tx_data {
 	dma_addr_t dma;
 	u8 sn;
+	bool drv_frame;
 };
 
 struct rtw_pci_ring {
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9fff..6666aa5245d70 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1312,6 +1312,7 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 
 	tx_data = rtw_sdio_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
+	tx_data->drv_frame = pkt_info->drv_frame;
 
 	/* The TX worker may already have freed the skb, so do not touch it. */
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
@@ -1604,6 +1605,11 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 
 	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+	if (tx_data->drv_frame) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
 	/* enqueue to wait for tx report */
 	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 6e7e6009744b0..19852077326a4 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -153,6 +153,7 @@ struct sdio_device_id;
 
 struct rtw_sdio_tx_data {
 	u8 sn;
+	bool drv_frame;
 };
 
 struct rtw_sdio_work_data {
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d92..f03b00e517576 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
 
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
+		if (tx_data->drv_frame) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
 		/* enqueue to wait for tx report */
 		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
@@ -655,6 +660,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
 	tx_data = rtw_usb_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
+	tx_data->drv_frame = pkt_info->drv_frame;
 
 	skb_queue_tail(&rtwusb->tx_queue[ep], skb);
 
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 94ff21dd08463..e861e9a66ab22 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -59,6 +59,7 @@ struct rx_usb_ctrl_block {
 
 struct rtw_usb_tx_data {
 	u8 sn;
+	bool drv_frame;
 };
 
 struct rtw_usb {
-- 
2.55.0


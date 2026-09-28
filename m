Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61B34D797C
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604289; cv=none; b=RB/wtAo+lLsNe0abau6oCBB6yuCQP4JYGiCLhA+AdxRk6nvznjvqUx/ELmo0I+jA2nBPM0B7BraPpO6Qby6WxarlqL5P7Q5ZWFjnV4eS7wAwR61wzI4qi66dQ9T7l7975J2HnulzlIHkJUFI3sV7srxV/j2iD2cjw3C2D4/dGCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604289; c=relaxed/simple;
	bh=jASAzubG3/1Ohs8axuhKUesKhQPmDAaQp2vTWGVMH3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UrORPu4ydHQ4+U855BV2tPxIM8IqdYEylbRV+KYpIGyFI5SOtfHxcDAVpNSYa5/HVjH0AEFVpM6BAemlurV6BrMcjT4xfJjV/MDZqUdSL9mF50eLgqBDFb7WsYp/OSibOZUmT/gRndnvkkEOdut8hNJBa05lmhRA0Z+J02tAB5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATsYI9Ni; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATsYI9Ni"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2b40e4744eso265521366b.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 07:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790604282; x=1791209082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yyby6O267E21VPls7mPdTMnZ7y58yWOOybub5QTr35o=;
        b=ATsYI9NivXJRCcHDRh48QqOLCcLrNnDSGjkWnctqcCbtc83z6kW5gJK//8LcePMDbQ
         ikY+Xee8ExBIW8vyb9ufYBqeIlh6zuHeF9paUW9/p00pG00oe/oWI0Tt8rtLVw/zC5pR
         rrruCU/FOMOfqEJ7rRgYGSdUKXXzJAXh/0PyA/oAPhyXHIw5li+r2itcYPs13Xt7YZv6
         04BolMswg4LbQjyFAPPHzICIprpHXgUzyoavoyFuBCRTINKmgOaNYKri2z11p+CGOKhe
         dd6TNpts6kFVn3iwuOEkqVggjqKy+kB2PjgGXA7vAeFc8Rk71HD52xDypsVXuIShSFY8
         fGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790604282; x=1791209082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yyby6O267E21VPls7mPdTMnZ7y58yWOOybub5QTr35o=;
        b=YLoKK/xpL1IB4MM+gBDRH07+ndGkSWRYt/s3en+8kw5t1jKKdJ9EgeilJNqTnS94a/
         az87VpjVcVbhNqqh5oDaPCVmuNgMAduHea/2ICcfCqmgHMtbL+w0N/n8UuADzgDFwi/U
         3c37JFpm31jV5Y4+mIrC3ZdEH8K2BLYKO+sMKpAA1w+gwvpg5n0Zsv6sXEDg75eQVpP8
         27LP2iip0Mn+xCkcrkBE7uKWMkTtFh/F6QTOJ5JSh1XXPGRNiJSTpMbGkiMGdRIJtWhZ
         2PPuUOAeHk5MhAIbdznGzmw7Z92WCiqaFPYmxB7ErEUddPfGf/Vlz6AjJDpdtMKzqIwU
         +mYQ==
X-Gm-Message-State: AFuF++n5xsC+Q4SOk1JQWd3VnF8uSXzNk5Uqwg5GdVSkw/KaW7vPApEr
	5xy+lWAtMsW0Nm/qkwhOk3nHBUKMtcfsWcg74TERO8cJdyiqfA8LZbKd
X-Gm-Gg: AYBFou3KS50pvySIX2cRgHSC2Z01i7lcwwf/YUX9CMVXMsMnZJjLuc74N6tYmn+WiU+
	kF1DBIu+I8lLmryvJqF7Bw7sBXn/VU+DEb8yQsddDuCSb6iqVaNJPg17CD4Wjzg41c83YXVP/dh
	kq6Xm7B+QubyVUeGIy3jyDZeZhd+GSORt6jq+6rZr76J/4AS0FusjE3RTK57t+UGBs2CuxtWs5C
	dlTkVTCX1e9mpUpI0t+K50BbTRU+UTRhSZdm6XjWeNc+Z6GjcDYTy6gG5uAV2vf96MTvQnOuKTH
	yKS5PEEvHOt0EiPWDGtAIped2GPsulZc5hrG/PyDhAAv4K87NZdEHrAaoaj2VygD1QdiZJE4OaO
	v48u3jUprqeLkI2+Q8u0ICwJGv66CtN97YjR6pWQs6OA92ZR4ZG7BjhEgZXDT4cV/5Tbooi6llX
	d1FnMYDCO2mqBY8DI0/OEr2rg1nHR55iazB0rzmTsd9pNeONF8SC+DHIh0FnC1F4NGbMzsis5u9
	MY=
X-Received: by 2002:a17:907:c0e:b0:c2a:fd19:8fa5 with SMTP id a640c23a62f3a-c2afd19cdccmr542265366b.34.1790604282009;
        Mon, 28 Sep 2026 07:04:42 -0700 (PDT)
Received: from home.powerhub ([2a0a:ef40:1484:7a01:a8cc:a863:c2a1:d5cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2dd68a6f18sm179642666b.52.2026.09.28.07.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 07:04:40 -0700 (PDT)
From: Quentin Strydom <qstrydom0@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Quentin Strydom <qstrydom0@gmail.com>
Subject: [PATCH] wifi: ath10k: fix Bluetooth RX on ASUS QCA6174 when WLAN is down
Date: Mon, 28 Sep 2026 15:03:56 +0100
Message-ID: <20260928140356.13247-1-qstrydom0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On an ASUS QCA6174 PCI device with subsystem ID 1043:8751,
Bluetooth receive sensitivity is severely reduced when the WLAN
interface is left down. This is particularly visible when Ethernet is
used for network connectivity and the WLAN interface is never started.

With WLAN down, a nearby BLE advertiser is received at roughly -95 dBm
instead of the expected -60 dBm. Bringing the WLAN interface up restores
normal Bluetooth sensitivity.

Tracing and register-level testing showed that the QCA6174 warm reset
performed from ath10k_pci_hif_stop() causes the Bluetooth sensitivity
drop. In particular, asserting SOC_RESET_CONTROL_CPU_WARM_RST_MASK
reproduces the bad state. Conversely, asserting SOC_GLOBAL_RESET during
a QCA6174 cold reset restores normal Bluetooth reception.

Perform an additional cold reset after the normal hif_stop safe reset
for the affected ASUS subsystem. Scope the workaround to 1043:8751 to
avoid changing reset behaviour for other QCA6174 and ath10k devices.

The workaround was tested with Bluetooth enabled and disabled during
cold boot, with WLAN left down, through repeated WLAN up/down cycles
while associated to a Wi-Fi access point with traffic. Bluetooth receive
sensitivity remained normal and WLAN could subsequently be started and
stopped normally.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-

Signed-off-by: Quentin Strydom <qstrydom0@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 335bc7c488e4..4a3c5ce63733 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2069,10 +2069,20 @@ void ath10k_pci_flush(struct ath10k *ar)
 	ath10k_pci_buffer_cleanup(ar);
 }
 
+static bool ath10k_pci_needs_bt_cold_reset(struct ath10k_pci *ar_pci)
+{
+	struct pci_dev *pdev = ar_pci->pdev;
+
+	return pdev->device == QCA6174_2_1_DEVICE_ID &&
+	       pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK &&
+	       pdev->subsystem_device == 0x8751;
+}
+
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	unsigned long flags;
+	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 
@@ -2096,6 +2106,14 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	 */
 	ath10k_pci_safe_chip_reset(ar);
 
+	if (ath10k_pci_needs_bt_cold_reset(ar_pci)) {
+		ret = ath10k_pci_cold_reset(ar);
+		if (ret)
+			ath10k_warn(ar,
+				    "failed to cold reset after hif stop: %d\n",
+				    ret);
+	}
+
 	ath10k_pci_flush(ar);
 
 	spin_lock_irqsave(&ar_pci->ps_lock, flags);
-- 
2.43.0


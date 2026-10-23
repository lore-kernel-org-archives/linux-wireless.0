Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796720;
	b=yVQkPO9xbL994w5o4kTvpBQeWQAXRtRWFHG1YBsMPmET4LsVqzkzwsdiN5uqx4tfg95T
	 dL/cWeEgvsxYT0b3hEMpC0Pgg7zd+L6wqDoI/uNTaL3NJah7eMHB8VbXTdTCqjmHQvRJX
	 ZCOG3bVxfk/oSklc002VH8ZyOzPsWNFPIdTjP4kTVwuWIYGsbvZXYkUk4VfWj7pbeNXDd
	 Js1S2MoLNhHMH4vFaJX8/YUYMFJmtsq9RvSuSmbxO+pZRDh4s/1UvooiSKqW+mRPEw8ig
	 +TUsoD8FZvTXZEu+QVQkO4PZYmTnQmh4M0ns6yabbvUua1/RIMvO/MIp4VWPrJpcBRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+nTlOdCgOZTp2Ts82DPZk/6v8kUc1hZX+9H4yZLS310=;
	b=iQQuSiSuJqmCwmk2OMUoxG8IHic5gjySq/+yGCwYObRR+mVCrKLVcVEDJRedhi7bp68r
	 uXKvby2jMF9RsyYZxNL6vSQ96dlige7imgahrM6CM3BxtHueNwrfN+E9+aM0o9FJSPGl/
	 vp//6M/UyFI+W3Sidm30L0yrvyD1EJSxZIwYyLOw6JxF53l2dWRj/RC/6GDzmOM2GrpPZ
	 NNf4Nm+bJJcSDzN4WEwAxw6W4zqF78vH10VPswOaEha2caDxYOn+5rHmL9104/zTXRrXv
	 P6s5HNgK5tfUv/88M9Er8hGpvPGfUK5oZGmrCDvHWvxfRm78gUTRidmxit6h1ISAoAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lB0RuYAB;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09777606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 23:05:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09777606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lB0RuYAB
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso909658f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796718; x=1793401518; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+nTlOdCgOZTp2Ts82DPZk/6v8kUc1hZX+9H4yZLS310=;
        b=lB0RuYAB0PfUw4f9t2tlh/irvI5rLFxJK6cXxF6tEOhS0D4Bp03usODLTO4+Iu8Dge
         zcEGSvjC/suWyHBBlmUAuMpwaAevYXNQwlJi3ju+mvF8CcwPUDw/Rtb1i9hI0ugHl8Ft
         9SjtkrRvj3e4BfYX2y7R0x3mCMF2FRYswBUo6qGD1TCaAB/GNlNAdNH8yNDocOr3+6+R
         goecTrFi03x6ca0D0HzQr/rbCImtnzXd7Tkgo5GmbOCHVlwK1ZpMnGTlPB0mv61kFqVP
         cLHd6qUKrcRUxmQcHkwIz16UpmDVDQFn85q3lpr7CKPynB0Lj3iW0LUrzwyjWRC8/Yl8
         Y7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796718; x=1793401518;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+nTlOdCgOZTp2Ts82DPZk/6v8kUc1hZX+9H4yZLS310=;
        b=qzzpOV4bY1R8BndwSePtLRgMRj3LEQ4kuSFyw1Nxma/AUs9YNsNtujTmbCBb6Xon/j
         XeFm/7WYXxTsxZ/KME2nczFpL8d8q4xXZJ4dytRGmtER6hnkU21NaAeNt8lizdS5sRQf
         tMvzuGAXc9VCBGcYtYVMmFdV+OmNtIIQMvss3CB6YCgsc8INQTcwCTOwaK9U4XGZSZUF
         mKY7L2/fVtGD4aQ2excNsAcgRZBZsk060NeDbhzyJAlHhm2WsTnv2Dji1SZmWej2sZTQ
         f8blllrHNlorvEP3wBtu+iF1ylBgnTmgVC/ElD7PJy3u1vI5y0yW/sAVTyuh3qZ3J/m8
         rgww==
X-Gm-Message-State: AFq9FYKeQcOk/WAbbExILuxL7krokt5hhWdWljqa3ziqUKR0nolBiRBJ
	4NK0EVvAWrg7YzfEY9+nzf1hdQunO5nnmeCXXqjjVg2kCFtzvSoiYiaKElFMKw==
X-Gm-Gg: AYBFou0bDCeG3wrWmQSOT/RhszZpht4DMgFT2A3HXssNvh8+lzINPLX5uq2rM08g87H
	Bt7PueuJl9ZOvqvptduPBWlUllujsLIiMcsAYfEChocbUOUg/NRcu0/uRmB9eQ6f/Ox06SoJBJS
	XPi6wJBZmJboqu+o5er257SYkQfFSPCOWaBhOkIoVKBGt9f7FZVe/t2MpEk4mVEW9dghWAYfmHZ
	pFVIoab7W5yn27sjVBxsVqnYo3TfijE0NX7eD5UaW5JZI9HsIvKRfNBUumHJ+9P3NAZgUn1Mc7L
	i0C1UGqCi8JlEoWFst+HLTYT7EkBc3oGsGtAbatU8cCQG5oBFx/u8MJKlt5EOGa+9jiKuZHQCya
	iSEU1sXlZ99x7VF/ESH6AlY/1XcOn3Pl+YNxFBFOn/ZWgGCLvQxlrncmfzcx3qWa3BiVTxNQOJi
	1Z5SmJKmtHIFYhpdf0qTRuIWyG1NbERE51OsRvbJbPUO//8xgBcWXXimA8lyzhTQY2x0WjLj3Wr
	GXG3jUmB7ZZ9dbWFN0mMtRYmpQ+OIuoqw3kdSknOiGY/mZMGW6/z5nn9QnZ1XHZ
X-Received: by 2002:a05:6000:2288:b0:48e:20ed:27b1 with SMTP id ffacd0b85a97d-48e3eac4af1mr601091f8f.0.1792796718258;
        Fri, 23 Oct 2026 16:05:18 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8c05sm993158f8f.49.2026.10.23.16.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 16:05:17 -0700 (PDT)
Message-ID: <4ba9e250-0c6d-49af-a4f2-22ff043374df@gmail.com>
Date: Sat, 24 Oct 2026 02:05:16 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH rtw-next 5/5] wifi: rtw88: pci: Handle more RX interrupts for
 RTL8821AE
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Language: en-US
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

RTL8821AE can raise IMR_RDU (RX descriptor unavailable) and IMR_RXFOVW
(RX FIFO overflow). If they are not handled, RX stops. Based on the
vendor driver and rtlwifi, the way to handle these is the same as the
normal IMR_ROK, so do that.

Move irq_mask from struct rtw_pci to struct rtw_pci_gen in order to
enable these new interrupts only for RTL8821AE and RTL8812AE.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
Perhaps moving irq_mask is not necessary. The RTL8822CE, RTL8822BE,
RTL8821CE, RTL8723DE, and RTL8814AE vendor drivers enable these
interrupts, so maybe they can be enabled for all the chips.
---
 drivers/net/wireless/realtek/rtw88/pci.c     | 41 +++++++++-----------
 drivers/net/wireless/realtek/rtw88/pci.h     |  3 +-
 drivers/net/wireless/realtek/rtw88/pci_old.c |  7 ++++
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 35f45e3ede81..ee693395b8d3 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -373,20 +373,6 @@ static int rtw_pci_init(struct rtw_dev *rtwdev)
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	int ret = 0;
 
-	rtwpci->irq_mask[0] = IMR_HIGHDOK |
-			      IMR_MGNTDOK |
-			      IMR_BKDOK |
-			      IMR_BEDOK |
-			      IMR_VIDOK |
-			      IMR_VODOK |
-			      IMR_ROK |
-			      IMR_BCNDMAINT_E |
-			      IMR_C2HCMD |
-			      0;
-	rtwpci->irq_mask[1] = IMR_TXFOVW |
-			      0;
-	rtwpci->irq_mask[3] = IMR_H2CDOK |
-			      0;
 	spin_lock_init(&rtwpci->irq_lock);
 	spin_lock_init(&rtwpci->hwirq_lock);
 	ret = rtw_pci_init_trx_ring(rtwdev);
@@ -482,15 +468,17 @@ static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)
 static void rtw_pci_enable_interrupt(struct rtw_dev *rtwdev,
 				     struct rtw_pci *rtwpci, bool exclude_rx)
 {
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
+	u32 imr0_unmask = exclude_rx ? IMR_ROK | IMR_RDU : 0;
+	u32 imr1_unmask = exclude_rx ? IMR_RXFOVW : 0;
 	unsigned long flags;
-	u32 imr0_unmask = exclude_rx ? IMR_ROK : 0;
 
 	spin_lock_irqsave(&rtwpci->hwirq_lock, flags);
 
-	rtw_write32(rtwdev, RTK_PCI_HIMR0, rtwpci->irq_mask[0] & ~imr0_unmask);
-	rtw_write32(rtwdev, RTK_PCI_HIMR1, rtwpci->irq_mask[1]);
+	rtw_write32(rtwdev, RTK_PCI_HIMR0, pci_gen->irq_mask[0] & ~imr0_unmask);
+	rtw_write32(rtwdev, RTK_PCI_HIMR1, pci_gen->irq_mask[1] & ~imr1_unmask);
 	if (rtw_chip_wcpu_3081(rtwdev))
-		rtw_write32(rtwdev, RTK_PCI_HIMR3, rtwpci->irq_mask[3]);
+		rtw_write32(rtwdev, RTK_PCI_HIMR3, pci_gen->irq_mask[3]);
 
 	rtwpci->irq_enabled = true;
 
@@ -1149,6 +1137,7 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 static void rtw_pci_irq_recognized(struct rtw_dev *rtwdev,
 				   struct rtw_pci *rtwpci, u32 *irq_status)
 {
+	const struct rtw_pci_gen *pci_gen = rtwpci->gen;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rtwpci->hwirq_lock, flags);
@@ -1159,9 +1148,9 @@ static void rtw_pci_irq_recognized(struct rtw_dev *rtwdev,
 		irq_status[3] = rtw_read32(rtwdev, RTK_PCI_HISR3);
 	else
 		irq_status[3] = 0;
-	irq_status[0] &= rtwpci->irq_mask[0];
-	irq_status[1] &= rtwpci->irq_mask[1];
-	irq_status[3] &= rtwpci->irq_mask[3];
+	irq_status[0] &= pci_gen->irq_mask[0];
+	irq_status[1] &= pci_gen->irq_mask[1];
+	irq_status[3] &= pci_gen->irq_mask[3];
 	rtw_write32(rtwdev, RTK_PCI_HISR0, irq_status[0]);
 	rtw_write32(rtwdev, RTK_PCI_HISR1, irq_status[1]);
 	if (rtw_chip_wcpu_3081(rtwdev))
@@ -1213,7 +1202,8 @@ static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
 		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_VI);
 	if (irq_status[3] & IMR_H2CDOK)
 		pci_gen->tx_isr(rtwdev, rtwpci, RTW_TX_QUEUE_H2C);
-	if (irq_status[0] & IMR_ROK) {
+	if (irq_status[0] & (IMR_ROK | IMR_RDU) ||
+	    irq_status[1] & IMR_RXFOVW) {
 		rtw_pci_rx_isr(rtwdev);
 		rx = true;
 	}
@@ -2005,6 +1995,13 @@ const struct rtw_pci_gen rtw_pci_gen_new = {
 	.rx_napi = rtw_pci_rx_napi,
 	.clkreq_set = rtw_pci_clkreq_set,
 	.aspm_set = rtw_pci_aspm_set,
+
+	.irq_mask = { IMR_HIGHDOK | IMR_MGNTDOK | IMR_BKDOK |
+		      IMR_BEDOK | IMR_VIDOK | IMR_VODOK | IMR_ROK |
+		      IMR_BCNDMAINT_E | IMR_C2HCMD,
+		      IMR_TXFOVW,
+		      0,
+		      IMR_H2CDOK, }
 };
 EXPORT_SYMBOL(rtw_pci_gen_new);
 
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 92532f842ebc..74074437e34b 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -231,6 +231,8 @@ struct rtw_pci_gen {
 		       u8 hw_queue, u32 limit);
 	void (*clkreq_set)(struct rtw_dev *rtwdev, bool enable);
 	void (*aspm_set)(struct rtw_dev *rtwdev, bool enable);
+
+	u32 irq_mask[4];
 };
 
 struct rtw_pci {
@@ -241,7 +243,6 @@ struct rtw_pci {
 	spinlock_t hwirq_lock;
 	/* Used for PCI TX ring/queueing, and enable INT. */
 	spinlock_t irq_lock;
-	u32 irq_mask[4];
 	bool irq_enabled;
 	bool running;
 
diff --git a/drivers/net/wireless/realtek/rtw88/pci_old.c b/drivers/net/wireless/realtek/rtw88/pci_old.c
index 464b57d8a629..ef2da0adff37 100644
--- a/drivers/net/wireless/realtek/rtw88/pci_old.c
+++ b/drivers/net/wireless/realtek/rtw88/pci_old.c
@@ -518,5 +518,12 @@ const struct rtw_pci_gen rtw_pci_gen_old = {
 	.rx_napi = rtw_pci_old_rx_napi,
 	.clkreq_set = rtw_pci_old_clkreq_set,
 	.aspm_set = rtw_pci_old_aspm_set,
+
+	.irq_mask = { IMR_HIGHDOK | IMR_MGNTDOK | IMR_BKDOK |
+		      IMR_BEDOK | IMR_VIDOK | IMR_VODOK | IMR_ROK |
+		      IMR_BCNDMAINT_E | IMR_C2HCMD | IMR_RDU,
+		      IMR_TXFOVW | IMR_RXFOVW,
+		      0,
+		      0, }
 };
 EXPORT_SYMBOL(rtw_pci_gen_old);
-- 
2.55.0


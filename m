Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792847924;
	b=wbeI/NhkgdD2INBpKatSNVdprtAqHvBzMarCGgzP87cQ21PFDHCpnAXjXOCknP7E4YLJ
	 WWCMfmDzSTbt953mxxJ4kiXy/QdcHNGnBKhh7Rrf4SqPwSx4uy23VpgwexiNW78XmYKtS
	 MZl68dFU9U6C2wfcj9423omZpl1p9Ay6VVNUq6ubIFHvHN5iij+txxJ820C2jIAXowWdK
	 tgReV7uRvrXCKR9i9OFAY4yUStZXokw3aI7ZgdySNXuReCAd4U9R31Vgs4ADVcLz1zs+n
	 vDRaKcE+LMKebPSp+67xgdPs9GGd+i6+ibmAiwxjfSNUSergerbB5jgD8RfkkUbYjww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792847924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
	b=ZfWIOrrS3iYOOfuO53vgldPfVxV264ss1mU0phTh1eq/VdP4SwLBh+ErNHHof/qodgfX
	 2y5q1oDouNdnNDuxqq4GV1jNzHfiPADx2jxrjCjkmlmbBTU4kcRm/aQ9hCR4H065RYgUY
	 JXZcJXoONKEAqqbTq5srPibFvb9qPpVDushipx5+QYdZPMeNvTmMcKox/l2qPHc6s7EJm
	 ylSYHSPSPQ3uk7tL5ElX/6MrONSp/3LZG9p1Sa452Oy7/QP6OZzKUg+vLmOYi8tbUypBb
	 lQMmqO+hicPe/1YBZLdLgEVhqM8MpXYZaV9rmgaEmEtiMQ8LXX0IbGxxBWNHRotanaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dWXcPICu;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D6606A31F
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 13:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 931D6606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dWXcPICu
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ac76a02368so2196863a12.2
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 06:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792847922; x=1793452722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
        b=dWXcPICuI5RutYG0stT0mWxr/6mtb1L0h7kPXEXl4+n4pgy2yiaNbrrMGe8wE+JNhQ
         igwWIYtv/4WeH0U0yWJG255me4H0JKq5osY52AL4peP+BfmdA32hfUKqofO3xPOVHSp4
         dVNBPZWpLiQT1QThVyMobFfwS41wlRLV0PDmynwIYBSsAYmL65UyU6hgm5STvbzPrDzz
         hlDQwJKFXvvyrLNxZtM8xFRaYyAMJP0oM2EgZGcUAW+Vh2Q3uWzKVgRlLP69zy4Q1mJL
         VA1pWFGHGJXN1L+JnRqj89aHysCGoxDIm99ZFt/UnagQJYtNr4J2EMEjcRIPVFlEC21n
         tIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792847922; x=1793452722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
        b=QXCZGVDm9PPwafW6wTot4z+H8c3gAHPCQ3WyjPCFZIvUeV4ZvE9NR1e61DgK/LeVQp
         CNTtPdMNHvBsettIRlCqIEwsPHUeMJxfJ8wbwdgHrZB9BCKJ2uI4sEUdEEnnvRkv4f1O
         k7s5iARIeQw2b0hIIIXbt3+QP0ieW71Dzm9Yg1mkm3e+/+Qwdu3sSNZHLx2XMwxBTZb8
         NLuYaieiMtyKmHszxUvt5g4b/3vBYTZN1h62oTdQbMEhux6o9EMImWabbDnnOwwuN0tC
         2cvS02H+V5r2w3/XCq3vu00XsgDrFUm2/GrNxqtzl4W7IHwwVaXUHT8EWCEies3NB8Ol
         iwmg==
X-Forwarded-Encrypted: i=1; AKwUvBzt3Itz/FGYiIhcU5pTpt2rNMmPEaUfJXIk/RFiyM4qSzklM0vC85ApHCaNPpAvIw7WGnmMzUP3wV+VCNCcYA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJW3mCAvqdcYkeQ4Zm9+YNcKUv/wOQdeoZ+9pYkZtXJqfJ4Ux3s
	1POLnII6xm24HBLiAWu6ymPVo8VpMfUOdv7eokIRAJk/yLpmrQUOCA7K
X-Gm-Gg: AYBFou1HVz2b5x06Rujv5GbBMT2BvTYQvHrR7DDvNlWS8kutNvx5AzcJwTMXnKCBNYW
	9cUabxpK6QqkMgXelbnDhXfxp/BKUvyswpBBc7PiCfsZTkqme3/82xiJ4ClEzYr0ypsB59UwUeU
	Vt/Wx6Wza4uUZibeSsQWiI21jBcZs7vS2M+N1Pe5itMgdjOjD5hWVX3swFmBfRTjLZkuNZm0KIq
	Sn92n+RrlM4Keh3HxoN4shZCTNRm8NJX8vblszll35kvdU6mzRdBRCaWg7JPoxH+exE5Ajob/FM
	UUPRaLrRUwP+w4AiPKJqzdDd0d4BedGYebEYPlPCwhjGKp+LIZw2NQY8pvNZhN7nE3FmG2rg7vj
	TrzmvNjxn8fhDHrdPZs/iei6uVCzxuZ1FTus1eJRHThYw0O+Sqgu3/O75nthLFIGGEuFHwPcO/M
	8ZQTh4JfOAsATVieDVPC6u8FCUsbN5S30FL1RI0eo+yNyOvRl3rN1wDYTZFQoI/Wy/nLOgX2iFp
	eMl3bOP0V3w+n0+H0+n7K06hiTwOfbspWZWO+BZO3V2MnVGw3fPznPFC3LlclHDTagfnMurFKSz
	tiGnVDTK5oAMyqmuiQ==
X-Received: by 2002:a17:907:d649:b0:c33:392f:7ca1 with SMTP id a640c23a62f3a-c46bddce42cmr186626466b.17.1792847921987;
        Sat, 24 Oct 2026 06:18:41 -0700 (PDT)
Received: from localhost.localdomain ([185.65.135.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd6276d8sm87306666b.41.2026.10.24.06.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 06:18:41 -0700 (PDT)
From: Hedi Ben Hamida <hedihamida096@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Hedi Ben Hamida <hedihamida096@gmail.com>
Subject: [PATCH v2 1/2] wifi: mt76: mt7921: add pci restore for hibernate
Date: Sat, 24 Oct 2026 09:16:52 -0400
Message-ID: <20261024131715.64435-2-hedihamida096@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024131715.64435-1-hedihamida096@gmail.com>
References: <20261024131715.64435-1-hedihamida096@gmail.com>
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

Hibernation powers the device off and on. On resume the generic restore
path runs the normal resume sequence and can time out waiting for the
hif-suspend MCU handshake:

  mt7921e 0000:03:00.0: Message 00020007 (seq 12) timeout
  mt7921e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_restore returns -110

Add a dedicated .restore callback, mirroring mt7925, which skips the
handshake, resets the device and returns it to its pre-hibernate state.

Tested on MEDIATEK MT7922 (14c3:7922) on kernel 6.12.113.

Cc: stable@vger.kernel.org
Signed-off-by: Hedi Ben Hamida <hedihamida096@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7921/pci.c   | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index f87c44f2a..00532b29f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -549,7 +549,7 @@ static int mt7921_pci_suspend(struct device *device)
 	return err;
 }
 
-static int mt7921_pci_resume(struct device *device)
+static int _mt7921_pci_resume(struct device *device, bool restore)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
@@ -589,6 +589,9 @@ static int mt7921_pci_resume(struct device *device)
 	napi_schedule(&mdev->tx_napi);
 	local_bh_enable();
 
+	if (restore)
+		goto failed;
+
 	/* restore previous ds setting */
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
@@ -602,7 +605,7 @@ static int mt7921_pci_resume(struct device *device)
 failed:
 	pm->suspended = false;
 
-	if (err < 0)
+	if (err < 0 || restore)
 		mt792x_reset(&dev->mt76);
 
 	return err;
@@ -715,7 +718,24 @@ static void mt7921_pci_shutdown(struct pci_dev *pdev)
 	mt7921_pci_remove(pdev);
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(mt7921_pm_ops, mt7921_pci_suspend, mt7921_pci_resume);
+static int mt7921_pci_resume(struct device *device)
+{
+	return _mt7921_pci_resume(device, false);
+}
+
+static int mt7921_pci_restore(struct device *device)
+{
+	return _mt7921_pci_resume(device, true);
+}
+
+static const struct dev_pm_ops mt7921_pm_ops = {
+	.suspend = pm_sleep_ptr(mt7921_pci_suspend),
+	.resume = pm_sleep_ptr(mt7921_pci_resume),
+	.freeze = pm_sleep_ptr(mt7921_pci_suspend),
+	.thaw = pm_sleep_ptr(mt7921_pci_resume),
+	.poweroff = pm_sleep_ptr(mt7921_pci_suspend),
+	.restore = pm_sleep_ptr(mt7921_pci_restore),
+};
 
 static struct pci_driver mt7921_pci_driver = {
 	.name		= KBUILD_MODNAME,
-- 
2.47.3


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647074;
	b=5nxXFsUCEQn7evDRvbAaNHFJU0nrK93MDRA9FWRZItGS5vYGTNobBU4tb+sFq/Vu5XDd
	 Rx8BG6rWBbKK/smdICTGNOKm/gfczu0f3EazgLRsbCBT0BXFwdMJyzih3fLRNYmLK+Idu
	 J/rXkYcbnnCk6PtIn2j7XS59a8nmBEhJOztgWMdPeFWXC4TPa/6F4oSfVEkge+V7nW/SQ
	 2tOZvmH2xKKALz/HDzQ+DujFqQaQr/JaPb3TQ0X/r6PkNimkzwICTRVr04SBd8sgGCRSQ
	 ioJOASueo2mC7ZpMl4mOaXkHF99+/CoDRbgammZs6Vzbh9MlIpmVd1pLFv2LfZ5DrDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVE8zme1iRyvaHJJXQb1UnPAk3BxoHJBltYK6kSmEUE=;
	b=QblR0R0WxRh0HVaXd0/5pxMMS2Bo1VDyFmbAUXOEGzYFbOQQU8b5n8VPNDNavxbpDNBf
	 ulh1E6IsNRBO5ekL8e0MNwcjCK+L+nEKEPMjFQeifvRyzUdspPPk+JBf82VmXgHrXYdmQ
	 xdiGm/Zn9pj32n9qcY90nh2FCv7Nh/cB4CTd6GDwF/ZAimdPnMoLoP6wIQ+TK8vsPj2x0
	 ocVRv/FywgP54Twj7PBbkwbdnuAGWxOa8GU+1X6RUS0HkD/uJ06W15gqUGOTi+j+4UFmz
	 JFiwBjHzCCw9BvB//HuRvJ9dB75eIldCOFvPbIHlPvRnG5ejNQzMArlDdjLSUIgFjUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pS5Pyk;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10C3606A337
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 19:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C10C3606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pS5Pyk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so34442565e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 11:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793647072; x=1794251872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aVE8zme1iRyvaHJJXQb1UnPAk3BxoHJBltYK6kSmEUE=;
        b=m3pS5PykhHodyqYuJX7hbI7UnTabwyROLm/nHosoRh1WH8eaYcpdCffqwnGJZ5vlr6
         J4m2HnK+qSU46GAGHphS0pQUdIaTe5eS4fHma2m1WlWvOIB15TWZ4hydxRUI/f7DrznN
         ZD3ekvoY6/ZfUGzRvI8oKEcF2VK6+fwODHyj5o4MPrfie8oWYl8BGgz6HWGrbPV0zwxz
         sBblv4fRnzBuKs4k71fXjtr0z+ahRidzy6ORUFT4YXW5Eu/yBwItKZe4BhpG/LqE6L1x
         DdYY3GY731RDK5tnmwm3ZYI9Jxd9jb6cCSH0jaU4WJiQqbg2DBg5iGdCap9sblMd2+Yt
         4ezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793647072; x=1794251872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aVE8zme1iRyvaHJJXQb1UnPAk3BxoHJBltYK6kSmEUE=;
        b=q1iwJaP8jo2xAPa4cxCWgah/gnUPcy5bqJJkrXSD9VjbxTYDbbO1FtzWOc5mtzlzPX
         Oha0iLbqtRpZKhwj6CR8qaT37UsOVv1CD4I5tpQRwLccZWz70p8oFnlBw33NzocGei2D
         JsN2jcRJKXlxrSW7V0ClS9DI5njYi4O4/ch78kjiX3K5q/kDkHc6hsMk3OIwE3unzIsQ
         S3+BzqxjEeAXhZzZwD1mTwKzdgNBUQXnqSeAnU4hwBphCze9FORAPtFU7kTH0u/9ih8W
         YLI1AQnrYi3K9d3f6AR3+m+EN2PtO83hdtNS2+qVWdwmoInyKTqGaKDcm4nLvlRy98il
         rLgg==
X-Forwarded-Encrypted: i=1; AKwUvByyNEXO5ZrDm+Uye9Z4wXgWauebkEpWvGMF1nnlMWjov9byDi/wgYjhsdCmFpaZ1IVaeu+hLQxphL7egQXXJw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIqP6+qPXtki/w0HVBnDnU0DwuqHl91sTJo4SuGyKmCzGDp2QOp
	wIK57CEcN2OalJKuk/yFAK9ucuQIVFb3jhF6AHP0xMXfx/IeLhY2HNE=
X-Gm-Gg: AYBFou3Fs2bXfW56w6DD+dUwFYTtqdBf8s1XFVdsqDITSLJklRDRbFZpO+D5KpmDn/H
	ZwhyMVrMhR5EN2PLaVyzC5qg8mR8E0kRBVeJPTMyDbndv5itGQ90kZvm+AzmRVPVuR4vj03xh1Y
	Enm04CKpq6TCgwFMfXpTm95KkRzvMS8syspoChimSY7URhirDs/m18D8pFSdqGiy+2SxFXiyG4S
	yKSu+1WNb2dozhp18QEcULgMTMpjm0ANdjPWSqdfe+Sq1XSt9bwSB596Ce3Q2g1QDyWF5gkhZmS
	j+7+RbcbBIDZqC/OtrvGfeXj9jdIy8Q70DcCocleOdH2FNtqmPBHmEz3pz6XpvHEzKCLG38nRRx
	K8KEz2hq+yn3UOKCYKbgkrBVUK+uga7c4vqCLkVXtlafoO1HY0W6Gcl+5PwMWhCtK0kE5A3rzoc
	shlzLGoJr0rsDuc+FEJkZft7lLdawYgcU18ljsVQl8K2H5AF9O7GvdqGgKyCbvAd00ywNvm3ypx
	FBXhcHOybb9I5VW8KzXUvXnh88fYKIpKMGfMm0S0nFzRE2yCugqMQFDVaLM7GrpsTec+Na9rB/2
	CsS3Cy7ZsL0=
X-Received: by 2002:a05:600c:3b18:b0:4a1:c5eb:b445 with SMTP id 5b1f17b1804b1-4ac1932b542mr261291925e9.35.1793647072092;
        Mon, 02 Nov 2026 11:17:52 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d4f9sm21801298f8f.2.2026.11.02.11.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:17:51 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless] wifi: mt76: mt7615: cancel coredump delayed work on device unregister
Date: Mon,  2 Nov 2026 19:17:50 +0000
Message-ID: <20261102191750.2308294-1-tristan@talencesecurity.com>
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

mt7615_unregister_device() calls mt76_free_device() which destroys the
workqueue without first cancelling the coredump.work delayed work. If a
firmware coredump is in progress when the driver is unloaded, the pending
timer can fire after the workqueue has been freed.

Add cancel_delayed_work_sync() for coredump.work in
mt7615_unregister_device() before the mt76_free_device() call.

Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index a9178e077fd6d..c06b0301a4e4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -124,5 +124,6 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mt7615_dma_cleanup(dev);
 	tasklet_disable(&dev->mt76.irq_tasklet);
 
+	cancel_delayed_work_sync(&dev->coredump.work);
 	mt76_free_device(&dev->mt76);
 }
-- 
2.47.3


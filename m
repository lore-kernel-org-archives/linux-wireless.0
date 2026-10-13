Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E586B15E8B
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849732; cv=none; b=i80KcT3mNxTj7ewjEXLCBZQucrZWckV57i3mh4jX+miy3LQCipYpSRUYUphH0a1IwYOdD2ltAsnABf7f/njPjOSBpB3ahMTVSwxedj3zkI8cMFYO2UgHUZTQzGTwA7I6K9LEtn4WEk01UG1EOi3QxuP6rqxviGwTp9twva1w5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849732; c=relaxed/simple;
	bh=3a+AMT0v6khTMsbtA0dy9SfSCDaJ+qcU//hG18aCDQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ulb4NmMAobEgqxpq/bDhEYb8IsEzIspD/mTUgeTaBZIoHF0zGCUlaeH8cP6Ejo60gGdPeB93LJC/XsdcCCGJXZNKCRK3q7BVGZoaIx5BGgf49a9ncuylvKN8rzAxk0PAKYfwVplSgr0J8KLDb97XMeYZv70twT2vOtCqL5arsGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r5nbRKKD; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r5nbRKKD"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ae27f06c2fso3694793a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 17:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849729; x=1792454529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tXW/owfqKGVcmAOIQp0k47hmuuHXvmL9jkkhytfXhXc=;
        b=r5nbRKKDNq5v+ZWfYRrdBoBKY30R/fHAhWbb1u5IG4TErLVR8C/Osq4gGk4UkbKV0I
         e6hTr5lglrkv8Yw9J103C1bC5M6on71GHbJc65tqOC7Jew+4+ZMKfzr86x0HDGco9eS9
         45c7zBN9ot2wnl8OqHKwhdnBLUjHa0/C7S1MXPt36qt4k6l2PnOG4y/qakH2FJ0pcDBf
         5zizgmgfsMtIEoqxnhLBYrN0Zis2w7XWrG3YtUjg/TRItQVwtA3M16aTFDI6ojvAzYA7
         vQjyt4bGhc8xEY4tR4uCJlO+RnokYTkfiU8y6/2oEjC99GzVIb9GhoQJrtIYPWT+NvvY
         7IZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849729; x=1792454529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tXW/owfqKGVcmAOIQp0k47hmuuHXvmL9jkkhytfXhXc=;
        b=o0a72zn2eSycxCAtDbh2iBk8q54NXmwl3Ah2Tk6Sy3IDde/EOGmbZ91nBrbr0sf/v3
         xgVoAMdSUy0Yq9Dq/I9v/MW6QL5MTTVaf3TEY+LX0eCtJbHwj8bnkAa2QQ07sEr6J61L
         Koq742+2yOsKRcRitvZmw0Hm0z2W3XpMNC/T0ZlvK4EcCYc2GWyNwgtbHDEIYDpz73r0
         f+AxpyqK4FMWAuyxsrt+i7u2VzNW7sZ5moyBz21ENOuIdPgR/gFfuTren/ybYqXGQ8ez
         PQ2n48w2LmmJSDt4dHZgMPGhd40mRma+OCGvTNytDUEQ/CSZxrKfMhyNJf94e/OuD3pJ
         i4cA==
X-Gm-Message-State: AFq9FYLBwGH1lhoyU83pFfjd1efMz0lD8J5Zz1VaBVgqgYr/IaF+s4Td
	+WUHmawnyvDkKVRf5Sr5HYcm8rRQ1GIBH2tQAVuisfTk8zTCGEhsUZHeKZ2qeOBg
X-Gm-Gg: AYBFou0IvIT/hzWj/d6TX/HRn6WH1LnY12aCz30xVy7zwjJXNf3qlNviaSv2xu57w+G
	lvNTTwKFDfhDQ6Q8swzPmy8ehhZ45EdFmqxoYwDTboHRiARozlJfSsNj6X0SmWFv8T+Zb/plfH5
	JuC4+A1ZaYQEpXNNE+kJZ5Cg/xEt5bnAjVQG6VARGe93sxxj8tTJ0xFDqne/RLJji8aGP6mioBt
	dE/ePn0ib/QqO34cSolclQGhoj19NF7i95B1ipyTXEEdY1mg4tx+Nv2sAbbkR5VBPGlMI3zxy3w
	Oo5igZfBdyGQSOU2FHQGy7ipYUCEB4VmF9fMPnn2+xwYCRfR3fWrr6qx/5wxIDzh+mAGA/hCEBR
	es2WWVZVjXK8zrno95w7EjRs4MxKmb4NqVYlxTc7M8x5KQSagSu6cCtDNWWF+27Lr9Hro+7D4UV
	Lh+d4PAnLf2virVskkSSDLyESWmXjFUToWBEEFzpVOBZi/Hlf+XfW/xTUifOArSxBfse361PvY+
	s0uapgpHJEDExeNuqEyY+nqQnc+MzU/tXwN3HbK87XifBLxTL65jyWEDm7j6CHtrNqu8G8AfAnQ
	Ode4f3n5Z1MWXbAh71JzIxUlXlvGdr5rU1usC3ks1/2JpodBPOoUdr/LPCX9ERedDuICyt7J0nY
	kp0Nz0spIobQdvNk=
X-Received: by 2002:a17:907:7243:b0:c26:19de:9138 with SMTP id a640c23a62f3a-c31aa0c3392mr1079230966b.43.1791849728967;
        Mon, 12 Oct 2026 17:02:08 -0700 (PDT)
Received: from zwetschge.tail45b538.ts.net ([2a02:810d:a1:6000:a55c:f7b9:d145:2469])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-c31a9ac924dsm527221166b.70.2026.10.12.17.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 17:02:06 -0700 (PDT)
From: Andreas Wendleder <gonsolo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	Andreas Wendleder <gonsolo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Tue, 13 Oct 2026 02:01:24 +0200
Message-ID: <20261013000124.48605-1-gonsolo@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

b43_one_core_detach() frees the struct b43_wldev it is given the bus
device of. b43_bcma_remove() then reads wldev->dev again to free the bus
device, which is a read of freed memory.

b43_ssb_remove() does not have the problem: it takes a copy of wldev->dev
at the start. Do the same here.

Fixes: 96838d61102a ("b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 817448e..3825b6a 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5677,6 +5677,7 @@ static void b43_bcma_remove(struct bcma_device *core)
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5691,14 +5692,14 @@ static void b43_bcma_remove(struct bcma_device *core)
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	/* Unregister HW RNG driver */
 	b43_rng_exit(wl);
 
 	b43_leds_unregister(wl);
 	ieee80211_free_hw(wl->hw);
-	kfree(wldev->dev);
+	kfree(dev);
 }
 
 static struct bcma_driver b43_bcma_driver = {
-- 
2.54.0


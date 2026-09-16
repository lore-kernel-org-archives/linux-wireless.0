Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39CD45040E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544283; cv=none; b=cWCEZ3gMXhQQWQ0ROsSVbInRH+nOO1/PzwOBhfTf72jT+rW1xvpSfPaxtpSY0ELyiVl/TS/JkS+tfNJKDI7f2giaDLl6+GOiIQK8dpNfFPMfMLgrjEnraggh63VnuylCRO54Xaifbk9qnDYourHtYCJrN8tHMkyhKN+aASvXrLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544283; c=relaxed/simple;
	bh=j7jgslCWBYoA2+D+WAWshoZXYUkf/W7ampu9ziB7JwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tD2i6r1MvMaUlXTGa0H21BNCJUIPV4uMZnE/PPRr0ZwapmPrO7schZ1pg2bbUjdSonkvF/HPS6POvlRIMVesENi7YLkXbN0Tkyd3w+4q5OW6fDeBrjMF4Cer5/L/Sx1DlbUsCtxnoXqT+nuUF2NSkVRgNZ0XAA4jDpDo5XH2Mhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLpccVq0; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLpccVq0"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b9184fa80so520477a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789544266; x=1790149066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4H2HhVJ8R9paQExr1TkyHeGUkf1dKuUDiaC/9DA+VGI=;
        b=nLpccVq0hHtlZbNAs98Jgt+76CGfUX68Ln80oDkeQBlYy7JFmmicRJ6k5gf7n2hv5V
         Ry1oRlg8QjBtsoAfC+ya83R+2uJtl7axr/P2VPBSNmxesoYqY8EWax0pXo3e6tD4t0J1
         lpRIt4KrttDtGEOKLOD4E7mgRhsDkGoUtZRATaGdqxmJNtC4lMKPF0D+PKLwgTEN1+ME
         /kTVJl63FBlC5rREfmacX0EIE/FcrCyX1sTO9cKTWKaY58n6sgeIazAaSXWf8AZbXOrL
         yO/EaWBYSYj6Px1lEVCI/N98hFD0z5eB4cjgpU3Cvhv+UQvd4G/CODofaGxRuGbUQF+x
         uqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789544266; x=1790149066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4H2HhVJ8R9paQExr1TkyHeGUkf1dKuUDiaC/9DA+VGI=;
        b=sXceGyk4fwxs1wIFAEJafu5I4gFJoelsvbHNBtRq9aFyXdKKne3NrKnzGLewUGP09r
         jpsXObLx2SicrQ0dvQ9c1FF+1TFwFfMhmwteUhXw0lX7NyQ4hyx3zIMxhjlBSQIe5BYh
         7rU9Do9+pV86aYVtX0Gcs/fsnX7wER5JoKUGjMAWae+k1UjsM6HSdMeKZVAY0oyM23XB
         9BmZN+rDvHUVeU4t3gFI3w5DcI86a3PsJSAu2L+3e7VIUqSdcMJKeKt5HLBDqbna9/pl
         BieWueSwfIShG/2c3PP+F3Ks6cqe4FXEyxWpR97sqPsqIVp5jHoybetVnoIi9QuNEjj4
         1blQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5AIUpDuk/OeMncIjIPLN/aF4SqYnXVxD4xYCDcswz1MXu9mhXuv9nN3qDBrv2xnKdzllnYU9tyrr77Rf3ZQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mhqbHZa+pPf2H7ipcoNOdEhB15wFHB+bjY98NRq61MPJaB+hAw
	vKUjFQO606LL9P/fNXndkHDJN8ppgaJFsdEvKjqdyD7P0xh04VrOoQdN
X-Gm-Gg: AYBFou0MBXXCYIgZunkscRreo/QM6UTQgiwvLlno2uaz2zoSGfxIzstbxFApP4B2VDP
	hz/loeVVPktOjsgKBRsnS5mmMiwnyxDIRj1ZSpG/uQwr1b8MEUnZKuDPlJ5ME2d0tmyJpog/hlj
	KrJFLI1r6UUZsF31hU4uNX4AJa1OgTuVdblT/73R7HKIGOQxrswVcXUuj8lCzQvpN0Aha0Hkxur
	4SmA7NYswIgSbvT62QlVFogYMmfIoukr0zPgZtV2XgcZKm5eOyfO9njnatLtGegSR/LpM1YKFCf
	KooV9oRH3r3Qs/Eeqc8NWoAJFyA9VdCzjVvH2fBBi0NEiNJkR4uiPzXYR4By1LnN4WiXiiC9bog
	XBiN/np+9Q2/ohYnTpAqFTJEbU+1ycenAuJBUuM6iFj7dIfcdPf0e0eIn9WhJ4NLhP5dzO7t3n+
	9/3ifVkXJMPfFcZaKXVgqkSGz6OBzaJPnR6WAsbIJAHNVesJst7GtPng==
X-Received: by 2002:a17:90b:3b91:b0:398:a486:81ec with SMTP id 98e67ed59e1d1-39e1e380e12mr3888761a91.11.1789544266209;
        Wed, 16 Sep 2026 00:37:46 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1c337e97sm897181a91.2.2026.09.16.00.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 00:37:45 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Wed, 16 Sep 2026 15:37:36 +0800
Message-ID: <20260916073736.2952028-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

il3945_pci_probe() calls il_eeprom_init(), which allocates memory for
the EEPROM data. The probe failure paths release this allocation with
il_eeprom_free(), but the remove path does not free it after a
successful probe.

As a result, the EEPROM data is leaked when the PCI device is removed.

Free the EEPROM data in il3945_pci_remove() before releasing the
mac80211 hardware structure.

This issue was found by manual code inspection.

Fixes: 073d3f5f1b3b ("iwlwifi: changing EEPROM layout handling")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index cbaf250626c5..f7ca182d1494 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3807,6 +3807,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);
-- 
2.43.0


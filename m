Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9BE386C3D
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 04:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789273598; cv=none; b=itWZwxUL66cBgh72pf3GRmdQPMnd1ErWS5qU/uhEMD59UeHEMkJaN0c9KBuXQOkWci7Fr3DxvBwS+RH+Kek4Aqvcml1biS90e3IiJjJ3apvwP7tflJQLHlewS8UJShXDyFjvpOhDKPnpXJphG5XsgUoeN5SY2NX7NBnwunfGq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789273598; c=relaxed/simple;
	bh=l0EqM8munegQGAWYoLgSWbJr+elV0QzsYM8QaNsLACM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DzVmRUg/MaYQs2VL/ltAjws+JBmNFenfQYxOcl8mhhcgcUkBfNQXGGVyPa1Q8PLqOEcU1WbSBf8BF+J9oos2nU+uZiSjJqNzHcLz+6Gcwr9e3ytHdZI4QAGGOWbBn+dxKxcwnCoV9yZBorBR94ZMv9lNFRCst4gEREi+rQPmpKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2dGO1kO; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2dGO1kO"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76c9df1so13967261cf.3
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 21:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789273596; x=1789878396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aWc5ORGBMLSs59eoqsaA5DPnuqtjSJQmTTKP2X4y/Io=;
        b=R2dGO1kO0USDCB1Ru/oyWQGtAjnYQ0bUMxS6fCh6cpcgYiBn2lN6RdnvmZW8fz10Uq
         Dp77ehPJirvBD+d5ZDsKphaTsIakBtoh4CCub+02aOmZ1yjZOUW+9NVs8z2cIV5gYRAc
         M0BxEBpUwt9HwR0Tq324JBLph06iWhLEHexFGzjmnFYR1X8fPc3ybTc6rgWltgF19g9X
         UYXFdb982yhQ1uacPnnWtBng5zmO+0WZBtrkcSJIqZXVr+GEfDlWZSGVseHTIQJBcx4C
         05DXUwHSN0qUYWQN4m1g7jz/ozO7YUaOSohQHoMnDIV7kkAetTi4AWMl8q7H2W4wA2QZ
         lUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789273596; x=1789878396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aWc5ORGBMLSs59eoqsaA5DPnuqtjSJQmTTKP2X4y/Io=;
        b=ftFNK78sr22VjDnQgrl+IEvI+pxrN/yjqqF91uzBlJxrIl+JirB17tg+cswfX/NtFE
         go68XEq7XGVnrywHnm6hIy1FYaoUvL39ljazlGxEW31B3A29+LiTvFoQHi2twlN5AiTL
         TZ6+MpdHgdxHzvS+XkSa9eV4Mf4B/I+ohVbvlnfH7MtjrPkgc7VXMmHVuWIaiBpgw0hm
         YIZYx1jBZTb8rrxF1tMCw33qhwM64G1r18yf94wZHyxVNaMntuURrySA06vYnBZu/7Jb
         p4cSXFMNtARk7Y+pFr8uAmrly5FyjDhozACkCNMasKxSvN3Rckv568Tp9Q3Uv5FiumKN
         q8Ow==
X-Forwarded-Encrypted: i=1; AKwUvBzb5N3cAZTo2NPGh5K3MhmahRJzuCH011FUWhEWCpFZ/D3VzWXksgsjQ/tCgf+UQPFilN1R8105roTtZmBMZw==@vger.kernel.org
X-Gm-Message-State: AFuF++m7kunHwc8XvJ8Q61XsHdkK1AccUnmBqNQHC5xf0W/HbINq64Bq
	B8tBwkd0JD4Y/mJI+QQsNWBeR5olzLSp33S6/uqxS3Sghs+6y037vknQIyhvU58ZdQ==
X-Gm-Gg: AYBFou2qY2ozTGKGmKtPcH5diD2IMjXxMMSgogbdMSOYsjt1pXf9xfKfSHlPc3v4341
	Sa1CEw0GClUenheTgP+oeaPdb1fnyvttvaParH54pKQ6YnE0VuszdlCa1hXfmzyLYbAByNpBzDN
	idzoE+fzxlalnr8znVYtunt4u8fZsvyNHnS1r3NYEoADJTVELZDcmCQfgqr9QIw25bb+J8ALVyD
	ZyU4d8iVbzJN+UtUq9v4Kesa4h4GgoB+zP1VUvi7h5gSCXam4b0ge9EPlwgV6Urjz2Z64KiIWVJ
	0n8mfesWjg11XhEkHrmcrIDLNzqjjbQmuVCuXda1sAKA6DMT2FX63k/ZB81Fh2IyzCRXlzSNHSd
	2WP+TxxWnni0yVF5ir6mWK1A3k2XHD2MTTmt8WvPf6mY+o21e1NYJOZzkdmr+cSFWq06JaEPfZs
	aWISX4boZKZP5M5cKaujlAW3XRyOUn2jtKQSp7GKdpZEASvRl/nzlB9AZrKSKZnjvyvP7VIDnsw
	l5nE/mWtQ9LjTk5t49RdoR3zHmgIgptFkq5Qzyk0g7W6Vu7PTCLaPmuKD38k7CSkyz8pMIn7JGJ
	cxt35RAMk2cctl7BjqFl+0FemtRJ
X-Received: by 2002:a05:622a:295:b0:530:e01d:6003 with SMTP id d75a77b69052e-530e81ecc85mr78423631cf.49.1789273595966;
        Sat, 12 Sep 2026 21:26:35 -0700 (PDT)
Received: from localhost.localdomain ([104.39.73.78])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f2033e7sm62784096d6.4.2026.09.12.21.26.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 21:26:34 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Mark Greer <mgreer@animalcreek.com>,
	David Heidelberg <david@ixit.cz>
Cc: Paul Geurts <paul.geurts@prodrive-technologies.com>,
	linux-wireless@vger.kernel.org,
	oe-linux-nfc@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] nfc: trf7970a: power down on startup RX gain failure
Date: Sun, 13 Sep 2026 00:26:25 -0400
Message-ID: <20260913042625.31296-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trf7970a_startup() powers up the device before applying the optional RX
gain reduction. If the register read or write fails, it returns without
undoing that power-up. Probe's unwind only drops the separate regulator
references acquired by probe, leaving the additional VIN enable from
startup unbalanced. The system resume caller also has no power-down on
this error.

Call trf7970a_power_down() before returning the RX gain error to deassert
the enable GPIOs, release the startup VIN reference and restore the
powered-off state. Runtime PM has not been enabled yet, so the full
shutdown helper is not appropriate here. Preserve the original SPI error.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5d69351820ea ("NFC: trf7970a: Create device-tree parameter for RX gain reduction")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 drivers/nfc/trf7970a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 60883001f..ddfc58c29 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1997,8 +1997,10 @@ static int trf7970a_startup(struct trf7970a *trf)
 		return ret;
 
 	ret = trf7970a_update_rx_gain_reduction(trf);
-	if (ret)
+	if (ret) {
+		trf7970a_power_down(trf);
 		return ret;
+	}
 
 	pm_runtime_set_active(trf->dev);
 	pm_runtime_enable(trf->dev);

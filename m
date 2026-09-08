Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA5824E016
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890627; cv=none; b=GJVMEspfYl+ogU0Rt3631L8GrDH7Fo68tidwmD1swR+a7jPazTkpCB31G294CRscaXL2VxXPGSW/pzFv4gF+1dNgPixvX1xc7Mnv52eCxOj386G07rw9h9nDiKf2ioc0ZHh3IiKsrzbn+AU0mBX4fW768eRK9FfcKlmFz2dlVt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890627; c=relaxed/simple;
	bh=QrQloLTgPyBoSDJmlMoitiIti6e69y2BWiWAb6tCtlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OO4Y+RaB7Gq4SGDiD1+5tiVCIK8md+a+xHClWMxuewv4Si47QA0f/tpiemR/phnifh99oqLOigtHBCm22t6szh1Lc+555NlDyhg4+o6xigAybH5ZTRywf6yJiR6g+IicRV5kt9N1rmSPwjdXOkWzE+rxnTylEEszqJwM08YtSFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/1IHny5; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/1IHny5"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-482f9309813so4627455f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 11:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788890624; x=1789495424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2pVC7S66/1r0QzvP5eIL5EhHuAGtHQbwAjanVNMfirM=;
        b=e/1IHny5j3TlXWKf0rTfiEH/5b/RZHAPye2C8va3JlzONcTNxKWD443rspq9JgR1wh
         2y3YdYd7H6SPTX60OrkS9FFx+9E/LYnGBAeV7iY/maZUNUdfB8xQD9Ql347YLi5HGxuc
         dV9vhoBMeP6cNx+XUZQ2EqPTmsPyyeMCS/V6gbhFipbPT6ZPHASpLMA4A5BIr0l8Wze0
         Hgt9lSnffoHUWeREH43LgIq1+Hu7ujXpeN1drcOIHPAyo482p0BT54gvz+CQnZ1cBemV
         gFx3jd+Wq4D8aDtSNHctbHRNTkr5ly48GlsRuLcWtDaLMwtZ63S9vl+dFSgtmWJjdzGM
         CexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788890624; x=1789495424;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2pVC7S66/1r0QzvP5eIL5EhHuAGtHQbwAjanVNMfirM=;
        b=P8JomeiRBePJScIJns/ODKAKtIkDG0lN9SqDpYk1Sm8XzbPU/nMnZJNrnrjBn7gs6+
         JJlecLC9VuS77s1d248AcntHfIfpyvWK/CgdJdQPhl5Eada5qUvDNUfJkFVq/DxcvePA
         D7J+fvwRjuMJyc5Q65reDmdJvK+RnaOrldjjjIEQ1HhzTEx8DF7qbNtQmbA+ge1xizhB
         OS3R+RpWWKnEh6tytUG5TwPaSAWrixtugvtyi03pJ4LhHdvdAvTOYwk8JV6ZTv/C8oWD
         huHGBXGRP6Y3qv2popuU5fuub14/QTxl/jmvynoNficMpyv2hvxkckFcu+CdTK+FPwgM
         slLA==
X-Forwarded-Encrypted: i=1; AKwUvBxVhmgL+BCjRNBVnW8STndDcaC4FYIWTj9ir39ezZ9RBZzQ8SShiqYhkFGiNBkS3BMejHBFByeGW4M4q/OhBg==@vger.kernel.org
X-Gm-Message-State: AFuF++kJvmG+2ZgjETsuc4Q7+rmCbuCEr0YDHajFQqQCjWnA01Us4Z8g
	EKZtstJHGijOI0N9EqySZGgs9NPR9mLaEgyYofQwiyyBGETKejj9shc=
X-Gm-Gg: AYBFou3068HWZm6rpoDLzNVScgtI0CYHW+O7MovrtRyLKTUk9N6GMbtYvnP9Mm62Yqu
	KtROjzr74UPc+Vfm9j6MjG1f6/ekooC/oRV2bNKLcU2C4eB/ii/o2Bq8zgHBbatyf14UBxV2fhp
	3KfgP7TBaB1i8DTdwJqLnPXm7D/U4syveFPS9rX5FucZ80t4/+FgHk8PBVPudHI2PT/oAiD0dh6
	DhkOFSYQTpHCEDiEWpv/C0j0aOPKFE/3rhxdY1UXo2p84UKXAoPnSglvoSta8XvGPYgUrNBRYor
	u36koNy+RZB6LOE868XgHl47ncJWj6r6rEywrROsJz4qACF1ZpupMq0lcmJf9yHr4tI4IoG4qms
	bdW/FlPnBakISEZqWK7OUM15fNGR9S+tjspQkqgd1aqD/uabFS++tUeBxzTDvgYRqS5gNGMBgLE
	GH4bu6O5nh6y5t5TUsYPOx0UvvRpdGdrdEOz5/pvAInp4dXnYWdn7uBQMd+G6GXHcc/i7Jm+XoK
	mFo2MqzEXxnaD6pzWoKqzGTZSaIftGY4hfx0tYBYDYqrgG6dy8QB4Qg7xTOL+0O9J1PnMVSmNHy
	9dJ5
X-Received: by 2002:a05:6000:1863:b0:485:83a6:b296 with SMTP id ffacd0b85a97d-485872b8d76mr36158782f8f.19.1788890623419;
        Tue, 08 Sep 2026 11:03:43 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885be1c1sm37039330f8f.32.2026.09.08.11.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 11:03:42 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath9k: refuse spectral scan control while the hardware is disabled
Date: Tue,  8 Sep 2026 21:03:08 +0300
Message-ID: <20260908180308.788642-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The spectral_scan_ctl debugfs file drives PHY register writes, and
nothing checks whether the hardware is up. While the interface is down
the chip is asleep, and on the AR9271 those writes go over WMI to a
sleeping target and hang the firmware until the device is re-enumerated.

Refuse the write with -EBUSY while ATH_OP_INVALID is set. The reset
control already refuses on the same flag.

Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index ca01a07f6630..0bbbef9e3b9c 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -805,6 +805,14 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 
 	buf[len] = '\0';
 
+	/* Every command below drives PHY register writes. Refuse them while
+	 * the hardware is disabled (the interface is down): on the AR9271
+	 * that traffic hangs the firmware until the device is re-enumerated.
+	 * The reset control refuses on the same flag.
+	 */
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
+		return -EBUSY;
+
 	if (strncmp("trigger", buf, 7) == 0) {
 		ath9k_cmn_spectral_scan_trigger(common, spec_priv);
 	} else if (strncmp("background", buf, 10) == 0) {

base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0


Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A010045DF52
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808094; cv=none; b=FSvKzihNd/d81C+pwWJ5BB+RoWzV86RMSLu8+H7wlbhDwTM4t0MfOP1m7BpjlYpoYfnieB/bMsVuM9Q6pZdKiQ0OD0nwChLCHkgTqmYqXSMy79KWyvyYbeT3J1Gas1L4b0HAOLACPrZRL6ZAudEA07qQxB6gh8Yyj34WfhPOy74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808094; c=relaxed/simple;
	bh=JMgzKQ8MAgEi6SWX+W+QcB/WyDSK3011AnCL9gzD17M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GrgZnB86oUvfW0g1ySMYC83L0miXh773vEan0ReQne9KMH41WTVbYJ/HQ/U9KYXJD2YpNcVl6U/6wBMdydKPaKxKSzknLjq07R0D+Vpxs5vw9LU7Q9rJ2y2AferMiGuv59nRgS0/ex6MNSUDnue5VG+DZ4Vij2+8+abVSeBb9JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=Q/PW0kTb; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="Q/PW0kTb"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e08baf860so578276a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1784808088; x=1785412888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vjRa0DTFc4Jmbe+bh5TZiQEHTGpASDC3/yAm/lBjtiM=;
        b=Q/PW0kTbyT9wpVdDmH4xKEwY/wfV/w04XJSsB/WAQz4XgxN3g9tCrfCw5jzlZ2CQW1
         m4pUHlB03rYR0QEqWwad/qbYhCcjDW+t4ovmQDO7sok453u9ty56YpE7yODUUmEO6dLy
         lv5cY+CY7rP1OMoh2BjazyfP1iq4h/vV0l669kAu6Pk7TbcQEmGxYdM1IDBj2SJ4QOyV
         qEcev4LQLDUDmYT4BwzS2VWGqHBUc8Vl++UuAB4OVdjJlkrIrT2Vfz4J4wJPTgrId4tK
         CWiPQp7lt+L/6gj9UVKfhY/GHo4WAamKNZIUXz/0cFx4YRmilEoOSVIfmAWR9oKOdUIQ
         Sv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808088; x=1785412888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vjRa0DTFc4Jmbe+bh5TZiQEHTGpASDC3/yAm/lBjtiM=;
        b=fn3D6O112w9X5H/uJvtpMcCBD+m8FIMLgIZ6NUz0GTPzf92CQjlCXIfnKBj8WiSO9a
         RC4vccbsv0XpUCCIZWP6fxGmdrSmPIl7sGKC7qJDCkWi2j1wnEadLmTC/IYlbmUuOsVN
         kJSTmjMpjVjGwAFfyQPj6F75a5xs9pvYFufL3hdMEP/LU8xC4RH3tF2hGnKfozy8DVgL
         W2BGa3UTPIVFiKoVBha30T+PeDHiTFprbRbmL8KOKJiBC9Xfr5q783o4eIIdyjaalm/g
         n6XGGN0iWzpLz5xothu65R2FqgHxA09hIkesIuF7cIvsh8rqhFNW1uJNoqjFxRPtAYgc
         82cQ==
X-Forwarded-Encrypted: i=1; AHgh+RphO6SZ4xMMVnHKXP3n3oGc3tTyG+R1FH/UUSYLq2KEOciF5DSyili4A1c8jSsKgcqQiMH6j3r5Qyg1a7ehVg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8SKfmbJIpCCRGTymN3hvCBS6ga4NDYcTdrLEXbv+ieo7uYvvL
	diIAiGj6vB3v91Wol8B5U4ctq4tGfzlm7x5Xg8JD70FTafh/7DJ3zjqToqfyQnHBxj4=
X-Gm-Gg: AR+sD13YoXzc25rU0uZCay4ERl7xAxpwhhoEKu83SqYVlN2EKPNw0ZZFWfujr1nskMv
	vBhZ0WEejvgUYOjlZpEqpNLoj6DLVd8IPr4g1S4h37gKvt0NRpidsWXuhrIr2UggvavOhdlywlw
	mg0reaKvI0u09/YZmZC5d5kYTUI7wLlWE3Sr888h5bSM5UAjsrnJu0/42Ml4FYpVrdBh6SyuZeP
	RYgzZk+yoqDtFIJI/BNAgHRhjK1vnkNaPjEro2Lku7meqYoT6AWfCBFIPEJnHYlZxu23jtY1JdI
	9k00bDiWsD5Po44ISzSupXd8YMOBkoV1hesojwVu58WVCAvxnlkg6rOXvO89Bhy5xR0icdEaJXa
	OvudzhsVtc5Ouc9O0T7MJk3PEXkGh+bn9dnSBV/cGqymD7UD/sd+o5qgaJnGBoHNWNtAFRSsSkG
	uJUWtO23Bjiq9++ur9fErMWH4yTC79gOaa4aGimVjuTDRAdJa57ezbEYyvBnQKZybRGDRFJl9un
	I+Ovp4TqUUtzRgmTU4DclQTiOGg/Ido
X-Received: by 2002:a17:90b:518c:b0:387:e0db:3d8d with SMTP id 98e67ed59e1d1-38ec66586edmr2599784a91.40.1784808087825;
        Thu, 23 Jul 2026 05:01:27 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-13d130a7738sm16180640c88.9.2026.07.23.05.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:01:27 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: pkshih@realtek.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Thu, 23 Jul 2026 17:31:15 +0530
Message-ID: <20260723120118.145383-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the last error path in rtl_pci_probe(), the cleanup functions are
skipped due to a wrong goto label. Moreover, the successful call to
rtl_init_rfkill(), ieee80211_register_hw(), rtl_debug_add_one() have to
be reverted. Fix this issue by updating the labels and adding the
relevant cleanup functions to the last error path.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

v1->v2:
- Added a call to rtl_debug_remove_one() in the error path, as suggested
  by Ping-Ke Shih, to free the debugfs resources which were successfully
  allocated in that path.
- Updated commit message to mention rtl_debug_add_one()

v1 link: https://patchwork.kernel.org/project/linux-wireless/patch/20260722115217.131458-1-nihaal@cse.iitm.ac.in/

 drivers/net/wireless/realtek/rtlwifi/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 73018a0498b4..de74ff8f6eee 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2227,13 +2227,17 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
 			"%s: failed to register IRQ handler\n",
 			wiphy_name(hw->wiphy));
-		goto fail3;
+		goto fail6;
 	}
 	rtlpci->irq_alloc = 1;
 
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
+fail6:
+	rtl_deinit_rfkill(hw);
+	rtl_debug_remove_one(hw);
+	ieee80211_unregister_hw(hw);
 fail5:
 	rtl_pci_deinit(hw);
 fail4:
-- 
2.43.0


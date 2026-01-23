Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800563EBF37
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769194901; cv=none; b=akVHchyOyV+uwEKhJdnXpLR9IlpPlrDeAt6UBUt2Z/MMG7LfDnCg4xBNB+rcx4uF1tAKTPg63azvzooFAY5M3GtEqO/vDc5GbZifa5M9oEFnvyuCi8VABYzdp3FZsj4I1nurrLSfJygi9cNWy52Q4WS5rWvm00H3g6p3FGdvTxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769194901; c=relaxed/simple;
	bh=HcuYJzYDbMRQQHpnpftplVjtYmx59BL//21Y1i5NVTY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DOJsBvzzmslCJB/tA/XVMkcnQmuSYm18zN2sLUkx2vJhMiIY1iJP76XU6jo9YRYBVSUi25OCWClY7d581QyiInbasjmAz175KUolkrenqgpemMG+MGEnJSys1xRX9/EpuevbB3HXuxqu5a6c7SC3ZxszLzEqAS7by2NDCAEGC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=u.northwestern.edu; spf=pass smtp.mailfrom=u.northwestern.edu; dkim=pass (2048-bit key) header.d=u-northwestern-edu.20230601.gappssmtp.com header.i=@u-northwestern-edu.20230601.gappssmtp.com header.b=FudcMD8x; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=u.northwestern.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=u.northwestern.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=u-northwestern-edu.20230601.gappssmtp.com header.i=@u-northwestern-edu.20230601.gappssmtp.com header.b="FudcMD8x"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfd6f321b5so1664584a34.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 11:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=u-northwestern-edu.20230601.gappssmtp.com; s=20230601; t=1769194898; x=1769799698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O8jrwxUFlBk+DWwXkcJaf7D36FV83NCzp5j9poXFdLA=;
        b=FudcMD8xCpRA7yxwktzW2FeYdfiW6+AmYRgtGCFj4I15Ih996PVdngxS1A9JdXkj5a
         t1YOvf2ykW345kqun3JagGgbI1J4RMx1P9xgdwwqwV51s+BfJns6kFRzqRIlC5jEkaxS
         8udepzdYuSVzOXchpp05jkdstmQWYebHYUK+AEiVIjpJxj3NgRg1fWUGPUGiggjfVmT5
         0ZfLnyKNTi0FWbWZq0jLe3Kq9Dt8DaVH7oWQJxZ2FSPHGq5CLe/ShIBttVy3ioIL6eBn
         JXBScob1/VsHrTQsq9YPffPIzLxGwScAes7ytA1kjlGPlZ38cbE1pom9or7oEPRSA8eR
         UkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769194898; x=1769799698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8jrwxUFlBk+DWwXkcJaf7D36FV83NCzp5j9poXFdLA=;
        b=u5GXaV81EDrlI5sNqJdl8mDsIEtPHml0Dd6VhPJR212ZBXMOGKgFgFYBuS/wW3bMox
         cHEOR8q1uByq3eijH9fBpFOREpHcC2rdpfCNEUpCUwrNPtz/k6j9PdFaVONmAjo/VoyP
         dgYW1ypeJkmgAs3HZu6rESAJbr8bjlzApzqB+h2esUhAGSNuvumnL75L93rW6kWxMBe4
         zt6vcrkikBOIlYH7xiCiZVo8x6Qt35Di0EYUal4q89vlIB129Nyk78zJq3mKEi7+l7kZ
         i0CnQbrERfjvRHil6GcJn4FmtyZfu5JC0ppSorjoD5BM02+DK2hHBedH1XsBJdEIpECG
         Sw8A==
X-Forwarded-Encrypted: i=1; AJvYcCVim0nqF0ZzGCJNnXEM/YGz8znTDmuHTgmG0PRr313fFEM8ujAXfR+s+jCfPNge9fX92Gh3e9HZXAz9m1eUAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3MwUd5iDoeO3mzQV7bXcdJiM6lY4boqHNByb6TbrNQONJxSG5
	8jY4AK0C5niyb5WNe9APxqw/e/ljCN786MWpOPtRrYDdfeh/U4Q+h/vyr7RGsqVmfXfjyCC9vDz
	mB2fu
X-Gm-Gg: AZuq6aIk6wnjm7fAchQn0vcDxxplcrlgVU9d4gbjjaV/qt0fLgPPyCZO3yt9USw1yBv
	MDL8KFgumTz1ZkzDrDXW+keTxdLtae0wMTfSsxSZkwgoYRlMlEQ/inTMW7yCv+087qb8Az/EruU
	mLdNyTDA9/jS1dKdpLGdaYjm5YiW/0FvuHALGKYuicNmC/7We7ToeFaAif/th4+SkXHGZJmUlhx
	b/wgbuEbA37vFuJPAP3mT1GIJIVnU8gTcSAwRvPeyT88KaqM+ZSVKV7+X4Wb//J0nqdnFp1qZdo
	I0HKKaVz/15THVhRjS/FaIh/2d1F5KDu64Y5AAaZAIJpBZs33hPQgUPTQb8nnz/JcrttC1NXUUN
	P6MSadOPmBx0p/r3/F6qbo5lRsrSvMSfPgPnErrtTWKQzgGgmPYnaqSI+vFO/fHkA/NFgN1Cgyj
	zlqloTgeuSxaJ5AS9quRpwC5Ch55BnPQlsBreTwXqzqPyTE+saTj69KnP4Tyh3Uhst31fbDReRa
	Hf7P7evPtsgzahAIJYSFTYzI00wUjQ=
X-Received: by 2002:a05:6830:3115:b0:7cf:e32f:de72 with SMTP id 46e09a7af769-7d15a5c156bmr2513217a34.6.1769194898222;
        Fri, 23 Jan 2026 11:01:38 -0800 (PST)
Received: from security.cs.northwestern.edu (security.cs.northwestern.edu. [165.124.184.136])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b3c01b5sm2327876a34.14.2026.01.23.11.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 11:01:37 -0800 (PST)
From: Ziyi Guo <n7l8m4@u.northwestern.edu>
To: Kalle Valo <kvalo@kernel.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyi Guo <n7l8m4@u.northwestern.edu>
Subject: [PATCH] wifi: wil6210: add missing mutex protection in WMI event handlers
Date: Fri, 23 Jan 2026 19:01:32 +0000
Message-Id: <20260123190132.1060514-1-n7l8m4@u.northwestern.edu>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wmi_evt_auth_status() and wmi_evt_reassoc_status() call wil6210_disconnect
in their error paths without holding wil->mutex. This eventually leads to
wil_ring_fini_tx() and wil_ring_free_edma() being called, both of which
require the mutex to be held as indicated by lockdep_assert_held().

Other callers of wil6210_disconnect() (wil_cfg80211_del_station,
wil_vif_remove, wil_reset) properly acquire the mutex before calling.

Add mutex_lock()/mutex_unlock() around the wil6210_disconnect() calls
in the WMI event handlers to fix the missing lock protection.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 6d376f85fbde..2bd09a225ad0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1703,7 +1703,9 @@ wmi_evt_auth_status(struct wil6210_vif *vif, int id, void *d, int len)
 	return;
 
 fail:
+	mutex_lock(&wil->mutex);
 	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID);
+	mutex_unlock(&wil->mutex);
 }
 
 static void
@@ -1832,7 +1834,9 @@ wmi_evt_reassoc_status(struct wil6210_vif *vif, int id, void *d, int len)
 	return;
 
 fail:
+	mutex_lock(&wil->mutex);
 	wil6210_disconnect(vif, NULL, WLAN_REASON_PREV_AUTH_NOT_VALID);
+	mutex_unlock(&wil->mutex);
 }
 
 static void
-- 
2.34.1


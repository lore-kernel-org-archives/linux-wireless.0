Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3640C298CC4
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 11:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721147; cv=none; b=FKeBiam41U4qkBRTaNm36NfckYEJSOlLZcLQRsrGSsrW5hw8L8QqyNfE+h/6HPxzA7IsCj1aNf8s4SzR8DwEgNzvDjY3bmeHxSUX/nQezsqdKIO3QUrQ8Sheb0d77omrZm6T5Qqua3IdQm6UaVDUr7RsnD6YYpt/yNw/3M0FtPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721147; c=relaxed/simple;
	bh=+C3ZRgNpPegs5K3UW4ksuKAEQAzCJx6g/de+0vlz5uE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pcDGtHrmXKK7Mp6VK5Y6G7d4t+3EamX/IeSjQ8kjnuy/JX/i2394h/cRnMhaata9d/UFJ9s6zU9PO3IjlcwD+FVbHiw/GZuoYvEFsjVhzZja9t8s+KrNpv2Qjfb9ReQBOUBcgcpzwwsm9LbfGySTDSCHXdSbdCM6Hy9CXiSu0N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=Lw8dFRDB; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="Lw8dFRDB"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38101f85591so5025347a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 04:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1784721145; x=1785325945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=269EtdxCHJWuu+Iv/X7Dxw9E+WzL2+4KdhP0CYuICuU=;
        b=Lw8dFRDBYes7MJ5RSuEEiSREwIE0trIEsCSIsdRWahma9/oydnul51SfA70Qj6H52c
         BWHdc8j3T6rCefyuGUEZsI+lf8Gsgple44jlOgV7fXIYk74oAJKm1vDSJwstUlYdVoBs
         0VE9SOnSdD2aYBsxQQj3cbDJS2GjCAqMZsIL/PvmFQ8tmjL3jje4ax24nHhBzmTz0BXJ
         2qCQfFxZd2WnMdphDiAbwMHU6i9QXcqgcW+omdOOF7n+2z/rC3Y0dU/RIQg7h6PCbk0l
         sjlRWgHZGCTKMZpyVG/fiRGM9Eb76BcOC+AMtS8/yxyVIAI7u1zk/K6OgZAa5bg1n83L
         ZC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784721145; x=1785325945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=269EtdxCHJWuu+Iv/X7Dxw9E+WzL2+4KdhP0CYuICuU=;
        b=MHfWzMzUjPzeXdFelht/a9TVZGHvUTeedTv8/smFYc9Vd2BJoSi+LJpqAnMyGjjUMp
         075iXJa2loi9AGG5jab3R+q0oHgj2wIJE+NuCdz9s4ZnvrT3G9u8R1KhA5FjW0Gg7AuG
         D48aB0veWU7tls6aMP4mBWMWSEgO+peQrefD3WMmJQl9ECv5uixhDyANQX3AdhX4Juir
         cDQyTy35u3HFbxTf2pqcFSh+AVqihxIKJaU2MZI+NMYJOUFMow/Ax32u+xo9qEzsqFlo
         PjHGtsI53quJk3/aP5NNv0n58Hwdnv3F39PB1L6/sKRm0HpiMIucTal+B+dN8zPteFYQ
         nGZw==
X-Forwarded-Encrypted: i=1; AHgh+RofkGdi4W+R1XlQt1tsixpzIAVK4hV+9VRqenMDSDtXvrgSR03FNyC6WsO4vtDfvN16o3fVCbuhc8mjCkTd1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfDIppaMBn5HRr3PHbuxLP/oBd6ABOM96RwiRgXxeQatIx8z/K
	jT7iddXmcoCyraQcU6z6IjjrUf/zUsFSC8NXc43EmGc9noF5rEHNIL63jaB37sam4jyc3k5mLjj
	ekE+VC9347g==
X-Gm-Gg: AR+sD10XVJWCNqu3kMgR8dMvkURstWDgqk3y1A/eczMT7ITKaS7aKTLZEyOU3amPP1d
	4w4jI9Brw/YXJX2QSTGmTk5sSVfctXWxhzZr6Sr3Znfij9JHtnkbbGt+9A4JiOVuQgw0do5+34i
	+YCPtbLukLrlJ6S7XA3q2/pSp+QqO1Q+QuV3JOuTuPmRYvdJ/0XelXJ8VuX6eLf3lH1XpcKXI/H
	83cDXwdGmix/2IfHAtZGVnq5jsNAewl0emLDtia1Q3z+tQzQKsKQ4uyM5/o6b5H/8DuHwzyY8Oz
	eIBh6g8HpygkBWq36ogwB+jiUAZMcw4aqXNGEhkQnNiwFluAer28HKGLUB2NEushTMy0paiocgh
	SK0O6NJVhPjxEBqScXSnJfRXntGLPX1qbD7S3UxJVDIx2D4KjEkuKR9lVSefbsVdHZYPQnnCVYJ
	XevvyWBMXkbpCinwjQbO/FWP0QiI1xbuHhN/Z3BQjkEXFr0Sg8iDCXRL05/wqfKMjQHFx5yTl7v
	mFf/Jf26zkJS8v91H+fMEYm8mF5cLKg
X-Received: by 2002:a17:90b:1645:b0:38d:eaed:4adb with SMTP id 98e67ed59e1d1-38ea391acb0mr3383557a91.20.1784721145493;
        Wed, 22 Jul 2026 04:52:25 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-13d1300401fsm8434349c88.3.2026.07.22.04.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:52:24 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: pkshih@realtek.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Wed, 22 Jul 2026 17:22:16 +0530
Message-ID: <20260722115217.131458-1-nihaal@cse.iitm.ac.in>
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
rtl_init_rfkill() and ieee80211_register_hw() have to be reverted.
Fix this issue by updating the labels and adding the relevant cleanup
functions to the last error path.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/net/wireless/realtek/rtlwifi/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 73018a0498b4..98365176a901 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2227,13 +2227,16 @@ int rtl_pci_probe(struct pci_dev *pdev,
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
+	ieee80211_unregister_hw(hw);
 fail5:
 	rtl_pci_deinit(hw);
 fail4:
-- 
2.43.0


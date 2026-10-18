Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771154D9F67
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357324; cv=none; b=uOA05blV6feBnj12h5QcvPm/oFRdU+JxQroZzg7/vifbl9gJNtB20If0vI06GFo6IOaSP+gfYKvWurzv+oqVh/qLWauCh9x4lc/w5//29CbPhpPvtLMJNeriu/3ZjznofndYy02VGlb4Z7v9dGLr+rEshFQiVPzS3o8A6sNzgBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357324; c=relaxed/simple;
	bh=/5uEmTAHQeYG22B/LqD3mCwkrCmdpDciJT70JPIhydE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebO3gb5XFNxIcTu43lU9KiW6MwOduqaHuROsjnh1k4vEE/lLLf44lTI5fUMyKLslQtMIiXbOhORRH/FZygn5PW0SsXPPsF7VcMgH1yz7WXGYdMJWGfMyznyEX9IB0nj/gZLGwugIYig4iFWuvTGkgTo7lRI+EFyhVih2tpEl03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=KMBJj9bu; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="KMBJj9bu"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4395d31228so59692966b.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357321; x=1792962121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bPr4qdqLVcWX6XCuQJCH3UmIwyLoC3WQx0IATf5uj9k=;
        b=KMBJj9buadvTs6NZBPS0suKByVrH0vN3LqPkOvqSe8fsi3AsI1SUQ9eaUjk7dfYAQe
         N+4HZ38y2xpS8YPfUDDQKmK1ENh8D5HXdqyFz68HS5BXrb9IXxfbQD52NzQb12OUUlwx
         iDcF0clchQoBq4CQDHfm3OBLzHKG9fOni+sDd5EE+UApFbQCWFGSAcqoisHB10Xar97U
         JJeQGj1GHkUpPdqtvcAeir+AyYjOzFpvXUN23Hh8jqRAWZ6ga3K1s3mI9IyoQn4BiCeg
         qtWJhbYlHCMZ/RUDCwK8GTN3JDcXdVmPXwhXqIEb8zraYUP4FWa6xd6V2rxgGI/hASGm
         BvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357321; x=1792962121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bPr4qdqLVcWX6XCuQJCH3UmIwyLoC3WQx0IATf5uj9k=;
        b=duj8gR0ezLNNPW+nHLMteGz+pmdIrvoJTzpQuWLRIqit2yEuY8An8t/q3KN5jKdF71
         GpA/2heOzxYeUZu7WCM8rncDm4ekL39vfqQ65VeF2TXQI79rhbxWLgVvlSEWJci1vQZH
         4Rb2GrVRSus7eeXYSapyGf+vG6qFYQrhdlMmazgcCUTlVusVjnT7IZsFSU8yrKslt7mR
         Gv9ibL8TACKWB8YJzKOygWJtS6/nFdKWJ60eePaHfy7hqnl892cXALhOyrTHL0UnF0eV
         BatnuHtejgsDs0eA7kAgNFYOR9Er2/oCA/APbX8y8xugbsR8a2p48qbvIVyUF1u36IL1
         VqFA==
X-Forwarded-Encrypted: i=1; AKwUvBzdOunFxoY1XhaWA+dBb0RszJXRDIY+uDVB36/x1hzgBz1Ev8B2Lo61jwSpMkdfGDwtSoChE+HBDDw6HFLCzA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKJh2EBl391Jyv7FqcLt4PHIXXC/a0KP1jkc/GtUnZuZe0d1mpp
	5lV7WtvyXuCVIkXI/f5aJSZdYjPRokD79cDFifvdj70niI0N7LvehXxyFJBM8Uq0sQ==
X-Gm-Gg: AYBFou2Gswti5jb6ljz9NOaYu8e2jELJwRFYE2OEAz6CeT8nAZTEDYaF8+HsNbKgais
	ihA3TJp8z37OrOwxqmIAkozl42XdzuNgEWMiGcgQUrglNKmYYgJbxwnEkhVkor1rEFAtUDwQHOJ
	ty7oMbWZ/KLaOxPzPTunLzXYw5FFORS35iB7y6OlGWbcK+5S5/3qcxUv3QjueU99Pz7sFiUqVyO
	wCX+NQ6f9F1PoFje3oYcx75H8MfnMg83W3C1Gs7egLsACwSZn4sdd7AV6dqgoCnrye6dsFSiapd
	lprhGDZ9lTjZ14nU112rWXDMXf4A/ZxpZlgGA941R94k5BQX0vfJXSVSWiiOECJCs59+w2jeNA5
	3bCDGkArUtzYF1X6QM48CE+ZsMpSzGW9XM1sVVfu54hYM6eU2LUaCyQTy9zFAVDPbGujnn+6iVm
	ade4GWCNKQUHQdcLk3eiNik8/JhlXE26FYVUaZxjIN+fNjb2KW32XqEI9nwWhqoP0loXncSXdMR
	SNH6H4wH1/OTLxPbAXjT9AjnnAeWd42EE4Z1Q2pPatAHMINF4gXvAZOAlblLx0gr2HWjoXRKidz
	UD1wO97JsErn9KtqPHPpCw0lKWX//4sM0ygqrvrxV/WRNjs4RnrcZu1DKmCWJN1TuYCtMiN99QL
	kBS8xzZOtDIUXcN8Lu9H35uhBDxsMBbBmLMAIf8ji2F0sEWjXZb3SnWvhGlfYBY98RPvFzK/D1t
	D/E0uzfkvT
X-Received: by 2002:a17:907:1889:b0:c29:4915:83cb with SMTP id a640c23a62f3a-c41a03f8030mr392380566b.39.1792357320700;
        Sun, 18 Oct 2026 14:02:00 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912cefd4sm291618666b.35.2026.10.18.14.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:01:59 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: [PATCH ath-next v2 2/5] wifi: ath11k: keep the radios when a firmware recovery fails
Date: Sun, 18 Oct 2026 23:01:50 +0200
Message-ID: <20261018210153.1925962-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018210153.1925962-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a firmware crash recovery ath11k_mac_allocate() keeps the registered
radios, but the error paths of ath11k_core_start() and
ath11k_core_qmi_firmware_ready() still call ath11k_mac_destroy(). A
failed recovery thus frees an ieee80211_hw that mac80211 still uses and
leaves ab->pdevs[i].ar NULL. A frame bridged to the radio then follows
the freed hw:

  Unable to handle kernel paging request at virtual address
  ffffff8316cfd480
  pc : sta_info_hash_lookup+0x4c/0xe4 [mac80211]
  Call trace:
   sta_info_hash_lookup+0x4c/0xe4 [mac80211] (P)
   sta_info_get_bss+0x1c/0x78 [mac80211]
   ieee80211_lookup_ra_sta+0x124/0x14c [mac80211]
   __ieee80211_subif_start_xmit+0xb8/0x3a0 [mac80211]
   ieee80211_subif_start_xmit+0x50/0x750 [mac80211]
   dev_hard_start_xmit+0x98/0x120

and driver removal dereferences the NULL ar:

  Unable to handle kernel access to user memory outside uaccess routines
  at virtual address 0000000000000000
  pc : ath11k_dp_rx_pdev_free+0x34/0x12c [ath11k]
  Call trace:
   ath11k_dp_rx_pdev_free+0x34/0x12c [ath11k] (P)
   ath11k_dp_pdev_free+0x4c/0x84 [ath11k]
   ath11k_core_deinit+0xdc/0x168 [ath11k]
   ath11k_ahb_remove+0x30/0x90 [ath11k_ahb]

Destroy the radios only when ATH11K_FLAG_REGISTERED is clear, as
ath11k_mac_allocate() does.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: 0366f42640a4 ("ath11k: Move mac80211 hw allocation before wmi_init command")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8e4dab61a3009..dd256853bab57 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2231,7 +2231,8 @@ static int ath11k_core_start(struct ath11k_base *ab)
 err_reo_cleanup:
 	ath11k_dp_pdev_reo_cleanup(ab);
 err_mac_destroy:
-	ath11k_mac_destroy(ab);
+	if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
+		ath11k_mac_destroy(ab);
 err_hif_stop:
 	ath11k_hif_stop(ab);
 err_wmi_detach:
@@ -2315,7 +2316,8 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 
 err_core_stop:
 	ath11k_core_stop(ab);
-	ath11k_mac_destroy(ab);
+	if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
+		ath11k_mac_destroy(ab);
 err_dp_free:
 	ath11k_dp_free(ab);
 	mutex_unlock(&ab->core_lock);
-- 
2.53.0


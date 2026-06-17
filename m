Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C24739022E;
	Wed, 17 Jun 2026 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781691534; cv=none; b=FyL9CKqi/gy10fuTMugO6GalYVYsoNUDfCjIiojUoDhBrIwKfpnXMAb1+3RdHxUp387J6Kl3zwCRNMjXdjCjrDWf+7S+DZEvn731hyvaCwh0Q8j4huhYNc+n9NAt84apsaH3oYkHptjwYqC98Q52Nl6uzs/eqIpleIyvhMcoSxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781691534; c=relaxed/simple;
	bh=XSftta7fHJx6mk6tjJNVdt7VHB+luyNdyoyg1fMlXv8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=u3BcMdnsd6mB8TG0+2oBsAdLQA8CHLqihtmZoEQFqDVxLH0R7jy7YfPBj7dv3AYdQyK0dAb7FSVMce3U0BZypsLTU0hM3XaCK+g2zqYEo7ZxyUxuNuMJ7I+mWZQ8XtiT3fWo1M21OYXsiX3tsPJoMvCUV3mECvvpb8ub8JxQB40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=RMA3OLw+; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="RMA3OLw+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1781691526;
	bh=XSftta7fHJx6mk6tjJNVdt7VHB+luyNdyoyg1fMlXv8=;
	h=From:Date:Subject:To:Cc:From;
	b=RMA3OLw+Ru5OHQu+2Gt3MOJiYo5zvfY9pYKkYP3HnuvwmD5sLVKi31uffhvZyhMUN
	 PV/fz2csGhlfqXEnuqio1uNU66cCbmQrIvVo6Z/++gXDnzA1C/rWVIewpcHTkigmBI
	 w2JXxhrXEqps7reEINS9wDVu6eq9FveT0HQ95c/Qbg2/rTSu9P7wC14gMir8i1zNCo
	 Yp0++WNtLV215Uh9r4zDJuhtiRAn/QuIENz4q3ww83Qr4UhqsoHkR0t1YJ50a4QS9D
	 zWlw97IU9D4DNd3HNskF9/T797oECBOQc2/c3hpVtZx7SQ6zaibZ9k2LOWpuWml63g
	 JS0a74Bys8T/w==
Received: from [192.168.1.156] (unknown [100.64.1.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mattl)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5FD6617E0920;
	Wed, 17 Jun 2026 12:18:45 +0200 (CEST)
From: Matthew Leach <matthew.leach@collabora.com>
Date: Wed, 17 Jun 2026 11:18:39 +0100
Subject: [PATCH] wifi: ath12k: fix survey indexing across bands
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-ath12-survey-band-fix-v1-1-e7d9555bb478@collabora.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSw6DMAxF0a0gj2uJhE9Kt4IYJGDAHaRVHBAIs
 femMDxPevcAocAk8MoOCLSy8McnqEcG/Wz9RMhDMuhc13mtDNo4K42yhJV2dNYPOPKGpavIPCv
 TFKaB9P0GSvPVbbvbsrg39fEfg/P8AbAFAG55AAAA
X-Change-ID: 20260617-ath12-survey-band-fix-4b5e78579379
To: Jeff Johnson <jjohnson@kernel.org>, 
 Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>, 
 Baochen Qiang <quic_bqiang@quicinc.com>, 
 Ramya Gnanasekar <quic_rgnanase@quicinc.com>, 
 Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Cc: Kalle Valo <kvalo@kernel.org>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 P Praneesh <quic_ppranees@quicinc.com>, 
 Sriram R <quic_srirrama@quicinc.com>, linux-wireless@vger.kernel.org, 
 ath12k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kernel@collabora.com, Matthew Leach <matthew.leach@collabora.com>
X-Mailer: b4 0.15.2

When running 'iw dev wlan0 survey dump' the values for the channel busy
time have the same sequence across bands. This is caused by indexing
into the ath12k survey array using a band-local index rather than the
global index passed by mac80211. This results in surveys for 5 GHz and 6
GHz channels returning values from 2.4 GHz slots, making the survey
unusable on those bands.

Fix by indexing into ar->survey[] using the original index passed by
mac80211.

Band busy-times Before this fix:

2.4 GHz: 9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
5 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
6 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5

After this fix, times are independent:

2.4 GHz: 23, 5,  5,  12, 2,   12,  26,  5,   3,  1,  27
5 GHz:   30, 40, 29, 27, 118, 118, 112, 120, 11, 11, 11
6 GHz:   1,  0,  0,  0,  0,   0,   0,   0,   0,  0,  1

Tested-on: wcn7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2cff9485c95a..9474d7e70823 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -13351,6 +13351,7 @@ int ath12k_mac_op_get_survey(struct ieee80211_hw *hw, int idx,
 	struct ath12k *ar;
 	struct ieee80211_supported_band *sband;
 	struct survey_info *ar_survey;
+	int survey_index = idx;
 
 	lockdep_assert_wiphy(hw->wiphy);
 
@@ -13385,7 +13386,7 @@ int ath12k_mac_op_get_survey(struct ieee80211_hw *hw, int idx,
 		return -ENOENT;
 	}
 
-	ar_survey = &ar->survey[idx];
+	ar_survey = &ar->survey[survey_index];
 
 	ath12k_mac_update_bss_chan_survey(ar, &sband->channels[idx]);
 

---
base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
change-id: 20260617-ath12-survey-band-fix-4b5e78579379

Best regards,
--  
Matt


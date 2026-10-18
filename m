Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438D9415F12
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345755; cv=none; b=HMsh+3QqUxtB9EYzfaY5RHNxUh7LWfXDR0FuWgar50BbKFPWFsW572H3/GNtV3DpEOfEzpdf7aSQGc7EHm9VRU819NYonsQz+A5qn0GhAaz1VI/0gYScCtlUgrs4YV+vSxdbHGsXePQN0AT9uaFbnUEu9FmRb2kfwkL2vwwkEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345755; c=relaxed/simple;
	bh=reAtcGD12mTxfAacTQ8TlV/MYmLBX0r4W3wjqX+D4ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp1dcAqKZofXuldM8EqdoD8PflMR8rwe2FhEpDkjSHkF7d8VoWaq3OG/LaUY+tOmVhRTEiGSqZPko/v4aZo198Fpb+F5dIqwy+dDjjCmORTcEs3hzf2SUCAZa8s7iiNjpCu0TZtJKr2DahZqOGtlWWQFQUeoMjiS3q6OHVqU/i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=NhYdFJZz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="NhYdFJZz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso145630766b.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345752; x=1792950552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZCxxJcbhpSt1i5F/1qHiqoph9gxQorPREPwC1lnzTjw=;
        b=NhYdFJZzIv4+wfCtzVlEuTd6hbIg1cg54aDnGDREnb5eKw/5fO8FQ681+gdh0qAShW
         4RBVbCnTxfpM/XFkj8AFoCvpX5XJGZaOpELi/vs37eOiFHx8YsUWWnbaXDISxhpLt+bW
         vt+d4FyTbGmXjAEo1WoIOlCFuE2LFNpGHDN5Lo9lod8CNHzMyYjE2PCEJQSoeb+A8fiu
         tAi8R1q3FMsezXEvBng3vq5btVOSORN+bixRd2LI4FOOsV4Cc9wiZEKHSqc/WuQFGxe8
         SK1pwONkhTD5eM4yU1kPE7Zaq9Nw3NNkQsSZq6p+kH6Pa0eZsxr1XUkW8oNrGfcczJnl
         Wo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345752; x=1792950552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZCxxJcbhpSt1i5F/1qHiqoph9gxQorPREPwC1lnzTjw=;
        b=fSdSUmTOMybk+EKs1sM6RnOmjk/s7EHAtGyzLd9fbNHliTAfdXMoP6+fef5OEvAxST
         PiOqAQ6s4V7kTFNJEqGiVJbE1EQFxlmyfMI/J9dXSvSJBEh/QLJ0xd178F6lqKlIpltW
         Pf0rX9+TLSihAtn4PBobaX1KkiTV95tZiBJIQsOnora2p+iNgYR7xGhOy0nJ+ueNuXNr
         N9JXZi+hg/Dd2q7NPSMpULmtMzmc5p3+WkQFV5Hm0qtxl4J9CU112ow+u428qlV3+c2U
         z1WfJnlCSZ0q1OaPwmLEmdFTirww29MqOMMO3w008MPa/mzbw+BONB81+HneydHGI8U+
         zqDQ==
X-Gm-Message-State: AFq9FYJuhYope18vzhsxw+XbGQm9SRI1egU0FdcphahYAIM/oawYU3qZ
	1d57lnU1WnKNdJKUtS/5MhkCbsPLMduUaFbZPsF6Q422HQagF7l2AGIY5RJwie1t6w==
X-Gm-Gg: AYBFou2/y/WYdk1RQlDNRAdYy+rJBRS8aqL3Nc1uRgVkwuEEO30d/KkjEZTZKQciOft
	YvEbdM2f+T06wMdNg7TE9UkdqT/WsGNph/yxUoM4sLelaqqjkFmiQrEGURde/y8mmkH9UfMwU0Y
	AqM9+ZNZ6wiv3H+IeD7b9p7Jk7GtipQKSzYx1CpQ/veDkm8hhhHq01U5v17Db60zTJIfwFBJ7Ku
	pGclDQ+L6f1u8Z23E9RxUM5YVyvTlnnFKoC6JTClEdPwbuX9Zl616W4zIWo38lL50kIC/WhDwxF
	vrLsH/fMfgFDwHBetFH2hysd4R8eS04sjVX5NDFBOAzyaIiEBktcac4ZeNFaF7n0dcUSSoPvfqK
	V+EVVzasgbG2E34TCIXOO80OjnVRf1vvQAE5aiuLoyFacdVOvdeO7ux7j2mT/+noNblxiK5NJGd
	9aNbEo4jiS+9q3lsa5LMS2B63alDkhNVmwATMIxoaEZzgCPwlmC1povOZ9SXvlEqjv019hwzVu2
	QBkIMtZGpN7GjPX1ihLKkCx6JcaIHwKcdqeJ4n6gHo0EdbLdKPuVstKEm+HbCeso1+0rEmbvCqu
	UXesakAtKeZlnzOOyE78OsKMyulnLUIqTpMatXMMQg/VPJpBFeik3jD2VqdQV7aU2dQnOvI6LYN
	g5vedYaohbxJhwuMDAzE5YAx2L2tyY06yhXj52ZyPxlIxbBe/8qM/d/W3yYZVmwqt17BNLDBzVZ
	863Le+YcFk
X-Received: by 2002:a17:907:9707:b0:c29:f5d8:9c6c with SMTP id a640c23a62f3a-c419e93247bmr367634766b.27.1792345752006;
        Sun, 18 Oct 2026 10:49:12 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:10 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tamizh.raja@oss.qualcomm.com,
	jtornosm@redhat.com,
	baochen.qiang@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	sriram.ramachandran@oss.qualcomm.com,
	yaojiale02@163.com,
	quic_pradeepc@quicinc.com,
	kvalo@kernel.org,
	sven@narfation.org,
	john@phrozen.org,
	toke@toke.dk
Subject: [PATCH ath-next v5 2/9] wifi: ath11k: enable airtime queue limits
Date: Sun, 18 Oct 2026 19:48:57 +0200
Message-ID: <20261018174904.1757161-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018174904.1757161-1-julius@bairaktaris.de>
References: <20261018174904.1757161-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without NL80211_EXT_FEATURE_AQL, mac80211 applies no airtime queue limit,
and a saturated download moves every queued frame into the hardware TX
rings. Set the bit. The estimate uses the rate ath11k reports through
ieee80211_tx_status_ext(), and the 4 us floor until the first PPDU stats
arrive.

With the series and the AP pinned to VHT MCS 0, a TCP download to one
1x1 VHT80 station keeps 22 Mbit/s while the sender's mean RTT falls from
526-587 ms to 42-44 ms (three interleaved runs per arm, default limits).

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 90a0404a101a1..6f4462b7d3f15 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10652,6 +10652,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ar->hw->sta_data_size = sizeof(struct ath11k_sta);
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0


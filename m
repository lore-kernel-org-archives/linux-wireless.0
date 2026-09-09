Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B71731B82B
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 08:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941990; cv=none; b=WyV6J8eVkKZaLNVoObHlNozYY1f0wITzMbJl44WdJGFeMYReOztaieYhpFFKgPRC34vtR/4oQlAAEOKDlMyRzSjlYyqT/B5n6dtbcel0FXD5B3w1meH4Jh4tfPkKlciZtVKsUdUEje8fRdUwaZW1QVXx+tqsEYU2MyrPj0Zq3MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941990; c=relaxed/simple;
	bh=ALiW49F/d5GoTiamQu6mmWXJoA2orkgGP9E7O3/Gnz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hTYSDsIzZssPjabnCRpNXPd26UNRFjVzvxmeDprVMsy40NS/89R+YJqhgtlHy5Fa9qUNvQ4taQLc1ayH5Fsp9bOWMShIRSz5qAZBm69U11Ivu9ZOyPgEGt7nESwUcD801ECRzvY4E5Tudp+ao/t9QP9tJAH7+/5WxK30Lgb7mS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s08dHUCG; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s08dHUCG"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc42c773d05so128740a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 01:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788941988; x=1789546788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AeAecISyFtoS/s+HRCWL6bIRyIqegC2fZufUlBFIf1U=;
        b=s08dHUCGDh8Yuaj03J5nx7CvDVl0sswPEZ0ivo+/HSEMUBn2eIRKbc/3NhSXL7w9nl
         rP/Q3ufiutXqq4FR40YNGXtqhOH/gQcFbUSMjsOYIKwM+c3INdLineS0GB+HTY4ZF8dG
         Hj8slaSJiA4V81VN6pkesCcC2WRdTxSwNXdOMucHCDbAOV/6Rl5o365qT4EBq06oTzih
         qcacU5BV+nvkrReLXsItYeQ8KH0lHVIHNaJ3oFlwyfWe8rPc3Rcnp5Cl9lU4T9PyCx01
         2B9XnBc2V94KmsSdZEI5ImnzxmUgZezbLHF5/X8wUoa8E9OVNHYyEzsVH0V16//HIqg3
         +Q1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788941988; x=1789546788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AeAecISyFtoS/s+HRCWL6bIRyIqegC2fZufUlBFIf1U=;
        b=fB+KlYJLsftjHzYzNlTICOC1Vq4lFSlP+0kTP5kwLkr/yrvly2R1GRvOD7K4ZOAL4H
         DJs85E7g2beMi7YzkeP36+SSuOR4aP6jIv3JoiTryJNSjSvHhblAxiYi8UKiGGmfyhzN
         zaq1fhxL6QcSpw155A4OAV8eQmKnCAyAM+dqTxSLITXlJZK2pQGDUqiuPvDN6O85yBj0
         T9TSPNHL46BCiqdOd78+fEZB+SqNOa2m9g1qOwvTjpR8g1nSeShf9l/I81k+tQNZGq/C
         gG+4HeCO5/Ou+F2l/Nu8Z8lmCMk5Mcj22/1yNVSHp6HVPDCNs/WnZICa5XDvsStZcFSJ
         mcfw==
X-Gm-Message-State: AFuF++nulQoGzL7cesqynl/Yr0Pm2mJvQqYjCtnJo7k+2ei5p3+jrAQe
	WBAX9baylUQjto8ZuX+qMo8XLW8vbURhYuEM+tQCxDkWZcRYhi0L4T2y
X-Gm-Gg: AYBFou06prw35c8zIJlsYXoDChdvRQAYtfJhV9S9rLP4LJ+868CoWRE10BYkKMyyhbc
	3oObY8kmw7wUdbhBFMMwK7tTEjS7NPFE3d8c6pXlcW/QLIPPCqPlw6jtBG5NPciNA0d45FQ1z4S
	05wUq4IXdtKC9aaKvd1iVB3KnLzBNRURj5UXeqFHtKHV0JcKjybtPFFRYYX7ZLojB3cPc0PEfWE
	i4KRGB5JmiguaPqeWIy3mVPEPs/Jf3GPe+7kBSY/2Fz/WxgvyXDLbfq9V3T03zzTRztv/93NnHd
	MSzn7qByNQeLRu/VhJJgfGZ4ZWkTLrgZUPDdo75hQKVL3lNHsZ6bRZ2LIeGF+VVMm5NYvrI/+HS
	plqE6SJfoQzbfuCqKRxdQ9wvSgmQogqJ0xscgoO45UcTlQjVakyF+frDtvV5v/a3l7GXecY+O0O
	KuVxJeELwTZWwMoc+/BesVodaS6mt4DGwdHNtpz2vXttC1714Y0bbrR8dqTWT52pfYhJQ8Cbqz5
	WBrucn+Ppidrw==
X-Received: by 2002:a17:90a:2cc5:b0:39b:64e9:2510 with SMTP id 98e67ed59e1d1-39b64e9607amr12279879a91.4.1788941988297;
        Wed, 09 Sep 2026 01:19:48 -0700 (PDT)
Received: from fedora (45.62.127.193.16clouds.com. [45.62.127.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b51eb40e6sm21357488a91.16.2026.09.09.01.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:19:47 -0700 (PDT)
From: Frank Zhang <rmxpzlb@gmail.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: ath12k: fix EHT GI reporting in monitor mode
Date: Wed,  9 Sep 2026 16:19:29 +0800
Message-ID: <20260909081929.122174-1-rmxpzlb@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the EHT GI value in the EHT-specific RX status field with the EHT
GI conversion helper.

The EHT RX path in dp_rx.c already uses rx_status->eht.gi with
ath12k_mac_eht_gi_to_nl80211_eht_gi(). Align the monitor-mode RX path in
dp_mon.c with that implementation.

Cc: stable@vger.kernel.org
Fixes: 5393dcb45209 ("wifi: ath12k: change the status update in the monitor Rx")
Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 44c5cff75f16..08b3caeee8f9 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -176,7 +176,7 @@ ath12k_dp_mon_fill_rx_rate(struct ath12k_pdev_dp *dp_pdev,
 			break;
 		}
 		rx_status->encoding = RX_ENC_EHT;
-		rx_status->he_gi = ath12k_he_gi_to_nl80211_he_gi(sgi);
+		rx_status->eht.gi = ath12k_mac_eht_gi_to_nl80211_eht_gi(sgi);
 		break;
 	default:
 		ath12k_dbg(ab, ATH12K_DBG_DATA,
-- 
2.55.0


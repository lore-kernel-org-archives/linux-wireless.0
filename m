Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8678E4A485F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 12:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154794; cv=none; b=OCPaRnh5q6ASKaeEiU2r+dTtSJsePG4ekYnANK/tK2DOiiEwd/n9fTWg0tPe3QTGrMh6KozRkmFU0OvVCI9F1sSuB1Gs0JDv51hytP4Ybz12kpBFFGHiOCd7AjvR1p/WSYme77ylRKpOc1KSgMjqCLXSODBVIj90G5ryy3Urywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154794; c=relaxed/simple;
	bh=EqUiW3/1i63gTVsPujaHZLsN69tXtUZJXoY79QWaqzw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mltnpu8Ac5bgEs4LStf3VAnC8jL2tPIaoBPYlE2gweO5fRkx1nBMjDhYAMkEEGGy5+9ArVKN6uISdTzL3pLJd+gm/WxugqDmlGgr1mwi3odY0z2uTB9FfOdP6qDBPEhFTDtOLT4RZIyp5Qm10mpAogiDoVbXjCDJD59foqELnMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIp7KuRW; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIp7KuRW"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso2207298a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 05:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792154785; x=1792759585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q5zj2v/4C3FbTFOf3UZNW27yR4URj0zj3Unt3ZSOPsY=;
        b=SIp7KuRWCJgKaVx3k2wC1ipLZuEvy4x9THNVtmxxGZ5l+KZnTs1aZ5aXkQIP5FYNxw
         2dCvUZH3IOgkWoqE0HGDJNHF95cfpHn/7yX9ZdHFdfuAdp2WJmVnnOOcUFZ6DSnt2ItT
         1oQ8cnHirovTyoRn+pVLnWJHtXA+hMFcMbksfZ9g8OvbJSv7QuLAh3yY8WYziUejuL78
         9IAP9WTr+nLWgyz41gWRc5fVoQWdjPK1PjnHUl/UvTAYyrPAFot7aiLWTalJJdkXTDdT
         FGBI3rKiEmj7PQn+h3m8odxMdFZqLzT8pMVgrEuWPRVvb2OTb2lGp/cRqCeM027wmvKz
         ztWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154785; x=1792759585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q5zj2v/4C3FbTFOf3UZNW27yR4URj0zj3Unt3ZSOPsY=;
        b=aDdr6ikw/kXTU9p/rvg5MHm0Cu7edzRdyMfVEACxdtiR+9b2sCCKLvUxJCk8loRkPp
         Z0vYEYtdFEUoqgp3lyuP5XHzgYaeR0MYGL9Yysw1+af+0uqrc5PFV9dobxCYX/RPTvRL
         UYsLWJcipdMfzKs0weSC1EjpLGl12/x27r2/6c12ookw2tH5eHIv1RYapmLsDsQSG1HJ
         WwpfA8A8jSDIwVRH34yNibT4iJFQesjUBAiKqiYAw4WneC7IH8P2RuhIQ3LXGVj0V2Ka
         60EHsiMGoLQ1kJbS5okH9rDCX/IO2G2oPAU2S/3QTmp29PRfR2EiYHSxfKcw/Nlb4cOB
         hugw==
X-Forwarded-Encrypted: i=1; AKwUvBz4LZevCVvtpNWOgfyzTcbKbr43Y8HJ0Bd0diWMCbkpFvVIfOQ2lYqBcLx8/Lz4w7dbjez925hXDTvk+xwuyg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtrnGBEkVNKPOm9GvIQbyzeAFBQCWGyYkYGKqObkgeGf2EkvsR
	isrpnyVB8a14SVNmty84ir9EMSZbXv/onGJF5Rq5gpmymjLfHrGgxlNg
X-Gm-Gg: AYBFou2pXnblrwHmBKgecOJsqzK0T5RjrxpHo7pNxDXnGW+2qIJVE2+6wU2+Ca/UBfw
	o40APXF1g9gR1QlcxLcqnSdN/3MUJbsl7DgvFJvd08IVYiXz/7BdAiNAVLWK5Wf0S5bp0yVGlFS
	EFkqMOUugBtqTGwF4wepDXyL5DtAvPLt1t+ECuAj0Mi2cTZfBjXYLMPqhGfgNW0jjDHzhRBhgqk
	oGMH3iXEyZUDBMGJManP6+gRMB7ISDw3Fi68q1Ezneo/iZdPeSJSkfLyO6HDPjjezrSoyMfBlTM
	U9we/g2Xn+4aefrhRIKtnVPOlbqhTLFI+9kNP/PEGBGSZU0dB6VeaQNSKryztp/r/BYyk+jBArW
	qBAj4L68nVj/ZHJyi/7GSHNcw/C9YMpzjzcSZO8fyNzzWEZRr8JYxdxtz6ctdyJ9yK/SoJrzIOt
	7uwjCGOUc9XEkWFMUK0RoZCJWMneva1na+EEGh2etjKAaYiQAw09zSczewPIRmn28vEsd8HRwFt
	FV1iOJn1W7rRA==
X-Received: by 2002:a17:90b:384d:b0:3ac:97bc:4c7b with SMTP id 98e67ed59e1d1-3ac97bc59f6mr5804257a91.14.1792154784685;
        Fri, 16 Oct 2026 05:46:24 -0700 (PDT)
Received: from DESKTOP-NM9EKIA ([125.134.240.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc4991b8asm4073508a91.16.2026.10.16.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:46:24 -0700 (PDT)
From: Joonhoe Kim <26rote@gmail.com>
To: jjohnson@kernel.org
Cc: kvalo@kernel.org,
	baochen.qiang@oss.qualcomm.com,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: replenish the RX buffers reaped without a complete MSDU
Date: Fri, 16 Oct 2026 21:46:20 +0900
Message-ID: <20261016124620.76-1-26rote@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath12k_wifi7_dp_rx_process() returns early when none of the buffers
reaped from the REO destination ring ends an MSDU, for example when
they are all error pushes or continuation buffers whose last part has
not arrived yet. The reaped descriptors are then neither posted back
to the refill ring nor freed, and their skbs leak, so the refill ring
loses those buffers for good.

Replenish the reaped buffers before checking for complete MSDUs, and
free the incomplete ones.

Found by code review while debugging RX stalls on WCN7860.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
---
WCN7860 runs here with out-of-tree enablement patches. This path did
not trigger in about 105 minutes of TCP soak runs on it, so the fix
comes from reading the code.

 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c804403e8..abd262d58a97 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -801,9 +801,6 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 
 	spin_unlock_bh(&srng->lock);
 
-	if (!total_msdu_reaped)
-		goto exit;
-
 	for (device_id = 0; device_id < ATH12K_MAX_DEVICES; device_id++) {
 		if (!num_buffs_reaped[device_id])
 			continue;
@@ -816,6 +813,11 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 					    num_buffs_reaped[device_id]);
 	}
 
+	if (!total_msdu_reaped) {
+		__skb_queue_purge(&msdu_list);
+		goto exit;
+	}
+
 	ath12k_wifi7_dp_rx_process_received_packets(dp, napi, &msdu_list,
 						    ring_id);
 

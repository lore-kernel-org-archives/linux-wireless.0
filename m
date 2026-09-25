Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59440471434
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339220; cv=none; b=PbWilp+nBHPfvO25o5z+M8AiGp2kVIqrP3tYiNf6TRtGPOW8HA3IPPSGWMIwt5KUMv/3cyDxjnmrhNWpxfwN/PiR+z7lFjrTdaFaihbVm2tEPZxXcZTd+Aces3VIaUG1KGClLUljRPnQzmUddaSFfA33GfMDRHUDqwSiWIzxhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339220; c=relaxed/simple;
	bh=SbRp24IDcrWYJIdZ4C/TGtPpbGJ52bSKfbPBNRYcU1M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UXUJbUiq3BSxqCCpR7HVQvVha85A9uaaMp18jWM4b+jeInS/I2AW2t2bZEfi4urirP8lOU69MNcP9ICVHr8qsBHKV+CnmR/+U/aig5XGWMdVOazqfUF+wLt5xMNkESvidqRLDPVRY3zoaCYOELg9XiByaVWmmveid69QWk0sMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wroyf1MP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AVXbvQcC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wroyf1MP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AVXbvQcC"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YbjQ3532122
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vzYXdSkKprGtNLKWEtOe2G7gqYD2Fig0Dn0aWWM8vfg=; b=Wroyf1MPjLZUHLmG
	LrHZNcgdB4LBm3PV5taubdUZZRPV+VpY6ZK9onwFjQUaqHBT1LV731fsfpLjgdMB
	t3qVkPxgP4GLU9+JfQ7A3Lu46+K7WQcmQkK/ooNjBGIY/R1dbACquOSF2XsrEQgR
	TXswoyJQBbXL9hYdjUorMnnEubd1kin7GJn5e+AoUEnpR16Y92ku12VyminlJrte
	OUb/dULF661OOqzPW8F7h+qOqB4L1lMdC5xIrBpwwWiJF76xsrPrNH1BzJ0cKZ5P
	AW5vS04N8CcsIVUPKxZpPFFuMmsOi99Cb36XVTotVzjCocH0ywfaled7OsWQxVXI
	oiyhvg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94kb4wb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:58 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so1087456a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339218; x=1790944018; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vzYXdSkKprGtNLKWEtOe2G7gqYD2Fig0Dn0aWWM8vfg=;
        b=AVXbvQcCfv4e5+mYYQWDHGiButH0Nd9IyeeMj6rwZzQRN3uHn+rGDI7P7WRioWVNot
         faadRBVgEqMiaKrB+BjIrbtJjRI7BhQQTgofFwIxpLNNUZOsyHHWCuas1RFk+oCvHBbl
         3+BZn3qA9p+pbXop2pTjcWqIa+pcuNbykdDeGaPNBSod0Zks0nG8jUDr0cqEaNJLPOF9
         yE6ISZwjH65wwhFTiXUJ/OT1LGwld5OCM3aaKgjHapXQZyvAoUy9kb+w0v3X5ApgMOih
         ctNw8WeZSGXuXu0dDkjU0385jimlftMO8ubTULIaPsxyJdYuvvJehywO+1hN17vER5cl
         zmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339218; x=1790944018;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vzYXdSkKprGtNLKWEtOe2G7gqYD2Fig0Dn0aWWM8vfg=;
        b=cSJkbGXY8Cs6+2/vUqlgXL48ct4ubyGsZt50PR32h6nv+/ThFB/JYJBt7Wb7AG/1YM
         62Zw8EUJRNp935skunYPDgi5P2y/393syCfbC2I8wDApiaHZrEI6eEjA58WgRDkRQSEn
         65jkx6SYaaW21aL/WC+vzPWTyZZw2uOLTPRQdrqiYV7SiKvqK/Qg7ljYvkQ4+cbCupbF
         irhcbXi7qUyfAmWawwidXlQuGuRV/1xs9imBS7RCzMypeTanRvh/MeJEORrMfmhWUqwf
         V6EqfQ4gKMK7PQDoqUjj4bSDSgEXz/fC1JUIyZjoZOJ9k1K1BGNKKixfbinutwi72IB/
         RGNQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXEHk/dDnO93MpK1S5oLLakWvsV169YLRKvMnaPcjEtEXrQS62hLzHXygySilLrxsbpVRAh2u3xW1AN7sxJw==@vger.kernel.org
X-Gm-Message-State: AFuF++mQNYcn1xcx/B7W9L5FZyAA4seDZrIG7JVwlxd5DCPLt93WSIk1
	C2JdDjSKRMgtCWIiqVv/o5yFpBLTktOeFMEzvQGjKJ/2RVDgcUuEq3QLeT5+VMYqFkr/FgYnEsV
	X4hGgzj1NOgU5+XdWlyh4Pm3gP2O37Xs5Szq/GTdjQ9lb6IdBnRUA0rbjmdMZ8P+6keZSOtXa6l
	lzEpCp69U=
X-Gm-Gg: AYBFou0mazBzVtFAIUAPUQBnsjmd8eRnb2rj8BoDl8pLz3Pvm9p7hNRDKRKxr8zxbcC
	odUZvabWWvoiwS+tOiKJUw9At3QpOQkEbAhrEkKJklErXZho3dyjvcklKOIEdTBftnf2BO6XV6r
	9E3xoTHrZhfUmx0OU7hG+pI8lvbLA0pLcx35PffaiozVAmQ352/Gbn3hQ6mitg8Z4X0RHmqqLM9
	yxAkBe5Fl/a8mz+MIMyvIZi3Wf2NEr/LDBwTEMlZ0c96i3IPDQlMBDs8cAI9MBG5UddJxAIopaj
	UZAlyGBGlhgMKVDoNi1cHs/ti28S9hpbUmaimVo01vSo2tNI9PcKa0vFz2UjjYJYCTZkXxAxbOn
	lZP0oV/n5rh6q0DT3R5jat/qWTCp+kqAK5cyFDpCadxzQm5h2UQ4=
X-Received: by 2002:a17:90b:3908:b0:3a0:c276:1ecb with SMTP id 98e67ed59e1d1-3a0c276224amr1119329a91.15.1790339212715;
        Fri, 25 Sep 2026 05:26:52 -0700 (PDT)
X-Received: by 2002:a17:90b:3908:b0:3a0:c276:1ecb with SMTP id 98e67ed59e1d1-3a0c276224amr1119310a91.15.1790339212138;
        Fri, 25 Sep 2026 05:26:52 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:51 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:34 -0700
Subject: [PATCH ath-next 4/8] wifi: ath10k: bound recovery time before
 entering WEDGED
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-4-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=3413;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=SbRp24IDcrWYJIdZ4C/TGtPpbGJ52bSKfbPBNRYcU1M=;
 b=7Hvx17ZEIBtJLIpdq9ZDNHPk0Ay4cXnOnhvDehs5jfH/4cTzwIvupAW/VI4ScsnFiBOb7m+Rv
 kq2L5k2S4CCCMki/htv3peMgA73rSCLbKcp7ZF9xsh+WMnpAL0aVOVs
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab66892 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=VCOL0f_idG3aiQAZe1wA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: WIUmNPxW7KIvGeRxo8XmhyDxlCDuAm38
X-Proofpoint-ORIG-GUID: WIUmNPxW7KIvGeRxo8XmhyDxlCDuAm38
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX45pflacbjtvs
 lPvliNN/TQ4nTwJWdh0bV4BHEPkEi5/q2+7jaibpD9Bxj2E+LDkhdAXUww1uvUiJIrDI0zWtqnb
 1cmK923lETZCIU82Bgb/zAg5ZaiEl1r6nqPVMPeeVRXT9LNz8qeRVmBiVKUfytktTVgLlEWLYmV
 x8t8Oi8fTNsPvngbeYFZeuA+oU80Ljdo4ilpX/k5y4B37kKRuoL251/NzMdRa9Fo55eXtkiwaJC
 52u/NoSZrJZHfTe1tqlEgLWz5APN1SwLkBgzu53auq+B4ZX52Fgp4gISujnhGe7uI+yB55YuFa7
 Zz30kF4NVEq5m8S/wbQWwT6NTduvL3LXelKVhFYUQFS39cy4Hz3kOeYTzhJ/gOLmOZd9Yk41l6r
 pVxEic1Xc1vJoCQSowytif9ujiCfCTSwnBmpTEdP1jDp7gn+tsdZ35srPG88/FS9Vg8YP3lYya+
 6yLFda6VUM2jlRY9BqA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfXyEGuIQbTFbGC
 I4kAekJMzkaCuCA5CdPSvAJcFCUUQx/ZS+lHfum0dp2FyCIWKdGTpVxCfNV+fNef6yLOlzEfKdV
 JHdqQqlf4e+cQ+khgD4LXQacaKFoOnA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

Commit c256a94d1b1b ("wifi: ath10k: shutdown driver when
hardware is unreliable") added fail_cont_count tracking and
declared the device wedged after a fixed number of recovery
failures.

This relies solely on the number of observed failures and
does not place any bound on the total time spent in recovery.
As a result, the time required to reach ATH10K_STATE_WEDGED
depends on how recovery failures are observed rather than on
a fixed recovery budget.

In practice, recovery-related delays can stretch the interval
between failures and allow recovery attempts to continue far
longer than intended before the driver finally gives up.

Add ATH10K_RECOVERY_DEADLINE_HZ (15 seconds) as an independent upper
bound for each recovery attempt and declare the device wedged once either
the deadline expires or fail_cont_count reaches
ATH10K_RECOVERY_MAX_FAIL_COUNT.

Also reduce ATH10K_RECOVERY_MAX_FAIL_COUNT from 4 to 2 so
repeated failures reach the WEDGED state sooner.

This keeps recovery time bounded and helps avoid suspend
watchdog timeouts on platforms with tighter watchdog limits.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/core.h | 8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f2e457a0fcbe..29ca34a643ed 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/pm_qos.h>
 #include <linux/nvmem-consumer.h>
+#include <linux/jiffies.h>
 #include <asm/byteorder.h>
 
 #include "core.h"
@@ -2541,9 +2542,10 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
 	/* Record the continuous recovery fail count when recovery is late. */
 	fail_count = atomic_inc_return(&ar->fail_cont_count);
 
-	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
-		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
-			   fail_count);
+	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT ||
+	    time_after(jiffies, recovery_start + ATH10K_RECOVERY_DEADLINE_HZ)) {
+		ath10k_err(ar, "recovery timeout %ums, fail count %d, shutting down driver!",
+			   jiffies_to_msecs(jiffies - recovery_start), fail_count);
 		ath10k_core_enter_wedged(ar);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c739fbadc8bb..0319da3ec022 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -88,7 +88,13 @@
 #define ATH10K_ITER_RESUME_FLAGS (IEEE80211_IFACE_ITER_RESUME_ALL |\
 				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
 #define ATH10K_RECOVERY_TIMEOUT_HZ			(5 * HZ)
-#define ATH10K_RECOVERY_MAX_FAIL_COUNT			4
+#define ATH10K_RECOVERY_MAX_FAIL_COUNT			2
+/*
+ * Some platforms configure suspend watchdogs as low as 25s; cap the
+ * total recovery time well under that so the WEDGED transition and
+ * any teardown that follows still have room to run before it fires.
+ */
+#define ATH10K_RECOVERY_DEADLINE_HZ			(15 * HZ)
 
 struct ath10k;
 

-- 
2.34.1


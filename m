Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A64CF495
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792229811; cv=none; b=nR4ddmbJPRl5j2aRvuDFSIxI/INtPhsQPMMCfv+0QX6G1a1BHCatdTFhLGBYWY0Ej6Ktxz2wfkdvUSzWi87vRHwgFAj2dsaoCSdqK8WGrsZGRPCTeShsCa7ANxYpjCr1ke547cj9svSEqfdd+6rTDpbulXE1mUms8/TYPXwNRIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792229811; c=relaxed/simple;
	bh=2tWAawY2tI6L5cBktFSft1IRsiolNI/DKCzGQP8s3uU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qX9Q33n32qa0GlYEUbthNNybN/KxOPJpnfK+TlIE1AqCVSFTUH+Wzqe0zfRk0kD0r9i0f5dny/W2SMmXZJBu1+1Sg6uNd1O0MSfci3OOhkzkbjZJoOrN7DL8p0l4H1x+su0pKrHneMXXoQvvCgaTGFjmBSn9iKJ9v7J54I5nxBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kzxG+Yvj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G6i9Xj70; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kzxG+Yvj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G6i9Xj70"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69H6oAgj204504
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=SLe6j/uu4SB0mKL9uRRQMb
	HkYnjpRPV7iqxGnvaN6qA=; b=kzxG+YvjgTbk6mfmbeMasthbCpIX8IKBoaudIP
	EUCBDMRXglz8OiwzkYMB6DMXzLV42r7NuNd2w7cKMG+RYaA1hmvSIYqpPcH6aspO
	FZFsW5sQY8vIyd+TfQzSKFOI6kR+L4J8vZTKVixJ/4Hz+5ti5zISj9KBZ+Z1BRVK
	n6pJSjQv+b/DnwoUKCxUbP8e7jZ1K6HMqqQxMFXhmm7uanleWHN5iKzz1DoTUeev
	hgFpd2D23BpRLbuAbPk3bJ273mEKA8ZtJQsoNevxcRKB8JjzFmmRyb8GmTjQE4bY
	6F+u59WWNfawFeLzNS1X+oiyGU2LgIBA64mFucOTZ3o+1d+A==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbxcnrxk4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:36:49 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ca9b53afaso223059585a.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 02:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792229808; x=1792834608; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SLe6j/uu4SB0mKL9uRRQMbHkYnjpRPV7iqxGnvaN6qA=;
        b=G6i9Xj7018Z+XEX8ahdZc1at5TFOUWOPg0/u7JLOGAZGq2vWz0x2KzTb1zo09UIvxv
         VM/sBM4oFBzptmMETn2BGw3SK5k3vBtF3oNNshWWzu1qVkCUTrd4tmZ+e4sditLTnKUb
         NxJe0+ZiVnGE+kRM6o5eMgzLaoZmGJlBsAea1pwPosbwHl5NgCF+NRJ1QkTD/kGFAZPj
         ejLPbVXFzcIVOjOdVLPu7kV+FSyJ8riz/7kMDcIO6xxc1tMHfCWiGbYmanKakdjjakRJ
         n+rTCsgF0b9XvSy91wf4ocU7A7t5yld+dN7vSRqonsfDbzxlIRg1i6ygObcu2xCR5vIf
         llJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792229808; x=1792834608;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SLe6j/uu4SB0mKL9uRRQMbHkYnjpRPV7iqxGnvaN6qA=;
        b=f6nlTC+tHqxp4PqQE4QUEGPn3dRseATOkg7Ku52G52n2qtl7FBIJeMS5F0AKzsz42N
         IEIz9Ex+dlXxs1P43Nbk9od9r4a5SirlZw3iJTntAosVszXzwUmRh+eSoKnhU6jQdnV3
         maVG6RZded83qsVpz9G1vrh0J4KQyE2FyQE6J/FLr9aHgOA9oQcDp5Kis/GUdzeH7jqA
         bBsbdoarKs170yWPATxK/JKSAnQtmHOGPNXta8bxvjDXaX98I0HznWtVpW8wgNZkdy2p
         gt/yy2hTrPTSkeyuzCuFNPNA4Wn8g3ZeW2M/7rFE0T9W+X0xwsKGFmVXhhRbEz7Bvfjr
         l3Dw==
X-Forwarded-Encrypted: i=1; AKwUvBxDeT/Clz7nkpQBGpDvGZWlRmzGYRjRTg/c3GMeNAqDkqxdEWTN+zXMQZYbZ+wz66jKTwWexrI29gXn3FSkWA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK4z7bj206I/x1q4UTpUmVjEcOy1yhzLNxgkD4jwFasCMjTJnIt
	Mj2J/H3/dn2grv6PNQc8wOvwv5xzLBvQgKnwbz0PJ49iTipyhrB1/LzFcQI2WHxMAKC3b6a/7dU
	wt3GXGLmSDDp1AMnT6eNiVz3JJHkU7VGlxGtAPH6jxqpYcnKT10NNiRTaeOebJJwebSh2Eduiur
	FQlQ==
X-Gm-Gg: AYBFou1Qw1+OSFXw3Ys4U/mocD20pEURp0ejrLfLLmEhjIs3y1iKCK3CXVItC36ZdRZ
	YySfTUjpiCBL1aXsmt2dT4dkxMZo4pFCQlA0G1xDnjtq/kgBX9NnXqsvunnhbx5AM44e9cgj594
	1NGBz1qJKQqhOjz2Rm18Kf5SGq8StOzE698KZjopr82Yuehfg00FkVbLQa+Ll7hBRBotnUdlPFp
	RynsrQxrUQeh5Jngj8YJBcHrn/kDni60Kf1FWV4S4bOzUojUwB7kEc0U853NXoIstqYJhOvFTyj
	gggm88RHrZoAJZ/iFlqEmU8YPBQIPXCF2kxk3qKIru1IuCG2Rdans55U4YUSZURjDvNqmihF9GU
	X903+b+jUeI9/nQ==
X-Received: by 2002:a05:620a:3942:b0:93e:c12c:f148 with SMTP id af79cd13be357-93f29e221cfmr362688785a.82.1792229808468;
        Sat, 17 Oct 2026 02:36:48 -0700 (PDT)
X-Received: by 2002:a05:620a:3942:b0:93e:c12c:f148 with SMTP id af79cd13be357-93f29e221cfmr362686885a.82.1792229807911;
        Sat, 17 Oct 2026 02:36:47 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd50ae5esm10830470f8f.51.2026.10.17.02.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 02:36:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sat, 17 Oct 2026 11:36:28 +0200
Subject: [PATCH ath-current] wifi: ath12k: fix DP used for WBM error buffer
 refill
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261017-ath12k_wifi7_dp_rx_process_wbm_err-fix-dp-replenish-v1-1-21eff2270080@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2N0QrCMAwAf2Xk2cDagUV/RaTMNrVB7UqyucHYv
 1t8PDjudlASJoVrt4PQl5Wn0sCcOgh5LE9Cjo3B9vZseuNwnLOxL79yYudj9bL5KlMgVb8+Pp5
 EMPGGsaJQfVNhzWiDo2AvQxocQStXoeb8rzdoQQyLCJUZ7sfxA+8mUXKSAAAA
X-Change-ID: 20261017-ath12k_wifi7_dp_rx_process_wbm_err-fix-dp-replenish-2c7ec293f37e
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=BNUmP1QG c=1 sm=1 tr=0 ts=6ad341b1 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=d7p5rZZzYc0moGUifpcA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: VSmO5OTc-Xma7vL9ei0i5ZHH3bUJ7OuW
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE3MDAzOCBTYWx0ZWRfX5YhuVuZgu2au
 4jdvXeHOT5/gEB8g8AMwoS/zQbTqN58XVb56BjZ8oVb9QT4JHMSKB6f0gJje7Px3EjGmXT24T3V
 BrQEARKeFo4pIZ1qJ6BAfKIXL15x/nI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE3MDAzOCBTYWx0ZWRfX+UZclfHpcaJv
 qKcB8grLqJb9oQmprA7HWoHD5ggDlsjUX1IwneUnQWRZ90MHNvRmR4gBWoJb80UJBU7phqS4SE4
 9lGGK4KNRMf/aZghdrYlk2ZtqZnjypk1Ql8R4YyxfBsu9u0HPDJ8KJ3e+me+6uV6JXlm6R3N3BC
 r2N/4LmLvijpqgnkNq8kjUu0c84Xq6eNmBQhuoQWQwmz5MtKV4sm2BBbODVa37lQR3CSlPB8fK3
 n1x5BeDnI5vv2N2ETgBC+PXAC9mo34f9H4HXcYiSwxzKhDsbBbRRW141VoHSXebZVoIqEonmEMY
 0AQp0+S1uScv1KF0A7J2WqBivNBo/Cprx+gusKoR/6IFejK1W1DB2V8GZdEnLepnUgaCFnaSeN8
 wG9kywAwNVIUvWrEEaqtN3+8GTej6rk1FTWRU95Jf/7Po0bilojb+5BqsaGCFE+YYn305zyJMwx
 ebLN+aVmNnHuOAyV2OA==
X-Proofpoint-ORIG-GUID: VSmO5OTc-Xma7vL9ei0i5ZHH3bUJ7OuW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-17_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610170038

ath12k_wifi7_dp_rx_process_wbm_err() replenishes RX buffers belonging to a
partner device, but passes the current device's DP object while using the
partner device's refill ring. This can map replacement buffers with the
wrong DMA device and access the wrong RX descriptor state in multi-device
setups. Use the partner device's DP object consistently when replenishing
its RX buffers.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 1d18b197bc4b ("wifi: ath12k: add partner device buffer support in receive data path")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..c3e4ec0ac281 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -2052,7 +2052,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		rx_ring = &partner_dp->rx_refill_buf_ring;
 
-		ath12k_dp_rx_bufs_replenish(dp, rx_ring,
+		ath12k_dp_rx_bufs_replenish(partner_dp, rx_ring,
 					    &rx_desc_used_list[device_id],
 					    num_buffs_reaped[device_id]);
 	}

---
base-commit: 08a3f02fea636e97a7422d1512f76dacdb5b0887
change-id: 20261017-ath12k_wifi7_dp_rx_process_wbm_err-fix-dp-replenish-2c7ec293f37e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>


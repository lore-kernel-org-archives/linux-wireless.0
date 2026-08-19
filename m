Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D637CD59
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117607; cv=none; b=J+/1NQ0E6BrtuBbRL0KBgByfvk/8rBROmbAwZAWKyJWInQh+PEmKCMdhU4GD9fO4O5c/eT/36QQbZxmTHVOUSu9FcMiIEfPPhDd60wWS6LpH6ZVnUuyTWWAnwxa0WizUqf8T6qPC68jd+kABQ5MXZWxLsuk7rB/IlKd6K5IWaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117607; c=relaxed/simple;
	bh=Q/awHLx6MSj2+GefZtb9O03/9BPeT9aS/hrNS4SDIdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bmIZrWEV4Yz5sZQAmGfwnFNHWVMVsyaHW/nPl5api1vErC974qH25bz7rHfCz424+t55amYAVaEaojnBva913/ZE+8pYl4oAb8sXV5v1qqocVNqv4drXVyP47CYjqbqDhPLP22s03pAwt1ECsvg2Cah4qidLXpPhi1K/W9QrFcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JMWxP5co; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JF7YwsrQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JMWxP5co";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JF7YwsrQ"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5I2GT3498629
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=pcnPZgHH2d4
	MNKTZmtelfrRGS8bNErGXqN5MMvyrAqI=; b=JMWxP5coEzDszq86cjVUH42s6vs
	WqFpMXKnyioX5xrpJd+W8yzG/1XnvUCbbZpHaD1tT9xzAF9kUKI8zXto80i9DlKT
	PjU5v4uI3KDWsbIqzxLExfp73jfNt65m945adVsmFMmUOOxx2DLhvyQk0xscqKZi
	Rnb0xiauguIF3q717vgsnEei2VXxyIu/shWpRMsaVCFSI7our+UuPZL+wJ3kZ0YV
	qexGzrTtHfpMEjwFKgEdIELSCE0rhIxB6Hv+5lsYQhfsb3G7vcQ2v9gzrslJWtsm
	1g0nldbM5C4IebZEFLTfLcqUEnIe5jUgEcvZ2BtHYYhZ3N7YjNqm25VHk/w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yftsgnu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:25 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso1325283a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117604; x=1787722404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pcnPZgHH2d4MNKTZmtelfrRGS8bNErGXqN5MMvyrAqI=;
        b=JF7YwsrQjwB4HBqg4looyVxOGbxWXsMXZyRDUesgCcZp04XoMwsWANk8c+ZsZ1kuVD
         0+5PXGq5ZfJVRML0yy1FqxadZjV/oT96uQnd+Wx43vPxBgnG3zSwD1WqrVVX5d5OsQao
         vWZxPbAfCLtt9MKS6W2KSaZanx+sFulMQBZj+5klwfxubdpfC8mDbNJuS6M0Lkpyqysj
         MyIJhr6HkFKxtgZOLWXqhEA9IpwshGrbP5H90D7xZeq+TINpHwcffGS9y0W6z/hgVT7g
         W3Jjsynz5uYDubq1+dGeqr7PP4PyPwWp4vqHCKN63yze3nTpBxFB7rBUbKgT0CXjw7Qk
         EPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117604; x=1787722404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pcnPZgHH2d4MNKTZmtelfrRGS8bNErGXqN5MMvyrAqI=;
        b=Qu1F0sm8PAYdZK1uPdV9LiN4e3QJB/mXYT279aKuA7G6fNnXsHGR2AtsjSZtbnrl5a
         8Z0kxjaGU44z3VtbkNc/o+60HgY+jwFvo20rCWGQK42088mTAG5TgJafbGhN/IrasuhB
         WnJ2p7SAJZI370eJ3hpnCVC1x+pSwQWZSbttMnqlELG5FCwoDqPUr8k36qLiUNOsPM0I
         qs2QHHYxrw+HvRZZj7W/3qTrGETqFU1m9x/XhF5kUvM9AZ30oYbEbOkQ7BRy8O8wiyla
         TIUNfqo/oTtxe5hN+e/k4IcrLEMFUrApI6LnLvA0BLOHQMrqPagaeaZWzL5aTwFjEwQR
         Gtog==
X-Gm-Message-State: AOJu0YycPK6I5Di97mmE8A32NX3kD969i2JnzaxTLI5aRsl+RFE11c4m
	fKNOAJXRwXvIucSul+cK2pMMN0mxcTkona/kBFjnXBPjyCS7ZM9ag0iNHvuaQcTBSgA+TDa/vCU
	1uVkOmZS1bhNbcaK+v1Hilz/3L2wNeekKxeyuR6IYnHojrc93OWl+I0G8vJb6nXGdIW8/o4PCqp
	+ZCg==
X-Gm-Gg: AR+sD13J9iisl+12AiK7LcewAJ/I186WUyoxY6MSZmCf/1UmaOqBVKkZY4dSMwPSdaI
	tF1bx01fZPeomC4DOScNfWN40P2IU7GFCZ4cA2pojdNjJ1vsBvarWVIEkDz4mvoKNNBCGfHBqte
	IvwoLW5nZ7WGQzlsJiJwuxYdp+dVrx0BlwsWF8RZX7LlbpuzPlwZsysO+beQ4GVkJ2jACkwugNE
	TuCAfhcLxFVGO0+ezAAK9eRSDpBs4jbuNLGoDcFo0iIU0gJoVrXrD3bvHdXoAwLk7VYbKfeckTI
	F6F1hNWw6cF8B+bhjSAMwfNQ4sidtGCa0N12LyEy2JBKuWnGztOREe3fq0GhAkczRdZn/z8Q9cV
	UhW45vOTi+Md9Tg6tCdAdXn+H20YrGGhOEoL1WDO662p7qrzt7tKV
X-Received: by 2002:a17:90b:4c44:b0:38f:2168:b9cb with SMTP id 98e67ed59e1d1-395810857dbmr3745156a91.9.1787117604443;
        Tue, 18 Aug 2026 22:33:24 -0700 (PDT)
X-Received: by 2002:a17:90b:4c44:b0:38f:2168:b9cb with SMTP id 98e67ed59e1d1-395810857dbmr3745070a91.9.1787117603828;
        Tue, 18 Aug 2026 22:33:23 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:23 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
Date: Wed, 19 Aug 2026 11:02:46 +0530
Message-Id: <20260819053247.1420393-8-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=FIorAeos c=1 sm=1 tr=0 ts=6a854025 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=qz0A3ntWxt9h8-tH59wA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX2WI3bGgvqlGQ
 Jtnhx1oyuMOF6fvDjF9LDCvLdvzmByZhqlSnkityttQBMfk5QSB3icicH4DSBaojzO1O8S/5Ce9
 jssJFhqyGNxVczNB1JcB+bQd9g62yJM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX2PfXNQSwBF+O
 Iy7TJdThiFbQAGYRALqw/BxWcPcZglyBmQEFuMGzqqBerh3hEGUHP43QMOTuqtGBTtXhqq6im1t
 vPSXSKKJwUUL5cuFppbqj8SuzLi5oCgPg4CYcfZFjVjf6WU8LNVSztxwIdL45DLab2sXMmISkjR
 gWs0ox01vbBOpwsp6sU2khUYup8IgXRKIrBNhO4rB/7oOLmqBWgCKWNO9Mzdbe2QK2zHmh/Wrif
 2RQRIkZ9fnIxkyHF0VQFF27diuQSDOVCUdyJsNovBdjlfWW+1cw9NgRI8mSxFAB+6Znq410NqOQ
 DQ5S9gm8A5NOWViOh00HMGdt/GCQM0Jsn8Qu8N0NkizFPZHeQh77yOtUVnhbJb+AuqbRp8kp4ij
 BmljpdZGCIRiaqa3R6zvOmj/9qtBnR6avjNhObYgoW7KXu9YgBlMSuj8mKrAsAViK3zqwHWOy7E
 Y5t1BkMNA18J2YYfVcg==
X-Proofpoint-GUID: 96iGNeBvrHOWerItPZDs6_J4bmbeaGBh
X-Proofpoint-ORIG-GUID: 96iGNeBvrHOWerItPZDs6_J4bmbeaGBh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190039

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The REO Rx Received section in device_dp_stats debugfs uses a 1-based
ring index ("Ring1:", "Ring2:", ...) which is inconsistent with the rest
of ath12k where rings are indexed from 0. Fix it to use 0-based indexing
and lowercase "ring%d:" to match the style used by all other ring counters
in the same function.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 5d5597d80417..5d6710f1160c 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1215,7 +1215,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
-		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
 
 		for (j = 0; j < ab->ag->num_devices; j++) {
 			len += scnprintf(buf + len, size - len,
-- 
2.34.1


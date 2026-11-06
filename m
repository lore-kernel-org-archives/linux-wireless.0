Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963442;
	b=ZFQwrQ/tFnnFHQRph/AgCULztY7Pun126HFlWKhgHXiAfklKsukPiK4jaeDyR7Hmu7PM
	 RumoeTQTsBZm4E4NG68s8leJi3UJXzEQcppEHj9gTMFDmIo2FE3h1kTMwhhTTTJT6/ldk
	 /ZBPRW4CK92l3W40Xe8iHow8c4NoqQYsjWyilgzsF1MkvV2avKkbi7gIfyrngBN8G0pmi
	 BCfcH3fpz+8Y8NLbytFwDpDwNChdxt304AkscbSdnOcA2NShTQSKSvZTzrVUH+EEohxOp
	 DdTef6wcTVSTAVsPEWy/aIPTwNpDrS7by1RCHFJwjWz601O6I6eNi+CvmG/TN1eH3Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963442;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=noZYc7vxnKjinKNp/93BUTzOMAsCoQ35KTQDuXl4JGQ=;
	b=H2PaVdMc4KnkSFqw22Y0tT55HQ6lp208e+4qvQ/YKQcqpD20V78+nsaC1DN34LX7FxD7
	 lnYYpvQOk6UFsu9IBtwk8gDWgD0vkjvBKi6axDvSyMHIijl9T5Z0gdk0RMwDKU+HfbGzh
	 nnvEbNWcukBFnwUljlRDcIZ5w2XCWyCSRZz5ks6iRe9YsrQwJENCHuQYXgdsE3TEfb461
	 OqGIMTOBldDkmNbRcJNZaDCT8Wn7gy1wAwsw/o3l9UcGUyNYol1SE3sy3nQqRvUbLe48e
	 QwEVPGZG1f5k5RR3Ye0ymJI3+/GHq3OqQVlOXY7EhIyi+eoQG0y1oMu6Z9aEoumraaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jSPJ+txu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XvryYlQw;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA38606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 11:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EA38606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jSPJ+txu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XvryYlQw
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AP7eF3703848
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 11:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=noZYc7vxnKjinKNp/93BUTzOMAsCoQ35KTQ
	DuXl4JGQ=; b=jSPJ+txudhIL37ctoBK3zh32x101mDjm9t+hpHQkaDBXxhseRS1
	REScyu2rs+WkXPN/pzWABgfeL4mQtWo3+d8h3w43rgXqXZNRXar2Ab/VisfKe+XO
	gGj4+cWeppnzd+dcgDvDzmlzkijwn90UsKxW1X2zIdotJ+PEnyZs2exuUftZ7H6L
	sABKWIT+hp+id6aB16zqcYTstDizp0ErUPyb7o5miof0ALxIuDqfhZrgXXaOdTW4
	hAT+1OszjczvMb5HRZsHqK6l/SeNyxrVaOyVoip+QdyY9pM4q/FENAmS27XAC9uo
	GAlhUzesmAXa2uLcHGzGQXCHV8Q3BLceV/g==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa2j7k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 11:10:40 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b0a528ca65so542354a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 03:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793963439; x=1794568239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=noZYc7vxnKjinKNp/93BUTzOMAsCoQ35KTQDuXl4JGQ=;
        b=XvryYlQwSCtpNIIhwQoIAuvpxW4itdCbkA/0JT+jYpd01f0u0iq3dNCSOWYHJ3Tsnx
         kuyFV3ezVMgJfGqI4VCASZKATBESHasMecZl32mA7zsgV5DTgcTIk1pkqv4H5tt4OxHG
         jwxDl5xOKZ32ZWiZPnNQVm+xDMB0ONqfs46U4xTMrnx8bD6XK1fSMBjsQx2gtOix9sHf
         L1tINmau5kmhBxTdcIEvSMC9LtSae2vZpRd3V1eRyjhCqSQHd6aQchR+LHe4IiAMMutB
         qFE0d3VyV6uZoVXLIm/A7jZbOUy8AGyddGn7uUAZzQDdvFG1ZlQBs+mb6AP7bb/AsiUE
         DcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793963439; x=1794568239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=noZYc7vxnKjinKNp/93BUTzOMAsCoQ35KTQDuXl4JGQ=;
        b=jGlWBGQXlqzTBClBXXAlvBcqYi8ANfaNUnBsXOH9ift/kpjiSlKxmHI04juHjofoEa
         VY8wkd7UoExiEoqeGrq+qzMuotu34FXdrtK/nJWUplVroc2abbH5b4XikRA0lwJy5nKq
         ezpQi+UzIWeocn5eXMOzQoCd0bKzP/xo0owI7U61rDqUwdjiYxG2FMSWtU/mAIFy2aKa
         3CTUFOvtCSMZ0yP3+Y+oqcoqwRzuBRMcYBvfzdR6CvU/aKH/7P9YgGaawtdujnMcXfM8
         pxhEU7DLWHPO7v/PGqvoMMfVIq4GO4AOWrZ2VlGyHRBfaPoKwR8br7wibTKaljUSzhYh
         0EjQ==
X-Gm-Message-State: APuU4Z/cSKTTAaZF1lo+PHRZED10MAegzTOEujhjbqHBW/CK6aMEkSFW
	LjCasn1OhgKwHzcuVqV5zKUekRH4QYIxRVffwYmhfX6MnD3tfbrOFlH7CjVipcQtPSNhwt9uDyo
	8rle0D2Ima3ZSwhGXPypnFT9/YPyYn9tWA+l5FjNjmIgzxdmv7/FZPvpeHQlXKx8L2Q5S+pAl9j
	9XHw==
X-Gm-Gg: AYBFou3wdCKsKGtasglvaNv0U++vh4B/D8UA8jicA9X3koDTsnXTb75f9GgCSddTlVh
	U3/T2XnKXpYAQbaf9nr2rQQOnx53M8jkPNY1L3qxqU0/KawpCiZdDikxxPLtbP+e8x6dNTEyNbu
	3l9C8gsBoLwRKoqPqVyPdrtj28zT0ca7eo+j79XWZM5JgeDYMvYRdX67MUGct+nCRLHhQwXgov6
	vRI2eQnCd/NUwgf1rInMaUo3y9X/T+gQ/P0IqkAj/TZusbUt900qtZcwPME3O/UEUQluooz6Anm
	EfNSFhuBcSfCU/J5YnDxYG11sN1KLtZqWR1CoCR/eEqNu9KvVZJPKo16vJ9X85JanAqPUcM81+6
	/YqV+QP9nG/aJRMllEfOdDDSWrK/eEs5tPkoYOlW/j1AYj70K034wxaPjYWgX8ZrixiBhBxU/jj
	pJYnhCkCxTYmwVWrA8StuyRyoCB0lioJygz1AtKVcx74fovSbM6AY1uRAt875wRw==
X-Received: by 2002:a17:90b:58e3:b0:3a8:211b:6c6f with SMTP id 98e67ed59e1d1-3b0db7282afmr2213097a91.67.1793963439446;
        Fri, 06 Nov 2026 03:10:39 -0800 (PST)
X-Received: by 2002:a17:90b:58e3:b0:3a8:211b:6c6f with SMTP id 98e67ed59e1d1-3b0db7282afmr2213077a91.67.1793963439009;
        Fri, 06 Nov 2026 03:10:39 -0800 (PST)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb70526658sm481422a12.4.2026.11.06.03.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 03:10:38 -0800 (PST)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: remove duplicate ucast_ra_only assignment in dp_peer_create
Date: Fri,  6 Nov 2026 16:40:32 +0530
Message-Id: <20261106111032.3157318-1-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA0NCBTYWx0ZWRfXwmDGBaVx5vpW
 msPaVs+3jsc/wfgYid0ILZMLG4s9pIHrvBfpEiS4SH2ZB4hxIAqU2nwzNUhqz6qxz1rWszuZXKF
 8hX/3MBSQdHcv5NLTDIIJS2qJR6I2d9GlOCtW8dzvkc7JEGrvVq6rj1/GQEoUM/n/jzhT5Aa9iM
 TJ1AC/ox+qlBCFx9jCEy0WaOO0Yras6CurF0T7webUVSvPcOP93Lw4cM2Own045OKRDgzLsDLCy
 xRkE9QCovnZ5E6DTNkqBVNMaAJxBnh5WhtD2AjhShzq28iJGRbGoj7U0H7naMDZikUNZqVOP5jT
 HI8hT82mTjfZ2JVCfT0voIQNhS34vQ7XJ5yOrZoVqXsAZh6gC/S37lWarmw9ISNkrczmw1UiIAN
 GY19cFEe9b5s8hdhgz8mvGlVV1hr6makpJwNR8Dyc3b7FOq39VBkBbz7W7rTOiFD+rZSw5nuH21
 iUarqUWsNitzII5Lkhw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA0NCBTYWx0ZWRfX6CFiS+HFGxbY
 BON0lW4K6owiaX7Rzggpx4i0Io4I7I8GY4TAVpz6ZuSwL8B/koP11kaytaGg6RHmD8CNwTH/S5f
 bskDq0OAn6aBKyr9Q8RxTwBXM9phA9Y=
X-Proofpoint-ORIG-GUID: v2ShZFW7ytacqSTVBNW8ovmHHQTUy5-T
X-Authority-Analysis: v=2.4 cv=GpzXaU1C c=1 sm=1 tr=0 ts=6aedb5b0 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=pUlQ19MHUesLrffGXrAA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: v2ShZFW7ytacqSTVBNW8ovmHHQTUy5-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_03,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060044

dp_peer->ucast_ra_only is assigned twice from params->ucast_ra_only
in ath12k_dp_peer_create(). Remove the redundant second assignment.

No functional change.

Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index bb5341b4251a..c9075883f976 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -486,7 +486,6 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 
 	dp_peer->sec_type = HAL_ENCRYPT_TYPE_OPEN;
 	dp_peer->sec_type_grp = HAL_ENCRYPT_TYPE_OPEN;
-	dp_peer->ucast_ra_only = params->ucast_ra_only;
 
 	spin_lock_bh(&dp_hw->peer_lock);

base-commit: b9acb873d035fccc8824164246535ea6fc95c71a 
-- 
2.34.1


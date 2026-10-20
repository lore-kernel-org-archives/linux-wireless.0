Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482789;
	b=vdbWabZqrKykesxzIX9qyWhao7sCU0t0JzjH69qORobzyZrnWYlsyWFmwn1iq0DKlDky
	 hJ/e3OWmKE7h7ppzT3WNryCfrjcAuV+TTwxxmoiS2CYV5XiqNOtGx+qQNkJ/1amJbDUl5
	 ckZ6OaTpLpqTEeC1ydUBpYG02+tnP6OM9p3pcDx/lb/5jV1PxP+taKwYh59k5uuKnfKLr
	 0fQa/Tfs8aRlU0wrujxDZsN4NiDtQqve+SSJoygAW0G97+AM2dEZf9wdTj4dJesl4zOfV
	 ULdPuyAtxyYbxIehIA1VaSpxMh18jLM/Y3TZVbKb1zRjtTTXK8NgG0M2LzB63b8Rpwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482789;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=dZULhqVxGa6w65QkJiF5vsmoK4e+Xzrl3DeeSL9YLYI=;
	b=4FqxRCkPZnrdxx06jcjT/cdtJeDtu2rZNQdQ+JYtFBwLngoyId1TwT9dtkz/V5gLkLiZ
	 zgiXKoPjNXh3IBwFVnEUj4TKBMOZJa/f8wN+6dUKwUl62nQ3cjDHNh3GN+6Cda6MOSzll
	 +d45I8E6NzZQXCAi/+5rDeh/+vCQF+wFSbIZ41gQWI7edKPDDupol5wKVdqYXMao5hl8P
	 IUjoO0nvu1k/hzy7uzp5cHlYbglr4FAhOGxbPfini5+b+6LyIo1CfsOPr31/DH7xCCs1x
	 kSWFeMf0sCgAgGb5zWhVfEmVw03YTc2o/iDMusEB62jXTiZ5v5O8GGQiYCfZ/NwXeOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HHve2Wo1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AHGuWxrV;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0884A606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0884A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HHve2Wo1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AHGuWxrV
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K0t7rV3806878
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=dZULhqVxGa6w65QkJiF5vs
	moK4e+Xzrl3DeeSL9YLYI=; b=HHve2Wo1LcJqsNMc+8UiLc2+pw7DCkmG0OdxGa
	+4S8AXZUkw2HMn7b1sZ/A7W89wXa1d7DU5A89YUlGMwlNh9+1tA9iYastQ05bt11
	lbU7mwCtp1wbTmIkNw2dD6+W2g2ESZPFd5VKDk+SZHZwbSyqANPGgQHJHW5b9zK8
	eA/jninxa6XGnqJXTdfsKoavsSSLKj3euVzt1Alz5l5BEyS93zdwsKz5yrMfI3qY
	EdlqF0gvuArvovzcsEQSX2d8S0VwL38OWL5TEBdjIHWFGCHXK+IyAb3p8IKWuNS8
	W+9Vwq0YALtGtX31AWWevR8hOb1TQGLf68mv31SYFBC7+c4Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5p9fr8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:53:08 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-351788121cfso9126489eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792482787; x=1793087587; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dZULhqVxGa6w65QkJiF5vsmoK4e+Xzrl3DeeSL9YLYI=;
        b=AHGuWxrV0Ox1HV5/TzMQaYLWwropMdpTh532QThn2mxfUlz26Yw/6YSA5slm7uWUF8
         FTeMe3dar5MC2GE77KwqHI+Gqfsl3vdc/I0dWhEmZSlViy42IH/DHLfOQfiwBUImACke
         0yyOSI+brN5j1pgCt47fOJEgW7AQxwa7Z3QI5Jakz81RTfCjqpvOcYaApPOiJirI+gZ8
         zTFyuaw8foPXZqu2PGRWiTPeOS0cjRWDVfMlzAa+qhmWP1jA5EbkZKO+20G38W5df2HG
         SoMgcOXwWx/dajM4VFgzPN1Tr6FVH/YZNVs26IIQOnQ80NpslnTWLK8SWjRp1xdAZR27
         MPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792482787; x=1793087587;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=dZULhqVxGa6w65QkJiF5vsmoK4e+Xzrl3DeeSL9YLYI=;
        b=pomHviAIvUwIPDj8QhBefJI+EdaV2ZKZKa2v28bdrMHeLc5FAsVshNGclU81ZNYKMe
         v9DercfE58Vx6LWpV0rpjSlyfiHbekqKz82WEstHqDTJY8Tugv7lQ+WTrXKKgkxAkFBb
         kJQzOJFzq+cO86x35CFDNvAZyumxRKtJIulw0ntahDPZmt9L46eOqKLralqaKPjOvdwe
         IVdbSMjt/NEhiCb31f1FFvYNlim5uOJQS0guex1IJpJW6EzbqsX+stvAiVeUsjcqj/1E
         vjkGyKEYp59t8BoJkgRVIbN0Fes5X+S5WwqBvH+et2vKmNjrQpnzCmbO8fbrDmaU/zSA
         vPUg==
X-Forwarded-Encrypted: i=1; AKwUvByi5pHqm1jdbOnR2kQbapnbSFX6j0yYE/m1Uqf6+OpF2m2bWRxFoCEl13KXkSuP8kMSymCGkkKfSmX2VJBlCQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLyW64xzXPfKnqizBnE032Y+zVisqApiCPs71lRRCsOMFUI0D13
	BG7FuXFXKJDoXnNKtXezvUYFbY6kVKaAU61ZtI9GNV4uB+VkExwnRXJNo+uSliCEUH3V4Z16VQ5
	U5ePy0DX/eGvJIKwKh06hlEBYC+LHlhZNxe4CSmee0AQzvP0G0RtmnAK4ZbQ6YIr+q316AhdbPA
	oJp4BMo9o=
X-Gm-Gg: AYBFou1C5IBD00MthOVEm6TzOuIH0EX97jWeEPEbDow2hHgwgFLwnlTF6WGpA7Fzo5B
	xNxKi9OVS1w2MaDb/Qpk9KR/gcF555DrAls9BnLQIzQ0/jcLYKFYSFsl/deBY2hm+CEmzpr5ZXw
	637H0zBQdSCEHUTcxZ3T1SbpiHslx0HBxsMVoYgEhAZ/k+cljQq1m3aFSu/jqcQgtwhfPuMC84O
	4TiQdrD91pflUeX+i/tvRIZ+/omSeUrQ4GQTnTHari7LwJB5EVHVqA30WdEv7OrajkoxT4x1wHh
	ARsnqVuc2o873HFk8vbp9nKXkgg3XBydxNKEkG4Kj6W0y4R36tqhYSellmn84Wou8sLoAhBwO3u
	QHaj7BTJDx8k+Qd/n7gw9Tk23PrK6YXCVOs3061Ct/CvdbZcq65M=
X-Received: by 2002:a05:7301:22ab:b0:351:7ec0:daa3 with SMTP id 5a478bee46e88-361a2541f45mr16393593eec.31.1792482787310;
        Tue, 20 Oct 2026 00:53:07 -0700 (PDT)
X-Received: by 2002:a05:7301:22ab:b0:351:7ec0:daa3 with SMTP id 5a478bee46e88-361a2541f45mr16393563eec.31.1792482786739;
        Tue, 20 Oct 2026 00:53:06 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608308a87csm63829468eec.28.2026.10.20.00.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 00:53:06 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 00:52:50 -0700
Subject: [PATCH ath-next] wifi: ath12k: set MSDU payload correctly
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIANEd12oC/yWMQQrCMBQFr1Le2kASYileRVykybf9RdOSn0ql9
 O5GXQ7DzA6hzCS4NDsyvVh4ThXMqUEYfRpIcawMq21rtNXqKXFd/Psx+6hs6KILhs6ud6jFkun
 O2+92hS+jSrQV3P5G1n6iUL4zHMcHwz1Tr3kAAAA=
X-Change-ID: 20261020-msdupayload-2c8d4c1e54b4
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kang Yang <kang.yang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792482785; l=2433;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=0QLjlN4xVDDPAlasPy5ys/3L8XpQjPcTWrmFjypqwMs=;
 b=2L5Yc+AglV1IkLyw/yoK4HQ/bzPueEFUOHBlMCLdg6KHzhuo4sttL/WD9xL6mD51voEG6RnKM
 i9QLSnXb0lFCNlL2FWXEsOaKkZbhdDHv4U+edxdf5XcaY/KrNg/8gIe
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-GUID: wDtA-162E8q3wLKeFG0ayp42V2OL-bAS
X-Authority-Analysis: v=2.4 cv=fb84WEQF c=1 sm=1 tr=0 ts=6ad71de4 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=YtwzFU1t9WoBE-wIZ8cA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzMSBTYWx0ZWRfXw3KkujhU6SMd
 SmO5BniLvC3Wvdv1Rb8VuyvoJJdmQv3rR8rvRR8VZ+/Jnj0ChqsVg9AsTbu9hnPKH+ny6grV/sP
 /dre5ZVyoO1zCMBWhC3hLTBPoEK86gP9Xvueppu8zZt48BetcY/rwlAHxOYUcE2z5LzQU4w5h2L
 OVAJ2donHA5pspGXDgP8xt6zQXZNggEFIgagbWugYxz0BpH7lMgbL/mM+DlduXWGE+Efuw7gXae
 iZEvu0sr1dD12d9r9usQ/lGyk4y7wL64UMFV+C48Xc0BDI1LnaICGLtBuxEBFebT09bxM0mFqQZ
 7PBNMUrr5ThHv2f1zWUq7PSNlN6FLdGoODqWZJXV11Jq9SxVdAd72ZGTxO5OpRQ/FZe30XRgGsj
 nxjMEtoUBu2JCx895KFWl6O8hH5HXO+0CiafYjKSqvx7eusphRgoG/ENJvLb+GC9tW6RwBr4tK4
 4qqwmfqymdx8OqM9PDQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzMSBTYWx0ZWRfX1UmShvhxwVwk
 32vt7avv2VLuzOaVfJ23f6Xi1r0vU7i37QnHQpPlM54FuT8pjKNAQhC4YTbYbVj6lLGg2vpneEo
 brmrEwPs1u5sFv9SsnbF//2OJ5ZAUXs=
X-Proofpoint-ORIG-GUID: wDtA-162E8q3wLKeFG0ayp42V2OL-bAS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200031

ath12k_dp_mon_rx_merg_msdus() mistakenly passes head_msdu to
ath12k_dp_mon_rx_msdus_set_payload() while iterating over all MSDUs in
the chain.

As a result, skb_pull() is applied repeatedly to the head MSDU, whereas
the remaining MSDUs are never adjusted.

Pass the current MSDU instead so each MSDU is processed exactly once.

Also rename the helper parameter from head_msdu to msdu since the helper
operates on any MSDU in the chain.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 1cf514fdc790 ("wifi: ath12k: use different packet offset for WCN7850")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 709507d44d8e..ae14e118fe36 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -186,7 +186,7 @@ ath12k_dp_mon_fill_rx_rate(struct ath12k_pdev_dp *dp_pdev,
 }
 
 static void ath12k_dp_mon_rx_msdus_set_payload(struct ath12k_base *ab,
-					       struct sk_buff *head_msdu,
+					       struct sk_buff *msdu,
 					       struct sk_buff *tail_msdu)
 {
 	u32 rx_pkt_offset, l2_hdr_offset, total_offset;
@@ -200,7 +200,7 @@ static void ath12k_dp_mon_rx_msdus_set_payload(struct ath12k_base *ab,
 	else
 		total_offset = rx_pkt_offset + l2_hdr_offset;
 
-	skb_pull(head_msdu, total_offset);
+	skb_pull(msdu, total_offset);
 }
 
 struct sk_buff *
@@ -261,7 +261,7 @@ ath12k_dp_mon_rx_merg_msdus(struct ath12k_pdev_dp *dp_pdev,
 		head_frag_list = NULL;
 
 		while (msdu) {
-			ath12k_dp_mon_rx_msdus_set_payload(ab, head_msdu, tail_msdu);
+			ath12k_dp_mon_rx_msdus_set_payload(ab, msdu, tail_msdu);
 
 			if (!head_frag_list)
 				head_frag_list = msdu;
@@ -296,7 +296,7 @@ ath12k_dp_mon_rx_merg_msdus(struct ath12k_pdev_dp *dp_pdev,
 		msdu = head_msdu;
 
 		while (msdu) {
-			ath12k_dp_mon_rx_msdus_set_payload(ab, head_msdu, tail_msdu);
+			ath12k_dp_mon_rx_msdus_set_payload(ab, msdu, tail_msdu);
 			if (qos_pkt) {
 				dest = skb_push(msdu, sizeof(__le16));
 				if (!dest)

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261020-msdupayload-2c8d4c1e54b4

Best regards,
--  
Kang Yang <kang.yang@oss.qualcomm.com>


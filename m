Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754662;
	b=5ZRliiKL59MLUebo91zK+k5zx6pl/51IOx7jOMsKJTFo7l85zq+9OAvpVTUvHP6O79ee
	 rI6OLhYxpGXGo0ZBo4njenO1AGv8B+TJoZtzmJLp6Cf9vOwMFjXe9RmkpRl0WOKhuL+L3
	 1m2poEYjhgvyGQ3U1AkBcpuzEAWXjJYdME1Ux7b164M0jSUyiPbz3okIZZT9syIHffMGa
	 brI3aNnaV/TIa0ZeL8renmRWnkZLJwRH3F+Mh4F5ICfhb5AGwKuN+6hrJgFpD+zkfE05S
	 GR45CdTHEHEz5DcF/auenF4O7oEZ9TdvyM6IByKyouKTpdkEEM56lp9g7QpaXpeCheg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754662;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=YDVv49g5wGDYW/TBym1xJdEIpdUnM9Rdd3PxpMX4Lfc=;
	b=4oyWy0EpvC1sHzI9Gzh0GfrZVrPGEtYItOE6CTRUoyR4mr8S/NZYMKL6n/Iwe3rQAXW7
	 v54nHgrE4ugCcD9fVJtbzpsNm+ACbuQZHit54nmLuL0BUKV6o2Cem6OH+zCqdliFMUGMq
	 HK4riXcWLn+0NPaVLwwxLKJVi9WqW8FGBuzaWKRqsYc3Fx9Dko5dYBsm7qA+4kE3FmI+7
	 USGCu/TIqJMcQU/wHYXaXQx5ukMU+6Vb8olHOmPBEda/SksdoDG/ZH6/c2Z7JXvbKba6C
	 0p64Eub3xyd0F/6KcBBrmSIbsLyNM8oyJltFhU6iYdnwCGWJUTLrsuxi5mpg77R7Iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="af02gw/w";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NXqR0JfQ;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D80606A33E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2D80606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=af02gw/w;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NXqR0JfQ
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40REHe3335342
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YDVv49g5wGDYW/TBym1xJdEIpdUnM9Rdd3PxpMX4Lfc=; b=af02gw/wUjXeLYGD
	H9qVGJJmul9JI+H6epG011kSXd1QEptcw/8uzFb+48xFc+prqWnUNJ6gv3tHBHoB
	zUOQQt5qgQ4Plv7nFZZwp7grY/hepLBXbzEUgWtDhyKxBgo1O8ErvY9ZjstEiTM9
	zeroM+r6QZn+ggFLJ9H0d4MTmSoOxaMhJQ/MZzltbK55dHtI4+dILSCHLzfTGP0W
	FiKwota60tMNgAR+MWNDeEcoPlkc3N5RNCKJak3S+YzKq3+SdJn+UsuUJg4QyIZc
	cVBtOp5QmdJQoJNSmHSOMWR5BLzYq9qtZbCMwsvBs2nW1KolWp+uhK8EYebNUruy
	CTVtgw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqmjbsf9m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:52 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a1e2485fdso261746eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754652; x=1794359452; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YDVv49g5wGDYW/TBym1xJdEIpdUnM9Rdd3PxpMX4Lfc=;
        b=NXqR0JfQRnL0n25MLtVgb3loPnEbdXwVOoDh0sBm0FeLyWWsKzzHDdlJIUCJMTM86r
         lE/AwbwIueLUEvnqka+ghcxIDCIHO5bkD5wgeSFM1uGk2rDTGK8jfgDLUex7khTeM2ES
         f3e0thrT0V4ctCdAFU+kUyLmjmGC/wGO1O8nr78SdWC3n2qabIi/p4kXHBSdyXV0SmVD
         XS3fdizRjQS8lNk6k/+dX30+K8CMqc/xqiTw2CcJ1xwDyimNhHQd9SFz4KCscNk4QsQ7
         kdRE6cS6b/mhr9Oe98aBhV7UAx3tBw+VABLpOYGTvr50glmWjH6yH1uNz4fpwFoNHRwQ
         9nAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754652; x=1794359452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YDVv49g5wGDYW/TBym1xJdEIpdUnM9Rdd3PxpMX4Lfc=;
        b=QA0sBrPkJVtU0u1uV7D9Px8U46GtC+Y/h6/wYh1qTcvQEoZyJL9YkpPw8/wXOaxVDH
         BlVGDaSxvV6N31ekm5NuCVsrStdWB4FuM/tfrzbraii8B1KMEIddyqIIIr8GWKeHxcVO
         +8uqPnCpXX/4qlCeYj57bH+jZmQHO5d0nt7H91SUZQwY7Um9LqF2aSmwCjdWi+qlTgCD
         Z4h4TroPkaQzOO/pONQtXVMmpIZYFIiRvVDfmhCjJ/qPN6lTe7bn8i7QWy+fsvNxKRX4
         HyAfdXvb5jtGlUNcZ0NocRcL2Do8fUSDm+UFNZCJnkf0CgXSxP+X2MEAE2GbM3iI+TlS
         xA/Q==
X-Forwarded-Encrypted: i=1; AKwUvBx9b36lX3g8LBv2lqFE19nNVs3wDckRrXskUtJ0Ile9IC2N2L2pZNWh2U0VRilREfdH9wbbdolznGYMP8eHVg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/ap5xf0gJV9YNctI0hMvYolaammzoDf3laijnPsal11OBZ15xK
	yXp4NpoxTud0wEchW/W3/9sx2UZPC6Se157ihVzBmEHtmvTkbsUvHCoWLG3OplMzSLLL7KRqydp
	66whzYtPjVX1zweSikYHgFWrw3wJEmJhUenN42JIfIaoh4QY2s/1ekhfTUMlAqEsPJ0goUea+kz
	MNqA==
X-Gm-Gg: AYBFou3eiq0h/Z0h1PrB74g6ukrBWq+oeakYGDJsZspE8zOJ1FyuxppTQfv/BehIQFf
	5CN+BP5kk/LRrf7XtlwzcTOdWauWIAq7BrUpNIQf/3q+KKLE+YYVvuZNp2lstihznEr747ySfUx
	7n3W3k/bF5a1I8lwaOT70T9IdYgO9QJkfxmqzwxctcR6dzwUnkHPpT5JSErRhf0zuJd9g9T45Jo
	KuL1lcD+lnRo+qg6v+StB+h3AdsKKoqPlf/fzCuVF6VqoZ5EsB70kCJ+tKHVKodCp2cVVo9gx4T
	38k4BTFMj+9myyEbHWqWD+tQL791fmd3YWfV/bO65arVHKsvlx4QOFqYT+7ACw//WMiCVCLq8CC
	o1lf1aVmUGiuVvC5kdWHSpDmCjhC7r8YZ9jqnMdf7NGdNz6WFE1ecNo/QWLzvsSdwceq38oTB97
	TJiVCcEXzIIdsJp0wA256nBQY9ROpKNUSM662o
X-Received: by 2002:a05:7301:152e:b0:366:83dd:4713 with SMTP id 5a478bee46e88-36a4249ba39mr19452028eec.30.1793754651565;
        Tue, 03 Nov 2026 17:10:51 -0800 (PST)
X-Received: by 2002:a05:7301:152e:b0:366:83dd:4713 with SMTP id 5a478bee46e88-36a4249ba39mr19452000eec.30.1793754651063;
        Tue, 03 Nov 2026 17:10:51 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:50 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:48 -0800
Subject: [PATCH ath-next v3 05/13] wifi: ath12k: ng: log successful RX TID
 queue updates
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-5-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: 4MfmORf-o_ZOhkxrtAySumeTsWMhJONh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX9k03KlV5Pqs7
 IoF/s0UJAPpVilByaCaobSlpKJdj4gS8u060WKPuInpRtDDDd/7vTIs3enZGartYJO0DlcmmAQV
 KZTah5025NcWq+cBxBkcq280Mug8jZD73ciseNA2k7N4UksH4PqHUXryvD/2A2bmdBASRkifBt1
 j6qPXu1reP9JELUU6sTjytiasnFPE0Xw3O0hIkUTB3UhTdjxhqqoGhLfrJfn3jPQH45Lf7zkv12
 Gl4yF5+JvkJK9B+WYO4jjVIlbFePkEASPHmb45ufRXjooNAiudt5jvjrY3AWiu5sl8zWZ4bS+Ww
 Cfy8ity1aTNFld25iGw5htDgRsSty6YNfToXEOkqIATLEt9c6DfgUudUmekfxjUkQpH5NQtVNAq
 eYpqMIhdEHUdjeC85sVu07hhWCNgJNHdTqyjKsapeyu+l44RgLFrvu7DjompYneKRe00IUTwhMF
 hOYJg5gLmfzkB84Aunw==
X-Proofpoint-ORIG-GUID: 4MfmORf-o_ZOhkxrtAySumeTsWMhJONh
X-Authority-Analysis: v=2.4 cv=NMhAaE6g c=1 sm=1 tr=0 ts=6aea861c cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=YHCRzYEaldKETWWiAM4A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXzoBHKRuA70zZ
 JzBFjg0fVSmo7yeqITWUrEFaf1e+ZuYDOd+rXnA4kgtbRdTF6La55zcwjf4gb0v1i783g6z1ZDV
 NDv6mMsHeJCGPEah8CiJSL8OmN1Qpz4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040004

Log the peer, TID, link ID and BA window after a REO update RX
queue command succeeds. The message helps verify the programmed RX
reorder state when debugging aggregation setup.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 379b33fc8029..7d196e85f280 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -233,6 +233,11 @@ int ath12k_wifi7_peer_rx_tid_reo_update(struct ath12k_dp *dp,
 
 	rx_tid->ba_win_sz = ba_win_sz;
 
+	ath12k_dbg(ab, ATH12K_DBG_DP_RX,
+		   "rx tid queue update successful for tid: %u, peer_id: %d, peer: %pM, link_id: %u ba_win_sz: %u\n",
+		   rx_tid->tid, peer->peer_id, peer->addr, peer->link_id,
+		   rx_tid->ba_win_sz);
+
 	return 0;
 }
 

-- 
2.43.0


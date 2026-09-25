Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A219F4CCDD4
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350017; cv=none; b=Q45dMQOMwwPpn1V57JSdrDDpQO+LAvBjcJs19lgz53TtIohB5WbJA4aTOq+TtwUnO2W3x64wG6q8rWyWjQbLyC9+wQeOR0r+qjAgmfvBG6ykNwtGBStaJQV8HfEa7Yzeg1IA+kSJHvtrakvPxYHCnNRvJlo9TXPa956TNlHExBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350017; c=relaxed/simple;
	bh=Xlu28ONxaFAA/BRuOBNZ8fPFGFx5Kj6VniZ365HrH84=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=geCj0G4x/68FUBbWEdfsUmh9m7F2JVCgpT95ZMimdZ3eTj0E/fl/r3QEPJIR3r1UXFKZAg+IQCVrCevLW1zW8Bbzma9X3SNJ7CnJxKdqB+Vl+mnR3FZF/K+xpAlov0+UAe/zMSrdaiYUrIo3gEW3DYbJTaC3Z8LGNJq5SdZuM4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fqIxs2cO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BlVZv199; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fqIxs2cO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BlVZv199"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PA4EeT609181
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rXVQc6aLJixe5RrAOxuDkgZnGe2vAyUG+yHDdq/ggLE=; b=fqIxs2cOyz0GMOwB
	0etcScGPyuq77tfsZ9qPkhOZahYV09dotaapRQ638IIkdCVionNUc6zpQtEuBIdW
	92T/nUpbSp0QyZZIddenTkzyC/IbGaEBsGRSwj62xDBhVIJKEF9oGn0EPoheBUc6
	S0R9xMYasjwoT7897zcuC93SWp+LKb/lN+RxFLsXL59L8geDKhbe6oIDBU9C2BuT
	G051klYVVj1nhgTwxG8yEVlZiJCocIIXzTxYACeQ0dW2Dm65uMDPD6aVFwopAJM7
	uK6AIMlpAyecJ0K6akg8hSPZ8C7QNUNK5WnBRebUT8vZusvP6HzSt8j9Qp2w4MoD
	5C6loQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwpvns29v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:26:54 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so2675300a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350013; x=1790954813; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rXVQc6aLJixe5RrAOxuDkgZnGe2vAyUG+yHDdq/ggLE=;
        b=BlVZv199TJJjNAYGPf4rMlVmUBUIjQa/AbpfkimqIvJhQkbpouYnifJe/eo2HFfeCJ
         38DN9T+8MLtvbRMQmH7Oy1zm0yQ/wXHux36K4OpZGkWYqMTGEzzB8PiursciWAlLN8W4
         gBPpINoY82QDq0LCdgAmaNkxQaOm9rkI9P43gyy073XO83QwEYenfoQLgdUZzR9zst/c
         rcUlR4AbvvG5Omft7F24I4B0c+SEKPfjSQf1sL/6A2weKo9nUyf6sCwZCLoGJmfiqIWr
         vIGKDJ8PsBc9rkhw8lK7t4rE98p/2VB0iYqLg0Bo0WpiQJGfS+/LgkcP55q3zr3uLm11
         GU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350013; x=1790954813;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rXVQc6aLJixe5RrAOxuDkgZnGe2vAyUG+yHDdq/ggLE=;
        b=Lsh46H5CkIukNzIi0GQ20iimZwT5kuki0yQ86Cny7svmVyLORsY1cB2rXtknYBTVgo
         MvUmwNorQ6EeseKjZ8Q/NZ26c+cXBLn29dbwpabO+HNDzEtweu8vgOiC5TYGJl6mhGG8
         NRFsz2AMTLIO01hH8rbfQHKlk7KFcQJguSHP2fLgVKkBv2VMvtfyyun7JvNfRDEFWIYU
         ir5NOmYWByFgnyT149u46VizTmyuMmivS1mMdd9vp3JB2p4ldoGGeI1vPPb6r4kLPP7V
         NbEofgYB25u7zlKl7MFFoN6zfTl+s17uVA0XB4f5fM5bW+KN83u5zS2caLmz3wz6PuKt
         YRjw==
X-Gm-Message-State: AFuF++lpE2bRjS/PUS4lCDq/Z3NniUecyCCoa4oHTphRtkKELcWzinol
	5Y5zMdKeMoT+z1Vs3EiPbYvDEFC1WhmeZtDng3ViLQybR8DOAJDyZ8VJp6S3W2W8IuAyf9wMFCk
	JJP/v6ewsDFwesLDKfSzd6p/ft7ort+lcwIvqnsxqPKMEnTdNeFabrUupiREweJvPDoYG76NcO8
	d9+Q==
X-Gm-Gg: AYBFou2mi9P7PAAj+x3YiPi2yZW24gghsYiGcwpc53p9/Uh/Jo8Gum1Qp/QhhHgNloj
	Bo2dhM8uF9txGrFLjt7mVUsEUsWFUsKQDbWn6aYrnLto1KUcTsibFeXSFZhGs2G05GF64Lp1Z+l
	TQVxpvIZJn+TMnjzRA39j6eg/6GhdeC7lnHsp2I9zuDmg5dCHYFZO4jK3y4U/f95qmzm5+l+Zh/
	z02UGDqantdzVwlxgXysL3r0B2zGFxx43DY0IFiSmVTg8YpUeYhd2b5kK3lxEsMoOtpam2uu88t
	XFotz18gjvtCTjzBCT5qqzqVZOY5tpblP0bNmpFeMhrkECkALRtWvNQF0n35gNYaUV8Ao/cyf1W
	1lBw+kLqHyAU/RAx0oeO9+iPrOXAG5fB+TVFJbb0aE+VZnxCD3bU+Z5c=
X-Received: by 2002:a17:90b:2251:b0:3a0:9640:8031 with SMTP id 98e67ed59e1d1-3a098d4364cmr4939324a91.8.1790350013302;
        Fri, 25 Sep 2026 08:26:53 -0700 (PDT)
X-Received: by 2002:a17:90b:2251:b0:3a0:9640:8031 with SMTP id 98e67ed59e1d1-3a098d4364cmr4939304a91.8.1790350012765;
        Fri, 25 Sep 2026 08:26:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:51 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/7] wifi: ath12k: convert DP profile
 parameter macros to inline helpers
Message-Id: <179035001156.3875741.885181265927010511.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:51 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: HkRQcWYTAToJ163q3Sztp5_Z1nSajwRJ
X-Proofpoint-GUID: HkRQcWYTAToJ163q3Sztp5_Z1nSajwRJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfXz49XeRPb2SgQ
 804/6i5bWbiyCGMOtHMJKmngpzN3o2vbMxWZA8GpAlOCPGK/iXuKyiF5mdTiM2AK2Bfojo0NcRj
 pITjW6CI887UZzj/+HSNyycqP8tmCYs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX3v8Lzs4Z1qY6
 TT+g1rARAjdI7Un6nfIKA+1f7Orto7wKjbIbNBZuanOmoL5HvE/xOyR/fBwDWJUsovZtU7qXHU1
 9n0ehID60OKExQtoovRQ+8kllHqBi8HXqujO9u0LjGD8yaDAbjai3hhIxWjU4KDT8nZAg+Oo4oy
 4ul3v99WSOc4L3/ILFmi4iuPNJL9u0wwVGjDg/I4zJgg2ykcUSUA6lq7XwLYqSMWhgF5GBl4pB9
 FFhVmAHP6d1VzhvpHM5R7X0WofIr8lSdBGez5rpqSE+06uTAZGhp0RjercajujGnInt+f5iNqBR
 tAiuL6LvClxsldyaI9XYci6mOoThjqIDH8GsBALCavPgEEUVriuI4SGxk4LAusjaiSBjzidLB5T
 lEGmcwAOnMk7yIj3JIW3poj4BvHxI9TXNQ6wDNW7J+fMFyE1b5o+fpq04tTvFftOjqYsRG9GnHl
 LnOw2SHVqQmdk+G/O8w==
X-Authority-Analysis: v=2.4 cv=eNmGH3p1 c=1 sm=1 tr=0 ts=6ab692be cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=Ch_5UUNQQzOSiarRQcwA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250061


On Thu, 20 Aug 2026 11:17:57 +0530, Aaradhana Sahu wrote:
> Convert the Data Path (DP) profile parameter macros to static inline helper
> function without changing any functional behavior.
> 
> Aaradhana Sahu (7):
>   wifi: ath12k: move dp_profile_params to dp.h
>   wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
>   wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
>   wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
>   wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
>   wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
>   wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
> 
> [...]

Applied, thanks!

[1/7] wifi: ath12k: move dp_profile_params to dp.h
      commit: bf7c19e231e2f48cafddbe3f4c2a2f5b6184b55f
[2/7] wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
      commit: eaff19e86c2dbde320ccc8812cafb0a366dc65f4
[3/7] wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
      commit: d57f90669269fad2dd9ca98cd32b7412ceccb0b0
[4/7] wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
      commit: 62e2758d17d307753457bd51af074be5f8265c03
[5/7] wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
      commit: 99b85a24189a518938eb0f1c4f8e15fbab4373ec
[6/7] wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
      commit: fafb9b0450fd6fd3618daf347717a6d6320bea38
[7/7] wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
      commit: 897d2e0046f941d8956f655f5ffc5d75c788558d

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>


Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941A2D4B68
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2026 09:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205786; cv=none; b=mAWfcuXwR96vDOhHqqVSubWiHPtXBgnmitZSDqNwUdM5rdKUWEYvgpOUtzdYnejuG0u4roFSLDJBa30BS0h2VAaGbK/3gMZQqpUfkMm3nJRRFkQDe8sOY7YRnW4l8vSJ4mBECkl1Mwykuh7SFs0EL2LTHpooVdKkLia68my3r6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205786; c=relaxed/simple;
	bh=sZza7BFVTwAsNCMQE7wZWRpxGt50qguZpQ36eZ/HiNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AeuAVxPr/xCH8GWxdIgXXbsoqnlF9Hm/SxWVuoL52ZJh1pxSkzaWGvgyWm1tSdGPSG3SAmjBlMgYX0R7oJTtFS7xhXGdU36369q0iM2Lb5Sr0dFIauUJIjAgf1CUVW8+37ZOwaOJsgyMJxazD6URov5n86egw+1tIoD6ZK00/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TeKFsrNm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O4sAG6Yx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TeKFsrNm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O4sAG6Yx"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N8kAAb3354712
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2026 09:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X96xsOqsCkbxYiEhQpEjf0D0dIK3FoXdZ+rFU3Qe7Z8=; b=TeKFsrNmVHzNt4pj
	tiQTNQpBmUuybMW2JMaV+GK9v2G3AXAF2Jo9MmSXoVENPVf+JDDUWkom0v9+q2Fk
	9pQQBrGnNqeTBlSC4rjRA8rozmGKvyfUP9dJ1V59Vyj6To1GGs84hyMLrRK3NezQ
	ekbEiFjWkEn3Lrwy/6rFezZmgg72UJgrypA0IRa0z5f99fjvP+gY3gidM+wPZaPc
	iEUT1TqlYracOmSV/D0AmZvdfF74NF4PcKzQpXYGIz+bwUXk/bbhqvAuZLNgNxVI
	xe7t2DxnlKaHaP1YOWfKwcuD7fm3rLUpvcQc12E+7Kt4kQAk15PLRx3GQY4efnFY
	TvYn1w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eypx3838e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2026 09:09:44 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c8c7f6c6069so595143a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2026 02:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782205784; x=1782810584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X96xsOqsCkbxYiEhQpEjf0D0dIK3FoXdZ+rFU3Qe7Z8=;
        b=O4sAG6YxTjhMhI1E2NFTPKxVXTwPxP32nactiBclVDy9rClks0YPFAaYoIR+LeM7Ye
         UYMPKV5p6xnVZHQypoo8874tXitKjMGOfLrpClrkKTcXxzX5ToLjXw2WCgnjREwrD/QS
         ltfNvyakqeUpY8DLQH13h+f5Z9Gx2ivrqzCGggaBJIcpuYLM9RcizBe1132teoKd8orz
         sPdiqKnMn3pbFswPdRGEFOE+SswK85jSLNoYTOQwL1HYLM+YJcR/Tffyp0d+pzbYDWIa
         i1ppQWaIbnt6Y1MGgIPJex6MUC/8x3qJwvwNkFmTfUFvlF3StaUO/PEU2VQX0nFLKXgR
         +7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205784; x=1782810584;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X96xsOqsCkbxYiEhQpEjf0D0dIK3FoXdZ+rFU3Qe7Z8=;
        b=dfMD1Hkne9fyftXn+JdgLSc+8ATnmgGW4TdZkMU7/azmjyWfIAXgDe9MFnWmDqpjkB
         +0DZVdHKWRP56BbTzDf7e/IODEu9CfQ8pU9OUK9u8T7tijNNpxM2byip5zzanb/7XhAQ
         A0X8vh9XUEWDfXPSnxkNITsVpZu6o0CbZTEEDBtkA9yepMAHiS5s78LelyTRtGbyF4/4
         hO0fwknH5oV0HGe44g3dsMhYdwkvgcALvPvpW07lZzA/3FHGvZRAU5F/kzFrR0WVCYfK
         jnqU1rzRRl01DKugRtbSPFdzfooI3i3NUgyMrKaCgYCbaHtzgkF452Xujd7dwlvI4LF+
         41eQ==
X-Gm-Message-State: AOJu0Yz97Qu9Su37oLoHuB2DYcflJvOaUvfmZgPRWktIqYIcQSv96VAO
	bxfaig24FLgv4iGtsYSX5ke/KmWv12swWqaMpWJMmHjlUND8Zf6EWWJhE5fHWjreFHNgb9hbGeF
	6DjCpqaYlmjIPOF6EjhIdR6da+H+UHq6SPlhzQowRYT8vnCllUa3nhdgIdR42nSEPQQYmTQ==
X-Gm-Gg: AfdE7ckVCwdjitJA2uqktNty+Uz9mx9Aprj+XL7kF5+zCOVgHLYKkZ5F0tyd5QlVa8b
	L9+AMkY75PPGT1IkVH38Q1yXDbjMgludD1cA2AfKeTcRleC7KC05qQR8nB1H6RUTriVUts3QP80
	jguIBxo3STqMbt+McKsmrynJ8/DXnbe5yDCxByR5yFMb9KJhIohSUjFq8vzdCxrJGrFTWLEgVB1
	kz2omxixZ70S0+TN2zRyO7epEikr7XtV9DwwL/iMliYYLnhTisCRkcnOMBQzJT7RneEMlVico2Q
	ljZMOJp3QZsAbvBDeD5sOyocJKJd2CuHDOPlaJ5O2QJRhrJBjpE2KiRWnnIRUEcVofdod38DS5a
	9Hg0X7wROY3eL1uCVLR3cTkF8KpVuxNnJz+dnnCx/2UTA+NM/90lz1PXuCtC4jNoQZOQcukJQUh
	89Wca+XJUI
X-Received: by 2002:a17:90b:1dc3:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-37dcd66b178mr2487150a91.4.1782205783988;
        Tue, 23 Jun 2026 02:09:43 -0700 (PDT)
X-Received: by 2002:a17:90b:1dc3:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-37dcd66b178mr2487121a91.4.1782205783542;
        Tue, 23 Jun 2026 02:09:43 -0700 (PDT)
Received: from [10.133.33.165] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4eff2387sm9439796a91.5.2026.06.23.02.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 02:09:43 -0700 (PDT)
Message-ID: <8e80b697-e359-4970-b823-5d7e9a86b3d3@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 17:09:40 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: fix skb leak on incomplete msdu
 during rx pop
To: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260623064355.1876743-1-manikanta.pubbisetty@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260623064355.1876743-1-manikanta.pubbisetty@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=EsfiaycA c=1 sm=1 tr=0 ts=6a3a4d58 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=PSAErUXHYyYb-UPQJNEA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: E7e5BSxOQbe9oi_XO2FWb2y3pykSk-tY
X-Proofpoint-GUID: E7e5BSxOQbe9oi_XO2FWb2y3pykSk-tY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3MyBTYWx0ZWRfX60WKEpvSDk8W
 JRHglXb8kN37bF1jmwIu+4lVnSPleLR4stuFjOt1WRtPM9lZFlCphaaOiV1WcTXvTS3hZYrcKM7
 Igpbuxk93pB5pUugjipdmUVxnXc+pIY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3MyBTYWx0ZWRfX66eE2WJTidQO
 Skc979HReC2Wv7y0DsL/MWvKzGk5Rp/MPF1t6k7hm1Nb721j/JXV6pYN+vbU/N6/hVJh1C3R4WY
 84E5pxMWE9sIdSdk8Bvv63+Q6dPe3V3qJCYHIkA/7mgfMWLOBvLlqNboKu5QX3wu7n9NNqCaKXI
 0jBQwrphsFeTtgi9uBiggsVQrO5SAQRQ9yMW1X7n7tJw4NdSaXrAzY6Fty16nyMFZBe5l0kaCHJ
 T9sL4mLWpGJ3ljtKqP66OuCuasiqNzrrSOqxRct3ksBbwuIrkUZGywlidXRe/URxdl82AB6wWxB
 PFqApmNNTEe4IYXr26bD/1yChY3cLSG07YPnmX43ETl+Ui6YPXPEFA2+Lsbh7Sjb+RpMcu7dlPR
 Fll6KYpbEJBsf+YaV1P1EtUQUDHb82Qxb2mgemNuGI13DsMay7GAftCHu5whVEsVkODoFabW+r/
 ddEBGXePDZ5sg4dnV6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230073



On 6/23/2026 2:43 PM, Manikanta Pubbisetty wrote:
> When ath10k_htt_rx_pop_paddr32_list() or
> ath10k_htt_rx_pop_paddr64_list() encounters an incomplete frame
> (RX_ATTENTION_FLAGS_MSDU_DONE not set), it returns -EIO without
> purging the skb list built up so far, leaking any skbs already
> queued in the list.
> 
> Other early-exit paths within these same functions already call
> __skb_queue_purge() before returning an error. Add it before the
> -EIO return as well to be consistent and prevent the leak.
> 
> Tested-on: WCN3990 hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
> 
> Fixes: c545070e404b ("ath10k: implement rx reorder support")
> Fixes: 3b0b55b19d1d ("ath10k: Add support for 64 bit HTT in-order indication msg")
> Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

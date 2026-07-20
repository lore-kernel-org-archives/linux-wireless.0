Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE13353EE0
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527153; cv=none; b=kT1EhDfWWY0wQ0Phu86WCa+Di8yg7yE93kDBd8XFCTE1H/HUntlpTwZC6dNAdcuoYBzzisuUm2jgmGzL4H1FZDmVxjstzR2R7Un2QWcUdEfHyjhgzOOVqf1onMPts3YMUzcq3HUik/prWvRpL+yL0r7hH78zUbeTPVAdcRh8X3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527153; c=relaxed/simple;
	bh=fcxdEPgmtMsD5/Bgxx2HXUGuCRfOMwHUWXQ855G9/Zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBJaYtJEC7pFUGDXuDEf7JDsIU6VPd5tUuzoNw+vFBdg9tz3ZTDaJVJK2cZNdN8HKIYR5FLlUt3qBDBfDolkZJXDIV3ais+B+dN3J/GxVMopVao4x3Y+YxbuRNfauHbOclgxItMnv8O/9aJ30SgacJz6fUk9tRf0lGAKrBnjIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kFx8AlDE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=de7U48FK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kFx8AlDE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="de7U48FK"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNsBJa803437
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x1uefA3+UQaby4KmgeDxHdUwVrVHdjO8FOubPW0/W2U=; b=kFx8AlDEEVK1tFBS
	QtkWDo34XI5Q4pBIvOP125535m8TWAnf+AwnKPp7kot0WQ3UVBwOPIzChnF2JqgW
	O0dpu51QKdVl8lYRs5ed9eIUJTbN9qEjRYb2qdr8KMfI04D6yCVOapbKNBLCa1zp
	TDgBmCsBxe/B7M0DgSF05axKwnLLC2HCiTBKGgrR9bQz7eLkZdkchHq1ftuy86T/
	mjW89GzscJvHHwXzpmnn5nEotdvTlulmlwhdghS5NpG6L5nxFWj7x1R7Kccxzalq
	tNIqWhTNiF47Bsyb2tNO8Y3Jyfxes2HOJHU43w7ha1inYc8jXBhGawRqviXe68Em
	U84fZA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fgd04ujwn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:58:56 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cd01a14e81so142464775ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 22:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784527135; x=1785131935; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x1uefA3+UQaby4KmgeDxHdUwVrVHdjO8FOubPW0/W2U=;
        b=de7U48FKOZxxzQbAaBPbsOzSUKbqkjFbxxo8cTQwrBtRHVfz8L7GiMRSCHqOeAbkgI
         HmwXU60f2pxBq4DjQfIbKlqCG1O942eiJUjPvqyXSNtgSPa6URO3j0Y+9OE1fz7Po0vg
         cZlU0pTFFge79/WKUOvxvLMrsYlMkbZyPrfrqXqh6W0ywvGC0wVoD0ujtHXz19URSA0f
         WAW1B4wvJus/CzlmFI3m56H2v80EjHeNbREoDokuw+Svb4lwjknMb+YMQgBu80LKtcKA
         BlKA7gh08CrXqlIWFCZBU+4TNMzvCQ5GRZpZs3Ls7iQL7jXJawilGPwDXdLHf0/W6SQe
         uS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784527135; x=1785131935;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x1uefA3+UQaby4KmgeDxHdUwVrVHdjO8FOubPW0/W2U=;
        b=F0c2agvwVVZUAyamDe3K28I28AA6oL3CcAqh+8HI1psNgXBjo+JunxQYC1oJ+hbcRR
         jBErpArzVCaG3F/sp+V85QigiiQJD0jhZJNshY8ga/qFiMTAHNHVNAoor9eaqNpjWGzO
         SSD2iyhevFLyekuWBpCY3B9iEfiONhEiFkl9+YrZ+cSNgMwMllqgs46hb6/Vp+P6p0ED
         fqzNJVgr5jkGMzVCbyu5zCiTeiMDRSZaCrPz0akB1196AgjTB9LppRNL883PyqOi2pCb
         s0/ymFYC/XGAIFV4w5Wxw6SWFYsw6dypfXL7BtnsBkh2Z6s/Lc/+B5M1MmkjeO6YT7kw
         PWvA==
X-Forwarded-Encrypted: i=1; AHgh+RrdGgWkHWunDs/2ZQ9ejkTxMmWMswNKwRgNXhUfNl8v3wkpd1MEScfC/GaiYGlhKKg6IxgGE8OBzxB8r6yJkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQHBhSygyPhNkcxeq0L3dyV4sFslAVycu1pc2YEPcQXXMnMgeL
	liQFLnUXWo66aSSgEtnUqsmo/I91gxGPtrlWyLTWnO5Cqg8RdxxSQxBaOJXE+6xFxNjcTuEEKvr
	P57G00mbVJ8uUmaWYe38MBbPPZTgyHCBmSrSGHweCHKkKgt8vZe7bzEFC7lVDXm9nk5zbnzoPH2
	5sVMa8
X-Gm-Gg: AfdE7cnKQ2OX44TG01MOcA2O4qVY5lkQqB3Pevs4F3RMmCUk5iyb7CimuD9uostdIuZ
	6/bRLe65Xf7lkvzSad4COwMwh7bLdszSqsvyIf+EXEtL2+4oqeHn7wVOaypThj9dN6MOFR9571G
	3FYGgAKZlfayCkIp+wPn436gwJiib3XXwvZS/IqeFNee1Bwfc7Os0nWiMHBK3yimAkWOOGjp7Ps
	srcnF/v9vZsxDmpnGH1L1+uKfa8HOj51z5wtTxNUSEXA5NFIogyiokOktf5W27Aox4iIDgc8Xyt
	um11Kr/IEynaYXU3Q9DGweem7xZ0V02EaHVSgTrmIRKIVCYtxOXqTNBeVINGxBRm2dEP7+IT0Gr
	A0mb5Tsn6rMJUyFj0GCiMB9lPWxpSgyjJtzTMtWcKc4dkDiqYRzDOWdcIyxAee8iWZldgAKam
X-Received: by 2002:a17:903:1c7:b0:2c8:1f56:9fc5 with SMTP id d9443c01a7336-2cf349fb45amr137301515ad.35.1784527135384;
        Sun, 19 Jul 2026 22:58:55 -0700 (PDT)
X-Received: by 2002:a17:903:1c7:b0:2c8:1f56:9fc5 with SMTP id d9443c01a7336-2cf349fb45amr137301255ad.35.1784527134898;
        Sun, 19 Jul 2026 22:58:54 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm50212035ad.56.2026.07.19.22.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 22:58:53 -0700 (PDT)
Message-ID: <4153e4d7-6ede-429c-b059-84e48371d35f@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 13:58:48 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath12k: fix survey indexing across bands
To: Matthew Leach <matthew.leach@collabora.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Cc: Kalle Valo <kvalo@kernel.org>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Sriram R
 <quic_srirrama@quicinc.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Nicolas Escande <nico.escande@gmail.com>,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
References: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=POs/P/qC c=1 sm=1 tr=0 ts=6a5db920 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=QX4gbG5DAAAA:8 a=EUspDBNiAAAA:8 a=GUBCPiHTW_XQuGLVs6sA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=AbAUZ8qAyYyZVLSsDulk:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA2NCBTYWx0ZWRfX/ljwUSMBp30C
 z/9uFJaZPCKDstyLL8rQIoKzBx2fVkQWFAPLnZSKVijNMHVbGBiFPW7TwMQKwhRvsERcytZghTS
 BYJcgtl10ik0PMB2HsUVyGfUeFmB8GdnMQ9XdbyuS1ct2J6fJlZVKmcMwmJYlt925X5cAJy9FTC
 i+4V7eG7BgFfYceYoc8+tdCQm6aZtbTxCM8QhmWEwVyiSfsw9iNe04wW7jlKIV3RTYE1oD/kc1s
 bHrAriOyOfoEdLBNIL+ZIOCW9bNewOKvZ7HijOakSCXW+hAVY+RogT8Qs9t9G97F4jd5ahoo9KM
 3htiCr/uFXJX5bhRQIDf1UTqBZ3yh3G92WnVUJUV+/rbqrF8gsL2JDgbVHCxDMsXbVKGdP2gEcj
 DaLu4pNGeYCk5bbXvU/KWvEYk7+eVrM7uaU0J/oDGnXAu8mTiSF6hyCQBct92y/UgT1zFrALzs/
 Dvh+EF2WxfiflPF88/w==
X-Proofpoint-ORIG-GUID: TOFClcJM1svwEPtc68XmxHTIKbsWduJD
X-Proofpoint-GUID: TOFClcJM1svwEPtc68XmxHTIKbsWduJD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA2NCBTYWx0ZWRfX2RR3tSrUyFy4
 oxyfrRQxHV60v13eKPciVLiQDiTlCZeUUlcFgUDzg611nQ6JPJTjJmUPjwZRs/kGxTWIWAlZpX3
 IgjIv5pPQkqm4l6xKgqmyfMucQXfYJg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200064



On 7/3/2026 11:56 PM, Matthew Leach wrote:
> When running 'iw dev wlan0 survey dump' the values for the channel busy
> time have the same sequence across bands. This is caused by indexing
> into the ath12k survey array using a band-local index rather than the
> global index passed by mac80211. This results in surveys for 5 GHz and 6
> GHz channels returning values from 2.4 GHz slots, making the survey
> unusable on those bands. Further, there are redundant survey slots for
> multi-radio/single-phy instances.
> 
> Fix by moving the survey data into ath12k_hw so multiple radios under a
> single wiphy share one table, and index into it using the global
> mac80211 index. A new spinlock in ath12k_hw serialises access to the
> survey array, which is now shared across all radios under a single hw.
> 
> Band busy-times Before this fix:
> 
> 2.4 GHz: 9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 5 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 6 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 
> After this fix, times are independent:
> 
> 2.4 GHz: 23, 5,  5,  12, 2,   12,  26,  5,   3,  1,  27
> 5 GHz:   30, 40, 29, 27, 118, 118, 112, 120, 11, 11, 11
> 6 GHz:   1,  0,  0,  0,  0,   0,   0,   0,   0,  0,  1
> 
> Tested-on: wcn7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
> 
> Fixes: 4f242b1d6996 ("wifi: ath12k: support get_survey mac op for single wiphy")
> Signed-off-by: Matthew Leach <matthew.leach@collabora.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52F420C029
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784469079; cv=none; b=QnFFfNSFPBVHIjdvSvZGNPx748/ucj1FAcCUit+Pe+C6CMC+gJz2TR+YLRYq2wS4xQlRejYdiTeKgt4cZ9w+4rS11REvKJgtB5OVA8cbV1624H4cX5opWuvYvG2B8bac2eTylreVba/ydRDhEkvne6pvll6qV/yoFAjWJU5be/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784469079; c=relaxed/simple;
	bh=vGKo5mm9OKykuAsEp9wK0X85X2W7293ETKLwrHgmcVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xif0m0DGKhUVUxr2HntuwJzv+pmWSLXhdRa62kbVqYfFtPWLPRS8Vi7+XXMwJ/O/uHnl+WZir9V/zjQbT0tPZYKf/eTV7OSH6mMtmtTnF24AO3x0IeJeYm7KK8BS/BuVEyAxQAzJ+hr/dROQAxO3fzHAKv2wsF29RgR1S9gvpv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=flNDb96B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RZtjC8zI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="flNDb96B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RZtjC8zI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JBBnDQ3564266
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 13:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ddkmmJJqxT+Dagg2XPzbAo7doThxXLzPRMVcmgsi+X8=; b=flNDb96BKvt27CaQ
	Fs4Ka3eLyfWZlwvDdgbKdS9X5DhPd70Vjg5Nf0cbu3ThJkHrv4NAWVH7dLmUj3qd
	hwiU56Q+L3rkklZj9Z0t7TJlrQC94sPfp05OR4zfxukqmseuTVZ4NlFSc2DH1kXf
	Em4cui8z/fy3W547B0+GyidxnNIcRcmzD9ylvZx7roh0BqWIGhhyul7LrObBuB55
	fADgLjpwviMo8eWfzTWVWS3I4i7P1NiYcJY3ZFL7k3lOi+xksxlpjaZb3022yZXL
	zxzh2+e4CXKFyeSRzA1UZOBLKHSft1H/AjC5ibUDOX8DHwcljTxaboqJLUobkrcm
	b/XoLw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2c6aufw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 13:51:16 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e22137fb3so6776470a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 06:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784469075; x=1785073875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ddkmmJJqxT+Dagg2XPzbAo7doThxXLzPRMVcmgsi+X8=;
        b=RZtjC8zI2FUB+olD3jbIfwhg13Fa0N1AmfXyrf5bwCnVYGVj1hGai4WZDloPciP0Pb
         wgVZp8xh3bulymIJBoRZVYQRwHT+oSAq5iC5nV7z6vw0JvJEnryMSIgLRmZD7rINT/M3
         A6fuRBf+Y+IFboMq/TVZp2FLPyjFBXPUSkvQZaoAfdhRkVuXPWA862SIbgV3uty/a6sX
         Fl9oCKydPZf8sAZK9OAsgSvr46bu8IlsfYHtJu7zVuJKro2JKevOlM6rQ/ghv0PQ3F3x
         Z3auwH3Tzn/r4X4hwLyQfGS2o/MPUvKgd1JVuP7OzXFvaG7+04+2ND96sLnJjqLJS7Pg
         ygNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784469075; x=1785073875;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ddkmmJJqxT+Dagg2XPzbAo7doThxXLzPRMVcmgsi+X8=;
        b=bglRo+9hge6MhkwXgCmBtDEWFmygEtUeBPDkoEvHlq8aYS5BhDemmAYBoZA1ERxQgS
         596/tohNMLVPeSioRMGmdoyt5EyLVApMA5kihiXn8M1D4FHWiVyDBwxdYA117CgKrQP2
         kHWa3MevXxtE8LzZo9gt21pRIdtSg2YnLPD6hy6NRb5qwpInqTdnFf6Wb7DVQAmxmiAz
         I7AW0+S/n+IIcdLhLYD5Ecj06b5H9qcZcoNefLmViyf9DZ78gTRXhLeCDqWGkVl+nVIL
         SDQhMSHbmN7Fefaotz5GU/54GUwbVMBssooaQkjQyjF8XbVPkvJS5lpBi1U2s8Vf1pzv
         IiYA==
X-Forwarded-Encrypted: i=1; AHgh+RpWSEUiVN30UIHoJZutNN6f8GZAtQsbLKalmsPU7R0tQCD+y1Jw9jnKf4yTA87xeq9LXguYty4XVc4+IKI5tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSPHvqybhHbfJslFvi2pop90F3MJbn7yCv9yYnxD7lLO2CHvFr
	RKx3ZatSey5zfWGKwXNdi2qauiY1MJQcwmp6Urm/g922FfbmzjoR47R8wDqV0txxdoysGZf6ReH
	CUoDvTgKBu4hAiry/w3E6hANkADPtPkWT96N//3ttRZaAKpXx+NwDE9mJjmuvqfxbm8mNPw==
X-Gm-Gg: AfdE7cnQXTn31IkL2owPaAEO1T9pAHDSfbxot+0RIFQ2Sjv5+SgQD4jxHwBLPzPHpd9
	0XJejnARoZ4Z1Ty9Lfj+fCWLljKaLb4j8LzUbrDnWCMIdjPLjGhC5jQ+5kDJRpKny9aJrf2b42G
	i3XKol9U98cqlcMReX+dxCaBVxQQH/SS0l3s3ijSgfM+z+DOHL/frZBmAqS3+VrMpBEEokblqlj
	t+54Q3QBX+3L3UZNdVBi9L2H81kNBF13RW1gHGe/0AnAJb9ClxOEQR1hfc3F88jVw642CkcAnke
	XS97hPnVqfmw+iwBZtvtaOUDQgbv/mKIVk47aprmuOcYbTSt+M5tmak8sMOZxt/mR7KOGjiLoeu
	TEL1UAiXJ8NoKZ+mCRDpDX2k+dew07NAAQi2fjur+u5tm
X-Received: by 2002:a05:6a21:3b89:b0:3c3:64cc:311a with SMTP id adf61e73a8af0-3c3ad64b57emr11236339637.22.1784469075406;
        Sun, 19 Jul 2026 06:51:15 -0700 (PDT)
X-Received: by 2002:a05:6a21:3b89:b0:3c3:64cc:311a with SMTP id adf61e73a8af0-3c3ad64b57emr11236300637.22.1784469074972;
        Sun, 19 Jul 2026 06:51:14 -0700 (PDT)
Received: from [192.168.11.101] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9bcd9sm27774316eec.3.2026.07.19.06.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 06:51:14 -0700 (PDT)
Message-ID: <a7ee5e74-f1ac-4870-b733-26f88e49fe77@oss.qualcomm.com>
Date: Sun, 19 Jul 2026 19:21:07 +0530
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
        kernel@collabora.com, Nicolas Escande <nico.escande@gmail.com>,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
References: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 0kBn3Mn_vjA3MhG5eITNIF3zc7bpmgjo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDE1MCBTYWx0ZWRfX/tLAOT9Bnc1A
 No4JwjEVbPYVfVuZRIHT56j1Ib37nmPVkm5Z0WNdcR3FCJB5scUjb8m+LQ3ZSwf0J2IlPQSJchf
 VVuylnk3CSfMBPoBtqZQvZOY4He+JBP2qnrNKmegadQ2FcENPk6eGHQroi90Pk6RC57n+qqm7NH
 CjcPbESwJqLVBB+oS1kOQWBEgM+rBGAVWUKevcfW82O3xmeHDtRpGLBAxb65PJv9dKxDgRyxout
 NXb7huUDzutI2T6iTxKARaJSFCaNzwAsVogHPsIwyeajDahnl80nvyrb/304EHV9zV6odjhr/5d
 /g0mYKsD++vJuySFPyxyBYvzIsfWxx8fKqYy6nA14eeGjkY2NO1xs3AGtRsFzi9RSMVLvOBI8fY
 EMCvPXmKVHEcmen9zIOJCwAaqudyAgg6n2zV6e6jim8lQSbvypAZ5XoetPDSG4EdA45HbBJmb4a
 3RyODq5NeRuYSiXHiFw==
X-Proofpoint-ORIG-GUID: 0kBn3Mn_vjA3MhG5eITNIF3zc7bpmgjo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDE1MCBTYWx0ZWRfX42Ul6bT5p++s
 mQVvxbGTIxyopQs1+GMFpNe/a9Rb/qkJ14SddvodErIlenjI3M69IkUZVbiHgAtG7Hi3L33lIEG
 aG4oY3orxTJPOk3TOABXXTMixHrzstw=
X-Authority-Analysis: v=2.4 cv=CJQamxrD c=1 sm=1 tr=0 ts=6a5cd654 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=QX4gbG5DAAAA:8 a=EUspDBNiAAAA:8 a=GUBCPiHTW_XQuGLVs6sA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=AbAUZ8qAyYyZVLSsDulk:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190150

On 7/3/2026 9:26 PM, Matthew Leach wrote:
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
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

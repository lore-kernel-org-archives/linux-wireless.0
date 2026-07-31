Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C49542586F
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785494399; cv=none; b=HPP2WMtKkKNXLzIS02srPZ9ZKzPVkiS5wFjbvFH+3DPK/sciUijHA5/z9Y3s3tnSl2sjMiS5Egreh8aVN9/gMkD5lN3VzJATruAGa8f2j17JnqZ9hUsths/8MUT+RevVcBiCbV+w/MRmHJ9NmO614MMf2PJBejCvxTR2nQbmaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785494399; c=relaxed/simple;
	bh=RIk6fyf6bo+LJl9TlLu2XvIjEfJQGRiX3VDGKdd5+Ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJQZcO2PRY423z7fiU62G8FqLJE8qfSW6RYDigOn1gWPF0UEzcwRORDBf/ZFLmOU/pOC4uYAKGUlQEojZcxJGkX/sDEEhM9XXdUBo829FbqpWZCNQOztXLUUF/xxiz5s2Q99Dw2tnPeu7+LCj6ycrxMjyP7sIbGpYyO8UYQbUdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hFmR2MMC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XvsqF3a4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hFmR2MMC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XvsqF3a4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VAC1Sl693256
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	N2CdYWIKWcB88Y3bsnqJ87C77pIUShmn0LngEmE9aK4=; b=hFmR2MMCt92O3QZn
	q2f8jOwrOBf3gkjXuCOaG2YCX+st7Wv6aEHuHXD0t797IDDeeyhken7I/jYVJR9M
	YRQ1xWSpyewsqTdi9uvjaTKAMrKmC3z3O/FI4WDIiUpjk4UcdHh4NtJvDYWcx+Ms
	Eh+2y//OFG4bPibDKaLQNj+1j9EHqqBDqDLUdCIQhvp1svNS1BD8bLz8N0AAiJCE
	t892DTjy5t3f+mrzMsS2sZ3ymRF7yxG391q4T4HyJ53/Bq2sjsjRVXfUpQiG2/BM
	LGMjMx4SuMIYcGPJAp017Q+1D7zdTmcnHDi4DWVHMmV8DznQnLg5HrBna10fWHMW
	kpLFOQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frsn503yf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:39:44 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so14589555ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785494383; x=1786099183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N2CdYWIKWcB88Y3bsnqJ87C77pIUShmn0LngEmE9aK4=;
        b=XvsqF3a45oN5Kth20I9Q8Y5cSkSknMZqcWKOdWUCHZzObmx2ikvKpAEhX5MhF21oMc
         qW2757pzByySog+yRg1pPtLktacRhtLIpWDsL5mnF2NZd8kOB2Qda22G3qqjF9A/Bj4g
         oF/mOFuHPByT6f5aJ1UK3KI+6cGDdbYxS+3MwmVxXNKsmeEw4C7DsBEPOREmdxbe1erk
         SHkis0EUTa0SCnTLJFeUvnHKw3Bh5ORBEnJLXH8hFmC7O2pmRVPB+k70zOoqKUZAqTRi
         d1c0Emgo3MUje+st/ohMQd9JCapYsu6s6Srn+7HYzdnSyLOAQJlaoGqFbLEfe4Ra3134
         Zvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785494383; x=1786099183;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2CdYWIKWcB88Y3bsnqJ87C77pIUShmn0LngEmE9aK4=;
        b=gaYkjngn6YgsKk82OdH8hTnxGN9GYnZys67Kd1+BSURciOM+uYHK66gTJn90lmPg5r
         FYUyj+EM1PzTlgbnVj4AAQo4nQ0keJg/pDthASgsdfGEGhJDHojXGFqnOZ2wDVzdQ2jc
         pj4aLe4L+lZl7h1jR/67QlQD2EUG7YnMXNhKk4kXDWWoP1km0e6ydDfon+WPDTqxvRyO
         PaGbPsx7sgeHAf/VdB442GmcSa7UX03IdMXzGUCxkwTHPrGqsPLjKfjt2/2sIJA/rgUZ
         NA+7CrkioYJy74ENDR+qzqAHk4QVoH2OA2k5ZdzGYN5QuKNoC9Gohp9KjGrzDHFMaV+c
         esYQ==
X-Gm-Message-State: AOJu0YyweJktnLIayCXK1iyG7njEBgFwCNPdUPEa4cp37AAB/F3jaJ/t
	x5xzY0rocFpQss0kA1XI5pdZXTj8ihGQgCMahjnxIjpHVNA+3hW12YDbhgf3D1othjKBIjjrWIU
	iGXjMkX/wOLwYwJm7uVN2H4Jkpz72/Kz4kzqdFPUilTnf/B+Uo4i4Jvj12j7UAmftYhtYiQ==
X-Gm-Gg: AR+sD130ZOq2G2g2p/D8LdxVGRrEgDi51qqCUwOHmQILYrd0mnASZ0KPsNnzINntWOF
	atywI9BKDLhKtVlMppx691MUEKdaC/bS4NNYSqJpl5DtzpVOXur76sT1YC38zKCSmOZtGBV4QY/
	upyHLT+0FbM3hp6D7z9WBOfrQlrDV9bJS58w55SuU+i5vEBP5bjMSht/Xnl1VTLvuBBCe3VNOOO
	ljj2SLE8QQD5rms82kZSMh3Zeye4cBLTNS7Sl0p0oy0rC4PYXjXIOGrTlfbmaa61sXd/QXizXbn
	W4V4QTKuuqG92UySmNRYdgbNYUEtFQWXItqGJpn1tXUR7W5UzomSgh4H2WmWWxbbJ/UdbXkvFmI
	d0yvw8y5rQS9PTSLCln/JuHLKSlSU
X-Received: by 2002:a17:903:1b48:b0:2cf:82e6:a5 with SMTP id d9443c01a7336-2d046da2c52mr15477505ad.13.1785494383451;
        Fri, 31 Jul 2026 03:39:43 -0700 (PDT)
X-Received: by 2002:a17:903:1b48:b0:2cf:82e6:a5 with SMTP id d9443c01a7336-2d046da2c52mr15477275ad.13.1785494382973;
        Fri, 31 Jul 2026 03:39:42 -0700 (PDT)
Received: from [10.152.194.17] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm7903298eec.19.2026.07.31.03.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 03:39:42 -0700 (PDT)
Message-ID: <11254acb-eeab-4c1b-b940-8fc25a1d5e25@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:09:38 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix encrypted EAPOL TX in encap
 offload mode
To: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
Content-Language: en-US
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
In-Reply-To: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: HSS5I_VzZjzUmoIa4Qqiz3sSuT8iJcEu
X-Proofpoint-ORIG-GUID: HSS5I_VzZjzUmoIa4Qqiz3sSuT8iJcEu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA3OSBTYWx0ZWRfX/U4eLDravPuK
 LaEAs8cha9+HmeB/ldLsPjVSd59CIDm+Hj9Wv34M0qLBCutaXnmJUvKll7VkEWE4S8kH1ak9pE9
 CcRTzZWD5OOdYSM7Spu9U7FsWHYkCaM=
X-Authority-Analysis: v=2.4 cv=ScbHsPRu c=1 sm=1 tr=0 ts=6a6c7b70 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=XimLFvTEBuXuzLDNtLAA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA3OSBTYWx0ZWRfX2cOAT+4kNp8V
 /gZwyF+42uonZh/F1vUWR7Du15mjvzycM0JF8M2xbcOBEg6YNp2Ln97a+qkbjATKqhJ5JtEGt69
 ghXsjBKkgLNxpWspkxUGiwRYbwQXBewnvAIZFVI5bOewBEE1qvXUFhNcTm10AemZimb6vyk8qmT
 B75OQN88VFeKaYR20jihOopFt2ptVJhteUEJssPv7EgtOc0fCMYBGDd8lW2S6yW+IK2pAg9PDrc
 /u4DdwmE4juPuX4WbQorF/VOBtwJ6FJ4Vj5Pr8AEE50ATvn5HBgkSHlpta9hsZJV5g/zD4zZ2VA
 XlgIDYblPg2zVVt82Y283ApXV3g/+7WVZfE+O6sGeTOYt5Q/2TuC+mYzTEq0CI5JU8TpDKSIGSZ
 Zr5fnULtGa2Mk1Yh9u0b/a40zdc8s0gOKVr6RjhgoKcHr5yJ7YEyjsgo3dc9b3HnWJ8iV2051iJ
 lNqcG6Y9BG+Dosp/Xxw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310079



On 7/29/2026 10:47 PM, Reshma Immaculate Rajkumar wrote:
> When a vif operates with IEEE80211_OFFLOAD_ENCAP_ENABLED,
> mac80211 delivers EAPOL frames to ath12k in native-WiFi format.
> 
> Unencrypted EAPOL frames used during the initial 4-way
> handshake are already handled through the existing
> is_diff_encap path. However, EAPOL frames transmitted during
> GTK rekeying carry ATH12K_SKB_CIPHER_SET and continue through
> the normal native-WiFi transmit path.
> 
> Firmware encryption requires RAW frames with cipher-specific IV and ICV
> fields correctly provisioned in the skb. Passing encrypted EAPOL frames
> in native-WiFi format results in incorrect IV provisioning, leading to
> an invalid ICV and frame drop.
> 
> Fix this by detecting the EAPOL frames that need HW encryption and
> converting them to firmware-encrypted RAW frames before transmission.
> Reserve IV space after the MAC header, append ICV space at the tail,
> select the appropriate firmware encryption type and request
> firmware-side encryption.
> 
> Introduce ath12k_dp_tx_crypto_iv_len() and ath12k_dp_tx_crypto_icv_len()
> helpers in the TX path to obtain cipher-specific IV and ICV lengths.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d29591d5b52e ("wifi: ath12k: Advertise encapsulation/decapsulation offload support to mac80211")
> Signed-off-by: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
> ---

Reviewed-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>

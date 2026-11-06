Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942886;
	b=PS19AE1giCQtcolRzX8HioNyq50PdtMDh35Dafk6VOjuFcO9tJ8hgeupJakDg4ZRVUFB
	 wxSUqbnqUcIATZq4fHhopnz1Emb8agy9rIO2Jd1MtAnkH71tjfycG0Phkv+EuaypfERG9
	 rK+/J+mnvZ33ugbV6y39zKWTppxLDQI2nWPLlVbxGQk0tHo8whSXIWDFoBx3s79E6tCXt
	 fh73KLrXZR9Ad9FICk8q9eZk9aZivw67DzxdoJffsH0Qo1WrhHqcF5klcBixjIN7VcoTQ
	 FNul5X5s3ZRI7PQLvldJIMwp9NFA0Gnfedy7u4wu/4ktb8sjyPjDZKOMMaLID6jy02Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942886;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=+goE9BwFUZa7uYLf5Tmor+xQ5OSwB+02l5X4V78/PXg=;
	b=R6ao0YJY4qvkizHoO/uNpK6KjaOtCF4p9gkC/ZG7ySbFOr/RFVRf7XRNjmX8P6FXRYMR
	 AG6bIIq9xXiI3pYRjq7yM1Fz4T966JsxGklnhFfzVuP0umYrGtGnAhpPpnKu8gwnpje6j
	 AKXSs9/qyYbhbNnrlzjCkztX9sKodR8QUvGx1C/THwEhUTJaY0XIVppN7UjUXE2RzjG4S
	 IAbM1+13USFGgieo/qUpy0XSYcKbXuGvCpFalkRaL5OszejgTa9CKtXiemEfuyI+6ySr5
	 +nIzZL6viq642OPqB5CzAk56EywL8RXzbRVlR4/nHVm4e4iBbq+jPGmooI3Txl/swcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kIA+eDm8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=H0mLUH75;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33C0606A328
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 05:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B33C0606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kIA+eDm8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=H0mLUH75
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A641Nju2474003
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 05:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+goE9BwFUZa7uYLf5Tmor+xQ5OSwB+02l5X4V78/PXg=; b=kIA+eDm8KW9BlQvN
	8vQyfqRho8W6GrSKF7Xw3Qj02ALGg5ijeJ97h9ekrug5qtYUZWq2G/MYaQqT8ICX
	GZBxHPJAsKwsjpDKLWKibO/VXCrebVqyoia+7u+8rmC9Tk4IbqVbC/KYk7gXwstx
	v0U6EZM7F7NOfawfV1WWxR0kTvjjj9cBtkzczzxXqSKjvYzK8oxgazMKsh3DkeQE
	/Q5DZcvjDPDacrQQC3Rx+vP5bUU+IZe5LgUxmnICm4NLPBf3v/F/vl6MY9YA80bx
	tIz4qkHUPbNzQN3KkQAF+I9KghTTBbJlAjmgQQ8JRZMpaqTePJZXsyAQm0yAMDPx
	0xFFfg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa130s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 05:28:04 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a3451ea93so457950eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 21:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793942883; x=1794547683; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+goE9BwFUZa7uYLf5Tmor+xQ5OSwB+02l5X4V78/PXg=;
        b=H0mLUH75hntJqHi8hrfs/Hk5xj2u9azNcCU4kbQ5He2SWpONxh/hX0NZPOV+RyreUU
         Zd3i/tAiUmjtTotHanhaVcuqr1Zv2t28X1LNB3sTbYbJXwv4AkKNRsHRpj7smz3q9Xny
         EZ7cspTX/zpCxk1YNIg715Dg/HjDVgif8rhbCKaCzRd3jfPfz4qSkfUjEcl5MLoUWyS1
         4BFKrOhvNWMI4nJoP6+7lZWLj0KyC7mks4rqy300J8YIrB/uGl2RYJO1hGP6m8Mrxmm4
         DskKCfF6+SVyRtsMl4/46kX6zIjwueg6oej2CgOkl92kg+J4JspkGVm2RAkdL0zM7ZQr
         CELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793942883; x=1794547683;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+goE9BwFUZa7uYLf5Tmor+xQ5OSwB+02l5X4V78/PXg=;
        b=h3q5p9qivzJFvefSlk3VME7iZp2jFGL8q/jmOazcMw1u5LmXPklzMH4rTcyOXSLsDW
         pvc6GXU+ocZ1MmRQ1RrswvRc+YpsU9v87QyTFOtx2hox+aJXdfSNVloLRl1EKe6lHjUW
         C9rXyHFFmWe2Rk2s2xfB/Ky1aryzPIfBjvey/5B93KaPc30Sh6znHTnOOvlC9MdBakZw
         RWS/8PesC26RxuC6hDEiIjPX8ea4gBm0m1vYS/wKeKdSCpIM+Phc3gVSNS4W8j3bDMbP
         U4I5E7eH3mSg8Z+bqFLQLoJKLuX8a8tWZTwUbOenwcHaj0DV0m1LA0Cq6Je4Y6U6uM7b
         o1oA==
X-Gm-Message-State: APuU4Z9lDlGri9jYDe8VSQx+N74xFTa4Y8lpslrAaV4vwHUSUT4zEURF
	42Dfd2xD/wtAUbBxW0eKI2FCMnwUA1Au5fq74iYMB/iTb+vW4gGGtAnIPAxb2CdjsC2lx9wXfEj
	DHndiNO+XVBGUsL7W15cI+fml49gZm0IdTUUWJ7d7XzqTyQ+gkNfN8at7zSyCxHEWWs8e7A==
X-Gm-Gg: AYBFou1ROq9a4Cau6rX/VwMDaT+fS+SFmfuyyTQ2Zgp8ip5OEwYrtl8RwrEqzYFNS7v
	r47Dt6wcIs2SVXQp4zlcKckajSmVFB32lBRl3wHnDI+lOyQfMmSbHfCUrm47Co/QQoa9TJnIOlS
	0L78e9+7nP9asDLpQTOEuD4/oMjvBZ4P9zsQAA/dGJ2+P9oJ/6s/ubOr6mBQV4TFG+8s56L4kVv
	Zi/gkxb7rkR4dS0RkeKYL5E5VBPeCT84MVp86Ct2jXj6V+0uMD4rh0jVMfE8RmudT0vSA0HGh5S
	36jrhDVOb9CSoXGell8XCxEOHUVPgAvVbQEEAGNW/e7xq1IFPTUvzv9/yyY4r48GtcISzDcSyUt
	cmhh4ML98bEQT6B9ShHvAR7yxjD78CAqHtwGjht6stjxhjIykwvGUFNGbffAIxQ49xMLx1okzTv
	jqKDMlF9Oz4Q89ZLchswU=
X-Received: by 2002:a05:701a:c907:b0:182:6c6c:d876 with SMTP id a92af1059eb24-1b25d2fe798mr1617899c88.8.1793942883484;
        Thu, 05 Nov 2026 21:28:03 -0800 (PST)
X-Received: by 2002:a05:701a:c907:b0:182:6c6c:d876 with SMTP id a92af1059eb24-1b25d2fe798mr1617875c88.8.1793942882928;
        Thu, 05 Nov 2026 21:28:02 -0800 (PST)
Received: from [10.152.221.90] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8c4f28dsm2578008eec.9.2026.11.05.21.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 21:28:02 -0800 (PST)
Message-ID: <47b4d020-35e3-449e-a097-ff8e41f4a8a4@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 10:57:58 +0530
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Fix HE BA mode and extend
 buffer size for EHT
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paulson Raja L <lraja@qti.qualcomm.com>
References: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: OJpbFb7jlyrFBYQmExNuG-G2sPFTVcCA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAyMSBTYWx0ZWRfX04+ZtDo+RVB0
 FmO6CovrxbAiNBiVsi+Alva495uSnEs6X7F5DS3LC1K+TrUhGgS03mVkPkzD2ws49IVqQ008RUO
 2M6WXlsartB96JD4XgeGzAzkY63pS6uH042xKqrUHWOKhPXzvis0m5NloYTlY/T6e/26fD4KL/E
 DgY3x7fZMfh8xWsiVtNUuP/wGw1fRGoHH7AYSnUlq9R5ZxuwjSpMbsMgrNk1uzhpISbTEqVquF9
 Day1O6Dh8PC9KB1HcQb6lSLsgjb7oQxo8PzgZ3gRkITrWBWIpklsG/AQDR2cdOh7GA35EyhE4qM
 NCIhWj4IyrzoPPvTgqgQlYCszUWdPmS/29p8Pc3vVul5hz7OwEBh0hSHWYyIbOTuaPv1laX1sE4
 QxRIU24JyF+3df13j8ibEdEOozkBfrnDyLP7jQ++o4fSAPMRMnqqwdU6EVQFHyquiZ7VUwZouV+
 5x2sAAVq7z0ERS+FbDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAyMSBTYWx0ZWRfXyEZM+d4orhrO
 YHv9177qaUlBkjcCAL7Bj+699ec3YP0z4vyZ7Xwih3lF05e6uOV9XOTAIT0AE9TFGNDksYvO993
 9CTet+0UNOlYP5EdKvcISksqhi4sAEg=
X-Proofpoint-ORIG-GUID: OJpbFb7jlyrFBYQmExNuG-G2sPFTVcCA
X-Authority-Analysis: v=2.4 cv=CaKdd7rl c=1 sm=1 tr=0 ts=6aed6564 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=qSRq8I4OGtnwRW6ma38A:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060021



On 06-11-2026 10:27, Rameshkumar Sundaram wrote:
> This series addresses two related issues with Block Acknowledgement (BA)
> configuration for HE and EHT capable links.
> 
> Patch 1 fixes a bug where WMI_VDEV_PARAM_BA_MODE was never configured
> for HE in AP mode. The existing code placed the BA mode configuration
> inside the he_oper.params check, but mac80211 does not populate
> he_oper.params for AP mode, so HE AP links never had BA mode set.
> 
> Patch 2 builds on the fix by enabling 1024-entry BA buffers for EHT
> capable links. IEEE 802.11be extends the maximum BA buffer size from 256
> (HE) to 1024 MPDUs; without this patch, EHT-capable links were limited
> to 256.
> 
> Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
> ---
> Paulson Raja L (1):
>        wifi: ath12k: Extend BA buffer size to 1024 for EHT capable links
> 
> Rameshkumar Sundaram (1):
>        wifi: ath12k: Fix HE BA mode configuration for AP mode
> 
>   drivers/net/wireless/ath/ath12k/mac.c | 41 ++++++++++++++++++++---------------
>   drivers/net/wireless/ath/ath12k/wmi.h |  1 +
>   2 files changed, 25 insertions(+), 17 deletions(-)

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>

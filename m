Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC5043B3EA
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236567; cv=none; b=ooZcLmNIS5ZEADBaiQrL7aofG6l+jB4ASkduj8jUOtGIxmkLzgibla0Zvag3BgGcvzVrLhF51VON86YvqIOyfm/LeAmi/FgcXKt1VKgPWL22Bp+vozZveO+kGbGwfiPKXVLc0wYULIClKvJPeGGeZMLB51OMQ7F2mx1IsyRWIVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236567; c=relaxed/simple;
	bh=iVUNZgEIS+X03uUzTSm1RFpXT2eTKHvCGErxEsgflCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slDUO7Ff8Ai5O0GjlcIojOHgSqiiapkkosT5F3C3pViMwPrTHaE5A31xMY9WaqsEeYtp1iFA+ptv/WpitERUJVIQLQhmFO+8j0C1V1EWBd/P82OAEQA3XyeW7cWmmpRBmKiiy1D3mYdtPm3TFTDIN4GaF4SzNmEMcDbhfP3eo2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SM5uZq0q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XCFv6jHq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SM5uZq0q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XCFv6jHq"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eGYo4147667
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iVUNZgEIS+X03uUzTSm1RFpXT2eTKHvCGErxEsgflCA=; b=SM5uZq0qPdth6495
	aqFd0Blv8/Ae0QmHg/glmnIshjGVEg0EmM4YHFX8oH57tmBOG+Xu2Fy+WziqhloV
	iUHEza84rvHPPAAvAoP8yMn0cGmAjazHCR90YS7MfvK78NJ3sfI9G/xrEQ/S0D/Z
	AjVeAYtEjYrz4qkWPm0GTlabvsPII+gyvEVK2jPst9UkmU8GlA40OlRUeV1wLO/m
	ZyhG0KQWleF0TRU0OX7Du5YGxQgFJZbGZZM6JTssR3nmjRcaZMmSwPITKJmJPMhT
	sl7k3HPyM8On7vsKoX1EvWslFsbLZJp/cPwN29bx5hsXZA2h1uGrJ8xtjEFJVnoF
	KM00lg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjv3y30-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:55:56 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-143803143c4so899931c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 00:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790236555; x=1790841355; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iVUNZgEIS+X03uUzTSm1RFpXT2eTKHvCGErxEsgflCA=;
        b=XCFv6jHqqdmb7OH2GJ4KAmZSG+EPe7I88EK2QXb3TvuXdQNenQ8/1T+HSk9d+g56RW
         yPSaJ1N5cXlG0emG+yFVp9uluywAEw4p9ec3r8VwVkZRyfrnwsyWz3etOa7eHhdp2AFZ
         c/AcazYXq+JzGK5byU0cAWUXyK7KTzfzk+LYqtCOAsuDaMOA8hH5ODap+8p2FA1V8sYg
         RBiJ0kQqsBxzgw589UuHS2+Z51VeHBUgGlIDHs+EtVgPY/F5blaR6Y0iZEaniYBotYx2
         BARE8aBTS1jWzs81ywjP+PEV8ZXJHJvxAxNAHh7wT7E3YItb1yhP246VeaSxCxVplHRl
         7HcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236555; x=1790841355;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iVUNZgEIS+X03uUzTSm1RFpXT2eTKHvCGErxEsgflCA=;
        b=p8QayFTAD+FLJNQfB4FIKF5qBv/Q4mBtZVXhGLpyuPfVZvvwHgxJSmeZlVubp2bH+Y
         9yxDW7ekBnWuGipMJsdHWPAWzBm8H6Hjh+y2vIz/H/+DVE4lvVhoi07RMx25iWJvWJat
         /FAagR4tKIfiz3bBvQtubUeqoUg03dueiF4YfUCO61fNe5R8mN4K25Tu3Cn+LPLs/OTz
         3U12tEt+OXT0KVg4wAPB5u0HSERSRPSKpapSkr+GrdWMgmKa0ReH+XLu8SMJ7Du0p2tR
         bfloW96ma7mE3S4lq8njhuHO6eHhQgxhGjEQv+afCsVFQqnYJRz2Z5Q2Ay/QbScAQI79
         E70g==
X-Gm-Message-State: AFuF++mrLdsByAzg52srD6GkZa5GNO4UfEWPMdZIItVZx+tou762+R3m
	Hv4NYNBK941akaOpxvGfN65Jw24FdnOwv1IdazH8Bfr8eigotMOSWQ640Dil1btmcGypQMkUqlB
	y7UD2Qh1VHHi6oIpS1/ixFWQNTbTvgGnRf9Nszj3ZeOJFuzZb1+7XFhtodxEGYye32m0ZezHSCf
	hxYw==
X-Gm-Gg: AYBFou06oYza6LiwPA0QF3w1h0wG9ZnD07f+T6xzVWARTKLcZJLhMrw0G8DlpFt7vMF
	3IRNSvC1FwJMWNo56S2QCw31KCqmbS1MPztXverfjUnzmblkegPNsxkzXTVAeYmOjZo59xhRs4k
	8ghjZpP1wF+oEjK3q1NPGNsPij7fiBtF4r1lUJrnPTtAMXqbWtsAuXRjti6rerSY8rC2huhBZJI
	3Z02ThJDvtrPp4XOE2S/WPWSV8mkHPorp0wHJ1Is9KlREj48Vq/TeHzQYHKDiDNU/0QVxPOdWvj
	s6gv2QhQS/5eL3dIeSigwAiO6ZU+zLSSK2oim92VV+9q7cQwDKuzS857LEkAmpC7dRqO0t+S3oX
	egPhJoQV5pHPaPEgShLA6CLTvdxQhOXNjAAZp7bXo4TOEx7pv0Phh9ZxwivpZ5s2kELIaNDsWOr
	MZ1Naq7bnXpz4YVVlrCw==
X-Received: by 2002:a05:7022:296:20b0:143:26cf:8617 with SMTP id a92af1059eb24-14504007496mr1227668c88.25.1790236555473;
        Thu, 24 Sep 2026 00:55:55 -0700 (PDT)
X-Received: by 2002:a05:7022:296:20b0:143:26cf:8617 with SMTP id a92af1059eb24-14504007496mr1227650c88.25.1790236554818;
        Thu, 24 Sep 2026 00:55:54 -0700 (PDT)
Received: from [10.79.124.251] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f988342asm10934708c88.11.2026.09.24.00.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 00:55:54 -0700 (PDT)
Message-ID: <30303e94-f0a3-4e91-8690-006fea92dff4@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 13:25:50 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
 <20260819053247.1420393-5-pardeep.kaur@oss.qualcomm.com>
 <435e3012-9b6e-4327-97cc-f65ed1e0e5c0@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <435e3012-9b6e-4327-97cc-f65ed1e0e5c0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMyBTYWx0ZWRfX38tzWQAkiMf5
 nYrUC9snhWJbVZ6RgQqYMtbmYnCBgQueQg76kWo42isvOPIylu5K3xmqMb6gLTgGZnfbbb0wb0P
 wKu2r2AOsoHIZASGv3FAFtqMWSYE9hUWkv8+VoQO4NbzY6qMiNNSFFdVoMasKn32UTF0lL2szMi
 TKAzJHvuep7yXI/lF0ka3vFggvyf957Kgxay9y6ee+sLe8eEbOwXxfzA4nvS+V1uaiLAPQJEFEv
 JagA1ymDBIsB7fqutGASNshSc1Q4PHY7ZGjp9ezz04PAKN73ZTeMxCXdDqePweDdMB1XlrcU4d9
 0Xgq10D8U4F7q3ygq5b7wirXZTnZWKQ03sRrjdDiVwVaoR66owL++ZWXEHGU3C258kFv45D36hp
 4a76Z7cNEdhc7jLq9jXcbv8VGopwMeKKEWXWqUWtPhUp0uC/kjRD1r5iR2zjzfhQGPXgY3OZNML
 RkEeQQ32wdyOnJ8+mZg==
X-Authority-Analysis: v=2.4 cv=aIxlOr9m c=1 sm=1 tr=0 ts=6ab4d78c cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=KfRVG6JlAz8oqK73lFAA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-GUID: YzYo-YWEw_mOjn8E4f759J9eWI6u5NmM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMyBTYWx0ZWRfX5cKdNi12/qPc
 99pNstES1Vem0RPaN3CgvsRbrSKVJtHiQ/LaEV1V6brgLHbQC8783eHNalYbe4N5LygWnKFqZ+z
 jyDRQgIYxgXOWUC/Id/V35H6tgo9rRQ=
X-Proofpoint-ORIG-GUID: YzYo-YWEw_mOjn8E4f759J9eWI6u5NmM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240033


On 23-09-2026 05:42, Jeff Johnson wrote:
> On 8/18/2026 10:32 PM, Pardeep Kaur wrote:
>> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
>>
>> There is no way to reset device DP stats counters without reloading
>> the driver, making it difficult to isolate issues to a specific time
>> window during debugging.
>>
>> Add a write handler to the device_dp_stats debugfs file so that
>> writing 'reset' clears all device DP stats counters. Change the file
>> mode from 0400 to 0600 to allow write access. Use
>> simple_write_to_buffer() to correctly handle partial writes and
>> non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in
> in what? the last sentence seems to be truncated. Or perhaps just s/ in$/./?
> if there are no other comments in the thread there is no need to repost just
> for this. Instead just let me know what text you really want here.
debugfs.c.
>> No lock is taken around the memset since the counters are updated
>> locklessly in the datapath; taking dp_lock would be misleading as it
>> does not protect device_stats updates.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
>>
>> Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
>> Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

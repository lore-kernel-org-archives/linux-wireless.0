Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792504430;
	b=SXNBAIezjvAq+TgVjGl1hYfr2tspG9Eed5aD9WDShnCc+0Pi8SoHinsk7M0vDioTNt/m
	 Ps96D/uEPgoLg7h5Uy7GhGpt7ouWDhDBLUx2/Dn0Uy+ru8ZiW1hTGs+x+SZXmX9b/RLqm
	 92SnCFyVrUroWEC6ay7BXISiuSkVAO+Nab5R1agMotfa2oWkR/TrzUgEFRoUOCfEo9itL
	 cumOLx8/6V3hHahP/y35iFtyIwNKWrTDNeIUHP4CNWm3OJ4StxzvoPgqIXLLpqjQi0vHw
	 YapfCIegdVeFrhDIvvVeFfz6o648VGX9ZNQ5DLJeBdh6rhc8o2mWakTgYcSzHf5hCEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504430;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=98h+uohlvwBVcGjNEa2NGd5iaB9mYxaSn10D70Q384o=;
	b=00UDTC19O5lRGwIxATOYX1xZWaMU1uEZ0twwh9dM+gAsPOvV7OOVi6dhlxmiKegHNUvM
	 G+HyjuP2ZX9dNBbJHM9sko0UBfmwEC7MzZEoQCD6AnR9lQ9N8Pln7P6Ja/T9RGuKKJjdv
	 CYFS6heg6s2irAjPm2sz/cDXS15SoM0iWikdQgW4ubW7aTapz1nhzLUGAtbrrT6Nl8Md2
	 /l1jlwNKkzvxpoa6T7Y5iDkflMAoWGpFXOig/AQyGZxXjbU4oPAOxKYCgarLs1XLolDKY
	 dp30hsPUJMmfLfh28AYRolGByEU9BKLIK4ttNzoy4MDN+71djfHs3OP1d+EpMpLwh6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PxIRm7mb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=arcqF47P;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD1E606AB32
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DD1E606AB32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PxIRm7mb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=arcqF47P
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDa65B1787655
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:53:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	98h+uohlvwBVcGjNEa2NGd5iaB9mYxaSn10D70Q384o=; b=PxIRm7mbp3RunCyZ
	yBQ1a8W6CcivEoLinHJu4jxi4YCf4nX1u8FfjVDxCla5njVtR2UGPJEWFjyP0G7s
	wVdktf/kpjXXR7O/FvMozK+QXcBAnFRvv5H3urG+pn81R6zp5Kl/qEt2cSOz7Tac
	5qHZ2GlLxsUFdwZMSO1oAiU98qlx+adlRUHN1qeiadKVRKb7TzcsrkVwc2UBt2ux
	Q8jncPMnfIU+RRnBXJ+igfWHeoR84h1h5JWIaQuNUzL+uBBgri9qXhrJAVT00Ixa
	qCXTji0qUnjizfBlCCrqEqQXSs3FpWVgQRJOAjqav4mNKhdwi1uwe7gOPIiqFFAk
	aA0Uhg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5n2rr3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:53:48 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c5aef2a74so11421811eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792504428; x=1793109228; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=98h+uohlvwBVcGjNEa2NGd5iaB9mYxaSn10D70Q384o=;
        b=arcqF47PiS/MntCF2/w23HqVg5OcCTKm7WK7+lOQARx64iFUERUNH8c2SOSwShKgUP
         e27Yi72Bm0v8R0RMWFW6U18nFBeWbGyMnpadJCy9ku/opdRlae/8E/IWTfgYRPXBHpJL
         lK2x+BaeprE7Bpx20pgEgcvkTLE5cNnf4KX6BQGnnUWPKO4hM7n05t3zq5uQjvKdJO1V
         Ij9zpAJi6dBAIuqvTiqIQ1Zhu05omiJtkaEQI59hQqg84IwquTu7cUGu3+p2xJtt+RLn
         E9syNiV6SKLU36JLZ60L0OmUblB0ivGEe8CwfXNuPU70ZEoTrlNUFwY3M4bDchdS3P/U
         NgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792504428; x=1793109228;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=98h+uohlvwBVcGjNEa2NGd5iaB9mYxaSn10D70Q384o=;
        b=JBwUJDNBlk273pE+CCzAJm6bkqC7htNcBxCjQ6JoGwF2GgThyJI0oRC/2D6r2mGT7W
         6dx56y3q2fDXGquJyPZSFs7N4SdKMdo/1qs1O+D5eCZsGHSklpGbI+EhVcfQ19wzKa2w
         PSw1V183s6Nz3rUZuEoUhDhUWvDSqvdRscP+MXGCIdtAgyJnQcGshk0ooHqEtnpKHH/S
         EZEk1UGF3zIGdNPVQj/K0Q9A9o6NY3+OuAHO6YtY8ni8k9akNee66VT5CGjionKnuwE4
         9NazMMU2DPIlj7tFwkKyrrtbcehK1hscyX1XZWh+sfDd5tXs/ej1r3WkDndeflAP7Cr7
         NDsg==
X-Forwarded-Encrypted: i=1; AKwUvBz40/CZVILxlZ20ZYGouuSZgcVANdUBDwcCfIA32MhFNpLoYZk5UfT8tTKy1VL61pCw9c72LPHL7T7zdyOBcA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKYJ7hbw/U88EB/8pziRzw586SiSzuOsimynwj59iKFitX1nS7L
	L9u+PLfHRqKmT22qOgKlazbkd1prfhlc9qYn+BQCe/g9OWgcDhLcHwLSKrbAYu+0Mqk5YXpqkjn
	aflTnFdrxjVbCgac+mYvRgc+HyouzApl4ncj8YcziJt31HkwKxkIhMClN3xOTCTYf7bBcmw==
X-Gm-Gg: AYBFou2+hJO24Kn6HEnn3WJanRC8iarMtLF3P1lNx50ukM7Kl5JcNblX6KFtLdv+Py6
	oLdk6iWGf/7JGpjWovPam5rxHcUkSd0XkwTTGuVaJVeDYVytNYEh7RlWOE76Y7q8radxT5zQAtm
	WlI93cDrZxez/jpql+L3R8UqyuUlREhwHdRXqMx4cUeok4YyPF8HpFbVtr6Lmoc8qEoO++MTiGz
	QR5AcwoKQmYUeKVJpyXOQ5GILCUPMwxPg+aw8ToNvfCUMqgFjUSXgvu8212rhw7ESlke2SH7+b+
	D2Wenu5LBrhJDTXifMTwokhcNMP07LGcryXh3hdsmm9TUmGQOxU4WkOhLg33hiu6XPUUgb2bKcb
	jtP0MByfnqBSJ8WIDefyLsEzBe0UXEzG13mgLJ/sKklS6+L9oc2V/MxSgJw==
X-Received: by 2002:a05:701b:2319:b0:151:2e62:fe8d with SMTP id a92af1059eb24-1851238b627mr14278910c88.9.1792504427428;
        Tue, 20 Oct 2026 06:53:47 -0700 (PDT)
X-Received: by 2002:a05:701b:2319:b0:151:2e62:fe8d with SMTP id a92af1059eb24-1851238b627mr14278842c88.9.1792504426205;
        Tue, 20 Oct 2026 06:53:46 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831acba710sm49618023c88.13.2026.10.20.06.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 06:53:45 -0700 (PDT)
Message-ID: <520e2454-a0bb-45f7-b604-62492eb15a1d@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 06:53:44 -0700
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
Subject: Re: [PATCH 0/4] wifi: ath11k/ath12k: validate firmware array lengths
To: jiale yao <19888972804@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        John Crispin <john@phrozen.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
Cc: Jiale Yao <jiale.yao@example.com>
References: <20261019100029.1908660-1-yaojiale02@163.com>
 <b573b6f.2196.1a1571bc45e.Coremail.19888972804@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <b573b6f.2196.1a1571bc45e.Coremail.19888972804@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: r5BDxlD5iSAt1Tr-lUqZpKM9BdeoVU90
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA1NSBTYWx0ZWRfXxmqK9XiLOwTq
 DwetotgmoBdOSSj09jjX4mD/P9OqAv8Try/wP4ZN/4cm8m6cqf6udg/siesIX4S6FloNSndErpW
 8dEnrWWirRZnxtsI22aZw/MuGy6b3Xo=
X-Proofpoint-ORIG-GUID: r5BDxlD5iSAt1Tr-lUqZpKM9BdeoVU90
X-Authority-Analysis: v=2.4 cv=A5z5rKWG c=1 sm=1 tr=0 ts=6ad7726c cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=A1X0JdhQAAAA:8 a=FdzspUwgXfhqtPi2OHsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA1NSBTYWx0ZWRfXzRKs6IRBlxl6
 ToMppALdS3zAsK6eUMuloInvEi/L6426ZZ8Fp73f6tj7imHx7/hkl+rTWmMR6nkQSKJ3JQ6+0rj
 JemlUZhS3u7kHVCWB8TbgQOV2JZy1ovaXk/oIRnhbSawIa5cjP9AZfThwFoH0i4dS/hMEZAQgE1
 lygNNTHkJGP8ymTnp+1LhdbLV/zirMGqdup4cM5BMKIukwnTjRccPXco1kdWFuLeQ2MdXT4zC7c
 nE2FqilnThLHV7bzZai+DlhfCKcGOPv1+OUlLjm+qeA44YLtZknyg1bJ7XPb5/4ySy3hkCQJssI
 N/8XuWco+6dxmJAO6GYkLskk6Pj1rUyccVTK3j+Hs8EBSZ4Pa87E47GMl5KLwsQQCpvgi3M356s
 UBDu2+JURcb3gZan4sjBPZVOEhfPrdudwoJSLQE3aUK3lEERxnTfpY1OwoNT5t/rSPs16kCArC2
 CrhmhhdN8KfCQ9h/s6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200055

On 10/19/2026 7:19 PM, jiale yao wrote:
> This patch series is superseded — please ignore it due to the incorrect sender name.
> New one is https://lore.kernel.org/lkml/20261019100506.1915181-1-yaojiale02@163.com

Please do not top post and don't send HTML e-mail since it is rejected by the
mailing lists. Please make sure you understand Linux Kernel e-mail etiquette.

You are close to going on my ignore list...

/jeff
> At 2026-10-19 18:00:25, "Jiale Yao" <yaojiale02@163.com> wrote:
>> From: Jiale Yao <jiale.yao@example.com>
>>
>> ath11k and ath12k consume two firmware-provided arrays without fully
>> validating their lengths. The service-ready-ext parser accepts fewer
>> extended regulatory capability entries than the separately reported PHY
>> count, while the ready-event parser trusts the reported extra MAC address
>> count without checking the fixed-structure array length.
>>
>> Malformed firmware data can therefore make both drivers read beyond the
>> corresponding TLV arrays. Add matching validation to each driver before
>> the arrays are indexed.
>>
>> The four patches are independent and each addresses one parsing path in
>> one driver.
>>
>> Jiale Yao (4):
>>  wifi: ath11k: validate extended regulatory capability count
>>  wifi: ath12k: validate extended regulatory capability count
>>  wifi: ath11k: validate ready event MAC address array length
>>  wifi: ath12k: validate ready event MAC address array length
>>
>> drivers/net/wireless/ath/ath11k/wmi.c | 10 ++++++++++
>> drivers/net/wireless/ath/ath12k/wmi.c | 10 ++++++++++
>> 2 files changed, 20 insertions(+)
>>
>> -- 
>> 2.34.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793932659;
	b=MRHHtXsi0Iy6PJt9yUfdrfc9yHLQUz5egnFIOAUSfy/sAHyQ2QQ0oRQ0hXAOVqytW6Rp
	 +1IS8/RN2P/aaVHKMHyZZOpQf5LAv49DHkOdK1/WwPVsV1I68Is6u1oMG9w/Sb6RO1GZe
	 vJZzIwrmZM5pSf/UtJLgZAwRtz/w66leoqufMDP74yXmyY4VAe8bsV4lVWFgqAS8Ey5uQ
	 z7aDtkgrcHjU0fS1MpWSD9gNgmbJbajOjSSHu0QSAQ0+ivpR0MCsoi1yR2LaIQ4AVHHbK
	 ccril8Lt1GXSTUsijVsY+8/uY1p7efj58zoE9g4ks6X/7Z41k8fadkwAacHlmwMa9XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793932659;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=FI80B+nNie9zTSHCY3+0rdCsJu8kCjduFpHKAP6KyEk=;
	b=fLb/vxo6B2wytb5rMDBOUjQuIf3masqBbahj7+nu51+PQ6U4ANup2Xz/VUHIW9798X6L
	 EYAQWdBafeciIzZLmWArGQhH7WvPk6PJNjMr7oqaZoYpKhu9AhEsqkdf+L/B0mqPjn0Yh
	 lpi6Uc3bp0yyJwJlwE/ZbTTh90UGFccym9qxRBCIOR5AojDUBm0nVkqVWhu0Y/P6zGFys
	 cRkcrgcOJC8WIVRWkplcI8aYQ2YhlmJw2lWIOJHQVpxWbeWzmnlZGTzZy0wFhXbqlSn6l
	 8FbFVDLwsmZxi7spZH3XGuK7UFfPfJxMOrcFG3JZbKNZDpqgCLl3CiNEbMbXQ1OPNWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cX3k6+o3;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FNHQFoCl;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44322606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 02:37:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44322606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cX3k6+o3;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FNHQFoCl
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5NePJg3295446
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 02:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FI80B+nNie9zTSHCY3+0rdCsJu8kCjduFpHKAP6KyEk=; b=cX3k6+o3+lNfW68K
	1HZ9gPO/cBOMoMWXrqHloeDAdwqEvFoL+a6umAhR4QOJGuZqnPtmsYX70V/ga1Ik
	Q84v6R07jUToYDJI/41hB/aYk5rdeaPDymcXeR3/2CR+0R43IbpkNf3z8csIMzux
	+8v771YAiUIuHtaBDf+NVTzD4jhr32Er/gwFwtujCafwkUcCjK86I5OC+wxhDzJl
	SJRyDilDwlXQRwUZmkfWluevw66pEJENDohem5XgJCEcL09ma1BPRKu7F8q8k0xe
	3HaKEKiU1O0CiRnJmsa5pcqOivJRSAeDvdNE4HGSCRz1GjC8WLojmmztQjdseV1U
	ZEcPPQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9rhd2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 02:37:38 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso227069a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 18:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793932658; x=1794537458; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FI80B+nNie9zTSHCY3+0rdCsJu8kCjduFpHKAP6KyEk=;
        b=FNHQFoCljYdgIq6QWhZ7WvAZuPNsF+F4zLRH2XzvEE7fzzYfd6HkoBjxrrjYMb+T0G
         W5aB7nij++nOwoEFfa8d9+l9PzXD/XxAojteHhnWVIvJHx0ik27lwPW0UZ1h2aewcErk
         MBF9HKduMVyq9yMo0la4vh86KRYEyl6XpmOc5DA8EHCNgTzCq/TfhHZZmQYpTH4VAQ15
         SvJCNny7ORhpVhKTANaKLGMLewiq1vQwiDVNkrtlgq6HWdx/KPYw9mUddOefSoMzeaK0
         rRlXqBrMrxPVPFHGLhMkTbYMTr8QCcvMu4dLr3x7v7LyAa8k4yPhfbIlukZgauDZjdmi
         p75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793932658; x=1794537458;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FI80B+nNie9zTSHCY3+0rdCsJu8kCjduFpHKAP6KyEk=;
        b=nAg1ubALg7S/Tf9Xdor0oYtkA3bgDozsUwBBHMdeQ0MrlFHk30Qu1jc5Sqk5FNl8F9
         dgzlR2N8akFjqFipc9WvTsR3C7J1wGBnrWrchV3PYOGFWItvfDrZGUIakPBfK4A1pJ9v
         mXogd/Wt8P3MfhnvHek5p78vyv6bnf61sX4F9YWQC22zAYzehcsQbX730EOlGac9+qgb
         2wvk8SvXkTEh+FC/MWU1Vtti6szzAwQ/oSBJEi8SL8U6lkzq1dd3i1X4oelJOagmNYn/
         naUrVmyjEqQfDo/jJDT1cAJl2+shoI21SqJyVqtW2XxB6accbZ0JVarlDgsRjeLXtCoF
         B8CA==
X-Forwarded-Encrypted: i=1; AL+hErHgkChZK+mPkwXdBt5VxMUpsetjyHQSq5Ff5V3w86ICXhisvptvcT+Jhmp3pTKx29YcBlsSjCHPZ/huet8hPQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+l31wXquZTBWg/lFWs2xotZpPMHaq3cnoNwcIdfUCLaeIZH4aC
	0xrYJZ2W02vB5TStfJbWfLr0jzrmZ/UdnbSPaod+xCYblgtQ6w29gYaxlGWgBVuuy3EXt3CuNEB
	c8JrEO9n6agTJj1xtQNJuPmYG0xwy5TyCgS9qQJ3b7gmDmQbHeTvEPVAk9Rc7RCbIG0K3Ow==
X-Gm-Gg: AYBFou1ACgVDfHDCEYBP6J3kum22MfvnTsRV5ojSVGdQwPfkl6PFOnETnMb4zuiIJ5r
	HTZ2fEWo3C0dQxJ4TJeI/srMZQtNTAZpLjS6j91UMM1vcPhwjFAZ+5OzigF6oYeNTCt4LL4AsXO
	1drB3sNJelcYsBWCdZPlpLmSe2a2nyk9X5/hqqw0LL+F2G6fJy8D6sp5QH0yvTBFq2P+HnROj3Z
	bBiOuaLQH6mRxE5GEojX8Xh97tmogjS3U+UOiT1ZHkcB1dK2Ee8FzwA1WSooLiZqGH6gdt1TWZE
	gp+hBnJwTNAFZKWRv7LIfpYBTnTgDwIt9Fjfv5kyuazQ/jj/SHhkl0g7kAOGc5+aCtUJJT6xk0C
	o5ExQyMHTyU97TyRQgsJpIJ3KXbGvpqxdDxl4fZg1GWE7r8vj2cm4kMTTAsw1NmPdSDJ0xGnpX3
	tMjJSRPnwAY5d88QzSW74LMJVAUJQ/VdzgJafsN7A1fguTCQ==
X-Received: by 2002:a17:90b:270e:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3b0db6dd119mr1162556a91.41.1793932657754;
        Thu, 05 Nov 2026 18:37:37 -0800 (PST)
X-Received: by 2002:a17:90b:270e:b0:39e:6a80:b799 with SMTP id 98e67ed59e1d1-3b0db6dd119mr1162518a91.41.1793932657155;
        Thu, 05 Nov 2026 18:37:37 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b328a04asm5705831a91.14.2026.11.05.18.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 18:37:36 -0800 (PST)
Message-ID: <108d86d4-3b0c-41e6-9a2a-3cf34ccd924a@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 10:37:34 +0800
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
Subject: Re: [PATCH ath-next v1] wifi: ath11k: add usecase firmware entry for
 QCA2066 hw2.1
To: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        "open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER"
 <linux-wireless@vger.kernel.org>,
        "open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER"
 <ath11k@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20261106020809.3580396-1-hongcheng.zhang@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261106020809.3580396-1-hongcheng.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAxMCBTYWx0ZWRfXzWTmTUid9ifE
 +k6ZlffDyu1uRcp0CnUlHlCDp9i7dIZshCVUSA4Yhgal50c+CfTR8X7IrFvmViWlGQjCpQjlE+O
 KEBSNQUHPDNGOSMbW4U4k/UajU8/X+w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAxMCBTYWx0ZWRfX3R3zKt1Fxgp/
 NGmNVWzVqLVvEKNPQ+oWYvx+7bKQNaWUSQLF+JYdu7bCB2AVrFluN8hu/ydlNChHAjYKCAiZAR6
 eboDroX/g5+oXmMqleA8DCuTbgoz8Q17PmwK+FgrMqhLR/AwmfwwZkpvORlhpxqVNYWYbuuqxsv
 xArn9WmIDppCe0QllaZU/7NLPUiu9QG0IM7i4LKf7NO06/QAML7nMROTYmVGnxIKh4JoyEbdMPc
 V/fwuh3/T0JG5rEr+xF2hP16w1FWcTalu+Pd0bTgkGbDV5fQSJE2W/DI7rSPpzBOOdcCwaWrkSZ
 7GRIQWgTp8AvWJ4xJajgiwvhO7meVxMqd6O/FoWJ7TdnMZAbUjUQucYF9ahNpOcOaG1TpvGUk5I
 oUShULDMqlgKlLZKUEomp2dBLDUaJ+dVgeRi3LhfaTpqWw4oZkt6DW9pkFG/3GdN5y2TR30Gryq
 eppFz80ADnPSYmXUPdw==
X-Proofpoint-ORIG-GUID: K1a1LpYOYJJhozm94nm9KlwkSymnFXC2
X-Authority-Analysis: v=2.4 cv=f6Pdl+yM c=1 sm=1 tr=0 ts=6aed3d72 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=38uOJd1x8bnEsvVciosA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: K1a1LpYOYJJhozm94nm9KlwkSymnFXC2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060010



On 11/6/2026 10:08 AM, Hongcheng Zhang wrote:
> The Monaco Monza platform (QCA2066 hw2.1) requires a usecase-specific
> firmware variant located under the nfa725 subdirectory.
> 
> Add a new entry for "arduino,monza" compatible string to ensure that
> the correct usecase firmware (nfa725) is selected.
> 
> Tested-on: QCA2066 hw2.1 PCI WLAN.HSP.1.1.c6-00302-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
> 
> Signed-off-by: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

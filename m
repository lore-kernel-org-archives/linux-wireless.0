Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634815;
	b=YerZJ+uUA1HWgIQPyNJXYx3bRYH0NDESqLoSGW6DLTlx0V+OParZBrUxsDFv1u8eZccT
	 qhutmFBknr3mrmO1oYIhWkTxFdhmyEqZ0yN1+PV9NP+QYBeZ+kVqIKSIt3K45Fm/ob5e3
	 GzMtopZtSufmV3IDuBOZpQoTbcY8luLKeHu7tlxCYdi97hxorFZvm+mEdwznKTotrkIAD
	 9sRy3Brye/0cikIakL8hPwpBv9IM+Vj+RDhegPdMp7LqKdlDfsmzf51vmSAbj9Y1yOu6o
	 eqOkr5d5Ka7yonwUeJsigzOKoDNLbGq1lluyWG+/tifGVkN44fGxpB8ANCtXEKT27RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634815;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=BIBz3g0Dj1YwTMilYZMcJh+qL6MW6i+rcIv9hHtYQ7Q=;
	b=JnOejEL7hwTypnXWIEuIwutcI7/KqAaXMJfCIxvl8QfEXfBV83MdMSA5iS0L4hbCTbtv
	 ju8MC/6Kv01UDyTA6HyW1f+rRUQxaSBTXpGbPXuP0bPoP6yUKNz0EU4/sqCLh3UakDFoc
	 v4F/6a6f//ccxUuq2GoTHEpi1HfbJHS6JXdwnwy6dwBQsbym1P/wzk/QgKJMPAD3sO9JW
	 l90s346Rk8pe1fDvo1UMfh1TibSryvSRnCEmZoXa+sncqdhDkbEQ7ONXYAObsH2aCsi2w
	 UsqYH7nmTMfRTrK1al/Vh1Jj3YWpgOBEqeZ+hfXyJ04TXtvn4rTaHBP+d6eDaAN4ksQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UdQunzKt;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dTxV0bI9;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203AE60AED18
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 203AE60AED18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UdQunzKt;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dTxV0bI9
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2DpRcH846152
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 15:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BIBz3g0Dj1YwTMilYZMcJh+qL6MW6i+rcIv9hHtYQ7Q=; b=UdQunzKtyEZiHTk5
	9btGeXxsfUOWy5VLcYYdwG5KOkCRLW/mRfEA+QeRBUQS9inPkBKBhrNLRCq2DEaE
	zFwuj9pC6CFH4u8X1jq1/C9Ju9wSL//7BVoRXVAFPYcW9wewVHsT5L/MsdxoVVca
	NzdXsxDEr/7FCNGnMonXFdHHTsqDcBmwn/o/Gz1R1uqSSvFqnY9nTjr4x5GFIv3P
	iFRh80qHDZsNGzeKfw93YYvD24txLbBLf8VYfeFFR/zXo+ILdFUF+rZOF16y1No1
	7FYwG8c3W5kBG4/Elc6QWpZkvSKpKzm60CB6xlhvpmN/W7JI1LoLl8L9bVDzFviG
	GRcswA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpmf1tg57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 15:53:34 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a1e2485fdso8240118eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 07:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793634814; x=1794239614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BIBz3g0Dj1YwTMilYZMcJh+qL6MW6i+rcIv9hHtYQ7Q=;
        b=dTxV0bI9Ey7W0UTtzyCeLVG6/7wEwbXYG9T2FLeBsqtizf3n3aDAj1Hp9od/Nvi+3J
         XamoZwzxp4HqAanwmTTQq+pKk4xlu7J1GfubIRCRnToJ3wtzkjwlDS/VdkkptgBnjEOg
         JPbCex42fdV/+S3qr7jq5cLeZX+enMiGbjtsU6OAkO6QudbYpsTfzGLn/H+nWP3SpMJZ
         +lFaXaHuO+VBQbG6Zp324kp5utCIk+K/cuiLCxYpQuZWhy4SMfuVO5J7juGhbfTLSkS2
         v8U/uNbzPQljnAaED/H+3nTQEh18NF7hcDmYq7A8+BxCusjmPPvnN22xfw/Qao/JJSeO
         rxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634814; x=1794239614;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BIBz3g0Dj1YwTMilYZMcJh+qL6MW6i+rcIv9hHtYQ7Q=;
        b=kLI/d6NNz7rVf1qewGq9LCjFSpQglr3R4Oom8JnIxqND5L/5Gy/mfW3Osf5x1kYdqk
         zeTBsSId+9kPtzUJMNMx0679erCfyFNivGl5L3AeoH1d6bo5WXbNJTjMzx2/K8pcJK5c
         32V+2sQuKYfhUi85lTW0YdDu4dkoGm5vxLu2Z4SsB9Q1Nlsux1cDNJuQdFrG9czIzco0
         JVn2nCJ/leTJ+MXWp/lwrrQ8Q0podMY7Tn6tjNTZeFnS0QBbu/ILd4bwXXGYCfydnsGI
         RPTtUcXMsMcll5rTbrRb0OsxL9iurOf+Hq8sGjZuXP3q3OrNtiHQS+7hLJXF8ACRkg4D
         AplQ==
X-Gm-Message-State: APuU4Z+tzc4fBpvEMUuiLdTBkGSzDDFy484rbapim2QAHoOB9szt/+zD
	kNZwcrKHeRN+G5Nxs4Emv9ZNYrCrw5fGsYB7ZmWXZGiDeQ7nzbWSvXkzezKnc8wP6jIFgZsyeSx
	vecK4r9jQHHh/+1p8vakcWlbwkqMwlfhLPBdqh2k0zhQ8y/cNUCvoilR1Uy9wA+v2ZrSAUQ==
X-Gm-Gg: AYBFou3a0h7IGGuErSqTIdJSGemotRgLoKoZCVjRA6c6Qtwa8BGPKLTaOIhc8jpYOVK
	Ye4eFh5CRPKrYJXoBEew7DuuovyaIKa4mI7WJ4BWpvCT9gPlQX7ZTAPKzmkkZtMgvx5Eyizc9kq
	SdIa7O9s1VbZLaZivfHqnVEHvJy/QXkbPiAtN2R1PJT/zjz+JRiSu1Lp2lPNDy//HlJW7MECeMx
	9Mr2OJhqL5H1Go0Y0wQ0xEEju0T8f9SQqT6Rm7YciII3qpSpITpKomBAVwD+vJw7JlHevzVt+WA
	zYaxrWzMpS47fqQx6qd7xmZTRwJ5qVkOCYHc57u6BgrkZLMnTtUD2hBsLjGk4Y4IFrk50dYUTrP
	sL40npEP6eXtOoXhnMXuEDlvUdy1j41hkuLQlwpac/7+h7j/asE7ZmPRfouJvctJMPugU80Bfxc
	0/p/LjPyMmLKB3qMSqr47QbvQCkxGzAw==
X-Received: by 2002:a05:693c:41d9:20b0:368:4acb:f8a with SMTP id 5a478bee46e88-36a4242f5fdmr15944161eec.17.1793634813617;
        Mon, 02 Nov 2026 07:53:33 -0800 (PST)
X-Received: by 2002:a05:693c:41d9:20b0:368:4acb:f8a with SMTP id 5a478bee46e88-36a4242f5fdmr15944086eec.17.1793634812852;
        Mon, 02 Nov 2026 07:53:32 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af1dfsm40754304eec.7.2026.11.02.07.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 07:53:32 -0800 (PST)
Message-ID: <9d97e1c0-3f07-465d-8952-ee33b9aba7e4@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 07:53:31 -0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: move arsta grouping from
 rhashtable to per-radio hashtable
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>
References: <20261021173318.1935569-1-maharaja.kennadyrajan@oss.qualcomm.com>
 <692a240a-3995-47bc-8360-136610fb6a89@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <692a240a-3995-47bc-8360-136610fb6a89@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: E_thcmzePorOTJQ9S2XNiwc0wSg1u0yH
X-Authority-Analysis: v=2.4 cv=bNaDs/+Z c=1 sm=1 tr=0 ts=6ae8b1fe cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Cw9SDZpd3yfYGb6VdUYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA2MyBTYWx0ZWRfX3IqBaUSO7Un4
 b6igGEuLfEdmWTVaEglVn3oJvzDbdxZoA2mU9/ffzm1zG4az7SlBG8f56iuIAgNI+dyxVfmppV8
 AAsK4BEbNiHdAINYvs24a8Osbpj9o2MdzcSrkOvTc46k5QY4bh0Dfbv76h4SxP+qep6KInCYcPh
 d9ybBh/ZtoSoV2HGvvQ8gTqh3H3Z0LGYtCOPELA7V1HkYtvLOU+5ZxxGY7pd0bhWHpQ5s6TBCu0
 8UpZk9/lbUungo3DQPokhHmzH5jWUdwVC7ctS4ZqvKz/nn1gKTcFExdtobNfpyYlKRtbgtWnQMv
 winEYl3j+QvVNW7TS5LrhBm5IpCLCGLbpp4SgjmGDCqeJEeAD8OlH1jdp7KM+3Uje3YvsNx9++t
 5ZRxODxAcztaTu9m3hi6xQpqDZ4kgWzmSwfa48IfmziQKk3ox5P3vuhwdAPQ2/dJGtCw7mInEQ8
 zaKvWpUURdO4pMXZZWQ==
X-Proofpoint-GUID: E_thcmzePorOTJQ9S2XNiwc0wSg1u0yH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA2MyBTYWx0ZWRfX3PcjzgXqzVAK
 6kPOLuavXBKy4+ogFTVXIkYtbFIb7fbpWTjPtHzSJ32Jx17JRoRb2MA41+k2yMB7+Iy+rm1Zdqi
 hBWPdJS9Dk9Bk//Un0+GeFXWDyeWbXM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_04,2026-11-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020063

On 11/1/2026 5:47 PM, Baochen Qiang wrote:
> On 10/22/2026 1:33 AM, Maharaja Kennadyrajan wrote:
>>  	if (ret) {
>> -		ath12k_warn(ab, "Failed to add arsta: %pM to hash table, ret: %d",
>> +		ath12k_warn(ab, "failed to add %pM to hash table %d\n",
> 
> it is warning, so you can have colons before error code:
> 
> "failed to add %pM to hash table: %d\n"
> 
> 
> with that fixed:
> 
> Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

I'll clean this up in the pending branch, no need to respin

/jeff

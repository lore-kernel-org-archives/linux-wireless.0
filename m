Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457743D47AA
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645816; cv=none; b=fUDWhX2qC4WXTu4im2rGduEJ7D6GFTkMJCgCTVvgfb7ldmHoMHjDXfpjkpss5qW7IB2gngIA79u5nfODzVzZKmbpvn1p4320qmHUN2UEJcsFjm0JiF4jDnTdvlNOnVbsORca9JoOltXttEfmmB0Crg6pQo/sEYuFnkMmWpSrgOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645816; c=relaxed/simple;
	bh=KB+3YLqgbKroqQ1QNF1Vt416kAmTvteXXm6pFSU0tJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jcq80Ecl7yOM9aMLuZfapcfXweT+M29vflebGV+noH6FTdxJwzU6wc+mdcae7fA8YkDs75sH/3HjXDVqPncVQ0Z34vlzN5sTrjK+F4HMwm9aSZV6DbmU185DQ9ii6U0n7zryxZnv7LGmsWMYMXMuzFzyQTd0YfjffCZ+1M+r5s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L/YAZ3/v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Dxf8PDue; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L/YAZ3/v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Dxf8PDue"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67P88MHm2387935
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u3nGs8Fj6xeNtfD+I61I2OiIR7G0vRvfVqgZ3eN8/iM=; b=L/YAZ3/vcuuYoVKV
	In1ZP3ZkR+Hi/TBke4vSUt9Bri4+W5BTy2bg5ST7WSkOTstmwqtW/lc3BeagVCDt
	kVP+XPJ80Q/rvLMrsWhB4fCXYt0tS7C6YxnljI3c9tB+Me4PQXspCQY5KHYRkm4X
	wsRkgYNMcQ4+E0PwPCrB7veY2q3RnBJOBgEVOIKGDK4k0+XZAk2ZH8pOlPwSkgJU
	N0Mv001/JadF4rD58RmS9eQrdCa3IeloBBfEg4KSxP0vdijGf9Nq6utz7SKq5UCi
	vGPwsV4fJPF0SslmA+wz8+iQiI26M16y9mwOwPhpYQxEwGeXpFn24NFpoXjvHU7Y
	aQI5lQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g8swrayck-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:16:54 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e63df032bso49865785a.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 01:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787645813; x=1788250613; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u3nGs8Fj6xeNtfD+I61I2OiIR7G0vRvfVqgZ3eN8/iM=;
        b=Dxf8PDueuUiqUg6tKqs3x14jQVoeyTcMiHGt9m/hIIk9Gioz0hJezf7OW9Xl0Lxz9r
         zBUNm85bR5alJd22n198Tk7blhwonemhsgGkyucGJugv1bM30J/iqZuuygI+1QlaX9fH
         A61yKTCRsP32j28ZTQ1Sm+Pds8tld7wu5fkS8TP8F4ozAJc/p7uFFzx4RAJ6foTaqpKa
         h2y3dH3w4K7PtrLlPn+dmpeXy4G7bvoYHs2j5L0ABe7u1X3zqOplsY/JHunVlJs3YVOq
         OnHrq7lOObPcbo+dnROgwKwJGNMT7Kz2d3Rg3zCynvrYvyIt10+7FIA0t9yqjfwa1N7F
         taPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787645813; x=1788250613;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=u3nGs8Fj6xeNtfD+I61I2OiIR7G0vRvfVqgZ3eN8/iM=;
        b=XHpG6U7wqHO8u8pHSH40tiqaS8V+M212Owzc9kmGBTCTv7lWTfSRT2UTUmv/Wf/9wv
         oPMDAPF9hjVn7OWOIudWsEDWr2BkTUGYrvKjQlp2J3uUmKnJtH6XP+nnRBNvu+P0kkhC
         6iO+rcF7I9wgFhuGshVv+OzgrEWr6k3PBiULyBdpy461enj62uUp4NtvvDWhj2aQvC+E
         hFaH2LNML6njOanWLPQ8AwZhkj/VPQEMZgINyJcRnMQ99BQMvFBRNlOxc30A7oUcS3m5
         zQiXPhMi/Tbxegyic+22hskGJVj4Jf36vrw9j6HqkkjTQ950EIwy+koJEE/ZP1aKlVsN
         8T9w==
X-Forwarded-Encrypted: i=1; AHgh+RqEp11AIwRZHC3kz2dLA/PfPgae6Qbr+QHNAvTYJ4TlJivIXMJIQvG1Nd4WCAb1XHzckJtdpxqeOBwEeR4P0A==@vger.kernel.org
X-Gm-Message-State: AFuF++lasnK2Z/jQHgUsBae8mh7n0NdFnGmiOK9CuL8dOIg97gPWkWW4
	qnIBRg/Rq5hrSps+s0Wd++r72PUwHc0Y3Zjfwc6u2yoddpxTK1YW1okNtZwQkUjIYBB6QqgAbtG
	9seHHLHx+RW9rUDGXx8sbMsNt+bhqAdLvA+yLi3h5VNQ6miDJ49sZSnn7cSa0Z796lP0s1A==
X-Gm-Gg: AR+sD109p2/MeWmvJjYy4I5eP0xek/wv0L7TUo4B8R960hspT2/rG3AE+PZdYjh3Pu7
	qQUJWfXCh0hw1VppghLjILNR02xm1iDcgwVyfIrJoeHtQq0d1Sr8FDgfIstfwON+LiHC/cEcwcE
	8CJehaRtb5fuzsO6TJfC0KuxSEgFGTUoxZPCRIYyn1Cprkz/3otqX3uq9oYgL4UL4r/g4I2pweE
	giY5+SIV5jbwPe1PDhwDEq+LMl9aF7KqYnZ9rLv1s3S24U8UEXBPJt6/SeHifbBuqUecrUf3Tfp
	z5L/INd/PkRRhomczcmbYTSIFp1JoSFTedXYJY8jWSdJbhSHMFobQTFDWAHuiKHDwm/kECGaCg9
	nFQb1UvS2hu1lJJtIbZLrEodYb+Ag
X-Received: by 2002:ac8:58c4:0:b0:52d:9cfa:663c with SMTP id d75a77b69052e-52e2eb42ce7mr51489921cf.0.1787645813304;
        Tue, 25 Aug 2026 01:16:53 -0700 (PDT)
X-Received: by 2002:ac8:58c4:0:b0:52d:9cfa:663c with SMTP id d75a77b69052e-52e2eb42ce7mr51489661cf.0.1787645812910;
        Tue, 25 Aug 2026 01:16:52 -0700 (PDT)
Received: from [192.168.1.110] ([178.197.219.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968abf18sm1777389566b.61.2026.08.25.01.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 01:16:52 -0700 (PDT)
Message-ID: <6615be69-6c60-4866-8fa8-73e76e86954b@oss.qualcomm.com>
Date: Tue, 25 Aug 2026 10:16:50 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: ahb: Revert undocumented ABI and dead code
To: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260825081313.71351-2-krzysztof.kozlowski@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260825081313.71351-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: WdBTM9O8FJrK9S-D_Y1OzqMPGJFIX5Po
X-Proofpoint-GUID: WdBTM9O8FJrK9S-D_Y1OzqMPGJFIX5Po
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDA3MCBTYWx0ZWRfX6q3WupD40CCI
 lnDJ5WIeKcsZRwyLGC3wUP8tnZ3xWQwDhi5onVUr6XDRddT28lTqNZJUhVgpJRVEC+r69lF5T/f
 XDYDkjeIaysEYCdkxM/9AGzUuqN0fpA=
X-Authority-Analysis: v=2.4 cv=TqPWQjXh c=1 sm=1 tr=0 ts=6a8d4f76 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=+bKQE0WJfmhK2875HamI0Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=qqqMIIPnSBjTorXjQPsA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDA3MCBTYWx0ZWRfX7X7DKUf2n2Xl
 ohWi/gz6z+QAo8rTMACT23T3oxCpnday/jUbqKzB8oNGrrmJb7k2uTcdhLnPBto+cv9HmINflho
 GEbUhiUND1soMbo4L9Yc11bpeZZseThH24JCbg6JzAWBOz5kWow3fm6T7ARbOEIKJb/9oaJS9dV
 FOCoQmPgM545t0OA0V1uFqiR2VrPCPFijf/ZE3g8r7XKZhHfk0uY8cn5/BLLUTsJhdj5xXXF+MF
 tZXaO+1rMxBfProysYSd6lEce3RTiyWH20/8OsAFHDYiAt0iVhgbRHALxQXPV286tNTSun7qfVp
 vLQyzKiJpIlNIZWFYcH7LGQDUqXDpF9T+Bm/ntgUuxvG8CAh8NTT2PeUpaQdET6tzfe6seoXPBe
 OzDYs1AqLHlFmypjnzHvbEXwSSyVTa5xrfzq+al0Oag46RfPiCPRayzAEfOygOvbOhFN6HL0J8z
 TsWTyIZCAjqaVUZAyyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_02,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250070

On 25/08/2026 10:13, Krzysztof Kozlowski wrote:
> Commit 96f46607bbce ("wifi: ath12k: add AHB platform descriptor
> support") added undocumented OF ABI, by relying on a very specific node
> name.  This is not allowed and was never acked by Devicetree
> maintainers.
> 
> Additionally that part of code is not even used, because all devices
> have exactly the same user pd, so this was added "for future".  Adding
> dead code just "for future" is heavily discouareged in kernel coding.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 51 +--------------------
>  1 file changed, 1 insertion(+), 50 deletions(-)
> 

Unfortunately the offending commit was merged for v7.3-rc1, thus please
take this to current RC as well.

Best regards,
Krzysztof

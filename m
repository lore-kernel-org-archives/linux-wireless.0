Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C631AF1B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785470018; cv=none; b=SBTwqJFtUMqiZ7W8iaqoW50//nOdKdOQDiBSr1TzWjS8B4dP/pJQKmUTBG6aC1i2eQbLB/q7aHiKVl2/ndhZXSUpODxDJqhfhdxbVTWb8FFnxa9kqt8Pb44ppTRCWMsoD/brx8k6GQX44V0JQ3sMway5VVR/vzyFjDdy9FmLhAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785470018; c=relaxed/simple;
	bh=as5PaZAALTVVq6IlutHz9VWYoUgQHw+2B+BbBfIDAK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LRT9Qlf5b5lBg1vpQLGYV+sKjHPJ8qkC2ZuacEgAWUwyJ3Q4Nq6ifaQkw0Tv+mPm1C8Z2BxXdqWSOi4MKfc13862oVu3j9EOLsUXfIanyPnTBFugPOTSmE7ef6BARnlm9YuttOQnNrKRa4Y4bCaD5P9A41z+w3bofT/z19rRsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c4zX22QT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LOqffdAQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c4zX22QT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LOqffdAQ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V2MYlH2509201
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	as5PaZAALTVVq6IlutHz9VWYoUgQHw+2B+BbBfIDAK4=; b=c4zX22QTzPmpF6Fj
	vuhV2lmCSbUm82+vnUBS8O9fAbYEfsr4p6fKtr6XY/ApExdjaRYBRLn40v8YZlN4
	S7G+99Pa0QMPXHPTT2T9XkiKPsYW9UY7thjZl8fJMj5qEx/BkVEwxMeWEwqL8npx
	dwLsnsF8jyUFHYJrisdqgfXrkFbg5PX7PQtJw5tBa113R+Yx+bp8Ij3jsff297om
	4RJmUKBrXUjF1Jb6ylzE5Wuya/SCPPmTW6teOj0xg3Uf10p7tw6xHkPj26fjTFo4
	cqkz6499migjccA9iaoL4tHWYPCTgrJ4GdlYqA0Mxa2TTKECHhLz9ITQo3FvMBUX
	U7yTsA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frjv9r93q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:53:36 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso792444a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 20:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785470015; x=1786074815; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=as5PaZAALTVVq6IlutHz9VWYoUgQHw+2B+BbBfIDAK4=;
        b=LOqffdAQnrR0+EHIX9wiI/qp6ugH42SGwlFCzqDPtIAvwXI2xLGPyKjp05lBrmVJba
         hFuo+NKVdBx5QasKs3dixpCyPbJFBA5+A8PupRyVZ8+o7sUnEl49JYBaHXMcZnTGsGyL
         CCJVeVkCZGZmoSS3eeJGmIfh/SPgvcxa0WT63oavs3JdNxcuFxLgtzTnKZC2VUC9exzY
         a3tog0n5JywOyVR+71eGU4OI29Ihp901ayUeOZSrl9LMbvn7SPYudiofbXjMSvUz80Wm
         39H4XXp+5Ul8uyxtYhRvWjIp/GqX4f82CKj3z7ndnFXepGpvuDLjBhWTao83IxPKyxpe
         Vt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785470015; x=1786074815;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=as5PaZAALTVVq6IlutHz9VWYoUgQHw+2B+BbBfIDAK4=;
        b=Npi/JVjCWezBnRu/IokYwb4mefwAPs9DK58MkSJHCJnPohhd7nFzHaHZ+8bfCLgfaN
         jBrsBEXmu1cF9w4EGUoOpIk375nc4rVux1lSN/WszYV07EIE/Mw+lCmvHSCWwi69nMtT
         uD64iXYZzZPxj8oMK+DH3cM6iYb8oitOlgzI+MrINaXe7zXaoX9tWnsoDHuXqk51+xiB
         lyaI9gOzbutyte72+6mdEyMvBeZBvIPvp20K4R+ijPWfE4rg2TOW+zC+qk/2gL5VIMpZ
         BKNSeXsck9yWUoMmC/TJb87Brvrhq8zHx04u8zRTGgBivHFZB7pPsi1aJayMNrBRZHYJ
         KmlQ==
X-Gm-Message-State: AOJu0YyHkwrHacNwzq8ttDNMO/ge6k8rTQ2nEx6138XmmwdcPJBjEsFH
	Y2dQT3VszDXukKuILoif1RJ4t3rigopOd5MorUFIqI9aC+xDxSfK0ug1GgJP1Vs26bbBD9rZLTl
	T27bibNV+6IZRiDqZERpI1Hu6DsjezJyycWZPH+0hkUnjSO3N2+zV1GWou7SSXpKLQbA6lQ==
X-Gm-Gg: AR+sD13CG2Oepyqvy1lhoMkyp5dWRT8VpnJU5E/c5i1D2d9ymwPifzZdeoCLJsKW8j3
	qNYIKuJmdZSz6rxw3E9T59pGCiNcdOhuU7cM5F/rYgOco5IAtKH/zPtTdEfipp9YhRIGsKA00bJ
	wj4Jr4NfBeMrq2MyQFtzmvYK6S0yNlnQ/IhXpIz0UPdWzEhUC5y3YMmOzBSRrcJthtslns5c+XJ
	Ejt9Hs0CiGNa0qtqcRKbfsNwHMyu4at0NG822TdsPYAHEps2kumlQK8P0IorKlhpgpj09XFGBpa
	Xt/2IXCzsnwwESB9iNuFrjcwJ3C2OBLRCBzIv0B5eh1l93kqeVpYjKZmAV1rZsax6r1mVyc1NLY
	zMw2pxdoiIl/JlcZiui/O+NAASfcXyHo7wMWV13jQBm2Das32kN3iYqCRl2LWZOi5iitJTkxN/A
	==
X-Received: by 2002:a17:90b:5343:b0:38e:76f8:fcb1 with SMTP id 98e67ed59e1d1-38fb144f3e8mr488798a91.32.1785470015057;
        Thu, 30 Jul 2026 20:53:35 -0700 (PDT)
X-Received: by 2002:a17:90b:5343:b0:38e:76f8:fcb1 with SMTP id 98e67ed59e1d1-38fb144f3e8mr488771a91.32.1785470014614;
        Thu, 30 Jul 2026 20:53:34 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2bae2efsm76141a91.11.2026.07.30.20.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 20:53:34 -0700 (PDT)
Message-ID: <bc84e489-5907-422f-a601-d2aef75c33bc@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:53:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: cleanup arsta in
 ath11k_mac_peer_cleanup_all()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140232.133500-1-nico.escande@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140232.133500-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Iokutr/g c=1 sm=1 tr=0 ts=6a6c1c40 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=nwA6kXA-DBkKNBvwkvIA:9 a=QEXdDO2ut3YA:10 a=DVKqRkKJf1IA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: nskrp3e8mnD_VMMXs-FVnivvUK_ujyIi
X-Proofpoint-ORIG-GUID: nskrp3e8mnD_VMMXs-FVnivvUK_ujyIi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMSBTYWx0ZWRfXzoGNhcqaEFnz
 mww22g4zU74nyL9cmIyUKfGvEWB59H7MyuNsimjixo8Jnua3oYp1oh++YvLRkrT6qufxfGMdsVi
 r0mqh17U4nWe1wCBiYluDp+Rerz8EAg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMSBTYWx0ZWRfX/NXqHEUuVes3
 hQ4Y0Q/lNlwsaSdGLDksyJFJtfbxZYd+kdFqmBHqk83g3KcrD+icQLhKZ3A4rrQEO/9R3FHC3sf
 e1719pvK00mbuS3OyPwKNDY7FdIadOYh6gaIIXzPbppTlfEDdx0Cv5eDxsgeNy+XWqsXAbxYbdU
 yDBQz5CR6eLJb35frfv/yFGvXXJ4fcD5tEdVPZEstXaLtPYALJqSBE/NMItTYV6XjGXL/iXXVFJ
 Q6tCc3/1S+knSeDOccMirQkCmhCF9SIB9GplPNZN0gNR5kajWTr86GB0R3nb/H4r61omQv15MI+
 ReTYO3BLh18lQnCq8ikZZK7CTPtmao0lHDPP3oDm96W5GD9B+hQCZyuxwbp28S/iBD+2ddn/z7a
 TuCYFhiyMZjLYtBAU0sAN1hTvkZ3FP/WNjJUJUxWZUUhgFz473Qu88wOpJiaY1lxvvEl5z6Ctfs
 LFa9k7wSwFENa6A/kww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310021



On 7/30/2026 10:02 PM, Nicolas Escande wrote:

> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

the hardware version is missing between target and bus type:

QCN9074 hw1.0 PCI

guess Jeff can handle it .




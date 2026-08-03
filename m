Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8C83043DC
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 01:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722063; cv=none; b=Yj3XL5oitSVdM8mrR2OdpP9xJ0KQBL+7cotL3mEwv7Fb1yUol3c9r0wQrC4+mzhOh1aLUFM5cr4vYmLXClvfNsWF3ZWkssggPxK4WN15vPUZpWOG4f7N38TtK63gOXFLb0uZ2CPws6HBQv9feXbnFDWAOg0YXOFHeLI3wjlTzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722063; c=relaxed/simple;
	bh=6mYtapz0iaBOwt1sOHtfMiBNylwnsCL3rCHcPW084W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GyxcLGmi1DhWMfzW6gbFBHfmDi82w1hjhIf36cBDfLtS24V5JtvcH0TIA0Vy8+pud73hRL+aRqs6apH4ZCP6ouKR9WjSkjkwiP9wDF73WNf64IYi4qOtpuR2fCpVsWi/t7B5DtdJ0Waq/I/ZMMzsGK8xmeZ1E1IXd5Can50gdEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pma3vxQM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CNpJQu1Z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pma3vxQM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CNpJQu1Z"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LVthr2626368
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 01:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XHmQgqMQv032aCyZDAnWTWd7d/wKQX5fXHHje2dMjn8=; b=Pma3vxQMUXnv+ZMf
	zJN7CJp9Jpx3h4Ty23cEfa9nUp1hFp2iWlj84PIp8lRktrfmuSok3SFm0Hm+PMOY
	6Dpk0/UXe41bC/dE7ncbVyYJZkbKImf7WyYMkatnZbEhtCnQZo4GMFhm3HBXts6q
	QpamReCj3eBuMWxwfFZ/QV4ggYylEx94I+9YMJbo9LLMloje4n+kn82L34LMI8CD
	78T2PopbelKuSLDoC5fo1/buE5IM99ssRBgV3bIXkEqbPNFpiHuqlIVJm0uixAzG
	lxQKNNGF3kdDujMAtCbqRgAFh0akDtIWaCMIR/wHgWHDq+vg8jReLjUXoe233Q8k
	cHEAoA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs9jfuw9f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:54:20 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2caf4173b1cso60822645ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 18:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785722055; x=1786326855; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XHmQgqMQv032aCyZDAnWTWd7d/wKQX5fXHHje2dMjn8=;
        b=CNpJQu1ZkbThJA18q0ILg492lYv+4tViXS0TvxmRTDN45wL9zDivaXpVCclB49dwai
         N0UnGpI3fcRLBp1i5P5jG6vOuZ0sPbbUK84EHt5jQRFhaLZTKyySWWNlfgEKAfPm5SiT
         VayJHMqsFO9ZtnZ3LAxsgh7kE4nlblrTp2DSbIcwD/ipP1gN4ip2XPOsmHT5fK0vMn7q
         CTza5Di8Fa9851bLyatvngy4E+76MJYkf9u2cJ5jYB/Eil+s+WbdsR8IaflvfGn41APy
         zFVPsR3ojU67rOYrl7Whh12sbkTrGBqQH8fp6ng5lccbDYqlxunGQYR77/2D5RTskz0p
         5uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785722055; x=1786326855;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XHmQgqMQv032aCyZDAnWTWd7d/wKQX5fXHHje2dMjn8=;
        b=qgm1IywwIR/sldj/+w2ZdIXdBGlQVfyrZsjXYKyasUKrz7gHaNgJDX5TgtYwqzGtrw
         D2g9PjDAZHk3Ts3U1qgSQoEw+5u8dLHnErK8uZM86MBnucLREwWvd7rCFbr67I4ZLoBf
         7+i9RtfsQcuYDLnEBwYFFGvbLhr3y+QIvBJBoHcYU5Z76xcBfFh6NYWKC8l5Xrmg+MV+
         McNqU/5HttBELxAmyrJKF5r2Y9/wX/Ol+0INCfPEzX0dA28Fr16j56llTMoriEkxZYGw
         3m4MjFyqWliBmuPk3L5oNBumdsF7cLwkNIgUmwT2T0S9mNJViIgKIfyA68Nxjyv2QVdI
         eVCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEnmRXOBF63reMxfuSUzixkBbX84wVCfI9L5EMrQKeBTZwKGbHum7Ka9U6nC7bhWVO+zEdKHKy5b07AcKobg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxljLnuhWL/yiYfADBdZbmwfY1XsCt1P54RpjGPraNea65Iokgu
	0ht1YkeBm62ZnZB1vXmyzK3qsJTwSZR+k5DFD33nvtUv8IbizA1ZKCivkOrUlEJ0JU9L0X2hwgI
	ZHgPnllkpj8v4pefO3iJLVsYCHQPQVGDArmQmR3yFO5FPgUkN7OuyTm8YjQt8fno5a+g65w==
X-Gm-Gg: AR+sD12AbCocLrcW2drhxl3YCHiJR+1AzoP4KRR/GShX9ch6o2Ty/5Dwu/FHBn9mo7U
	uqBPqKTWbh/DcOvhVI6xN35lH9QDPnu87MD5qOfad22HRf0PVfEsGBUS2rWxxo2Sd9IHjB9JuCp
	UbHbczuT7S5VY0uwzGHyA9A5A7d/SsGrlYIf1lIZr2NxomGQMMDGQOKkXUFYNJVdtFyOwW6cTNn
	cyBHxHThvgIY4sklV6Y2yb1axWTlDtzVGPvJd9PGCoU3LPQHm7hqQxfrr6rro5HBv1W5XhzTd6F
	9OTxCwMy6EEDHqpSWNnBjGrBD5DGRO/B/a1hlCTqtYfu++DY0wlLa5cPjSUcdbEKVSAiwWOVz/B
	ktYkVhNO3fPA1Ptkux3Jlr3q0IdG4U1iARRho0ibaDZM1ZjdHoaOWdJEdEiU75mA+U7dhrb8WMg
	==
X-Received: by 2002:a17:903:41d1:b0:2ce:fa3a:45f7 with SMTP id d9443c01a7336-2d0521eabb6mr83034375ad.16.1785722054640;
        Sun, 02 Aug 2026 18:54:14 -0700 (PDT)
X-Received: by 2002:a17:903:41d1:b0:2ce:fa3a:45f7 with SMTP id d9443c01a7336-2d0521eabb6mr83034205ad.16.1785722054265;
        Sun, 02 Aug 2026 18:54:14 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae58d8bsm30212665ad.26.2026.08.02.18.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 18:54:13 -0700 (PDT)
Message-ID: <a990c25f-8f6c-49bd-90cc-9c4d0729fcc4@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 09:54:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: remove unused
 ath12k_dp_rx_h_find_link_peer()
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: S4B4hxS65TfhKSCtz8MfcCFLT711FR7c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDAxMiBTYWx0ZWRfX5bZ5nVw/WFe9
 aWfPd31pW3RtD6w/gjS8uYQhOjiGn8m3dFc11KAHOnP7B54JivXhgytqgiLDfBYJv6oQCFv6Xkm
 qRa4cyyBRwGi2ieaGmOdT/7DRLw5PNSIrc5ZyoWwCGXJ/m/Igd5fAgcQzNYPU7P+efil4lGgfU8
 WbST5zQI3RzSNM2PoVrf5Sb+SCMZwp/eN3Z+E8tokVnKZH0BA1X0QDkUhBdCOoNFEUDONuw4ARe
 r4Fpz8/VtgxKjXo2lbNfY2IBbG/8FG3oYMdyg7jRn+lgY/TwgcMgvk6XhitjZb3WSrSSLbLKICL
 kexDuxi+77YJeBWKGGdueae4UxJMlfzsg79kWKBNRJVBW6gFiiABs9SoWJt6maMpGkgENiEPiny
 qlxwoxWYsCbBF32UqHpuxIQkXP4zJBGNPrRMGfUotTVeiDb80s0QrekyNhPj56eUp39Y5l7ZSfI
 3/ZzA9mQzNPJXziK5cQ==
X-Authority-Analysis: v=2.4 cv=TYSmcxQh c=1 sm=1 tr=0 ts=6a6ff4cc cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=A0BUc27G3Na8zYCJx7UA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: S4B4hxS65TfhKSCtz8MfcCFLT711FR7c
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDAxMiBTYWx0ZWRfXxMU3aj+d2W4s
 wwGj6dpu0QDNhNlZJSTL3vsxyi2UkqacOZ7YHNezuu2z9F6eVI13DxOIfXxLAsGmAsIuo9wpLpi
 rnM/+NkCNL5U+mt402NeG6YI5xh0zu8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030012



On 8/3/2026 9:05 AM, Miaoqing Pan wrote:
> ath12k_dp_rx_h_find_link_peer() is no longer referenced anywhere,
> remove the unused helper and its declaration to avoid dead code.
> 
> Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1

is it OK to use engineering build in the Tested-on: tag ?


Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD05370AE7
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791442151; cv=none; b=Sqieghb5gekp9mM7xbPOhTQDvbyeoIFOnJcgn8Rl9EjOHqBPNL0Z67zVfKKBRG7pQW2mUpb+2Xc0qvbrVQzUXKAJw1M8wuWopQEUiKGpHEmmQXADXMb9SFwmLSWZJmu/tstwlywW4fk0hyNqqpp9khOsNestiN29KfCp6dsIFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791442151; c=relaxed/simple;
	bh=icP0yGCzswj6mUyjJWo0McyYmwhFhCq9CCcJJ1QQl9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2lD8XsgLVqe1zrCHs1TXIWsWy9LREySzGh4pkZZnpcZsBg8/h5QH/IRL5pmgqxCAyzGKxj63xKFOv2om4tSw/LhZopkJ5NpKCh8Mgw0FjMTuoS3EeAq2fQjfT4qhPaV4IX4dzl8stygipG0dD3i95pmvI1fxjIj85oYSnd9coc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kc6kdFcN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MOYB1G96; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kc6kdFcN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MOYB1G96"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6984BXVW928540
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 06:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/thxqmSGXCGdxA0ka/F92mAeNv7Z/Yh5f4+3MKsC4Es=; b=Kc6kdFcN81smkTc5
	skQNvg0P4jBmpKtFgj3UYdoG7PF8j4K9I0mNYgd9FDGK9SsaHCpTlX063CSLTcfY
	rTsBJLTroHIUL+yvDjSK/BG1DF4bPMWUpiLo256r2FvBuLNxkg4M/uVZEO76GZOx
	sNdNLiISe+cRJhFLWeBCUdQqeeHsjxah/7kpxa6bxta9bc071wNYE+ceboxqu5zS
	XGMfYsMCswnzJd/4djH2ZZkwkqKRGRrOI2svWGTS2riZB0PnIc40sTuCefyakSUo
	aNUNVpTDvAO5Wvho69fMa9LrzwHtD+i7lJfTgmNLyMx9niy07urjSrcCqGEPrp0A
	cCnHmA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2shqw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 06:49:09 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so47932485ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 23:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791442149; x=1792046949; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/thxqmSGXCGdxA0ka/F92mAeNv7Z/Yh5f4+3MKsC4Es=;
        b=MOYB1G963K/BeM8ztziSTdjHTnovpgMtFv7I8Buk4SZrHpOs+I8IbfYd/JNon+CxWp
         ToKSZYHM3HCJhO1cYSdxTKdgcJzKJ5JqWDQYw4+5ITeKv2t6bgGUQmacmjz3XrE7lIqR
         zCPxO2UVd2vUn1VlNwJTXaefxdyLdyGEGP8LJ+tHu9PO+VFV8xVaEb4EQgZIr77FspuP
         q5ZOxA7uipX/5hRhO/By3Jpakne2FRbBbJikNzqtlGOTzoYa1G+jExX8XHU8lRbn1Dyj
         F323lVM16sw3W0flr5G2uQCXReFGBWI1cfIUAsYYXsKB8xg71HEk9NCgAzVf8NLi0S3A
         5GeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791442149; x=1792046949;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/thxqmSGXCGdxA0ka/F92mAeNv7Z/Yh5f4+3MKsC4Es=;
        b=z09VpHcRz25Z8JnN5ssoxFtImEwdm1SPAYp5JfKu/GAkrqrxcd9q1fXFJUlF7MGiay
         wFoDBHo/D1pHaH8KBXpIda0Umjw04NgF5ivH6yQDFA7jhiYitJmcIBYIo3JxOt+xLEOF
         6USI1IYJlk2VmQlcwzP7EN3gYHQ/G2pJpSt4coSP4/tTH+8TqRjpqJ3oS+zPtHP8OoJL
         Lkyf8XcRSiOWPKV8bgKLTW5NAWIXTgMOodLfYpE3XyO8JoIUTWMNf3GfqSE+483Najzl
         +CgeT+n5Ie5ghtGEsPYdpdRvy8Kcicg7IcPhbSswbyMMF7seIk7xJEHwmV7kYk7OwoR/
         9OEQ==
X-Forwarded-Encrypted: i=1; AKwUvBwC8gXIIJWGo3dG1CPGS7MlfB17/8/bp5QLZwlXMs4+xVx4MBm/3wwk9/opVKGEb6bd5BzkDWCZeaMRRS4rrw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJTju3nrK9bWo0+e2woCP4W4+6Rku4ndxzTWN8VEn9j337caMtH
	PzJTI1JjvZ9/EuIPYA2gPDt+yP4+GCNeKmm0OOsl//RuUhV/AN6frxAMI+d3RTxGzE04JqF9I2g
	cJX0NeFULn69rpinAdW3x2BO9dI/Fxejzxq7UEB3CGDXSRTUd2gx6AYoox0elDHSUBl+F4w==
X-Gm-Gg: AYBFou16mEWvsoiaHxN5eOesEpJ7A+UPBCrZpERv94IlgguQuEio/gRrtD0QV+KuDVK
	LkB6i2j1UF7K/no83qHeuWDusdMwQybtfdo1QXcPotjXisbnmlB0XRcaf/vBC8HyKWmM8SPN202
	OFTNO1DnlOWq1VX9dWx5M1x3LYOe0QmadGGGI6wdmaPqAvUYJ6cw6GK3XujBs1IkUv7QezRrJJW
	Q5cFaOOPRi/s3PH50lhnm7Ey+DdQHE+yMX37Id0I1Nxdjn0ygJ+4QlRRscPLoQM9LhpxxSL3wua
	Jl+4AFLqXBy4xqZrCO1ESq7nzXFXQ/CBLIj4OFKPvP4UaAxrOcah6jwX8Y5/eNWSDpu9/ps8Ipv
	a7CFGSS6Q/RckyzldNj8/qdQXbL+QJenCmXC5ju8MdeP4R8YW2pl5bgV9yC7gRvO5BaZWpI93
X-Received: by 2002:a17:90b:3b4a:b0:3a4:adf9:5d38 with SMTP id 98e67ed59e1d1-3a89f674ce1mr3494816a91.4.1791442148504;
        Wed, 07 Oct 2026 23:49:08 -0700 (PDT)
X-Received: by 2002:a17:90b:3b4a:b0:3a4:adf9:5d38 with SMTP id 98e67ed59e1d1-3a89f674ce1mr3494804a91.4.1791442148021;
        Wed, 07 Oct 2026 23:49:08 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff8d5896sm2860608a91.12.2026.10.07.23.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 23:49:06 -0700 (PDT)
Message-ID: <2689b288-05fa-4a51-be5d-c65fdee22ea6@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 14:49:03 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: validate MAC/PHY capability count before
 saving
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20261003101944.596546-1-yaojiale02@163.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261003101944.596546-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAyNiBTYWx0ZWRfXzkV9EeoQYqPK
 TuWrX56u8+gypAZInAHrajJtNLYQJQWCweH7OnVgsuy/urp1uGCNTe2FFiJjdlY5uA7u1Va8xP7
 oCeK9OALfIsrtJu9yqKnjGHUswMf9hs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAyNiBTYWx0ZWRfX88Eds8m9wrDe
 zA21brW3Ym1dc9W/qx8ql2CMbHWQhIblopIF1z7HjvcD25nHNk9lPgFaYIhOg9Z9EPe85K60BA+
 P2cEPxA+A0C79XnzBHXmiT1heRkegylkrteM+EJ5M9ZbAQ6dJZxm0OoymDZT4fzCymOZGu4QyXc
 45oVGG1xyw6ZR46LQxXWJhkepl/dk+nqM2xaIoX/4211ajQGng9o6eCJu+Qp9oLmu2rQGzE2c3A
 f7CbmbInqeLHug1g673AfZQgfI3+xxqbze78DYXesqSu0qxaPon4NUMCfnS7P+3haDD1n9VnDIp
 2IaqTlk2K71DfiX9GaqdCT96N1R+1oJ6GcJ39BnYFNmxkj3tXCIInTq+0tt72Gh+RFCeUb6fjno
 L52ajERDlZRXBUh8635nca1tQvRmk+SqmswIFrIJtJDJIDULoa0LgnhFff1xBtcZu9kyHQtLBZ7
 KBFig3FT5WUfqQW5wDg==
X-Proofpoint-ORIG-GUID: hAr_-KwBvku9jNaP-v4O5b8Q2LAJU0Ml
X-Proofpoint-GUID: hAr_-KwBvku9jNaP-v4O5b8Q2LAJU0Ml
X-Authority-Analysis: v=2.4 cv=CIm/zhrD c=1 sm=1 tr=0 ts=6ac73ce5 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=CgAF95LDYrE-zO_MwBMA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080026



On 10/3/2026 6:19 PM, Jiale Yao wrote:
> Firmware supplies the hardware mode count and the PHY bitmap for each
> mode in the service-ready-ext event. ath12k_wmi_save_all_mac_phy_info()
> uses those bitmaps to populate svc_ext_info->mac_phy_info, but the
> destination is a fixed array of ATH12K_MAX_MAC_PHY_CAP elements.
> 
> If the total number of advertised PHY entries exceeds that limit, the
> loop writes beyond mac_phy_info and corrupts adjacent memory.
> 
> ath12k_wmi_mac_phy_caps_parse() allocates the source array for
> tot_phy_id entries and rejects excess capability TLVs. However, if the
> event contains fewer capability TLVs than advertised, the remaining
> allocated entries stay zeroed and are saved as invalid PHY information.
> 
> After parsing the MAC/PHY capability TLVs, validate the destination
> capacity and reject an incomplete capability list before saving any
> entries.
> 
> Fixes: 062ade23991e ("wifi: ath12k: parse and save hardware mode info from WMI_SERVICE_READY_EXT_EVENTID event for later use")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

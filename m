Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC073E9C32
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227599; cv=none; b=fPAJc54PyGrbVfbcFUBKI3WKNogZcKBmkn8JEHy0dZA/d6VzV73f9zrustvCP70ecXUWXsi0XXG9yGue0TD5JG1HKENUxwqedQ24P43BkGadS+A5QfkSjU6n62cO7j1O6mWnzDyEIzJSZ7tY6dnlC7XJQ+DycMMxg8/1sYMpKMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227599; c=relaxed/simple;
	bh=gC3rAUisz4qhWwbHtv3xSR51wQUzfyVCKvBE7uMLvlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFrv/m2l31ScBTfhcwPssLdJ8ffu48DZLZczVYhn6nWwixtXVnutiY2twVxMTudMDMzH+bgAF5/3UIo34kkP7YUw6pCA/LbI2U9/PLa8fPqJgj+PqkvPrmteOPUa3xZTFe8YGUD0tZRiC1Kx2UPrAijxopUSI/F01fUdZZI5+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oa5Zy7+V; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IrFLl+90; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oa5Zy7+V";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IrFLl+90"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6811q3FG585563
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 01:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MLB8BcqtseItV55bGvx+qIYw26TP76TQUsHtl0K/n/g=; b=oa5Zy7+VBd8W9e3S
	gR4t8pLDJ26qZWgtWUoJQg4p9U0ZxzeUpd+dZGjpWArYLnnuqgHjRSkTMqWHNvI7
	J0c9DoKgEBPAE+R0RtAjzg1TvnPCcpRpRyMmPi/evGR6oL23QEaRPao1NOzFK3E7
	aRI9eOLT5WA+I3TA1lAk3g0Ax8MfC71/8iZLxXxVc1UfSH9iU6Le5Wb3iESe6D4I
	sAQ4Goj4MeNNOycA7wCTY+Od4sXDqwKIs779dNlxIVvuf3mays58IFN6VxyzEYbZ
	jrPnb9i5+FhZKF9ZfSStCaVTjD/Hp8El5d037lv1gBewJuTDLpaEARVRjA6ETy/8
	9fyYDQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdndx802a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:52:42 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d932ef41c4so7373665ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788227561; x=1788832361; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MLB8BcqtseItV55bGvx+qIYw26TP76TQUsHtl0K/n/g=;
        b=IrFLl+90lR0YpmjPQrSIj5ffa27WZ+qIwWTq3UiwtRnqvawG7XmxcH+Tf+NC1+AxbD
         7/dh3d59GY4D4VzLXaV5rP2o7lQ8yjfvy1uaBcLrcuwZOrqV4IKejumbw/UoXOFKkyMs
         vTpOkUh9lJbGc3A+jY5i8PbOluhLPPePxrLGMRs8KPKKOdluQsNhNMlCLsbEojjktBKh
         Svd7DfX9UpBazEG5xtkC4m6NoTS/uX/rzOehK9h1pRGEYMa/3d46DALlNK0cP2uMArES
         VsmjlAOjDu5Mt+qdWe3zzlFKFDI6nFucB8a8eOwysscATy11z5CKiczQDw2uHrPLDUHY
         ln5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788227561; x=1788832361;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MLB8BcqtseItV55bGvx+qIYw26TP76TQUsHtl0K/n/g=;
        b=b7KcfSWUHu2E445B0CvwqItSyevoCaXmeWgvzxqfxWqhMcS1ks5khpQLOefZlULyfc
         /4DsOq8TXoYBkSNu0oaZAnOD++PIZGHBjk8JIg7cO2015Cu78LqIomjSwaDGmrKNHqx+
         XhA4kKbdqbcueW5bO7M7aCyuYq6AJCwS3IDGNTvVm7hnhKHP3Nt0P1GVUdnWhulfSsgq
         aI+TQrCgkeE61Z5stpoxrPiPJbNlyJiAvqEFiHwgYLC9ECngUT2iIcpwgCJSxGAksLur
         XitepYk1s6q3jdsUTewfKwNHb1ybYFw3eh3/8LNu2d3FTAUfXfGJPIwau0v2lq2m+Mos
         hERQ==
X-Gm-Message-State: AFuF++nmI2ZESU4zSPBvMCw3861gZHPJtp5ePkzICT6cmGGTzsjEiKw1
	ANiTZe7Mc5W/wfeYnaBsOm5mJ7lHJ7iaXfLtenXPlnhmSz+ai3ylRqTzFmIF9zNygnpo0SSfTre
	blzJjoJJsoQD/ekSQT2NkIUa0cT2KpY/+zuIpWsAIQ1rIxRwCKM/muHIwi2nTgUo9d5dFe6Zlsu
	hlfqen
X-Gm-Gg: AYBFou2TCQb6ZQZKfDOtk3jzJLN0fkcTAfC6Nr9FT5lbTtepkUmJ+wztlLclv8wZYN0
	sPQkKKcejKF5Q02CS/PzGLIFadth4Zjys2IbDYeUKVtXuMLHvtwG7tFNsTN1BI8KCdUTBM7vVe9
	qhLCjxXbls8iMGXzn5k2tHcR4+3H49dmb+kqffO/8VowNas2UI4BwYk8xxXJyZXi6H+q6uvjxsK
	Yc1jyKVRdEFzkyTTCBUDklcNaserblzHW1slD0rFdCRf5fyy6txgeUdWIVqxW2adgDeb0MdlZoR
	mSRnTkSBOhg+l//qyBR2UtpD6Bog8LnSe95mOGArxP4XpyWUCI7VCk/Ww1zguTXrmeFYqZpA2I3
	Bcw+dSsZN/2GOKDnqwYgl1gyH73mruw5aVfhPsChGf3yMm+NHNXfM+Fzx79ZD+vdUoboec7cH
X-Received: by 2002:a17:903:37d0:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2d9526d3436mr20524575ad.3.1788227561309;
        Mon, 31 Aug 2026 18:52:41 -0700 (PDT)
X-Received: by 2002:a17:903:37d0:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2d9526d3436mr20524255ad.3.1788227560883;
        Mon, 31 Aug 2026 18:52:40 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598bfa51sm42590745ad.78.2026.08.31.18.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 18:52:40 -0700 (PDT)
Message-ID: <5d6fab0d-e31d-4a81-a592-30ee1c6f295b@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 09:52:36 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: ath12k: support calibration-variant from
 device tree
To: Andrew LaMarche <andrewjlamarche@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson
 <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: DRfFtCKK80TPFX9vFRLllQm0972fcwuI
X-Proofpoint-ORIG-GUID: DRfFtCKK80TPFX9vFRLllQm0972fcwuI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDAxNCBTYWx0ZWRfX5rZVNJa2a+o1
 Vivkg0Y2n6J9edBncnKyJfBke3NCNbSzM63PF305aFhokUIMvXsySRCR4aGkU830fwp2WRZXOAp
 8fikrF+9xBTHxUteQsowMuWODrvjZqY=
X-Authority-Analysis: v=2.4 cv=U8eiy+ru c=1 sm=1 tr=0 ts=6a962fea cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=erCTOyO-HGHO-QmL5V4A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDAxNCBTYWx0ZWRfX2uADyNHMkRl8
 62Jh6CL45a4FkCiwT+L1uTLOPCsjvpymNeAEVlTUa970SNJFxXZnFo5A7Cwz4hpDY/Sk+CuUeRD
 vonlgv480klFHPZRm3LWoS9mNX8/wEMhEdE0JLlvYf666yO+XKX9YFTm+i8/CTilMhHDgt7i9Gk
 cu38KRxWsrnhV0suFvPFgxKjwQivlwECfzT1Fx5Irz0yTN7a86OEpgmb9Y+BadzFrKZCF3rrbAA
 0Tals3EkbsL+JTKPkuEwT1FPj/VvxlmcOcNzwbr5UC+LgJ+vm72s0fFdQkZbLAJXU3p4U2GhsUb
 ZA58hheFWKhQVaDwhCPzzCUIvnL5wS47NFy/caSNQyHdMGHfwKsVbsMWjwObOMj9gNgVbNIm4uI
 ijuIcj+DyeLJt9OMIP978fS5LMW5IdVoa6i/Eepc0la89ULrSp4iK4VrCKj+QXxbsomyv7S6PDe
 ORr/arirFvr6i2u3G1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010014



On 6/30/2026 9:30 PM, Andrew LaMarche wrote:
> ath10k and ath11k support reading calibration variants from the device
> tree to locate the correct Board Description File (BDF). The ath12k-wsi
> binding already describes using qcom,calibration-variant but it is not
> implemented in the driver.
> 
> Many ath12k designs expose all the radios under a single phy, each of
> which typically require a separate BDF. Without this, the radios may not
> come up or will not be calibrated correctly.
> 
> Fix this by parsing the device tree for the generation-agnostic
> qcom,calibration-variant. This allows the driver to properly select,
> read and apply the correct BDF.
> 
> Signed-off-by: Andrew LaMarche <andrewjlamarche@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

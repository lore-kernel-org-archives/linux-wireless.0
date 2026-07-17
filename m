Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A5233946
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253494; cv=none; b=ikYddUh7HdXE0OP6XsFxZERX2YsflWQYJaWC3EICcbTcmucruCX2wck9R02tmwYDPPBbMUAfRZFT7TscIU14ACz3cmnb7i7X13vl3z/H2JcBDWcLDp4640WoylcKNOZ9p/TQZl8b4Ibnzm1QVYpxBjGyaE7Wtnm068X3hBQ0piQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253494; c=relaxed/simple;
	bh=v86g7JOX7V3wq9EtD9arBH53JUyZgfW1S/mmdwXfHcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4TAGDDHfboyLo9q7aoZsFRAaytPvOKov1d/7SRa5rSdqcUrzCMpaogCKU9XLUtKdotnp4XiCFYbAG0Jqm0meAHeHiUp1AOSq+YgNV0b2JWBCk5tG17t7mM9KYWpGDVKt8ovW9Hn6o/Gpl80yxHznuhsTAGyJRpz2zfQyLKGtTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ofiaQ0b2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GApuuW6m; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ofiaQ0b2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GApuuW6m"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNIZ1V010484
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NfMjdix74msaRvIWwfm+9FyHwm1EorjtAesSIN9caMc=; b=ofiaQ0b23QEAtgjg
	ovVhtbb6ZHiidNLCobEzdpu9mftmD9sKTwJu7x+NSpJyiT2cePajCa7P3BGgZlFl
	6I/NWuEbWoKdDC0VnYvqVgoH7hGm/gIx8r/IBNpMrp9bqhRbK5gDNIT0wR/tzlKE
	isq2DbDUm0KLLfATdjP6mHUzfrzETXWGFHquq2G06a1vUL/4ULxfxeVYEDRyIOEr
	IvcA8bAM2a2jCFzuq1eGql0vyWEdnRhhXxv51vZnMYWmMwomLdmwWZX3dYotrUyp
	wosZ1+jCs2ZQh1jiF2xDtpKMjN4O7Wt7oQlCAYuJWdrPYKK9/04Q/m7DWZZfyqh9
	QtJ/IA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feuex43k7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:58:11 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf1c86963bso8035655ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784253491; x=1784858291; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NfMjdix74msaRvIWwfm+9FyHwm1EorjtAesSIN9caMc=;
        b=GApuuW6mptqv4Fb8E+iAxzzaVe2wRmgFYeeKNeRaEaVrQK85qUYCO5OKub/BPJPuvh
         afpM4puqQPeJn206DMBExJPv+StlbwJlr6he5HdpJZiwfYPdpC29Q0Z28LG5TZDZ36U5
         07iKLCtqZrTF28S1+M1Gr3ZRJiFDj+cxdvXt12h6eOjzx7WnP764V1QMtijU8xXYIita
         25HzP1zXzw/0N4XF8iZaXHvjA5Gp2ZUcPuHiXGl9Z+8sMWWbOmsmYND53FdFJoWLMApC
         ulunsJDQpncDjQ0x/wOx9IHp2g99IhEVicrMZkhByV3VcTYC4N/2V1TYX3Ej9xhaaZrP
         0y2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784253491; x=1784858291;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NfMjdix74msaRvIWwfm+9FyHwm1EorjtAesSIN9caMc=;
        b=cGs6P6O2wQ5dSIAPsCumPaY+i5eIrQS00FS+pVCTzYl9flBdZ/VUbMQ3aUKFxHfkUo
         A/tVpoPVl0ESQf0TeLBeDpeBCYOjGGrqQuleJQ1KroUJbFs/Y2RBz4I+wmd5UvCcISVS
         27835eCskKYe5nOHPVNf/+zNSd+8lVTo5ehSijgYfppNzpz4tO75ZVJoVDGJ+5Lg3TgZ
         W0Cvqz9tc9XGXtVLn7DRaPNmWm2JVx4Fu4MTEfFsVAfVXHXvFo8+9SN+1/Ib6nonF8hY
         ggJY7S6/XOSlvsb55Vu2QbVz5x8671iIDXBFHj1g3RgKMUx5pzgfC82uWsk4xLrOWiOb
         INTg==
X-Gm-Message-State: AOJu0YzALQNkC66YggYP8RhdNop53i9+/XSANu4W1cGbFAqqT0ubIm1s
	EQhLvCsbQBUG0r1gYntrYDQqfP9MvruPZs753Zct5vhUtgNSc9yTJcTrX5H+flFi0herNl0MhmM
	gK3KPtfmvoXy+E+UiUJrOCi/fDkTdjOFTjZ6gFI5ND3c8z914BPMqqHKg+VNRPngVBISM/Q==
X-Gm-Gg: AfdE7clIRgg0GeTIxQ5302pq4XvqKh7IpFRtLmwFN/qrOGUzoK642j2yjuhH104Z+Bq
	EqACVh6RGMyBGjbUjQfANl8gNzUKg5Gr3TBgPmzpa07lEe4U66KcEXpP2cym4uVkm/ehyTPzwFz
	Cs6yluPw/lk0yka0niGhHU+o6Dzanfcgu+Io6LDvtEHV7q+vPMBOA27CryqwwWeBtIamfN166N7
	saMndkUR/SOV0G0Y5Jh4E+//CPLngB6aaODq1VVBRPBGhkH9sh5KYWMNas2cjxly2uLHzAjEKDa
	nbBlur5nMWTUTSKx988yQhA8ay1uzosIMh3OR6YG4DqWoCbq5/IlSNIWqTE3HDMLODYJwWyrVVh
	hpu8tNN0+Dmf/ZGFJNhUDH4NVziMYtA9wiV6SNKX9DM/d18uVl8iseFnFWoHKRSvItSRhhnwG
X-Received: by 2002:a17:902:ea10:b0:2cc:ac15:ff4c with SMTP id d9443c01a7336-2cf1f29ea6amr57108255ad.8.1784253490749;
        Thu, 16 Jul 2026 18:58:10 -0700 (PDT)
X-Received: by 2002:a17:902:ea10:b0:2cc:ac15:ff4c with SMTP id d9443c01a7336-2cf1f29ea6amr57108085ad.8.1784253490323;
        Thu, 16 Jul 2026 18:58:10 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34713fe1sm1858275ad.55.2026.07.16.18.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 18:58:09 -0700 (PDT)
Message-ID: <f9f8d6db-067e-4680-81d7-391e18a6a36e@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 09:58:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Avoid buffer overread in
 ath12k_wmi_op_rx()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JeeMa0KV c=1 sm=1 tr=0 ts=6a598c33 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=ymRfW-ZP9UeHRcWsrQ4A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: 47ZJ6om1Q9VVaSsnkgHnTlG4cGiHLrfR
X-Proofpoint-GUID: 47ZJ6om1Q9VVaSsnkgHnTlG4cGiHLrfR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX6atVsgXbL1zt
 p/ZpVeSze5T66YBbq2nSf8CPaEpB5AzPR09dT1es2gOO89IQM9Ekb57NvrQDDxnAi8BfJErxWSj
 HHvcntxyxLpxlYTn6Ij9Tk8vmZTFHVA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX+UPa1ioAhdYb
 2uHzbSNXS/9P6/Ft5/YX8pBdEzO8n4NY7wriHdsJnN3dw/b7btpO0bx8JOFN71oSI9/NEHsF60v
 xeO1diOd4Q9sWo+IIBlAfTSVLQJheFi7HgU+nh5qFgfQ/2VlHpsJusWQTSdj0zo3DF8vN3fnjor
 guPg7YCLo5FDWYKM2EyTtDJ4AWLQ2BxXximfO14AxaKbgX2KmB9/tHfGBCKsoiKCU64yxeuedQq
 UCCwsLRjxWDrPBFE9ZNLNs8RSNsFYJWJGoaexqpp6DBYxO3CSZ/vwEVlrvVw5Lyv2UpLz2yRx5T
 CWgh9S35iY7U5JtYtDeq/HonRosYzb3gNnqUJ9/muVCZnzEQcmh4AK7BDey1CHv33TxHfwKXOCM
 WC2UGSaP+Ddk0jpvoXV54115/LyHyqtFplxg2YtnCs3SMOHi/j75NST4gmygt20gbQNstaxfmnW
 /obDgfG0lRwSy7t4pTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170015



On 7/17/2026 4:01 AM, Jeff Johnson wrote:
> Currently, in ath12k_wmi_op_rx(), the firmware buffer is read without
> first verifying that the buffer has enough data to hold a header. This
> could result in a buffer overread.
> 
> Update the logic to verify the buffer contains at least enough data to
> hold a wmi_cmd_hdr before reading from the buffer.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

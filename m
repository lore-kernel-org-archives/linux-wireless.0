Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A616130D402
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353730; cv=none; b=ryUHwrZg2eEVve7r9UbGHZOManBMYMtv3meKfgEItclhQTH1B7/lzShZEXB2KZpjBVzbvgEabwzz7TLaoLZcAQGWKYhHMXD/JeVhZnKEgpnLNsPNCQRDs231XtMEPGaXXg/VI3BrBY8HFCilL5T2nueBSd84f0WtWN7bicOb7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353730; c=relaxed/simple;
	bh=YDxkVBZMGmsXvV1aqKlZr7+5Q6ydFogJOLPOSGKqAtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WUqm2KWGYTejv9iLsjx9FQ0vo/LxATpzpwou5UT2X2HuHZva4QzIEzHj4HjRhY0eEvaS/0/dVKMt4t8aSM95TzEjWeCdu80Mr2XZv5Qbjqkzd0TTHSlMBH8l0B0VquNQm6djf+Nr63NZHTkLAn18qoO3BFO9W9Qg48gBslI0CVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DTDisqrp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WV5Exead; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DTDisqrp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WV5Exead"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E2efPQ2241406
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 02:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TwTEFykKDk3QzgeZ5LSS5wi+KEW9wopRBXAry/K6+G0=; b=DTDisqrppAE0EcKj
	hLfarKOD4tnZ+LDR4R/EP2pGFEiR8CS3Mo3BcsBzGYksKWmTRgU0QhAgtUifxyvI
	Hv0qK0lSVrt5Cl2JwpbncZUCg7GONQE57SLxcHu3Uog+ESouDf515WrrTIcldqUy
	LOxUsHOn4Og2Yn4y7xLTzj5WaCYMlTcUql3BefQ3T2YkWSVWaInhLO39HhpzBo/5
	ptcIfhZzI2sdkK5jie1+JutRo7EFG8pHMQTt8IzfK54bXisFMmJxzZnpozn5w0Mz
	g63GYJUu4VaczRe6g0+tRh0XPzqkJX1SvASCIC9XiRo8fyo54i89FN/sXYdMViXK
	fgGm7Q==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmywh4k0n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 02:42:08 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca8aee88725so4191484a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 19:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789353728; x=1789958528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TwTEFykKDk3QzgeZ5LSS5wi+KEW9wopRBXAry/K6+G0=;
        b=WV5Exead120T1neviIlY5ooHVwSYv8K2JPgt20n7ERuh6KHOR1eAC4E2ThS2AB6Z7O
         os37Qk5QbjnZZsM8L6zFL36Zddhc7kiJbwMWy1j+m2J6gVP4pD8q2mEkg4Xo88rhFxUb
         yMg2+UJ0Cx7g+CPKzHtfjKdlNKenFTcqr2ivpgKAQ89eJX+wA8sjgjxkrlqxpy+ImvBh
         7kjkNvloFZmevk/htqQlYSKL1X0s8BsHVAR/K7LRx4jxoB8ay/4Vc1bVqOmoVnl2CpY+
         fOkCLVyYsq8Onnd51t8CLLMMneDmMYxBKOmYyvMuowOP1SptqET6QIRc9uZtqmoeG4id
         wfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789353728; x=1789958528;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TwTEFykKDk3QzgeZ5LSS5wi+KEW9wopRBXAry/K6+G0=;
        b=sdTNriWOoRwLdIXz5nf97XX4FiQijfAkY3HXwOON3niuCXgeTsayHxN7bnF6x0E5IY
         HkH/g0Vt+duFwqU4Txhl2ewL2+KFmiiHuXsVZtIS6fE+zNbkPGGjgvdfOLWvnMXuqH2Z
         VynLEhR+xGXlpfcIok08aomNayX3HJr7Vc18Y1R6QNzEF6goVoilIgPEh5xDtDnGK0xO
         ZjO2wTcnD40hg/v2gZuGZO8s+ozq9zz6jaR7dpY/jqZSpxNOM4MiBSWzTJbECjLkTgfa
         w4Byd2+mxFSRUejS6sgb8crEPXICQ9wA6AFadxTyHKi9AsV22FOSwZ4ySi7k8iFh2qWu
         cqOQ==
X-Gm-Message-State: AFuF++mcunD7gW7ZlY5yHBvdeaM/qke7Bg61NHZBfCZ93gDAPgvOIm/h
	UxeQm3GMdwl6pAhy2WhxLEwvPPLlJ1Nkn9abYwd37Tf3E6qZlJ4GApBJP/Ix+0YfT1Vngeg74jK
	n5/MtlOKMpvTmuanED7TD6rvXYZU4s7nvct0pmfDDydVlGW64mJ77BOt08sJ6GSs6cdhtyQ==
X-Gm-Gg: AYBFou26MqEiQMjm4Irf0tA8RlcZypjxV0BZJ02rY9uTvejCQU2S133goITiOtqAOiT
	ciPB6UIGlVXqyijwD0tvtkhr+jcOGNI8wFrLvQjjmHc2p4H74hbxZ5plbbnGz6l7jMpNU++Xk8q
	vGtA55NaCAOgVlon6x8HjqEnDEpXMiW7EWY9dm9Y98NOI3qv+EGtxz0JbuP8AsKYkdGOgNiyH0j
	ZYeAPcoYDUJRGNEpYdCwLg7+xdrYjUJjfsXEIqcoOi3mPrZDIx/WK940RHhcRQ6miLPkCqPc43s
	KpK7lri54aT/ElfqtKubfFil98yd0fewR9+HSndGLtDIrz/OxRqq3t9Db8UXNvIwmKct3Bcx9KX
	6tc2xCWqaOJeKXv96xXtS6o1/MUlYJJxC8ONZR5F72Ml87wDVop9N30Ng5br9aB8+Wi/3Ss21
X-Received: by 2002:a17:90b:50cc:b0:38e:9eb2:9d43 with SMTP id 98e67ed59e1d1-39dec1c2074mr1721694a91.16.1789353728181;
        Sun, 13 Sep 2026 19:42:08 -0700 (PDT)
X-Received: by 2002:a17:90b:50cc:b0:38e:9eb2:9d43 with SMTP id 98e67ed59e1d1-39dec1c2074mr1721640a91.16.1789353727584;
        Sun, 13 Sep 2026 19:42:07 -0700 (PDT)
Received: from [10.133.33.62] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95713602sm18056503a91.11.2026.09.13.19.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 19:42:07 -0700 (PDT)
Message-ID: <395c7f5b-2f74-43f6-851e-ee5e779b4693@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 10:42:04 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v3] wifi: ath11k: reset ar->num_stations on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Eh81HYqW2k2pm7aL1SRbWj2VHrWIghWv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDAzNSBTYWx0ZWRfX/mhBcPk65aH5
 CY/vbXR4Yl5I6sgv70mHGowDoIFnAUVYsW7Tlh/3Bx4WjpLDWokuaoa01POsrru6531+SKwYiyH
 enxkf8oSYancW29UtuBxFUIAcLcj3rHknxkbvZWK3mENPE7MC4OO+mCQyfd13BZpYAFH9w0BXJi
 0tcQy6a2KAcMhETLwNRJpTXvL9W6f8F9XcWOn/MK9wpZNzAx7/pqMRfuVMnHJrldWki6mU6JATj
 n4UXSk1DT+cOhtb47qM/rQsp87yU0leph+L47piAKAGqSqM9zz4+PWXqnv3ceTwR6PtGQFFC0cj
 35nRv2oh47F76B5GVSADRgZt4rp2IFYVn2Y+Ifc7e04sVLSNXAExOc5RiASS6b+BIFwizVA8/QL
 7kZfK+zR9k4IQXZVczwLJw5wKjHB2SlrLLspNW1vD5LqASzDDeN8Z5W82PpwED+5ZJOf7kHyfZE
 30SSVn8NLZWRVMecTpg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDAzNSBTYWx0ZWRfXyyr0PDlYXnZZ
 79zSJzZFPKRmGLvsIH/ArBc79fdjhHeSKmLu6rLjryp3IcblyzDyDcQX9qEE3yTsDtFRoWurbbk
 lKFhYvWavlRWJ0U++yNBv6Mn3lECqJs=
X-Proofpoint-ORIG-GUID: Eh81HYqW2k2pm7aL1SRbWj2VHrWIghWv
X-Authority-Analysis: v=2.4 cv=PsUG/AM3 c=1 sm=1 tr=0 ts=6aa75f00 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=XDoMHiau_i5UK2d4cvIA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_01,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140035



On 8/12/2026 10:58 PM, Nicolas Escande wrote:
> When (multiple) hw restart occurs, we end up in a situation where we
> cannot accept new stations / mesh peers. This seems to be the
> 'num_stations' in 'struct ath11k' that did not get reset properly in
> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
> that did not get reset so let's clear it too.
> 
> This avoids problems like those:
> 
> 	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088115] Call trace:
> 	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
> 	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
> 	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
> 	[1248828.088127]  process_one_work+0x178/0x3c0
> 	[1248828.088130]  worker_thread+0x280/0x440
> 	[1248828.088133]  kthread+0xe0/0xf8
> 	[1248828.088137]  ret_from_fork+0x10/0x20
> 	[1248828.088141] ---[ end trace 0000000000000000 ]---
> 	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: xx:xx:xx:xx:xx:xx for VDEV: 1
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

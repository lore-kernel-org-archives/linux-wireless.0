Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8286369208
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340006; cv=none; b=MGdVaSCSs5XoIHkeHw0V75dSVGobNwIbulKiSY4NiPiI9PUkocQQIjp8XfjX21MTvpH7SYMFW8Jwco3P9zsDz55xXHyfCXU44jk1EZXYttcaMd5CTrasjJJ5j6prLat0dwIwD17NiBPzU7+84ImZ+YjzqS9GGIHMxjma5rLye2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340006; c=relaxed/simple;
	bh=I95kMCyV9MwaZ9nwqwxqaMwOirKgYxjCliwOkjye4hc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=H6i33FmFVbKw/xrtSw6KLdVeb/y5WeFtNjNm68rxZFHEQ47m0V0gca5Lig6BViFaer5q2hBCRu6Pt+3Blk9SCHLmzjFJ1w5Z7dV2pltme9fS2/OFXKfxlFHmmBqmUbShcHngZTv4evuVLazqT6EFU9AXWCWpfQHRORwRnt15WRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n36AyaTc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MDzH4Ind; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n36AyaTc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MDzH4Ind"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF37rs3343219
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FRVP823fAAcox/ry8BPkjj9sFCNNH0Nz4PJFbK8Qygo=; b=n36AyaTcz4Dhm7Cy
	tD2tanMgjSYKlZDyE96ofIRlwdFnl/pkbcrg3/s5dlemsd07neboUCORZZ6gXqq/
	pGN0Ucah4wtAW+zWjitr5mf0dt8fPMUZG7Xkt99dQqVuCzjpYNZoW7b8gRYHLlZM
	GBt2Vd4O0dH1mmOqtZDNblhyLMQ529GbrgkPaLhRYfuZY7yUIQCRroQMSPUTFGH9
	alsyL9zJw4RIIjZH+jcM3aGxLxQxSF84ODzuPc0coYVqVEndIYXlDR3QOkQ+wumU
	yT0eH3ZmovIJJnsx7pNMr4IYt8VfZCQRGoblz7rzAe2rvwDNV3Ki5A/kF+ANV6+Z
	6S5CfQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqh3ms4ga-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:44 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so23446235ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340004; x=1785944804; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FRVP823fAAcox/ry8BPkjj9sFCNNH0Nz4PJFbK8Qygo=;
        b=MDzH4IndimMAqwwxqXDFVimKujwh9FLt28+tbcPmXRWTi8JdGQhEkFOvK3MkvlAsD1
         6h/Te5NoWjoXwsr4jFQxBlHAn0ldoMQ+u6YU32FY6BB7yYmS4HoOcAgcmFIuMS4xYrOJ
         6h98dd/WU/Uoy6Ss7teUSOM9a0CNexxPk0m8JaCE5BRMxTeeJjwMCkC/AGVdZGhhO0V2
         cBlMB9lKMcZS+quRkczfcLnBAoHsRPCquLNMGpIk5j2XT2+aS+6GFf6MMPkDiyxxJPmi
         Wg9BYAOLq2mZuzQIQKvKzNYjzImBy8o9fpVyfYpc37BX+SAgmSFWKyz/uouJQrSmGI4V
         VWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340004; x=1785944804;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRVP823fAAcox/ry8BPkjj9sFCNNH0Nz4PJFbK8Qygo=;
        b=SH/3RXNHmnujGt+1FbKh3Qx7wjYlrLjHS/kCSG5jqGWy/6bYZsA+WXDL+JioV4pxxO
         d9+51rmoFVdn1nj1A5LoRrGITyMEoyZUIPqR5pzxZ8rA5bTTZxA8KIdNKzD0HDC4H8EI
         6maORs1s/unVm88EA9/Tx52DhaTzdVjb3Z26Y7Y2ESe9klhd53bP2QUuUDcgcRUNgDQf
         EhbWjsKa0GfXw2aNXb1MFNQfFDU0MLUFSM7E6AJDwYM9O7qU8YhsoMY4srMr2F+gMJXc
         pmcBqW82jEH+27/oU0o8OkhLd3M/GmysC4ytNaAVn7hza98dSyDSTIiK3yi6LKTkcH/o
         MAhw==
X-Forwarded-Encrypted: i=1; AHgh+Rp/bnqwxOqbOkv+7c1GWp+JjIkbpn1EGnzRlG+dFITcW+llwVmC2tML2xi8LeSM4rVBExW69Ej9gWlHnQlb/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEHW6C5V4GNv/n9V3GV0ThRs7u/pdIxEFSSzDE0tfvE5YYJFQW
	KuOK2KUgYlwsJkJ6MAI/yPBV9NJZ0+BkPm8GjNYeG6spAULGJbHnE9KL05Wk2iHrLeMGIEkHhWZ
	3y9/EcLlTkDaqDxeIL7N8ah2h8g7dewsHFBRth41CxepGkytZIAxfmtQpyyMbZHpWW4Mqmw==
X-Gm-Gg: AR+sD11bqn52ZQiSrq738Qcp/rPc3/442sjl7IiCmq1R6TCZ7jZvCNxiHuJDVSik7tS
	iz9TG+JrINIYzeJg914tS5lpYyk5KFcAaA1Qu4lThw+raJIQbhhk61zcWqWvXy5eiSLiabOlW+E
	md70nm7YhZlqjIxV2zVSpfMXUeLyxgHP202Kw5meUGiFgo+1+M6GzT+c1GleQgxa6GS4JxjgAvv
	dYd+b4F01G+X/VSRKlmiZnF40snlJgn/OJcnGCF92TGOTAqygzrJENukjZStYz5KBQ6EypW9ixP
	d4b9wxhc88aJso6OfDyWOtF4FiFNqrTifWTTa0DVatwKr9XI+tG263Zs+2ucb9LQd4pJethYBgG
	GQuugcgX74pNVymMnrNBh/4tn2kQYXarnMsokIDQNTkJgCyzVMs2U43E=
X-Received: by 2002:a17:903:1a8e:b0:2cf:b066:7de2 with SMTP id d9443c01a7336-2d015d46125mr85548065ad.22.1785340003671;
        Wed, 29 Jul 2026 08:46:43 -0700 (PDT)
X-Received: by 2002:a17:903:1a8e:b0:2cf:b066:7de2 with SMTP id d9443c01a7336-2d015d46125mr85547825ad.22.1785340003301;
        Wed, 29 Jul 2026 08:46:43 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:42 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
References: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: validate TLV length in
 process_tpc_stats()
Message-Id: <178534000184.2826154.4421935426388447838.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX8RH2X0rLQL/a
 VwSQtFBbN2uaSi+wVb5fF7QGCFMJTbisIq51/662KPJ2n/Kl6gpuordhOzACPOeeOK6YoFI+7rC
 5dIRfHQ10MfxJUZQfXcdA98gpnK2hvHz6+sJf9nTO9LwzbZh21nMqHpG0nP3jYC3zAP9cdMUFZZ
 IjjikfffQXw0aYwRg/eRlClUNjw9mYQ3mKg/HK9WibSW6UoYehHGUzg+QULi2lnBcVSth+z1Who
 A3Y5Q258fGGABw1zQPaTmSASzpbZuJNePdB7qWU2ZjCgpUM1YP0dzYBo+VVB7FNkP5u34AuLy+c
 0IquRRSXlnTz8PEdJz0fiCJko8yR7RGgVW0tK8BMywlbVchNFYqj3sx23ii55llyLOfUyhUPFBn
 ipxlI1xIVKtSl+3ZVL0ooccO2lr29ZLipFVqtrrbyvUJ1N9AXJYpARU4q9WLfb5NxjrC6JltbKu
 2J2jYGsMBv4qhvJi7Aw==
X-Authority-Analysis: v=2.4 cv=F49nsKhN c=1 sm=1 tr=0 ts=6a6a2064 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=oNZ9Jk2e8T8Wm7Im8qgA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: Zac-XHSIYc6KTPccdhY4fYqTNmsMjI5H
X-Proofpoint-ORIG-GUID: Zac-XHSIYc6KTPccdhY4fYqTNmsMjI5H
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX21C0V7e2jsR4
 MGMAjOyY1zKysLfS0LWAuJDPEPp3uo8Xr4GlT67DtdDHRMqf7QCsPeFpuTkNZuwnc8PkZt5qitQ
 OZ9AmbOSNAWAXZFvlyaP8cKRstf5Q60=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290126


On Sun, 26 Jul 2026 16:02:07 -0700, Jeff Johnson wrote:
> The outer skb->len guard only confirms the SKB is large enough
> to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
> field is never checked. Firmware advertising a TLV length shorter
> than sizeof(*fixed_param) causes reads of pdev_id and event_count
> beyond the declared TLV payload.
> 
> Add a check that the TLV length is at least sizeof(*fixed_param)
> before casting and dereferencing the pointer.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: validate TLV length in process_tpc_stats()
      commit: 8e415b8068480d51a057197ded974e2637e8c42b

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>


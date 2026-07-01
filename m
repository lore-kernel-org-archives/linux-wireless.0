Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DB43F4830
	for <linux-wireless@vger.kernel.org>; Wed,  1 Jul 2026 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904260; cv=none; b=M4hmV2cyID1B87g7y5TMcPzQJZcWLus3qI6xCeu/AzjOyhMr7JHAc78fUK9VJPKN+BzryD3QzmXM15hWgATuh5MbG23Y0g3k2uuJu2VDkWHnUuoZ66w7GdHmrYHzKk1YTOef5H7cCj4Q+2d4dNbULZiHo8kchiQo4iDn6Xx9Hnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904260; c=relaxed/simple;
	bh=se5+mIiql1qcAS/QA/QdhGoq3F488Nb59gImUNbQodE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHtc3ZF0zsoxC9URWl0aldEs+snVW4xlgzt+jF3TL13AZkBYiznHJJGRQr+xDItOfKE16hxHWk7XCv2uPoQPWXaK+3CH+L8YwniH/nrgZ2PqB5g5gc7QO0Oqc4AMEzknLAOZPI7sz7Vr8YzjzIVwrmfuAGNJg5UBlLfD2ng+8a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EiVY6z7c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OMgIx2ye; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EiVY6z7c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OMgIx2ye"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661A8cd7744397
	for <linux-wireless@vger.kernel.org>; Wed, 1 Jul 2026 11:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	n5nBOf/Ov1F+rraEj62zHawTRB/8BjMFTvGV2tnm9N4=; b=EiVY6z7c4AclhJxv
	IjydyH+Cf8APmGkuVaT66N2cKfurEuN4IifGkWx74mHARak9ukggNmPfdqugDsc/
	jbMa3p+k64vQkZ76ffbcdebzndLfIVYO0bnFRSykzIvsd8t+mQmKLWuAowNrWiIu
	o2kSM8Vs8TO+emdmY3tkXQEku/1WkpkUYKJCyoE+FVfZlzIur/hxrub8JBCNXlPj
	L3caq2QjgybbdwaC1QRAGosiePnSltCTrmJozbzWw3+EUbdZWH2ljPtchgjGssHm
	muLzoeFipStVoy+j7zPbClKblFd6XHlaLLivvkoVXLUWnGFBhw4wURAD0a7wHw0d
	a1wavg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f4x0th5cf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2026 11:10:56 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c298a1b20so372881cf.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2026 04:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782904256; x=1783509056; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n5nBOf/Ov1F+rraEj62zHawTRB/8BjMFTvGV2tnm9N4=;
        b=OMgIx2yeVmoanXkZMu4y2TRFXtiNcsxxb34vRbLjMEoeG1dZz0cs9O4ifzpKuNc3WG
         2BntP59iLZPS8tIba1xcmWO+s9oZGCzdHE9ZoGnfrRNxju7zKGqz+DCMLQVmae1SW/Xc
         0Mh+eoQm07ZKJwluvt4jMaLwp/lEUS9npUtpOQCU3YjMgUVDK3oA0S9wE2iHpnfMtcka
         bwBRdOlg28l0ZR6jz3pKoB0QME00FgoW+E0JOwJ2vzYzTp66palvQXZ2VJAXvUqkyrlF
         ZpUQFb7PQMtrkXK6QUM72fQ9HTxNv/GnF+EUgBd+1SVTVo3wlvWjbWMzZ5xKXOu9IgDH
         2v2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782904256; x=1783509056;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n5nBOf/Ov1F+rraEj62zHawTRB/8BjMFTvGV2tnm9N4=;
        b=h6DGekqUVsyk32ic8ntjy6XNLFkzObcLpl/i/wmKJVhYAQEZgW0CAdHHG7HIAlHB37
         y5MlV9FR41GPEfZ2WmzSdVZyJzwwqVsIrcrnKfNp0KxBDTpn6xN+/nILPoKI1mOQtdk7
         kUjpQnFPIM/YKQxXiEy91rELTRzxTRVwegZiAvB3pBy+DGV4ill1P0/YpTb8/re7yOxB
         Qqo032GdOzHCu057xeEtw4TV1VsVd34qZUP4KlzeYbZQEiBxAtd+amQf9q5fbLGBDjQ/
         O34XcPCeXaAso4wkubqxS2U3/gvi9w9lankGcY+QoCXdGP6cYtSFLnbkCxExK8w54Y7g
         UDXQ==
X-Forwarded-Encrypted: i=1; AFNElJ8n444DxecMvQ2eURg67O0lqjqU+agfGeDOqRT8tS6fR3IevWNWlLESd7h3NNmf92mzBi0gLaiWwSAyOsHEig==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQUcj3q1QY+zlttMmU0puS0+ik9dfMwz5ThAZaiva+XdPfPatf
	sCzlN912yoqwPB+Op660PfP88yRBMvkhzMjue4GN5DANiW0HFLRrG1nXAu/BGsMj2xxdwwq5UPU
	CAuZ2nBuhaPwA1Dk4Xa3vaN+or76qzOCg4X3ebJnBhyTxhSSqu5jlYGHOsqighMUA9TsHGw==
X-Gm-Gg: AfdE7clXfsLPHBNFVUYZ9dufuLf8SiiyZBTnI8+32K/4HZpFY8eppETrGFCEpFefxYN
	Et1D1c3EnozqJIDETLJBTeloLzg6U0QCgRxDLRZrLHX5M25CoS8ae6NTYkZPURABkhOScleWY3t
	kSjZOTOJHlIvmclRp9pi7eeLFv1p5FvNbguTS+iQRmJVwbBfcHV7XvwDEyMLGx+4fqrTprVkFtN
	s4iWbRZmVWCaeD5IPXbNEI6pPzG5J7DWx0TC2cT6vpaZnCYcKNUkNQabcEFQs44Wen+30mncPEV
	9B+xc9P9R4QQI+8wW3pSdDhHuhs+h6qHjxWdke6P4Q/dKnMVH7zTnqqPYeG2fKnwkWhe18rQqFL
	dCAdyWJ9v7ZG7XtDwY/PRfPfDup1rkJtaUAI=
X-Received: by 2002:a05:622a:164f:b0:51c:d16:b498 with SMTP id d75a77b69052e-51c26b4ff5cmr8481951cf.10.1782904256328;
        Wed, 01 Jul 2026 04:10:56 -0700 (PDT)
X-Received: by 2002:a05:622a:164f:b0:51c:d16:b498 with SMTP id d75a77b69052e-51c26b4ff5cmr8481381cf.10.1782904255890;
        Wed, 01 Jul 2026 04:10:55 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6987c3b5ba9sm2553522a12.7.2026.07.01.04.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 04:10:55 -0700 (PDT)
Message-ID: <392d38bd-8bc8-4567-a79c-dca7a1bb8e34@oss.qualcomm.com>
Date: Wed, 1 Jul 2026 13:10:50 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: qcom: scm: add missing IRQ_DOMAIN select to
 QCOM_SCM
To: Julian Braha <julianbraha@gmail.com>, andersson@kernel.org
Cc: sumit.garg@kernel.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, konradybcio@kernel.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        robin.clark@oss.qualcomm.com, sean@poorly.run,
        akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jesszhan0024@gmail.com, marijn.suijten@somainline.org,
        airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
        bod@kernel.org, mchehab@kernel.org, elder@kernel.org,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jjohnson@kernel.org,
        mathieu.poirier@linaro.org, trilokkumar.soni@oss.qualcomm.com,
        mukesh.ojha@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com,
        jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com,
        vignesh.viswanathan@oss.qualcomm.com,
        srinivas.kandagatla@oss.qualcomm.com,
        amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
        op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
        skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
        sumit.garg@oss.qualcomm.com, harshal.dev@oss.qualcomm.com
References: <20260701110344.1999068-1-julianbraha@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260701110344.1999068-1-julianbraha@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: nmKN26MIfQkmm8odsXyqlBVtBWbcQ-KC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDExNyBTYWx0ZWRfXykN2MknQ8g7Y
 HgcxkOGvAGhhBD/HxWruKIpFd9FdoHsov1jux/glY7VNKz+nDjDGJCdt6vRV424wqIhLQyUtIRn
 9cMbpxB8QLKw3X4QDmXC1jfeeDXj88Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDExNyBTYWx0ZWRfX/QoypIw7yk+b
 wpySNvFlWuT2KJ5dvo5ZhqR+EQPNFyGHn9Qxv+vWqttaTWxte7HjpGThIx+xKA7x+N6TYEkcaza
 rkm6qmO15T7VXKfG0vQ/SlssAbB2yaANgQftUXEIZtFrf93rJm3WUiLETl09BB/hCUGm6Q5x6EA
 mitL9BJ54BFtMy1mgUqQ2Yg22dAKtOL+MTNUYurxRpiCaM2D45DuA26TtG71Fs7b4Uworz1fNZS
 K4Lev7L/Q8fibwpMMOy9jhaEsJFS7L4q9WTu2u2MKLu6SU7Ku3jnFnl0XtpF1DHev9FJblvHHf3
 Rg79mJQUK8rGzpIQWJDEU7X0fVOT56D0PbInsItD34vlIvH9VAMui0wZOnYF0A8UrmDd/RSBUgT
 Ca/H84J/0YM1WutJOVx18fsufuz7Ypr6Q2aJ2r5MBTP58IAW38LzUsblrptVDE4db+rHsobIbO6
 mZvckOknqHGWL1DVNgQ==
X-Authority-Analysis: v=2.4 cv=T5+8ifKQ c=1 sm=1 tr=0 ts=6a44f5c0 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=46PZNAZc7cL1ucK_2EcA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: nmKN26MIfQkmm8odsXyqlBVtBWbcQ-KC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010117

On 7/1/26 1:03 PM, Julian Braha wrote:
> 'drivers/firmware/qcom/qcom_scm.c' calls 'irq_create_fwspec_mapping'
> so it will fail to compile if IRQ_DOMAIN is disabled:
> 
> drivers/firmware/qcom/qcom_scm.c: In function ‘qcom_scm_get_waitq_irq’:
>   drivers/firmware/qcom/qcom_scm.c:2512:16: error: implicit declaration
> of function ‘irq_create_fwspec_mapping’; did you mean
> ‘irq_create_of_mapping’? [-Wimplicit-function-declaration]
>    2512 |         return irq_create_fwspec_mapping(&fwspec);
>         |                ^~~~~~~~~~~~~~~~~~~~~~~~~
>         |                irq_create_of_mapping
> 
> A patch-set in review proposes making QCOM_SCM visible in the kconfig
> frontend, so let's ensure that it's safe for users to enable:
> https://lore.kernel.org/lkml/akS_6izxrhgK-I22@sumit-xelite/
> 
> Signed-off-by: Julian Braha <julianbraha@gmail.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

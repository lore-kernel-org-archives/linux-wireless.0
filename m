Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D783B3C18
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 03:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528155; cv=none; b=hh0YjRd30hrUVvq1YnlbzwwqaisGE5YM2EbmY7w2EAzA321V113he7wSic0iUou3dpWMHuqn3eqyXIbYDjbe9GCnJLt2a3mki6Ert+QZRpAQrtYpDX+DJwcGpT+YutHPPbA/3j446PAy7B3FRJT61ypf/p/EHsSs2VRFLhRS5k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528155; c=relaxed/simple;
	bh=yM62N2H1bOa/X/eOm9XfJAW2/IsPTDWnjWPkAJTwNSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QKsCfUrbG3TC1Yih8wlsQGHoo9psr/zuNdpA1D6cUCzWFZ7aJf46FiIXid9gLMy10+wFV9EMnJJfeYwSG8lO1MFkKPafKbNV1TNnlnq2ZW4wZpiymyAVtkGDZFm6teDXR86xEDFoJBo/y/QND61GvvdAeeGMLkggLKL1Z+KnGro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C2+SAIH3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IYgCtG97; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C2+SAIH3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IYgCtG97"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLZ1FD050905
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 03:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ag/Pmmtchq8t/DVKB8xq+CT8w46MUWWfnfZyBXqWQgw=; b=C2+SAIH3viTGtLwt
	anuftS1UbBrRY8f6gP9mjistQDrN/AsiOiQf3x41sBtkTrxkv2qkMlbOelS7+vFH
	IxyGug34Y/8nBg3B0mKx4XygsIaqK+JD22LiMRTr4Iy5BUaoywgK+ha9vuy514bj
	Yv09UMS81I5PGX+OFQalGYMrKhGXhHuKYqG+0r2uQCrnEHQWgGabyWsvjY/Q0Lao
	VN5Lj1mSx7kknMqcLPpKj1pebCw5TB3fCq4/rVDxP2uuD8c9A8X/6FqQ3xbfhJMO
	olYD8haiGPL22qeTSxSnAJ5yAO7Drp62KAgx0RiblKph5ca7GqEBIgHXjfIu+Iaj
	ZhKE/A==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gq9n62cv5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 03:09:12 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc2229450b4so4680243a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 20:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789528152; x=1790132952; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ag/Pmmtchq8t/DVKB8xq+CT8w46MUWWfnfZyBXqWQgw=;
        b=IYgCtG97oCtgCwa7XV+JVsxNC/SVkSZfYICs+eB8xSAoGbzIHsWLwTf44jDRZQpXSV
         vW/3w7r0iSIls7L7DvyVSv2+mq86/HVSVnGTzhF/9UdIN1XO/4ttOIMTC+5WZkan1T1r
         udpsWj4YWdgmIKBzy0vWpds8+cGrXnA8q8w/zVtKzh3d4iBLU31FkY45Y4WuOXwo9cYv
         nSfFLxFuK8Wz1a8Ekv6+1waxsKwQm0D6Ct4kmsOpQYJI05VHodh8intXVnXvfqyIs404
         Sfq9ck2MdnLPMHVA0kT1K0JmaC2QactnZv0ux5OYeE+B11i15fXqtnpzkydD+gKCvwai
         /W+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789528152; x=1790132952;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ag/Pmmtchq8t/DVKB8xq+CT8w46MUWWfnfZyBXqWQgw=;
        b=HuQhwCqQa20DxtBYCVq850wtE+xrAv4LRxhoKIMoGEBtCaRnpN+D4QsRyLSKRBd5Hg
         PDpkdMGyvd649PsDKUjSZk1dE6oK1wRlWx2YlKKZw14adNKgd4ohRvdASaXpZithdLBS
         xTfJYTUf40EH9LB9EfQJj5mfEoeVbAG6aZsFjzSsIjvCsD5nlCfbkY9kf109a6aBNr/u
         OqOMdMyYtaLd5gXuhZco11I+EUDY8VGpqoCqosGsm5zHdzi4hfAVJ6eLiVpoXmeovNCq
         lRk7zlz1pTW3ch9UUl+zj+Jub20BARBrWjxATvpevv7ESTXdw2GrWuNbCGIPCnEYHb66
         LDrg==
X-Forwarded-Encrypted: i=1; AKwUvBzetF0zQ7DtGOvHMHU0ZKnKSkyJ2XbTwRt0fDaRcc9QFTL/4ZzwHxvXj191ES/EXObn7v7pkhk9keVkcC6tgg==@vger.kernel.org
X-Gm-Message-State: AFuF++lf6YzKNncwsaWptmX9ilGH8ZMHqUe+rBhjMLWqW3J1v4tVQBhb
	3+y/ONjUCeu4JQ68IbH+N8k4UWHd8BhHjJmEA4GuyDwzoYps47pgInv6PMrY3BUlmeycwvTvENI
	ZVGf74UwpBE3sAIjkhQZoGE7OWaUduSEe4X+MvJB+eaT2GbA9mZtaG3mk8e5zQ8sKqKtZTQ==
X-Gm-Gg: AYBFou15GOO/G3ZIG9nUUPIISGF2+ueKwwjKGDxgY1fmsNU8RcA68IgQHF7SUCRr81V
	okeGQxiGb+6jyDVLBfH3527eZbYd77vbnEZqAnPrn+44gw7eiJC04ptajQkdoihOmTadrZ8JXKw
	wEz6VDtyA79Q9eF1nzqHVSLkwvEqGkA/tO4RjWySCgXYYfWUryerudi3/GE2BUd2/7h0jCkWexa
	aBxeaZJzXfMrkeFDi5WspQoMpAvkfrO/ANFO66jUkV8Z3Qb8GIGh4IBlCG6SKMXQpY3oX0P125U
	lkJcn183TpwBdBkTQ+H1YwA+5rwqMhR6hlR0GDmc4GeoNcOfEPV1dgU0nO/FplTxTSLcjdLstEB
	aoDyD42+Jasd/2WhoMNXBvyXyVdQttWLCjESntchhM7e3c5F+Q0vyNy/6LQ==
X-Received: by 2002:a17:90b:384c:b0:38e:9ef9:eb97 with SMTP id 98e67ed59e1d1-39e1e48a0c5mr2015600a91.16.1789528152089;
        Tue, 15 Sep 2026 20:09:12 -0700 (PDT)
X-Received: by 2002:a17:90b:384c:b0:38e:9ef9:eb97 with SMTP id 98e67ed59e1d1-39e1e48a0c5mr2015526a91.16.1789528151476;
        Tue, 15 Sep 2026 20:09:11 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5e40494sm3191996eec.15.2026.09.15.20.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 20:09:10 -0700 (PDT)
Message-ID: <6257c447-788d-4362-851e-0d552bcf7c56@oss.qualcomm.com>
Date: Tue, 15 Sep 2026 20:09:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: qrtr: resend HELLO on MHI resume
To: Vlastimil Babka <vbabka@suse.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Daniel J Blueman <daniel@quora.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Takashi Iwai <tiwai@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
References: <20260909055846.16539-1-daniel@quora.org>
 <hcr4woicsnz3pbhzlguuwjlego7yli3znhjmsx4cdz66xa74zd@wjtle2yslc4b>
 <c99d9feb-0a19-4f8d-915b-c2ece401e3fa@suse.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <c99d9feb-0a19-4f8d-915b-c2ece401e3fa@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BdVNQbt2 c=1 sm=1 tr=0 ts=6aaa0858 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=t9ty7G3lAAAA:8 a=EUspDBNiAAAA:8 a=_wE0MnXGkHm9nJMVzvUA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=CsAS6f0m0zARWR-uHzm3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA0MCBTYWx0ZWRfX7YFz37Zej6sa
 sBo7uW37MSnwaaza0KhnBvIJwIU8if4RYpLxFqs81fX58BcIGAYacN0JcQQSkYLL0/k+85eill/
 +bQAobHYNIZ3FSZ5rtsND6VH+w2UCIGb9vla8489kDPrBAsU3hN8oArrBFPY9cQuXVc8Cn8Vb71
 pW7ie4oZMTNf/2ncKca3vcePUgOiiDUIsEDLr1YmhF8i/t06ufxhaZ7/rVGarCsbACbRqA8EXZ/
 T3n797gc3vlxGQqUOu/XRMjT4VWNGWvVCbnZsf1RfOnNTQXxNihrkN3z8Y18aWPcYUl+A+Leib2
 V3nA0QsCfLzYlnGCHYkTQy7zLf7w8LzlieK1Jo2EXylFNse5WXlKShlFeasFslf5VPFbnnD4u6e
 w+Gi87+3W7MN2xn6xLNFIP6UTFeVbdcQEBnRMddtQlLFletaSXNoFVjOcmWjLzwWZvpPNZqpRXP
 WKYAlZSvknCzft4B0NQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA0MCBTYWx0ZWRfX8T0t6BnZ7mBS
 Pjxa1SE33kF75RGmxKTtxAQrvqoOk14Kb0iUQIbAIO3CdGejxM2pzp6xtVVMrKzyVAwT2FwXDOg
 laXXlqYNq76I64YHcyNYyDtm1vwzu0s=
X-Proofpoint-GUID: CCaxU-gESyzE_8-aBb9FhL9qiB4LH6Et
X-Proofpoint-ORIG-GUID: CCaxU-gESyzE_8-aBb9FhL9qiB4LH6Et
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160040

On 9/15/2026 3:48 AM, Vlastimil Babka wrote:
> On 9/11/26 12:44, Manivannan Sadhasivam wrote:
>> On Wed, Sep 09, 2026 at 01:58:44PM +0800, Daniel J Blueman wrote:
>>> Since the MHI HELLO exchange was relocated, it is sent only at device
>>> registration. During a suspend-resume cycle, the firmware in WiFi
>>> cards such as WCN7850 indefinitely waits for another HELLO,
>>> triggering:
>>>
>>>   ath12k_wifi7_pci 0004:01:00.0: timeout while waiting for restart complete
>>>   ath12k_wifi7_pci 0004:01:00.0: failed to resume core: -110
>>>
>>> Fix this by triggering the handshake from resume_early in the MHI
>>> transport.
>>>
>>> Validated on Qualcomm X1E-801800 on Lenovo Slim 7x across 10
>>> suspend-resume cycles.
>>>
>>> Fixes: 544d85de4dc2 ("net: qrtr: Send HELLO message on endpoint register")
>>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>>> ---
>>>  net/qrtr/af_qrtr.c | 13 +++++++++++++
>>>  net/qrtr/mhi.c     | 10 +++++++++-
>>>  net/qrtr/qrtr.h    |  2 ++
>>>  3 files changed, 24 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
>>> index 78347c937af7..2ffcfc2fdb4a 100644
>>> --- a/net/qrtr/af_qrtr.c
>>> +++ b/net/qrtr/af_qrtr.c
>>> @@ -623,6 +623,19 @@ static void qrtr_hello_work(struct work_struct *work)
>>>  	qrtr_port_put(ctrl);
>>>  }
>>>  
>>> +/* Trigger the HELLO handshake after the remote has been reset, eg on resume */
>>
>> Use proper kernel-doc please.
> 
> Please prioritize merging this sooner than later (it's a regression from
> 7.3-rc2 that would hit people if it made it to 7.3 final) even if it means
> fixing up non-critical aspects later, or by maintainer upon merging.

Concur. I recently fast-forwarded my ath tree and picked up the buggy commit,
so everyone using my tree is now affected.

And just want to point out that many of the function comments in this file do
not use kernel-doc format, so I would not consider that a blocker. But it also
would be trivial for the maintainer to add.

I've tested this on my HP ZBook 14 where I've replaced the OEM Wi-Fi adapter
with WCN7850...

Tested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

/jeff

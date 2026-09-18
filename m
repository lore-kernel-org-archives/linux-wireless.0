Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437E351812A
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755230; cv=none; b=fPrP5QK3nAGi+EvNvqF1m1VwNGYCsnNw3o8pKX3k95V2+7Ta+BSYU2e4+MgG5pfqGZDc9VGxZgxqQDpjD/t9wWrjd9kUB7tCJaEeezmI4XF6+BbNk9iT3iCTwx7/5vZxIn1aj52LA6ycPXkTvCR9EzGAfOZvjyrd/47N25oTF9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755230; c=relaxed/simple;
	bh=Dlx/PfGUh6GfEk2g3gR+hejrW0fiMomk39XMRrdIbOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qs6SmrV7CD6ykwIBOzhc1kt70WRsVUUDAteAhoYWsWkRto/OOh/uLGLtaPHNStJJulf/DgD3BLFCmfKTSa93cWe4SaKzeozFpMQX37aMNGoODlZBnXoisvCw15KjcOZWfeDRyuX/sy+q5ZEppu7rKRmEfHa023b+sqoDWCw0zmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QnSiSkrB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wgexgwh7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QnSiSkrB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wgexgwh7"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IGomnH1818085
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 18:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vlrqp6hzEyvS2JuXrzVg/2ASZasMwkiKMUs6oP7YPjU=; b=QnSiSkrBsQffLT2m
	/WdGxKrll1bdiyVF5lVP37RUWAP1kVlS37YajVydWd+bTWHY6SP/0NFwUhDO3ZtV
	6MySMjpuVY0RQ2x4J5kye9lloYTC3mXXc6vvo3X0jOSro38GWRDRcsh8RpdMQ7f8
	wrNG+VRzNNNH5fLuQleWYapmnEAalGWb1GK/KXXOiNBrfQ9hUzLprhbZlNR+IUmN
	TIO2uA3b5iLJHP+LR8RBcPKra+YAIWPs6LpaXgIOERPuhUUce1tQ5KVY7wvGd/l0
	lnnY6vzkGGO1jB4EYQShfL3YJvlnTT+FV0fDMJZsaCFrmL7ozjCRRNkiWO532YSX
	fBGxlQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gs2hva661-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 18:13:46 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so1778191a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 11:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789755226; x=1790360026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vlrqp6hzEyvS2JuXrzVg/2ASZasMwkiKMUs6oP7YPjU=;
        b=Wgexgwh7WkKWRuH7D17ZcmhrXNgbiv0LvH0P1w8kYgjSUf9bT1FEbVQ2plmylH5wHk
         5J/tptQpqwtf2lMi0bF5ZsAvIBRfHxHwgeeRSeoD2zjWGZ0Uya5FCWZDis81xbu6pARk
         wRWHob4NyBjtitcT4VnG4oVLoiXcd/2rOgG0mD6AjIdwoDeld9yW8PEI/JiBWRt5STH1
         Fb7aY23J6yO/5VPOBF/ibVHK5x2SFvqNohlVt59UWShqa0fLG1Q2X/oxRC7Nspm5dbrV
         D2aTy7x7Q4WOk4l9p4/nJtJ900kVP+w7R6ya5rsvp+DBpNdAoseg2BjEwzPCcaT6gWzB
         MaQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755226; x=1790360026;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vlrqp6hzEyvS2JuXrzVg/2ASZasMwkiKMUs6oP7YPjU=;
        b=xgiB5BiqWq+wrctkAULdZCGPceXtvkhmccjPEkHbj6XuWHPH2vnt/HzchVui1+UNw1
         nR6CreHdu+DOskf+qWzWhHnJyYterDXY30yavUqqftzlayWm6f2ubEgH3p3mgqn9Z66a
         AI2ZW342jWN+pNz71iWVwr+31HN82kugZYJ5blaYHNFJ4eaaZJnM3GyHyJQ3NlZ+jlRI
         6cKVlV/m2CMLBU+sURIIl9Si46YhmkKqJ2e4naGXBhWUKYDtnTFgVJ9QDtywZJkeMtDI
         eFB6tZXUW5EESzx+Wz9X0bEfcPdwyAomJ7TUIod8ursDPCR4IheL2YpPGrjOr3VAE5HJ
         QZZg==
X-Forwarded-Encrypted: i=1; AKwUvBzZ18i6m7ppyg6gYRHCDkZfBlL5Ynb5Z47T6/xms+5embRLAZ5zmVpmUPREoH33nq4VeyweaCCQ7751Eiwjfw==@vger.kernel.org
X-Gm-Message-State: AFuF++katE2WF4HF4VNJSsWfuDTpd65HnF+6wSXK8klC4hOjhmZp1XKf
	b4B7fMjxQuzmbHYzP14ja0+bB6Lc1yod/P8/kJeJ8110PKpgWvQwdsKYP4a3qpSjIUFk0KrQVRT
	Eghkcy1maYASkgiP5kt4ij8cQV+umrSOCbZb9iK/iguz3QetkGAzCBycfFTPqhNP4vThNSA==
X-Gm-Gg: AYBFou3yKlo35FhjCDarIRWBabptiYwK8EJcK1YGR36Y8kNFYqnQGKCvvp5wuIQCTcd
	RZ4PeAdpjXqhsdudtivqVWXZKHB8Y/+QsOIN6TKoUj4G3ctLZAu7oMQLBtnxupTDSwyNs6CC2sQ
	eqq0FsJPATEb+cJR+bSniDf3o/EtSiYXcA5Ot+oBVArtBBtcX6Xa1l+T3nk4vue5tubuoz2+KVc
	ybqm1xMrWpc1pbObivbJ9m/DJwlbt1gOuhDXbV0sV7ks/B9lXzg9yQFAcVnuIUV5alJS6GUZ+Ui
	70VCunyIp803FMbUpJkkmOg69lgdEfHSbz9iqzRwiJMIDfI4u1wwOg8QX/btoKelzbszsEOjDTn
	OBT1r8maRz8wOU+JWT9tA37zaWZKZLWIVXKWPfg/EqDd3p68mCuUdIE6mIQ==
X-Received: by 2002:a17:90b:134f:b0:39d:febe:7460 with SMTP id 98e67ed59e1d1-39e54d3651cmr7028575a91.22.1789755225602;
        Fri, 18 Sep 2026 11:13:45 -0700 (PDT)
X-Received: by 2002:a17:90b:134f:b0:39d:febe:7460 with SMTP id 98e67ed59e1d1-39e54d3651cmr7028536a91.22.1789755225051;
        Fri, 18 Sep 2026 11:13:45 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331433besm467963eec.16.2026.09.18.11.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 11:13:44 -0700 (PDT)
Message-ID: <4e0481c1-9288-42d4-94c9-e18da5cf8e5d@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 11:13:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
To: manivannan.sadhasivam@oss.qualcomm.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDI2MSBTYWx0ZWRfX9oEQa1K7yA5V
 neEC/P7P5SzuyUbOtleDSJdwKtkXUTuBscr41vU9hitu5DIr9vkFxOIpFXAXSJ9rDdhzAtjuqKr
 2ZnRIdaHJD8yH5S7BFpKRp+wRw9cCak=
X-Authority-Analysis: v=2.4 cv=IOWXmQvG c=1 sm=1 tr=0 ts=6aad7f5a cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=KAMPhC-K3bquQAzTacoA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI2MSBTYWx0ZWRfX/RWtjqBla1ug
 03nN+cPxUC/J5lwpkdqn9paIJBokbBcgSsQZ/jpC1S341H4wes2CSnD3cDFUi2h+vFaD/4DiE4u
 YQXoNAXjp5j8sPzatXUzKfHNwxVk1STloHQ0Uf1mqqVmGpc9XnzGxDe/hlEgkjP2gWhbskzb9GM
 wqaRl3l6iOjN6YT5MHunZiZC9RqAJYIdDbofHyhFVOQxTys0mRCitUME23fCUgTeDiNIoXH6pKA
 FxaD/e9l8kAiX97d2G2eoL2bAbouX3oUJ2t8vUBDHHecOY9OD9DRFZQp0axLciQN+w9lj+uxzIA
 ftYf2c/nBPXgGZoZsnSOCLgJB1u+k2JitVM0xAeOWWQWqOaCUpjgmuyHhFi+JIAAT+h3mxpJ9q3
 RtlH0tgR0kFaNSgg7qPmIEFHDqHiae9T3L1Ce3apwko8DRJEPV/14Tf2O1HSGkmtV6KapjEG+rP
 GjS//cOQrp0cEkN7jeA==
X-Proofpoint-ORIG-GUID: fBfxH5Ex79xlzmU72iBb7lIncpo7LItF
X-Proofpoint-GUID: fBfxH5Ex79xlzmU72iBb7lIncpo7LItF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180261

On 9/18/2026 9:28 AM, Manivannan Sadhasivam via B4 Relay wrote:
> Hi,
> 
> This series reworks the QRTR driver to add support for using identical MHI
> endpoint devices at the same time. Currently, QRTR driver has a limitation on
> using more than one identical MHI endpoint devices like QCS6490 or any Qcom
> Endpoint device making use of QRTR at the same time. Because of the fact that
> these devices will have the identical QRTR node id, they cannot be used at the
> same time, on the same host machine.
> 
> This limitation is a blocker for running upstream kernel on devices like Qcom
> based routers as they often have multiple identical WLAN Endpoint devices
> connected to the Router SoC.
> 
> This series supersedes the following 2 series from Juha:
> https://lore.kernel.org/all/20260915054207.2513877-1-juha-matti.tilli@iki.fi
> https://lore.kernel.org/all/20260915074135.2567411-1-juha-matti.tilli@iki.fi
> 
> Compared to the series from Juha, this series simplifies the multi-endpoint
> support by computing a unique node id for each MHI endpoint and uses it for the
> internal QRTR book keeping. This ensures that even if the MHI endpoint devices
> have same node ids, the host QRTR will always use a unique node id for each one
> of them.
> 
> More details can be found in the individual patches.
> 
> Testing
> =======
> 
> Juha tested this series on multi ath11k setup by backporting this series to
> 6.6.156 kernel. I'd appreciate a formal tested-by tag from Juha and other folks
> CCed to this series.
> 
> Merge Strategy
> ==============
> 
> Since both QRTR and ath drivers are falling under the networking tree, the whole
> series can be merged through netdev tree.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
> Manivannan Sadhasivam (4):
>       net: qrtr: Allow the host QRTR to assign a unique node id
>       net: qrtr: Assign unique node id for MHI endpoints
>       wifi: ath11k: Connect to the QMI server belonging to the device owned by this driver
>       wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver
> 
>  MAINTAINERS                           |  1 +
>  drivers/net/wireless/ath/ath11k/hif.h |  9 ++++++
>  drivers/net/wireless/ath/ath11k/pci.c |  9 ++++++
>  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++
>  drivers/net/wireless/ath/ath12k/hif.h |  9 ++++++
>  drivers/net/wireless/ath/ath12k/pci.c |  9 ++++++
>  drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++
>  include/net/qrtr.h                    | 21 ++++++++++++
>  net/qrtr/af_qrtr.c                    | 61 +++++++++++++++++++++++++++++++----
>  net/qrtr/mhi.c                        |  4 ++-
>  10 files changed, 136 insertions(+), 8 deletions(-)
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935

I see this is based upon v7.3-rc1 (current release tree).
This series doesn't cleanly apply on the net-next tree.

Are you planning on netdev taking this through current or next?

And an alternate merge strategy would be for netdev to take the first two
patches and then after wireless fast-forwards and ath fast-forwards, I could
take the last two though the ath tree.


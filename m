Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D93815F3
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136080; cv=none; b=OnGPeodRnc0N95aSCAJCb2TcP6XH5Qqq6NNIwNjrJlp+paAkm/YAwqUa/dRHbiLEg7T6k5hsU8pCPkUIG0CPhk+cmWFYjoMVIhx0xvm7hyU0+Z/a+q+ZrVVX5EZZGsS0q145wCV4nMHQ1tca9sYpeoN1efE36YQp17oocZ9+1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136080; c=relaxed/simple;
	bh=MlGbG2vJoibc3BOes0UgeUSrG4FAFETK3S5CtupQMog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPgnVOhOLr3Aektuwn5yuupb1qcaqFgVh53xgoFsiyFH762JMt+e68pNbIAdxHmZuQr1Eaw3h/Crm1yykznuwccYx4hvKrwQijuw/5TD6Sn9iJzA6fPfPjNQ70PLGeCxjIWo+0X4dfbIH5Z5FJu+OAP3ad1OS5SoZ65EnyxInEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nb95eT/L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LCl5jqKa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nb95eT/L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LCl5jqKa"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G6W6am2678060
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SlBMSIeWU/+ITFgK7ICbkSAiU1fGhd3/MLIRy2QttEw=; b=Nb95eT/L4SOCKzYY
	jTXtHv2GqrLqCHNY+iWjkc/JuO+aqU9GhjEbBfXJQoQlrahKDUegsAVnK8rYiiNZ
	ZT+u40hZQk/dxvem8O7ihDvTB0lkbUW0vJqZ4rEg7dnYEIscZTUBcRnUaIb/vmmr
	oM6ztH6z5Rg9kT3e8KqMNYzw4I/y3pzxYjdVcsCAaVCxE5GudC/+XJnp1lkypHNf
	2nxXDmh7OYHLTIZHAXwZ7q2SfTlAh5VYClYo7/YQHb5pp/zA/3YxdTI2Idb++BrI
	ORqCaqzRDSrQkqb7vVxGmc1yvkOj+kkDVgNJj+NZF1zEuHKxn2LDbmh9Rzl4OqyF
	w+vg2A==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb19tbbk0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:34:37 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510d0baf63so8663606eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 00:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792136077; x=1792740877; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SlBMSIeWU/+ITFgK7ICbkSAiU1fGhd3/MLIRy2QttEw=;
        b=LCl5jqKaqbrCVxtW5xOroGfl7UXmVp8n/D2cldutfuPJiZW6VPA2VflmHObOZMZzvd
         T/jxXZ+OfN5eiHcZgdb1+3pQ6mdCQFIksQifdeRrxLhoHUSEgosU0cqqKkBiEYGXchoN
         KaJp/8yioLshktLwXXuBgXuCfOpfKG2XAd/najplEp0CKj63qpx+lCFTgs+Mv6HS9P64
         b+JLDoWB4qfSrzTMxfgtdCBgpUlgALlaE9dvr5VpzC766byRCm62/k2JpQOiHZlAvxmB
         ExZL64k9XrQmw053Zt2ZiNcwKpeJoVY38SXhkJS5J6HNx/UBd5tx6hRPJA/Z5RNCIRaG
         1ChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792136077; x=1792740877;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SlBMSIeWU/+ITFgK7ICbkSAiU1fGhd3/MLIRy2QttEw=;
        b=AYdxwK4P3wBy2HfOtpQkiBnB88wOyJAEaDtEvmge5VBkmS3io6kxPOIbaMJXRebVyR
         cfrGPg5CbU0MKkGG7ZchIlZgsqzB1m95GjAfKBZ1zPmeDh6h5YwQG3nTIrD6137/2paU
         7MB/TkYLM4TDMDOpRVmCxZdjO5pvhyNdKw8M784uHwh9mx40ewY2Tq6pkMLHv8KL+lWH
         9AmOOXhIA0TButZQFw/l0ohzHyj60oFo4BlSC0JFaj1MfhNA4ACZ5xjt0qcvD0rFnvZk
         o4glBj00H3Wrwv1Jp/AGaU6ywG9q1NTvngWy80yxOXCiUeJYyksyON4ob0HM9F0+U8af
         4u7Q==
X-Gm-Message-State: AFq9FYKuqgtAqXTo71n3w+9UPIkaSRsqcMfZmops57Smnd9y0nLlM+6+
	LDhkQmbbHB9qh0NATtJ/6zj/EPeBMAp5vWvuZIIA6N/JhHh0FGYTjJodjIiRjolSc7bqx1QzpUh
	xjiq+IFAaoBN84ke/rLTdOrjITO080u079OIyO/l5EOldOV487mfH+nHYQ9yVvEefgLy0Iw==
X-Gm-Gg: AYBFou23aD1TB291EUXAr8JicluNYI16r+vQs3IJfgzRmVy/dkxbGvvlFz6sFNi9uBo
	Si5ftlb1PQxppqj+itojorx50+jGyZaEGmpNb4/dNc9mfSM8yWGTmrlvuvK8d7fZZp6qxYQS413
	agKhHOt2XfGQKvtZcAaNSx40Q0kUZ2MsgNnDU/Y9tCio7t4fQAT4HRviEm0xbyYrmeEia8iStzI
	jIk8HkB19l2Sgf0OPxkIxRsCmr6AKyONiceqhtzGDGyTFXALJEaPgu6fjVKHQ8Aae3/MoUlQ+mK
	mn4cis5jbY1hq0FxiGJMsifKms01MRLAfyY+oAqeRv6t509BvS71pkYeSDz1j4GViDWKZiVKy03
	qN6013/UznWRnqJ1IaWMyy5KH+sY3lHaujUpNXtYFpshbdzVHGA==
X-Received: by 2002:a05:701b:4505:10b0:143:2982:1043 with SMTP id a92af1059eb24-16a6169538fmr26989429c88.36.1792136076744;
        Fri, 16 Oct 2026 00:34:36 -0700 (PDT)
X-Received: by 2002:a05:701b:4505:10b0:143:2982:1043 with SMTP id a92af1059eb24-16a6169538fmr26989403c88.36.1792136076187;
        Fri, 16 Oct 2026 00:34:36 -0700 (PDT)
Received: from [10.235.81.133] ([223.181.200.222])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831919fdfesm3565412c88.7.2026.10.16.00.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 00:34:35 -0700 (PDT)
Message-ID: <b0f4fc0b-3c42-4fde-a4a6-9263695b0325@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 13:04:29 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-1-14baf913df94@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-1-14baf913df94@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: YLlOVTa8IJZC9un9WlN_c4hmt5V5K4J0
X-Proofpoint-ORIG-GUID: YLlOVTa8IJZC9un9WlN_c4hmt5V5K4J0
X-Authority-Analysis: v=2.4 cv=NqZE4MdJ c=1 sm=1 tr=0 ts=6ad1d38d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=mU9158tKupmGQ1871ypv3Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=iWoZ94pyu4gkirMMr4sA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX0lskOaaWTcvc
 +qhw07+SgRZMiiwfhFuvheq2+YDtojZ00eavoU3GbH4Qh3zDDIp6cocRSSQs7BTdwa0JQxNcYE0
 WFqm0Rk7o5G4A4PItB6iS8MMbUS3Ra2qTXfPfM6XFrya+xp2N7rs4uaGkKdjZHRLhta2oQ8C0lA
 QgsgXKZwEVm9AjwbnSzv8xlP25Y23JRNFaeKzyDePmrPY5X90LpWMD7ywoaaG/80GEXx6B3LSAm
 DuQOm8PwWfgn3FETMJOs3HRGACCwcnJ6H0mFWmGPWBz6vOxwn4HcKlwk1c/PHADqqzu7fzgPMKr
 W049kjo1YeYr+ejKW77//hNNoeVRtMRKsHlIhGTkbPUgKGOjPBU6gdXfHdyEkTmNKMIY4BuuDzm
 iFqga26RJSy38YdP63J7kgXdAojFeYBj4dQPfki/WF6UJ3Cj9B+InpzOZB7Tc3QDrT9+U0NhTKA
 FlhpOv8QeHBbAhP0cAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX5Z4r0FTvkGTS
 YCmHLLJ2RP749p5k/PQZYZHHsJ8Z5/C0thVwMI6ZIJ4kLpgGk6rRlbkCn+pvrooIxs2hVIFBUpR
 Wtafxt57YgM+OkP+slwPurTM7C5A2lE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160029


On 25-09-2026 17:56, Kang Yang wrote:
> Recovery monitoring runs on workqueue_aux, which is also
> used by SDIO RX dispatch and WMI SERVICE_READY handling.
>
> A single firmware crash may generate multiple recovery
> triggers. Recovery detection currently handles each one by
> waiting for recovery completion on workqueue_aux. On SDIO,
> this blocks the same workqueue needed to deliver recovery
> traffic, preventing recovery from completing.
>
> As a result, otherwise recoverable firmware crashes fail
> with:
>    ctl_resp never came in (-110)
>
> Treat duplicate recovery triggers as part of a single
> recovery attempt by gating recovery startup in
> ath10k_core_start_recovery() with an atomic_cmpxchg() on
> pending_recovery, and by making the monitor path check the
> elapsed time since the attempt started instead of blocking
> on a completion.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Since the issue is described from SDIO point-of-view, it makes sense to add
SDIO hardware details as well in the Tested-on tag?

Vasanth


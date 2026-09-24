Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31404420889
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233574; cv=none; b=IY4ZyJaJTsLrXAIyEvvym/vJCUplsV8/zPAajGXnDXEqaVSjT2HmFrZqEuYCjdbtX/+NQxtH7eK0cw1kTfxkwbsuXJRf03miCyupo144qzDO5kk41unq1i3M+duVffY5JtRIpyoixtZgx5EiGZu+dAtTjy0o1q+J0QJjko9iCfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233574; c=relaxed/simple;
	bh=P1iXJHdrn8Lv0iiFX6u9vbYnDh3OmEmxI89RdwYsHAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cwKDz/xgerGeVEtSSr/XaiC/Lm2+GPFUe2ERyu40i8ILlamZM6w0cZ78COkEzD3aLcdyuiZzz3BLBg7KY8FDQg8WicS4NhmBWDgN0Fae64z4VEbsR+pqvwr5yf8KfNGfWspVAVpmk8cNUtf4AxVB2bB+qR9HZu+oKCs37R0k0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n2pTe5wG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lu2u2Aux; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n2pTe5wG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lu2u2Aux"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eBBN1531717
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o4nn7rL8dapC4UOGT/5eGQcnexT8dmi9oUpt/Cv5W90=; b=n2pTe5wG6b5/PwU4
	sFoJkc/YmHGTBSQf6wwRjV0p7bCtknjK0W0sbtUxeMy1XGPxwveVrkO2SmIB11OE
	Ej4HpzXwEoMaTMUqXAWKVUfSkSVJsYNpeLVns+cFLkVpeCka87f6t8Pi9iZ7vDwf
	GBig9qT0FpwzScDG+jt/AV5Fy+MGVODar8qDhEn+4hHLWnaPjSWJ1oJ2iyzIzbDc
	ZO88wYEEpT92UiuYEkHvbkAYQWYwtbKYP1MkRap5dsn6NT7uSrPGU6huUPQJK8TZ
	fO5dmv+XTYVPewCQBpy2TKs61OLWrHAHiB7aS2QArdR6Hra5b+1Cetzv/8meBX1E
	4qcwng==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgs60b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:06:08 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-331b2ec616fso1429646eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 00:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790233567; x=1790838367; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o4nn7rL8dapC4UOGT/5eGQcnexT8dmi9oUpt/Cv5W90=;
        b=Lu2u2Auxl8pQK2+tLzjt70cxqOKqulzQvtkSMsZV2e/Ol+ae2rL+Hhc/h+431QgFVT
         1BXnq73rKJmXZdJWxBg+xE0d7aVcboJ3Vw7KSdmuioLGFfXwGShFjLdEnkHVIpajunzq
         tTqAeXqpzfzX+j0vxdOczUtvkdZUkX4JdmioYQTbr/3A0DcCQCAnYCvd8hyCHQDxrKi0
         7ghQigLPX3Jwg7K6idlKm5x3Ak6FtSCft1mU5v6lXvYoxdDmxcCysXN8CEHN5WmnlhRo
         Yv/HBqKByXW7lb6nnFePRqpxY2bz2CsSBZ4KuaHkeKPgBGADoifl5bEx3zD+I7giDcBm
         dvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790233567; x=1790838367;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o4nn7rL8dapC4UOGT/5eGQcnexT8dmi9oUpt/Cv5W90=;
        b=Gskzzi/2jRp45PMjGsupo9EZRnAXRn/gRY1s3NGmy20elbBnq/HfcSm9vUfnNCLcu6
         da2tUMp7nd78PcK1wRsb0Pgu7Vlz0J5BQETDYxBPwF/CkDBvPYVia875PJjG6IDS2M0s
         5h+ErHl2sQaUIIR7wULT6BE3lS0YniL6pDqJwYkwHMM9kEhDjbWqg0q5ZwW+ymGJ9+fL
         EFpNeyZ6SZMU/n3oRppPjpi3mL3Hel3dXpq4HBvHbUW7V146k9kcPLEHJirdUnXVNw1s
         PnjYtH9+0wyjuEXX+2rZ22g966lJS0VZGKjPNtKNtX4T0OsFMpGT9o8bETqr2Z/cWTRX
         zb8A==
X-Gm-Message-State: AFuF++l29DaVX1X1oCa4OJPuqyUMqZW4KLDXSzERAwx2eMKit8EwQsVP
	JxEhO3HXjvh5aPy5Qeuo5j7wvX3Tit6RvL99yLLW1SQoAUeO4ufrg5Tkrkrf8jFLZ3bgIOD8kOk
	4vfs4OMIQIudegCLzYNw9hChQG0Akb1+na7dhChyJG4oAxjq4f4vUR3mAcfvW0CfPhARVWQ==
X-Gm-Gg: AYBFou1Vai789NGVeSSUEb2JWbWQ/KjtfUlPhCS11qILm+sZDayjb1Hg9mj6PXCj/UF
	WTdi/319Wrw0N7P31SOq1mQ49wg/lTdvbQGCRGI/AOrJZpZPmbInxC5T0oixhGP7nqdPiTqccTo
	G2YnNGZc5LrzxI1tghhYG5MfrfozuhAr1Q6vtLHoeQS5u9BpGo9hpjhXUnmR9O0K7FVl5V04NNN
	abgNcssIBLhXK8rUtaBXMTxEfrdLYYKMPVSyoSapUcFvvWFH7L5BLWkwYwHmzrEtWqlLEW1cJhP
	UB+0cPdT8HzGCrOFzQiADIe+6JUiHbsjmPnf1nfTquRBCITTT79En8ZZZ1fX7+hJLVnWVjTxehB
	ruPxTKxWsCaqwCRnwfN8kLct7zgJo30Ro6A==
X-Received: by 2002:a05:7301:7189:b0:33b:de13:9574 with SMTP id 5a478bee46e88-340034bb5f2mr1189884eec.19.1790233567290;
        Thu, 24 Sep 2026 00:06:07 -0700 (PDT)
X-Received: by 2002:a05:7301:7189:b0:33b:de13:9574 with SMTP id 5a478bee46e88-340034bb5f2mr1189702eec.19.1790233561971;
        Thu, 24 Sep 2026 00:06:01 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e9684d643sm23791376eec.18.2026.09.24.00.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 00:06:01 -0700 (PDT)
Message-ID: <66e6b21e-843a-44ca-bf77-30441a80510e@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 12:35:57 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
To: Johannes Berg <johannes@sipsolutions.net>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
 <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
 <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
 <ee25d1c927d4a618384eb05a210b0f9b2147d055.camel@sipsolutions.net>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <ee25d1c927d4a618384eb05a210b0f9b2147d055.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab4cbe0 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=4E4ZdRUUPFxwFNmS2ZwA:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: V-k5ROHFRaqH6abMuVd1TjdaK2T8p59_
X-Proofpoint-GUID: V-k5ROHFRaqH6abMuVd1TjdaK2T8p59_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfX1dWCzjdgrX1Q
 aDFXfmG5PbEIv2+1y6CqSSVER9mQcRXds5OIBR+kIMfsN04CcirJ0SjC+3J/qw4+rO3ZGdWaQ4B
 hxyYyCXRaxTD/pPN503KvMnF+BryDXg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfX53vJG+M9r0wp
 QFOXgLakVdzgzAPPsS7cFDJYKwn5CY4NFfl0KDB1UZzNM2xypOOp9iBSpYk+TxWvL/bA4289618
 YWR15T6j1ofj7pWoFR8WSAhWxfiV8zjUD5wwXwoHEBj/DHy/2wwXIRPY34G5uXc7LnQsQK6Sk1y
 bgn+z+k1nZz/18NLDe2HMbHpwC6LappddejxbMZseO88z8HkiY+R86V8X1Z7vFtzYEnOtj6qIzm
 9z8xcWR1I0xkesWbzqOdpZRrSHCRLu1Fh7HfkL3VBGTfpnayQGpkxEuWgQQPXZlxE7iPR3BZ8zT
 sSbU8w+xWjuGek/4+bMSwUM401CoXKONigIO5ci/R9ddrEBeOb6ZyXCdFsLzM20TcACNxM285XJ
 DO4CgNFp75laMWSJEiST0u7Cl+wWlm9mDtX+Efb6eDgdyYMsNJlddgOfX6qmZZCv8U5pweejV2a
 44VGSQQwygD3ohaxJ1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240030



On 9/22/2026 4:21 PM, Johannes Berg wrote:
> On Tue, 2026-09-22 at 16:12 +0530, Aaradhana Sahu wrote:
>>
>> Since all these parameters (beacon interval, DTIM period, CTS protection,
>> short preamble, and short slot time) are already populated in sta_info and
>> are visible through the iw station dump command, I only made changes for the
>> AP_VLAN case, where these values are currently reported incorrectly.
> 
> Fair, but I suspect that they were really only there for 'iw link'?
> 
>> I am not sure whether any third-party userspace application relies on these values
>> apart from iw. If we remove these parameters from the AP-side station information,
>> the iw station dump output will also change. Would that be acceptable?
> 
> I don't see why not, if nothing relies on it.
> 
> johannes

Thanks. One clarification regarding the proposed removal: sta_set_sinfo() is common to
both AP and STA interfaces, and NL80211_STA_INFO_BSS_PARAM is also reported for the STA-side
station dump, where these parameters describe the BSS the station is associated with.

Would it be reasonable to remove NL80211_STA_INFO_BSS_PARAM only from the AP-side station
information, including AP_VLAN, while retaining it for the STA side?

If so, I can simplify the change accordingly and avoid adding the AP_VLAN-specific
BSS configuration lookup.

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCF03D47B4
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123591; cv=none; b=bvbFdpyMtT2v47ESHo/EdslQCMfxZyqlyLNUc3Vol+nPzswCNtged3I6O3TEWOBLTqqPXdaED1SZajje4VKvdEFnP9zBqg+5/XK3EP0nApdi4AK9sJDxeqoOS5VCtM65w2dHxDvzv9Ho+NKun60MX9hFMw59MnScdQN7KWCu1DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123591; c=relaxed/simple;
	bh=a5lNvKRq/j8Qy0V+kwdWXsaCRZOY5JGOPs6Tc7NI2ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3W9m0iMys4IZq1f6ap6/j4DIJWSRXBeT29ara5FMnpr6T1kDh84iZD15saY9NX8zre4MoHVVn1ZG84UD1BQU0cCRgMVJX0zDKW1f4z9/UV0J1cZ+N5XkuxtBfjiI8eDiLurdhUylPdf3Tc5RksY1Q9hiaUaPJhneTncitDN5sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IviZOpR9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Idy8Gsh1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IviZOpR9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Idy8Gsh1"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6Yt0P026349
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/0BkrDQRvYNkd85vnAOabUT6kq+vJI+njfJTS3E1pmM=; b=IviZOpR9mz+FNMkK
	WW351BavAkzm99G+ja8jp9H+WIKbtAnhtQswwqRBn648gho91WNWGWkaHcLxzNl2
	szCyT/BpmPCrqS97XYF4Ka3G91QcZlRqatNnhxF1ApuzsAKXN5QJRkQDqxqm4Wp4
	G3nH0u0JrY3p3M2zIybOt5HUpIJMm9O7pjEhgDxhKv1qhffyF/j0golHrwO5A+MW
	Ay3/w43Q+49gJQPc2n09EP2ha1Jqgol15pzE/zy2kzS7DlYzomrle5FKSQT2O9DE
	WWFPkAocUdQqDwjWeQI+Z1J8aC+0k9CI7458JSCce22WI3G9u52FHbf3BXjMtjCx
	PXzdYA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfpsugd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:09 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbedfa3898aso732151a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 00:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787123588; x=1787728388; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/0BkrDQRvYNkd85vnAOabUT6kq+vJI+njfJTS3E1pmM=;
        b=Idy8Gsh1iKoysTZ8novNASSpujGE7vzjefmYCyP+mLqr4waVaV4m6Ipy9lBpOj3E66
         B3NHwnr1jbPwkn1cJD0nKEEsuSIxXqGTfGuf9pgGDF4ezmQlA5iGITFa51PKju1EPFhw
         imVxOA2xOPnxtULspdzkvDO+vp89ahRfswdkMimMj9Vt9uSdj4qz4jc45fDeygkKTGEl
         vyuj+PYEAZLd6I5Qpd72tJQwpWGXF/Dd3F8gHKNDkOzoTY2ob2Jq2lMODY35gGW9kG5p
         E4KTA4A9wHmPl1jyAWXUbztFK/mjvgH4O2vM9rjmeoEdQL9VBQBdzPp5k8DgetdPj/x9
         iiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123588; x=1787728388;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/0BkrDQRvYNkd85vnAOabUT6kq+vJI+njfJTS3E1pmM=;
        b=LIK1ijzHIFcOSe1Q/ug1UX7TKXkWzW6qAdt7oY62iTS4j1NI+wAOgVLpF63Fwdwbbc
         pLKlpK45Yj5BlVliTEY38WNFEIoYEoScH2r30gg5kMcjri7JWLqKr9u+OOf4nQ6mBt6f
         HLOUH+uNyJVPjOaAH1El6zCvgnRxDunoaLvSLkPInlnw9uW8q2JyxxbSt50HrY2I+q8D
         inEGdPofUWpr4CGjD1CXRHEIxwVeZqMsnBnTb0QZV1DFBfuoYWzLxZJh4P1eEgsSy+XN
         efJ1E6Xn2x+Q7s9Kkr8LHFH744KAcd6V5bulQXhX//IAuBCEfNfoOrGH/LhkTXpuOZtD
         9tjg==
X-Gm-Message-State: AOJu0YzDQVBA9KmBtuhD8e/SEt+WeMlKR2YSlJUwk43EGrwGW/rQrUtQ
	tk3NuPk+uoSfg4HUF8faLYapCSZivvQnYY1asNYdby+oRX++8Ud3c9qJr7nUnp+uR0/PErpI0yL
	IFqMVUc84CD+3GSTDEv7qNNJbJetyNk0fxCwBTXy9fVc7u6krI2AmbF7P8aPwjq6UA8oa8Qd0wk
	3l7A==
X-Gm-Gg: AR+sD13UxWKNK8jJ4XU3ADzXKEddEQySekv6WJATT49kvQh9EzQqRNEMo0J8gqkmaXB
	npg5my7x8kuHNZMu+DjsezVZhrqm5wM7E9u37IU/Qd1WQEIXb8sdZM322mzGj6AiSax0GoxrLeG
	vL0OvxL2EqbNi+gDY3iGX+eJN1PY0/6HT5FZMu1RsXlQgVlkYekmEJVASQ/efhWazF8eBsnRDqL
	ChREU9ideGzV/mCnfnG7zWXc9wdUrLgjcjffrApUQt8mQFIpBRZkDCELgPGxH9tWCFPiBkgfLko
	VUX9Fio8pfeLWK1F+QNgoWY/sUbRl0mbf9cnTL4f7AeXyKR/YqeFI8m0UOsqbuiLb8B5DWkCPpa
	L8o22h2Yar7BDcO9GX4uoKBa7ssr0i+L8/BHbqtXS
X-Received: by 2002:a05:6a21:9182:b0:3c3:b57b:645e with SMTP id adf61e73a8af0-3cd00df4c1emr6056724637.5.1787123588570;
        Wed, 19 Aug 2026 00:13:08 -0700 (PDT)
X-Received: by 2002:a05:6a21:9182:b0:3c3:b57b:645e with SMTP id adf61e73a8af0-3cd00df4c1emr6056662637.5.1787123588141;
        Wed, 19 Aug 2026 00:13:08 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf143775sm4277493eec.23.2026.08.19.00.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 00:13:07 -0700 (PDT)
Message-ID: <b2d7dfcd-e66e-467e-a4ee-fcf7bb8ce27d@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 12:43:01 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: kGsqYC1YDPj0LlGiqaOVInnvqVWHHo7y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfX7/DqkHT6JaOu
 ZPvDmjX8G1bFs1xWUNwwq0+OT1fdyOvC7SGV32V2pm0biJ0gW69igZ3ROfmjyasRta/eJAQ/BR3
 xGUWS/dX9An0qCVofYDjMtXLPoxhf7ySUFTNDVT1XMQ5fR7FTLJUFaSHexBxhd8QRXW7FhYXeKU
 nXMoSu8cUVh5Xv4Lpb2NGG8aGI9YT/VY//rQdwB1gemsUGFG3ZDdmDDOL1wQBD/vWZxSFkCHCcb
 t6HVHxtQx2/Y2xsAmtDZQc2q+q2j8BKTeV/sUUaJCmyC7I2olxkjHEx9X1rB7jz+H8xsHAxTwBK
 azSWRY0kPu4RzC9q5hUcNeG912fHneH3RycvjN45a5kWrW7zCooEu4LJzLUuGcql6QI022bGSr2
 OhkWzqGGd35Kt23CUh8inYfcJ6uz9BzEfRZI7oD9mtVqllZG4FlyhMz5N7M/zm3CZyv/JDUyO3b
 mddreZ1zzOpl7ySoMww==
X-Authority-Analysis: v=2.4 cv=aMrAb79m c=1 sm=1 tr=0 ts=6a855785 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=pkw8S468fx6YIQHryOEA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: kGsqYC1YDPj0LlGiqaOVInnvqVWHHo7y
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfX1wZamryjxKHR
 lc7w8jkww0TTe+Wgf39sRhG3F+OyikXsh9gWKGcotIV0Xb0g1jzfMq6pJFCNlvtZpVQ76+c1ddj
 vHd9lvucV3fStpL7M4giaruxmPsfbI8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190053

On 8/18/2026 7:14 AM, Baochen Qiang wrote:
> ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
> calling ath12k_dp_tx_align_payload(). That function may shift skb->data
> in place (when headroom or tailroom is sufficient) or reallocate the
> buffer entirely via skb_realloc_headroom(), freeing the original skb.
> In either case hdr, eth, and skb_cb are left pointing into stale memory.
> 
> After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
> skb_cb is written immediately after (storing DMA addresses), and eth is
> re-read on every TCL ring retry via the tcl_ring_sel goto, so both
> accesses are use-after-free or stale-pointer bugs depending on which
> alignment path was taken.
> 
> Refresh eth (conditionally, to preserve the encap-mode distinction) and
> skb_cb alongside hdr after ath12k_dp_tx_align_payload() returns, so all
> three point into the live skb for all subsequent accesses.
> 
> Issue found during code review, compile tested only.
> 
> Fixes: 38055789d151 ("wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850")
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

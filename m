Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A00391833
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 03:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790134078; cv=none; b=sNXbApvztcedTIDdxH4VZeKK+si/GehJNIjAV8EmZ5jtmo4z+zCaU2O/WOoVmpVJ78hP05ljDu+wHZQjRDREPBDa2J9kSpqXZTa1X/So0iLmebZrz5SB2J4utObncbUCxZz225VAF2B9LtU6Dx3aps636IX/mBXRVUr7t8x52+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790134078; c=relaxed/simple;
	bh=h7iiRpnAfuWRNBbwrT3zYytQhwzHNPp3fqoR6tWqQss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okwor/+5lmVZqh4L4wNVGmk8hW9CRW4xfqlBSl+PnO8DTRINl4BfJq0t5rqiVwg11na2SWlrYEYm0bCy7J7tzXhW2KF+PhUTX58Ijhhrs7yq/GLDhsTCurb3ZedgJkUISv7A4fZStuDejfi9bHKokdPeHVWiINhb0glXdukb/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PROWSGHR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OMqnUYw5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PROWSGHR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OMqnUYw5"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N3CVot1509179
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 03:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ae6gy9+PTa4qOcfFJrlLX0N+HPRF6sDIXYy3c2z96Qc=; b=PROWSGHRjNXwSWSm
	olupPxWyO1s1T9w0Fw/Aj/xTTddFxxgpN7yS+yQDUVJK55n9VPnGD89tX/AL9Y5z
	jZmnSlG/oQpCgwzblDP+seg8ZoCi4xheBc+P4gdrdC98AUBZc7FN+WHE91h7WtYx
	xmDzohNskb7RzrBTwOf5Afjw9fG2yXmFAUl6jVif+lzJ0Cn1dFoTJ80V477dej2w
	18ApKVa6rbEGBGhpsRZHJ+XScvpvdxMkxUTl18GfQC+PNLlvT4HAPa2Mp7lPRJbt
	rDRJI910gIYdpgjLpIoo1a21HYPPnPj53/yS4Q5EoCgYAshI6v0HKeJTGDXvu1s+
	XpU4xQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gux7xt9j5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 03:27:55 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1b8088203so432634a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 20:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790134075; x=1790738875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ae6gy9+PTa4qOcfFJrlLX0N+HPRF6sDIXYy3c2z96Qc=;
        b=OMqnUYw5BazrhjnXjWLtCIEUktPUMYBztn7HWdAnC0uq4j9AaWtfDuJiHsKNVnru66
         cncuDzfFJ+cbQO1biWT28LKOkUwJYRh7hF2+zdqSeEQ9AYvrvRpkO8jq7hlS5NQLWFIz
         HMI+nSgtCIsMUdVKKJ9oFgCSOaJbOraneiUngunAot7wWj+vtodAjRX+jUNQ8a9oeub7
         LdZeDLJ7X/s9BEm1taZer9CAs0s3xgjMHy+mJUyJgFtVPU/P3pSdglKe0h6sayCPTwtl
         XnpdIP5DVdReekmVHVjN7V2YBlwdnpwRCtBq8zEeO3MZLONSQ4iaMuXCyHPIga0su5uz
         31pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790134075; x=1790738875;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ae6gy9+PTa4qOcfFJrlLX0N+HPRF6sDIXYy3c2z96Qc=;
        b=S2ziUBK9Imx9zoZlDsJlS2mlEB5C5TjsNTfBMDehrYjDny95uJncLNOtjzeL1DeNbV
         PRHOohTZjI24F/2mWv6hagtQ1ORbAOsmvjkczqOZJb6GNyUhjTQ9WfUQnfahQy0twi+0
         WigBnbPZtZwfBdN6k0bMl6ACoiTXUgG6uKWJ0djsfsIJ1BkVW1mw+26FpZdxxCYTiC49
         tdGFgnhfdeuV4tXksnOoA6lGeFk1gl0cPbXlbYFHBA7haAL2G6PhEh9S3mI+PlnUFrL8
         /yR41d3EDVKclyN5R2/d1hcBynpPzhbBr7teUMiZUM1T8nd2eXpjUCteGBKFUwAb+OhP
         flqQ==
X-Gm-Message-State: AFuF++npkRfGn/scxgX3HxNWul/JIllANQkbIpLEFxXOwgGTHXjeKWZO
	h7hjuXoXeuo1GCHHecYEFaKyfyMgf/zNWDF/GpljANnzJldgF3gZ6jBwUHh+hIm2pm3keghj70/
	J+cg9smHn8onQedGYmCrc2lfkOQhzYIrXAanK+6DAkEJCTwrrKrHEl18xyFtKAawue5YkKg==
X-Gm-Gg: AYBFou3EV//HusewauVkjIlGagBuFfMcF2dRz0Rlc7M7F2G7sV3SNazcDM2zft5SziG
	VOvKvkKDSO4BWeltm8qIfaSWyDy+0Amk6jsqsepLFU80AAiMZwEwKanurIokYt3MvOapqkoW7Nt
	ggjM+3L7J9hincq6LQrwXXGKgECw8saJ9eMHrqwlBRHbDDfQReaUxl7GJ8LTpNCfXwSa8qP+1Tf
	TJqnRgIKuqv3dqyF/TyQaV9WKDukLZ+yyNgVjYZx3jhdAN1xUvQ0oxbnT5AzYQb52QUn8xNV26o
	/VKRsDTqI8XYQJrgU6zVYqVlG8JkK+9IkukQEMNglcxvI1+pqCczsFeHTzuQ3Dect8Tp9oFPmqZ
	4BeqIYYGeproV0s46Xc6dnr2kb4Lu7UbFPNDkz7sQA0+ZOQKHKZbSicJbAe3VfbERcb9tMxDoDw
	==
X-Received: by 2002:a05:6a21:4d0f:b0:3dd:85a9:55a1 with SMTP id adf61e73a8af0-3ddf81fa4ecmr1204394637.35.1790134074971;
        Tue, 22 Sep 2026 20:27:54 -0700 (PDT)
X-Received: by 2002:a05:6a21:4d0f:b0:3dd:85a9:55a1 with SMTP id adf61e73a8af0-3ddf81fa4ecmr1204380637.35.1790134074304;
        Tue, 22 Sep 2026 20:27:54 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1dad3978sm548593b3a.34.2026.09.22.20.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 20:27:53 -0700 (PDT)
Message-ID: <2dd83d65-ff4b-4598-979c-481c11bd18f1@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 11:27:52 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/7] wifi: ath12k: convert DP profile parameter
 macros to inline helpers
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, vasanthakumar.thiagarajan@oss.qualcomm.com,
        quic_periyasa@quicinc.com
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ozsASphx5IKhwb2C1Ns2fslus9lbLcSb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAxMyBTYWx0ZWRfX/SSfC5voJUZR
 UUvgXYYOsnYuI0WLapqXtB6gax86qblZDDgk5nZyyOzcB98lDw3QH1tSYXhKBc2BGVe3VN9MwJ0
 zOXoKz+M2ZYIrK7QMNUwWLkzO8VfFiet/XN/BXJkKb2v2twaj5UGEUDEMg4sn9Bqzmj3QRN+Jq9
 BWJTg7x0zsuCJZDcI9s2S+5ch66hA7oEoUSp91UtJ5mWH47bYAm5ieVGwnbFdutVkGWDgpnpj/u
 o9FQN5id/2uZ7BRjC/P/cxuEialpgHYVEGWKNJHx9YUUPAIQVRuwDwA8RgTkndC/Fk0MAOpy8I0
 kvDFSgVRRoOybk9yDmy6hzzeSr3EUH398ytrhRJNi8pciCv1bolgaxL74viP7XX9eMdoS5YGf+S
 7zgkF//X+FCEl6JRmqSdtxEvm3Z1im3FhCFdxO9qgda1h9xPQj7Gloqhg3C5SPcApK3ykNhFz1E
 1m56znomQYd3mtf4iUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAxMyBTYWx0ZWRfXxn0RlXljyC4Z
 W/ogj1rXoGymoz6xRcfOiQ/VDL4v6RUt/MMZn0hkhzkkQnSjWmN+gnvGx7q5JtGYjKBTqidm9Vw
 Xtku2aagr8jONfw0+Adzd00TeYon6r0=
X-Authority-Analysis: v=2.4 cv=QsDLTlyd c=1 sm=1 tr=0 ts=6ab3473b cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=egVK8HpoOGdWJymRfCUA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: ozsASphx5IKhwb2C1Ns2fslus9lbLcSb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 phishscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230013



On 8/20/2026 1:47 PM, Aaradhana Sahu wrote:
> Convert the Data Path (DP) profile parameter macros to static inline helper
> function without changing any functional behavior.
> 
> Aaradhana Sahu (7):
>   wifi: ath12k: move dp_profile_params to dp.h
>   wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
>   wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
>   wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
>   wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
>   wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
>   wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
> 
>  drivers/net/wireless/ath/ath12k/core.h        |   9 --
>  drivers/net/wireless/ath/ath12k/dp.c          |  81 ++++++++------
>  drivers/net/wireless/ath/ath12k/dp.h          | 100 ++++++++++++------
>  drivers/net/wireless/ath/ath12k/dp_rx.c       |  12 ++-
>  drivers/net/wireless/ath/ath12k/mac.c         |   5 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c |  12 ++-
>  6 files changed, 140 insertions(+), 79 deletions(-)
> 
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


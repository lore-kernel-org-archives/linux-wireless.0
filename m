Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BC32C032C
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788326545; cv=none; b=EcMQUP1vDWPUusYdGzZh4zdusjQD9Jg0SApB70/qoPz7wukj8GMBGDQ06rT3ltfFP2loQwHN5Dn8ranwUZTjRfJsZIuqM/nzLhJpnGkU+fP/hyFS4q+reuGaHFS0KQOV84omKgf7jmF4ZuMa5fC6NZZ2r5UMriUHJVJ5CpI9QqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788326545; c=relaxed/simple;
	bh=RX1tqIKGVP0bUorI/5rlQmkq+iT8Q7dOX+hFIanw6B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5Jr1pKypO07cjedakuXt++f0wpChpvO3qMYtgseQaQFghsE6q+TRNuOZAGNYI0VQV1X/iXMhTDhtEF7HOsbYr5ojML+uw0aTrnyckDstv4g5++6DCdEinYEzYCQFrJiRsO0OBJhg5a7+oboFs7SSAiAbMt87+p/OAmjmoJpW8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=m7PaReY9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bqZLLBT3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="m7PaReY9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bqZLLBT3"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68202F281013362
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 05:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RX1tqIKGVP0bUorI/5rlQmkq+iT8Q7dOX+hFIanw6B4=; b=m7PaReY9pZUxLkDN
	dqh44VsclV1XXF4zYuQ1SDCcxyEF1yYKhrLWFgdXUCgKFj9NP+ITQvGs+aQNz0zz
	Yc26OZM1m8LIQPY2lKNMoPrLGCWaEdM/nR5WuxXAJymwnXaZQGE/5tOq6Z2w/BUm
	k2Sg/UK1POZD4ZOhzUNqjlJsNRFKYP/ZK0naZhLk8K8a19rRz3SD4rJlJ4fVFQxm
	oVrJVAFxEDpHQle1gjlCDH5kVr0O415/CNuBvgmrEmIiQjtjK5lglTDXLeTmLM58
	yTBjBuOtQS4+EKooZK6BtG5FRRj1qBbRDlidekgf8NcAohzmg66sgexDJKAmfF2k
	l6vZwg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge8whgw47-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 05:22:23 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so1087726a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 22:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788326543; x=1788931343; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RX1tqIKGVP0bUorI/5rlQmkq+iT8Q7dOX+hFIanw6B4=;
        b=bqZLLBT30NGMzLyrFxLYUJmHreE9NIBJ6H0VD66HBddlSn4Djg3L/lJDwkA/GePToL
         Gsi/df1l4oeesFxXoVcKnpIQ8d3J93HVOe3xZ0NkK+LrQEZe2ZAunbeYWl/l4Uk0V7e+
         pgGZ5Ks6M4LsrRsiWqYBrNwJu8KUxA2EgrV5GJAwHXbxrHWm2hHZdbRwdt8oUyHoDCey
         socUrMOZeaJ68i2ppqQbmTdjeiA5skanBXPuarrZ4kTsaDMqBfblaP/QtmX4GCgDVYys
         qvfGWpphv1ZYwzEwJaO5iUF/Z2IeEpmP03EQ55DDfaXE/gt7zUZMNhBF116O/MkfttGI
         RF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788326543; x=1788931343;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RX1tqIKGVP0bUorI/5rlQmkq+iT8Q7dOX+hFIanw6B4=;
        b=cE7zxl7Av8dQtcIfYDk0cCaWzOo1jyDE+p5IR7nLxpy4QPiASNdPbyQoTSQz5NiiOj
         9xP34rgioJwHwx7E66soqlXnchzne+Ue7Dsshyr5bbhkqxf4oI7zbHA15UHWWo4eavsd
         6Fw3XbBFgWSPk4SVS8p7pdDc0+PXS14T3KnGSsaCVGVkVGkh8qh1Sl/1jQZRHxHC4C/n
         uwqKJRdb3t/vK0IXBzNr4IM4s/KZ9wot48pyiSghYw2PkdZCOZFpH+72aKf4U9p56Q7n
         z06UwIFb+8+VomDjiVnCUtFiXYEwSb7oB4+/WneWDE0GKxcHpm5e3de0uc7SJiaCxWqn
         boSQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0TfLYsXvG3MSJRlqiugRnYFGJMjcPT/hgTlUyavy1n64h1La75lIV39Difvh1GmztLSp2Z9s0qzSoYSiYmw==@vger.kernel.org
X-Gm-Message-State: AFuF++l3wX5grcDvJUdd9CRL+AcR9qRelm7JzQlORPnx/DtZAwIhYr25
	4NkLQf6j/gXytY/P97zDsvMWaRqqdUoZ7GQOni53XyNv73FHxqPT3LNfUPYpb79O8QtV0r7OTSg
	Y6oxzMs05h/2sxY06WTnBSSB3ViOhT4A1uD63HJBZC6SnAO6QQK5McbJYLyjuZuYQziYndw==
X-Gm-Gg: AYBFou31zl8EvHJfftQu6+u/had87cjL0S1QqkGR9qXbxE2m6Ml3Z8e+6n4GMig4it8
	aQL1BDQCZLErK0mGx904M/2ab9V+qhun3MdnpMpGDDue2uPGBB/oCv3zdT+PBx5JTN5W7JYsNYf
	NPCoENQB4CRD+1xGiThgJoG1BNl2Wt1K+YWKXwGzgTGpTbvopxbTtqcFRhEV3Tpa3KK/7RqSAv1
	DQLRPvjPpVTACImQFt3k4If83830b4jFrKBpsvIIBKsCuXzgqU7HU6h05q3Dhval4BvYU/BNFBg
	1aND3GiOL0beT+fo90rRbZZAx/9TEq4M0BzKRkxB3sBGTz1HVNEh69EuzOUR7y/dHqWSM09GXNd
	S6GpzqhbZ121W8dd3oog+GIUTGzbnnavx
X-Received: by 2002:a17:90b:2f0b:b0:398:9c00:29ed with SMTP id 98e67ed59e1d1-39aee1f5fc2mr3694906a91.21.1788326542661;
        Tue, 01 Sep 2026 22:22:22 -0700 (PDT)
X-Received: by 2002:a17:90b:2f0b:b0:398:9c00:29ed with SMTP id 98e67ed59e1d1-39aee1f5fc2mr3694846a91.21.1788326542204;
        Tue, 01 Sep 2026 22:22:22 -0700 (PDT)
Received: from [10.218.35.45] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430eafc907sm3003702c88.9.2026.09.01.22.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 22:22:21 -0700 (PDT)
Message-ID: <cf33b23b-9068-42e5-ab90-ad7f42d72b74@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 10:52:15 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] PCI: qcom: Enable ASPM disabling during link
 retraining
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Lorenzo Pieralisi
 <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        qiang.yu@oss.qualcomm.com,
        Krishna Chaitanya Chundru <krishnac@codeaurora.org>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-6-6dea79786b37@oss.qualcomm.com>
 <jdch2j3vcjsr2f4u7jhiazuotwqu6pon4xlvhzuhrzpzjhmkkb@7zzy2autzbmo>
Content-Language: en-US
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
In-Reply-To: <jdch2j3vcjsr2f4u7jhiazuotwqu6pon4xlvhzuhrzpzjhmkkb@7zzy2autzbmo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fLkJG5ae c=1 sm=1 tr=0 ts=6a97b28f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=LpQP-O61AAAA:8 a=B3be4mm0s3FIsxF7KqEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=pioyyrs4ZptJ924tMmac:22
X-Proofpoint-ORIG-GUID: BXQvCMy7DCHcl5yzBkeAGNopLG2HPkDI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA0NiBTYWx0ZWRfX3QJD7IDqdJAJ
 A/k8H8TVfB5nHRuvGMo9oN6nv9Q27sKrnWaaaHxjNOX9ckVnFfbHS2Winsyv+FJ0wYYehmzJHPI
 m4FWyT2lQ3kU5OoNBx9gES/rgjKeAodfcyGeHY20zX4kE/9I8Kgh9o04DbVBmCikQCLU8v8CRkr
 BrXNyMOC8ARMYFyaSQRceHWDG1Ei1thzdB9FLEWvArluOeWqYBx8Ii0Pe327eANyOJHixOV+dBc
 0aMqzTtxI6sWPk0nN0GUjgsBW/8yOJC0/AEYdYanwCm7gMjaLs18BBTpsAmkoLxD7cI5nUx2jxD
 GYN4gphA681SW/siwJryKPkSak97zrrI/33Scuas4G16oQxdrlYgmCijqucN9oj3vRs+GdQ+U8m
 S483zK8q3wYiLourOCNohXdDy3W15S07/ZHDOLeYVZnQBx2reB/nhnqWNSOQucE+tAirey9Yq2G
 Q6fTQPXhQUQXqGqu5+g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA0NiBTYWx0ZWRfX07VfisSZA2Kc
 9yGziPoRXcY1yy0eBB0kF75raFTQ95wDlm53i5jhKFcpw+LeuFPFwwJGMgtpRus1TzGMVtZWYPa
 eluMP+pt3xf9aMnQ2/827hV9UqIz2Hs=
X-Proofpoint-GUID: BXQvCMy7DCHcl5yzBkeAGNopLG2HPkDI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020046



On 9/1/2026 1:38 PM, Manivannan Sadhasivam wrote:
> On Wed, Aug 19, 2026 at 06:55:57PM +0530, Krishna Chaitanya Chundru wrote:
>> Set the disable_aspm_for_retrain flag in qcom_pcie_host_init() to ensure
>> ASPM is disabled during link retraining operations. This prevents potential
>> issues with link state transitions during bandwidth scaling on Qualcomm
>> PCIe controllers.
>>
> Is it really a controller requirement or a device quirk?
yes, it is controller requirement, for the future targets there is a fix, we
will not set this for those targets.

- Krishna Chaitanya.
>
>> Signed-off-by: Krishna Chaitanya Chundru <krishnac@codeaurora.org>
> You need to use OSS email.
>
> - Mani
>


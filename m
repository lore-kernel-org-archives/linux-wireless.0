Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D25306B3D
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289237; cv=none; b=Iz2AW1yKClx6K1/NDfeeKdZoa1yRzg/tkHmtXpSwGxZlsdqESr6MLbmsoM01G1rLP7V4SyhzoZ5ptmG10NVXCa2fRF3X704bIQJwyHfGvgQcDZ3hQvnFLX/mVIslD426l+zYzuOe5gSSNoOziuO/dNN1Nqghw8lKFnds+2OpX+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289237; c=relaxed/simple;
	bh=okusegE+MCGRGgmachZNYjHQfdbhKFBAuZR7EzD5ZIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYEp4wtQMYjDyIBaJOetGjXSeHV0WZumd2vmqniQoP0x6K7GBkvjOn0ZfREPQFnJKSnQJqs8tql14ZeGBoOO6FWZDiiMjnnJh/gtxZ7YsY5JV4iih8ZIba3Gm7+9qWyhCnh+JMhIU6Hp/IuslWM2++DpFsrlctTLZBCaMc4pToQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VMJZ1tXm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KZiDBPPs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VMJZ1tXm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KZiDBPPs"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1HQk8449940
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yl4SkjwOHuqi6RO7BshtqcwKa8UMFH3u0MJsjjRIo6M=; b=VMJZ1tXm/vbsaqZg
	CRGnqEczqMyH/RsMUKYrqw+8sbSqu4Izqtqi9Am/VzH+KvnOZcrIz8gC7ZZdgt4c
	7ndQIcgv24ZVLvzaVizB2gcpxfLX50fBpJt5G62i9+9JwTimJyJ1wqth+Q2Q90Ae
	eX/V1UtMHKtzpIm9eZ1Gw0xQf9prHGuKU3oPp2pzBkCcxg2MlgF9ZFSdl0NILRPH
	GZMLxvyOWWnxW1XolRji84b19DkFU1F7s6HJoc2RjzTS8tt83WK5/pRnMI7Way1c
	/05f/c63xV2vCZX9k0oN5ug3urvguU0z9GXrHFfQORIvHIG2ODcwYyuYYfXpdhlw
	EpBzDw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpvtvb7mh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:40:33 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb6dd278512so237574a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785289233; x=1785894033; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yl4SkjwOHuqi6RO7BshtqcwKa8UMFH3u0MJsjjRIo6M=;
        b=KZiDBPPsXyJmH9mj+ZqRvluIhXw9wMbXCS1EzZ+Bz5EjCpAot83y8eET8rNVCSegNb
         Pk7otBF0iqFFO2JGP1/P2ZtI54N0JJlPR6EXMkVcxSjdJ6FqXubvXhPWBRugE+O+nzA+
         NkkmBtv/DUCizoxrLLlR52FgEkSnjIjWoUqZG7zDOjy4I2xybi4HpflrobPOqLniz5Mv
         HVUlmTIq7bGWdC7nvJx1/i5vGHWogxyWcX6cA1m5KK3kJn9glBLz2qBLoY8vSCftavHz
         sq64jEUWuL0apYCdfAIVz+mbELPE6QIPyVOv1xjU53NynvwVQD2p31B5uzD+uK8xDjt0
         1abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785289233; x=1785894033;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yl4SkjwOHuqi6RO7BshtqcwKa8UMFH3u0MJsjjRIo6M=;
        b=K6XhFw0UDTXPN9kthFAegI78hTFMkIT58WmuChnyxTKJZmx2BEeD9OP+uW21QZF6lH
         6uOxCYY6MMovyWkv5q8mPIMtaeITvHNoa5UOchkCOOL01xmg4Qk96LaAE0pAkNR17Fzx
         Nl84R0SUxNypHVMzOeUmCL0wNMNXzuahyFregmWb+oQ5KvE2orhI+9Zl6UEyyrtXwSoj
         JaWb/+6tCeL/BVRInOgx3XtVQ6ZlQ6Jxbc1bkwo2etkmfO7XnagCuUOFcwgVuhurriWC
         nKxX5JpUxZAZx79uGucJ31XKNYJMwpTTh6cnlvY0OaCkfapwspGY47YZIZiit55Xddne
         CUUg==
X-Gm-Message-State: AOJu0YwNYGaiWp2J68l/UEMdE45ObQyCEyQrSw3grwNRnWwdDil3wONP
	qQMfMfV6d1tHkqgRVNck/R34SVErJe/UfxKFPCCHTvT3N54hfyE0+gZ2pUnM+2nMV0slDcK+1Qg
	HN1uHJq6cHYSa8uSl5FYwgQSEDsnrujO+lrKklsATk8FKhlzy9P93BTUG+u9h2+5EvIVosQ==
X-Gm-Gg: AR+sD11JRBnGT0igBaluyNG49JzL/YLSQPRTckP6BA619OgIoeH4ldpi9Pv9srwQ57E
	yVgnpoBLx4JDC3mrVFcCBPt74m4PBrJ0l3Y/5SAh1vIi4ZWetggFq3IMfRwf1tQfybMcqWcg7nz
	RfOo0dOy+TNodbRYKEazNKaZots2AIPcGwVC/hlN528ZfOQVFJ/R4TUSa34tTvhocMfl/FLQJ/A
	SvXR2P82F6XC59Vsq8tuyyCbU+gPBpb9c0H2qbOuLJzeYwpUG0rUjVl3Ms8GjV8WTs6gXeU0W2E
	Y+zK3WM6BkCJyskYdsR/ot0rB762FWLcXxfWqKCZmThRw742DqIBRqVml9d+bophHzpSUVyJ8Wx
	lF5ymC+thk/juIAXHvhJFcISXRDzJzX1E8V9NDDUegLW6Z9LER0OlwXN7mAQpQ0hwHSQGR4iB4g
	==
X-Received: by 2002:a05:6300:2206:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3c8aafb6e6amr5808968637.11.1785289232877;
        Tue, 28 Jul 2026 18:40:32 -0700 (PDT)
X-Received: by 2002:a05:6300:2206:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3c8aafb6e6amr5808950637.11.1785289232431;
        Tue, 28 Jul 2026 18:40:32 -0700 (PDT)
Received: from [10.133.33.251] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba7341c0sm194223a12.24.2026.07.28.18.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 18:40:32 -0700 (PDT)
Message-ID: <ef64b516-49e5-48b0-bdbd-5a62476d012f@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 09:40:29 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: =?UTF-8?B?6LW16YeR5piO?= <zhaojinming@uniontech.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath11k <ath11k@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20260728031335.3818736-1-zhaojinming@uniontech.com>
 <1e19adf8-d3cd-47c8-a986-05faae7af3c5@oss.qualcomm.com>
 <1C78A779F3AFA320+202607281410457939688@uniontech.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <1C78A779F3AFA320+202607281410457939688@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1tMh2pKJ8eOjQcs-MA3nWLHUQw4UXBGi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxMCBTYWx0ZWRfX/lemnrXTrIDZ
 iypOc4YhyBWB7vH5RQ/WAuP4CfWUBEw9BzPsZQKaFrIcQR1J9K42tDZc+/VIvfFzkFXc+Pn2g5Y
 aTNm/IH+iEMmT0IVAgdMF4Bc5YnmiSU=
X-Proofpoint-ORIG-GUID: 1tMh2pKJ8eOjQcs-MA3nWLHUQw4UXBGi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxMCBTYWx0ZWRfX1GgRT1Rs+pys
 WIjWYoveBEu2Z+Xp5HSgnLktYCF4avYOqlxYH434G0w9NNgT1u/KpIPL7ogTKstdB7eqrEcXJlk
 A8YhgsV6DeGNOWND7ODLC0ujq4UfGHvOFMO9R69n7cxoJ0u1/vxPH9mEP6TdHUtPBh6begnlIOE
 uMc//qJRKV7ioQU/NIjO1TXAbhm2M2k0QulbxP4rdmLcbU/dyzLb8pOyFTDHVJ8dmuFzWK4grCI
 sETTRNy1iPpmgjL6Hdx3Miqbc/NZFQAkgJ1XSJzLt0VMjsCvQNl2LlX2fZ2EBi/54TayYzoEDuR
 btGGl9UCAfKvPxqzGSWc+HQIfznGAr/amP+dZQ7fs9mSAdVuEAqXKSV+31zxdZ2CWW4u5Jy9Lbq
 6xi5EGEWtLpSbnvEXTE8kProLQtLEsliEqCoKkBrh1NWrr/4+MPkQfmubLryam4TpKC3Z3y+WYL
 Ahad4qw5V+VQKou++dQ==
X-Authority-Analysis: v=2.4 cv=dOiWXuZb c=1 sm=1 tr=0 ts=6a695a11 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=casdFaPNnGWWuao0AncA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290010



On 7/28/2026 2:10 PM, 赵金明 wrote:
> Thanks for your review. 
> Do you mean the Link tag should be placed in the changelog section (below ---) rather than in the commit message body? 

exactly

> If so, I'll move it there. Or if b4 handles the tracking automatically, I can simply drop the Link tag.

b4 can automatically insert below tag in your changelog, e.g. for the v7 changelog:

Link to v6: <lore link>


> 

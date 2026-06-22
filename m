Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7B135675C
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122711; cv=none; b=RqYc/ByWi9JFtkoX8Fi2Rhfg8HbxjFpnP2FLDMrWq9Zj1848iLVI4gHSPnbQlXDubk0m6tGsr7wFBXc0zUi5li0+3jh1rSRx+emjclk+X5EIctQpGyh5KaeAKuWy1V7kXBfw2E8QjnoQ7syQyRKqNFi5hUQXuQmBlK2ebRkwSWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122711; c=relaxed/simple;
	bh=ProPr86zOMUTtbFodVcFhPxmcetC0364qK0ltpwk9V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPYwOvK5nMuFFUETcVKMC+vDwbvh35bgqvxN0ZnmMc+L7sRmgYUyeNYugblF5euc5WeSvg5s8pw5dzcZ6NpA7bK3cA9F7yOQw2k52tE871vgbm9jy4B6qEkqzgGXNUZkEAVdn8LspkxyXRUsfKDlu4aj3xopVRJ27MyUqm2mmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q1Dak2mZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PakH5uy5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q1Dak2mZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PakH5uy5"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MA3txd3112485
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 10:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9v1OGWOHyglFd+5UWLROqlFEgqkKW1U6EE2JVBSssiY=; b=Q1Dak2mZ4aqdYQ+B
	1XVWR7M68pvUQvkPSr8g/B4ov/1qIS147wPFL7iTdR5NQ/4YuNoVdKi0KjKyfO++
	MHgGZan7KRiPCEnrTWIsLPUW93sJAgdcgOX0TmMVSVouN79M8KWIBwylmpK650Ao
	cZJqv4YxnF/nlsJtS3TOi0WZZYJMyt5NmNp530l5KS7cConmyjiQ2KjjFmOusM49
	sDzsri6XE8O/ceMGuR1movxtINgL4SiMsnbB5Zo4oLEfI/FIfREwfoJgLm3WpZAu
	XGwM8cApOwknEOlpyKngOkPfRxUG1Sz3LfiAGNhFWkoTxYpeYb52e3LPwBdySzK7
	87yFBQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey2yhr054-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 10:05:09 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-845319bb97bso3459654b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2026 03:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782122708; x=1782727508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9v1OGWOHyglFd+5UWLROqlFEgqkKW1U6EE2JVBSssiY=;
        b=PakH5uy5gev70aCwAUHAhCu0eCdPDJApBqmPnSTZhnCjiCBsyB4hEhXNP5bEGfJo/V
         il8ERIvON1Pzqdat41bTPXTNgYIPBGAgQXiTNeCMua1+xkl2ugdRAdNGJg2WBTV9rKX6
         AVhE6QyGCCKP8p/jl/bdkQrTDO0fUu29xwCmK6JtLLN7Iybw86xmpI05k8mLdrE9an51
         U+9lNOpYgKxn7oYxPzRTerurWwPfHoufcFrA7dxD6vKZPfWPFGX6g6naqzHfujB+T8hV
         M7+TOvTWp+2hkmW0QZevFE1jOxzPbjiM0JUUeM2QcZkqVqjybAEQt8SkMjzIUTMlrCkF
         qVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122708; x=1782727508;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9v1OGWOHyglFd+5UWLROqlFEgqkKW1U6EE2JVBSssiY=;
        b=dFsCVDmiR9yKLZwHicbQ5FFYEuxfOk1+o8DqfrcfVPznbcAfOJgSJhnBV9ImJZdoZE
         nI640HMKGucJhjAOqGVOxk3HzQejwHbR2IDgOg3vXkOkCeclwo+TnJlPAUO1qxVoX25o
         +u394oYA4jDBMH83r7hXQ5HGvYIxGG+O4cBs4H+QqCrhLNrz8dAIZQkQc2GVt4iFUmMY
         Jy3uQQPkVH97vkFn90pcXkydnFoQJCmEMt7WMVDO0AKHT9UTUcgFnXK6toF01yGNiAzz
         0aaGUw0aBzQC7NB1SACNDzPO2+WV2Bkrdb3MNvw7NviAISE8Doq2yIo+crEbAeba1AiH
         k+sQ==
X-Gm-Message-State: AOJu0YwOgCgWT11vaHJmD8l02cBtzoDgTuDTAVC1HDnQDNHP5vmXP1y/
	HVfB7lbvsr+f0O83TUc4Fysa2h2IDFTBJU+WYoRB6GSxeQgxSa8y51L1RvHIDaOELpabFxtVvrV
	9EYF0kXs1XcUEk7IJq9YwnmHYaUsW+HxSGEyIL6rZNm5ipch26B+EoePSPp65Fq+GnNM/Cr3qYq
	MB+A==
X-Gm-Gg: AfdE7cl+lroSe/l5oi9RJzfdizdmNcjNoJrRYPBKRNqxaDaDobtYaSgwLkKsBJ3ut8s
	kDHci/ofQYZT/JJUNZSipt97p3Oc+nnNPPdoljd6iuhsb4lkxpvQlYNX33oUtW/0tkPayPKPID2
	XMdhjDR9xadZdUsse8NtpPlJ56xRnAwfvnWJrfrrkO0zJ2D2Xhbf+5L59UoSJSxnvbzfZ+GKIlb
	CXldkn5u9/H6c0hjXcyI2emyEBC1f86tWIbX3sTeVMmjEzveUlquQhUV7pDuFMyJiUX6Kv89gKv
	odjME5+I2u0/7K0rQ+rhRe/HYl7UWzPgFP1Yf2rMp3T+oDtBTY0OSwhJu22Byl+WZVxmr2vMc+y
	4nh0RlTAoxa7tFtNmaALZtahL4noMtOeZasxQr88G0zKZWdfRTfDxJfrLuNOlli46m7Ibr0dvQk
	SWiKWe3Qne
X-Received: by 2002:a05:6a00:2d8b:b0:845:44c7:2fdd with SMTP id d2e1a72fcca58-845508bb8camr15391397b3a.34.1782122708291;
        Mon, 22 Jun 2026 03:05:08 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d8b:b0:845:44c7:2fdd with SMTP id d2e1a72fcca58-845508bb8camr15391363b3a.34.1782122707756;
        Mon, 22 Jun 2026 03:05:07 -0700 (PDT)
Received: from [10.133.33.165] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564e7480csm7030891b3a.33.2026.06.22.03.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 03:05:07 -0700 (PDT)
Message-ID: <9bce4b31-0096-4301-8262-d248988ef70f@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 18:05:04 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Reduce RX SRNG interrupt timer
 threshold to 200us
To: Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260622062324.758533-1-thiraviyam.mariyappan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260622062324.758533-1-thiraviyam.mariyappan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDA5OSBTYWx0ZWRfX050PPMUcy9Bf
 GucvKwbAnzIN2lI/AsHHCyY5rav/+47LD4WpCm94VqCSgvcg3vMceuK3Y/GB0U/B/878l5MSGlp
 ve2F80JfvittIHCpGJibOQgU3uLn5/4=
X-Proofpoint-ORIG-GUID: tl5Mko6o5o_-UAQkWkmcKyCvbRldX4_g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDA5OSBTYWx0ZWRfX+h3S92x5TRzg
 DpvWcwPTyHc42Z7dFcfoD78tppW2ucoIjIGzwJsXH+Ee+7MtFYbxLFtctpR7BE8B33j2e716Wsu
 0HtWvgZdL8RvLyzldJ9zD+ABBCO7NYsX4QD1PcHRK7NhWKp9dF6AODQMEgp9wydNT4yfgqJRcLM
 c7mB3sxqG3ml66lqY/hfa2VtleNIyB2hwBc5Jxs2/BXpCVpUMAsi1n0lbWn+doOArn2bnT/CkJF
 J720pfFJV9wJA8HORBYHCvpJKpdU8a4dbTjknIWsYEUxu0DepJ9kzLN2g4MGWG1ZwJvqVh8NvX9
 L4cHxrnoAb+M1x3DEAs0AdOhyNbGSOGYG6r4VRhjZ2bD4HQ0/dHP6MOTyX1VlUhlWfrUKrX0gRs
 EKjXn2/PJJmTCwOKvXHU6bG+Wh5HfwZ6j4GMd+XTG2Dw0ra8GoSzJopoi2RDH8kRq9MMpqgnncv
 5+BI13+mvkxF64b/EjA==
X-Proofpoint-GUID: tl5Mko6o5o_-UAQkWkmcKyCvbRldX4_g
X-Authority-Analysis: v=2.4 cv=cKbQdFeN c=1 sm=1 tr=0 ts=6a3908d5 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=6v9ovjmckxnE5_8N7CcA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220099



On 6/22/2026 2:23 PM, Thiraviyam Mariyappan wrote:
> Currently when RX traffic is low or intermittent, the RX SRNG interrupt
> mitigation logic defers packet processing for up to 500us via
> HAL_SRNG_INT_TIMER_THRESHOLD_RX.
> 
> This causes excessive RX servicing delay, leading to increased end-to-end
> latency and degraded TCP performance in low-concurrency scenarios.
> 
> In single-client single-stream TCP tests using 5G EHT160 (NSS 2x2) mode,
> throughput drops to ~400 Mbps DL and UL instead of the expected ~600 Mbps.
> 
> In addition, UDP UL end-to-end latency measured in 5G VHT80 (NSS 4x4) mode
> increases by up to ~48% (~570us versus ~270us) across frame sizes from
> 76 to 1518 bytes in uplink and bidirectional traffic, indicating delayed
> RX servicing under sparse traffic conditions.
> 
> To address this issue, reduce the RX SRNG interrupt timer threshold from
> 500us to 200us so that received packets are serviced more promptly under
> low-rate and intermittent RX traffic.
> 
> With this change, single-client single-stream TCP throughput in EHT160 is
> restored to expected levels ~600 Mbps TCP DL/UL and UDP UL end-to-end
> latency in VHT80 returns to baseline values ~270us across all tested frame
> sizes. Under high RX load, no throughput regression is observed, as RX
> rings are already serviced frequently. The primary implication is a modest
> increase in RX interrupt frequency under low traffic, with no observed
> functional, stability, or performance regressions on tested platforms.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01181-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

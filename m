Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA91369972
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787764959; cv=none; b=TMUOZWCmBltEc6xvDNyflsxpRO6UN1LYZ6NmTYF6sK7NYVCOMg9SCObhclpSLP/edZI5u0hkwjtlRXU4Kwtx8ggftV/SwdWyGzpCO3E4BE2FV0K23plIDk0Je0XKyl+RMqYyVxjeALiRNz2npMoW0Z03zCB0dZQEYmbFVj+J9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787764959; c=relaxed/simple;
	bh=DxdiQhdWsOWWMm/CKe5Ab8kwBEImWxzSskDHeesLetY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=et5yCh6SZWgfDZ6Tjq/a8M+cbnF76QQcKn7qGAwT6Xdoe5BX0Qjhs3ITZLSndyMsqJmNag/aRX3ab1jlEn0wX7BMe/sSEUBSO5L/WrD3tc+DKs+IO1ir9gxzQbvqpuVX8YXu+qoIG3Dn+osH61iMfLpneve0ot3QayP2n5ENPHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BvQPBtD5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V8wArXST; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BvQPBtD5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V8wArXST"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QHInIF1572131
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GUp9mWn697LHqoXe/t2BQOvcPOdG0aKShFCgaFRzBNE=; b=BvQPBtD5AbfTg03f
	5PI00B+B7HHveVeq/q+j5RbhlvfO5hE2pGgmhRN5gwgWxSWkgYIJ2ZIktW3lb+WD
	Sf+nYlbgjGa7AUYZFoOXLNDoKF8R2FV2scb91dMyfia6lFjw9h0IVuw+aa2eNLoN
	dujrupwdl1ZVtf2hhENkxHG+bFlNNNs6zICA1rBJ6Oi9FPT6b49IlhrXCqOxaqEM
	YntF8Mb1R3N/FSmIrWaU/tYVWhp/v9N77mldNHQcKB95AC2MfiO9tKnCkuFskY45
	kRBLBZcxFhxYsV4si64ksobgPELNEUPeZHgGa0P1KnRJEG9QeHiMUX1DZsbKDp0i
	uvBa1Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga4ec80h1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 17:22:20 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cf1c86963bso1161335ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 10:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787764940; x=1788369740; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GUp9mWn697LHqoXe/t2BQOvcPOdG0aKShFCgaFRzBNE=;
        b=V8wArXSTqGqr34n9bcNSHZExXUKME1I7Yk6WnChD0tz1rDrpBpav83C4SJGPX3J7BT
         QTFSSUTE5bkURZ14Y8AoElPDelwnHeONpO50D4aJtNzgNs0HwjVMchnYwKDNkfXSmr5e
         m6ZN2NnD1B43cIjhFhOnVf2Oq7TBFZ6O/HPDiO/GUxroYt7VEWF+hVOdJm9NE+qyNxE+
         71/ckfLtS6l7HyUOmXSOU97wKsT7RLHyHLrZJOYTu/ZxKRUKVV2J+eA9/lLo2sSoH6zd
         xSVHlRxj/2YXmPvXxCoRP4OruEXUja/GrnDzCHOm9kr6m5lBOAMSFtTJ3zU3Woj3dDJE
         UPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787764940; x=1788369740;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GUp9mWn697LHqoXe/t2BQOvcPOdG0aKShFCgaFRzBNE=;
        b=fRKpP0RL4jw7ZuJ01tSUWvxdLPyqMUOmVgbKInMlxNN609OWgDMdYHfCzsllWMqGSr
         b1kiRr+8c2G7oSp18vBMm7lZpXevU86M4T/1tHOhNHOQ9H4vf3ZkxoZps1EZKamSx3pm
         SyE7CKkpl8/7rePa/efcNRFBeXzYF8CglNUvlPM607qfbpdZeUsL50qHUlgJv89ps2ef
         MJSof7Ug1XqVtYTD/jXmQ8zV+rmr5phfxNFuNFujQjtr19MdfTHL4EtkFOBT58/hOAeM
         557Rdh+s0KSXEX9iwA1aRDkdVFMw3HZuWkrgtfnrRTt3LkgVmLx2yfabuiTTfUPnDmU3
         Pbhg==
X-Gm-Message-State: AFuF++kvnf3avW+KGnBHXLi4CVnaOMl3k/uAqU4RqiIxaKDYa6eL4EG7
	/CdHgSbtSzNskipuYr5cV+2/+iT3s4YV8kuUuoeAGTrD3czMFqfDU8h1OtPaC8DREgUyTqrLl3d
	XkiiVwaQ6NGHgmg/wwHQ99Z71TerZY3gQVQgKDkdWBw8yDgrlbJgVce9hqrmBeKneq3qMAA==
X-Gm-Gg: AR+sD11L4EpwNhjiGVLjgnyVv3sRDJ5VB4rW76PwBnQ1ZK16U4fTnIFLLscu9+3WEgh
	wuRIqRpyBrq3chYS/OAUl8BbtoFeiIH7KxPenk8pJCvxl1tb4vFx1hyLhlQUUk9b1qyWbAcye51
	IHmrUXdPO716WlzcpsO/zOSKlZMvzPoF6w6HMQekLMKo5ol43swkjR1fXVjG6COTxzPVayca7rH
	psztJ0BgImjI4tsi50j+Zb2SXAa91SW/CwX4+8W10EriG4Yp8BcyVupM4AUTD/VbSulQMSf0ODt
	IQaBLd1PJCudq2sQAVR3FmwBX9B92qDFx7YRW46OjtVa5METjsnV3vc0hSH2jWAx8Gbkewy1PKC
	HuE7Rx9pCxS6g6svcZlp2lXH6vVqIAvD01A5oPAYRd4sB
X-Received: by 2002:a17:903:40ce:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d7269f5c6cmr7474855ad.13.1787764939860;
        Wed, 26 Aug 2026 10:22:19 -0700 (PDT)
X-Received: by 2002:a17:903:40ce:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d7269f5c6cmr7474185ad.13.1787764939373;
        Wed, 26 Aug 2026 10:22:19 -0700 (PDT)
Received: from [192.168.11.105] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32854db74eesm734542eec.18.2026.08.26.10.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 10:22:18 -0700 (PDT)
Message-ID: <002d8ad3-fd9f-4918-8a01-6000821ecfcf@oss.qualcomm.com>
Date: Wed, 26 Aug 2026 22:52:14 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: use kernel types instead of
 userspace stdint types
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260819-ath12k-cleanup-userspace-types-v1-1-161a1e8910f5@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819-ath12k-cleanup-userspace-types-v1-1-161a1e8910f5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KIBqylFo c=1 sm=1 tr=0 ts=6a8f20cc cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=S76r9hedyb03ojg00oMA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: yQQaOLENwyX5v2oX6oEgSBuupnV1sDyV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDE0NCBTYWx0ZWRfXwInU2vwIKLY7
 Kxcrea+7wi1Ooua3vdtqA5eBK3kFauJrrsY/Hx+bihjd/xTSOCHX7joSsS9TCD/x5fD0JJeqHmi
 f4de5TDMczPzFoFUNRE3y+CcXymuVHVhvbO8lpbdOsJYSXVORMmeKPNiTVzJPiF7B+cnNhVlvae
 M6swKytz7uF8GD5hRrzQHzWFYaT3Y6i7SjklHEoDuqW0DCWd1dywNxaRJ9C7T+N/gQqiyH1u+nl
 HyIE2U1HmI4C7is762iyFbqBtSdVzM69MflZk/kSFaVCosKUNAm7NwE0r6/cWiQxqdncaBzp8lt
 PTqAt9JWH7o4n5I3vkKIiY7r+/ofp1KAHEMjQjsHNRCP/8Uu3tvxSyEpXwRy6yUdxT2l0lTG+2K
 J5CanzQ0jlUVUelGIg7j2EAOV42po1gU0e/5iIfhgu/k9+uciSwuvZzeeLfEoQN+i3wCRO99EUJ
 WlP95gtiqdq3Xl7SP8w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDE0NCBTYWx0ZWRfX9K8kuclHoBLw
 rnCQlG0RbekZh700ZPJmKsJFKLTHok56Kkf47g5SruIVHBNw9yYXSS+BwPCgjp/oJHDkYOZ7+1Y
 Y1slg+1SaZ4smXSHzI2rPwn3wCyENFU=
X-Proofpoint-GUID: yQQaOLENwyX5v2oX6oEgSBuupnV1sDyV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260144

On 8/19/2026 7:13 AM, Baochen Qiang wrote:
> Replace the userspace stdint types uint64_t/uint8_t with the kernel
> types u64/u8 to conform to the surrounding ath12k code, which uses the
> kernel types everywhere else.
> 
> No functional changes, compile tested only.
> 
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

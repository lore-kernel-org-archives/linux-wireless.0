Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A143368B0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376211; cv=none; b=gcR4U9LTn8OJv10bkighkQS5pHTOVpkuWc7hj1hDf8pTbd+G+16aHNyyfexQwT//Zum5smBAWIZ0uzQS21qEhYEaUZAbtwwnrkKGgZtJnwgoTPElGNvbO+Sth7Tb6FrNRxn4c8AmpoWc2LBoshv4yrn0SbFXhUV21Hg8l4A9VMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376211; c=relaxed/simple;
	bh=oLqh14DVVwTPvuiRjxRVuufC6RjBn5ProNz02hPC7HM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RVl0JDqspzWHWUHFt39EV5woDcL9CxHTFrzoOb10RGgb2D3HaOk8Mlc4zG3rkh+36MQg1ea/mJUgmCKHPDgmXYuhm2KxIsHv0S9cNzcwBObYccY06rR/gkDcwBDO2U/iERyKCi7TO5FHW9EMGcJf3QdGDfmGP/i5OGb2tg9wLIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F7mZMw0r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D0VFeoW2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F7mZMw0r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D0VFeoW2"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U0x7lc3487148
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oJUibkuvqcc83Slk8deZNKe4ym582iCwWh1X9ZD2lpo=; b=F7mZMw0rx2JKEwZB
	yH5cREwXWYDAGaWMN4JXk8LN2L4tKQPymQ/wKVn7EgLh+gy+/gt9ORfPzNcqtTHw
	Tu7GnDGz02xL+3ApYKFglYPsMFvBd9E8ucsmH64Rs74jlsYE2Vdf+PoCOIEkiAaR
	vu1BmocX940PzB/n4atFD5e1w9Q9k4+eSt75z7mwDnY7LioQA/6hhjZL5YL+hCTk
	DsX/J7EqUp0HWzWJlbSFeTqU0D0OmBUSLROBQTXgcZeNP6j3/uCJ4I1FpSq62dGB
	32nwe37TDNOD+1mQzislq434NdJ4KvzIXIsnD+TsKOA1oOh9UAUbixF1lgEX+JQp
	afhSxA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqvj584y8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:50:08 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee1ec30f2so19946175ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785376208; x=1785981008; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oJUibkuvqcc83Slk8deZNKe4ym582iCwWh1X9ZD2lpo=;
        b=D0VFeoW2OkTP8MzoBudD/cTLUM26xA5SCs3teWL9L4yPNUgUQVPVQORvGg0DbjMFlz
         zHWFayt6IpGs2nwOjcNtCLuSv2pr4VoF5A2GwzVMQrFDtA1TK8lAHXsJTyQBZyhSBEbQ
         +hytIqBlW9plw028dpLZ+PdjyqcLoWtWQZ8FaCXAYNDq5PCJ0dvyNs5qrfjpLrMN4211
         SxOCUpV9ed5dJkpdQVl6bzxIhdyp/gZXl7kfukTwwChuO0AgTqAGM2k8kmULUcftsOhF
         jqO4Fzm6Rd3PRCwGzbuqRvsivp1z8MwARqMhzUscb16ZVFI9ouGfIQQ0b20JkL3QstaL
         nb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785376208; x=1785981008;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oJUibkuvqcc83Slk8deZNKe4ym582iCwWh1X9ZD2lpo=;
        b=QwIAOu6kOi0525nAz9WjkjsxNAEwkzkmODZMs1hLdyt1kFXVKeesGaAJ8nCR67yOLH
         7ud3xuXKs+WQxr3Lry4R15QuaMCQHYa+awUnGQvLIi9j89Ax4TAiH6wFXlUze9+y9eji
         jxtHKC4uaD7MaMQiFc8aJN7l/7zB9I7ZfAxPzoALN82lwsRIv6JLlT9Y3Ol64ibgz8sv
         OvjcB0fYrR2NFBut9oQrOQ2+7UkVNxe5F7GZRKjPOYmnM8eL6HDQ6ZzSP+TTtzK1do3R
         fJ25D1qS9XSwOZcV2B/S/xEilcaPzAZKp2QGCSAgqAhklubrW9OrhJo4LSnU+Hf/OdO6
         p2pQ==
X-Gm-Message-State: AOJu0YzNDspfcMjk2u5+qb9cgUjdnGgkrlJlxv0LFk/303hcE5UzkRDJ
	8oJ5egyVLsFT/r65frkFxa+Gr/Gn1pr4YyvaQ//rTybQxEx7bsb2yDo85N1fiCYqIfGPqmwgEqH
	+5OTXBNtLoDQrom2pgzbLVw6r59vHmer0OaHRpnBWdXc2EGgQvR23j+YmTfbrn5iWfXAz2g==
X-Gm-Gg: AR+sD12b3Hs51/4qGOOGW/OOXM0SMBC8JPYwHq/AYL7bcIObzDTwMWiPZQoYLYZmJs1
	TsERGfIYzswx+OgKareDxcpJwmBWAv3K1cZF+k+hKKooO9Wd9epVYBa5yNWV+ZazwvpiwE/YWVt
	af9Mk6gQ3pZahXWYz/yY+S501fqUeVqT4LMPrHTDFnGI2byoLD/zSpqeUH54iOyGm0D+ahRJg/w
	0ZMyaYP/BJPUjfr/5n4MqYyDoZyHAx+zt7kVZIyBWQkmkWigCSYpbu/1r1kOS+q39UOqOsetvfP
	5EXKNXF9xUo/5J/6ct1UIIPZ8WcK/vvECRmqE5vtW9MFpfelthX2NVkfTogEaLs7g7UTw/v+W5E
	z5dR3U/XxFLtlxdxJV9hkm/6fiQa62IJS+jwN9qDYt4U72pWPOXG9Og/08ewqh3qM3L99HQNauA
	==
X-Received: by 2002:a17:903:987:b0:2ca:be8:62d with SMTP id d9443c01a7336-2d035cc4dfbmr6973845ad.32.1785376207812;
        Wed, 29 Jul 2026 18:50:07 -0700 (PDT)
X-Received: by 2002:a17:903:987:b0:2ca:be8:62d with SMTP id d9443c01a7336-2d035cc4dfbmr6973605ad.32.1785376207419;
        Wed, 29 Jul 2026 18:50:07 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf7cb7sm17974595ad.68.2026.07.29.18.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 18:50:06 -0700 (PDT)
Message-ID: <d3a636a6-ce43-4e85-9340-9353bce38031@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 09:50:03 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: remove skb->data check in
 ath12k_wmi_process_tpc_stats()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxMCBTYWx0ZWRfX7uXdAWo04a1K
 Meirj4Jk4pL1cZfGDDbk4N3DoEU60JFvjDBhQV97wDfkXAHd40NfWQaYgtySnxN3cDMdtrGs0/s
 GOI8kg/CYuh77/bqiaKKgaVrwUsRo9iZ3YdGIlNUwTL82MsUCnh1Jqlbl4uADs6/3jApMdv/0Ht
 0xbtYxDCq4gYAR0vsQHOvW8ewubFjjK4nGqbD+czc44Zu/oIfr9fmi0d4NGDQ9PQDXtk+i7orDb
 K6XjYTYPFT3XwR0PTqDK2bUSrIt6gWTMka3AFcDG4XxZBuUgQVCnBSY12hPhNQR6Q8hxhx81S4m
 W8TCgN4BshyN7FeUQUE9Y42ygyW/WN+iNIr8Uvm/sgQdfw5V6zrxT/7oKXXPOmIMHiwI8u5leVl
 Cjl0vVNE8S+1Epqd9KJ8MTyXL4C8b5GPVIogyTf4qIL2RWnYpiLgKMkGKlv8kQj3/LhrPBTk4B0
 hcIBzI21HFSYKnXJBOg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxMCBTYWx0ZWRfX1h/0aLgeZfsM
 mnsLRvMm2aWIzZhAnlEyREkg4ORJqsF6Ov07pNCFNUKCmmIwKZFgdZ3XTCXV9fcjvugPXaIoGSS
 ksO9InyHUixIFjAfpSV/LshKTyiC/VM=
X-Proofpoint-GUID: L9KkQa96Ful3u5H_szXu1Ciu9DQdYIJn
X-Proofpoint-ORIG-GUID: L9KkQa96Ful3u5H_szXu1Ciu9DQdYIJn
X-Authority-Analysis: v=2.4 cv=UcVhjqSN c=1 sm=1 tr=0 ts=6a6aadd0 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=R_5BTG5rON9OUESi59oA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300010



On 7/29/2026 9:15 AM, Jeff Johnson wrote:
> Currently, ath12k_wmi_process_tpc_stats() has a !skb->data check.  This
> check is pointless since skb->data is accessed by ath12k_wmi_op_rx() in
> order to dispatch the message to this function, therefore it is always
> non-NULL.
> 
> Remove the pointless check and its associated warning message.
> 
> Compile tested only.
> 
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

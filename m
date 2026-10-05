Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C574C33D8
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791224024; cv=none; b=O2lwwGeoQs2dVD7qLL/lcTMAnoEkZdGeRFmMxxMSIP9+X+fKi1uCPT2PSQybI4ADz45p33ko53NunQpsS/mAuyoNMB+G22BIZf5JCaWJtCmMVrT6rRCAP2/581f1LOlF9Z4Ju7YE7GnutJIuhLIRK9maI7iRxWxSeEQ3qM0+RP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791224024; c=relaxed/simple;
	bh=UkuXu0qOnj8zN/v8mkjPx7t3hSvPIsN3i6bv0Ebq9VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eptEV9bAw3gnBh6BWjVlsYQH76P+5Xi7rWnvxbogkuZLZ4J0kcHVeNv0ozYIv82xiyObXb0KDQH/EWGuhNdgV1K7G/bzGSq9LeJHOvUR2AhQLgewadpqcLbdovOBSUtUyZD2GVV/+vRBTR7XhD3YaDrH5m3+uh1+FeOasVgG8w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lbTlvuu0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IlFLi99+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lbTlvuu0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IlFLi99+"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695HLKMi2909408
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 18:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bnQOTfjQ6wqdqHn/qVQ77fhq7el1lDrRBmqVerTW1VY=; b=lbTlvuu0NdEsEw1S
	i3QudmlK+pydVwMAnOUdx3NkB9vu/bPKYn3griO94HOsGoLYOWTfeqaOoJ9IEU/o
	Gvhr7ALskX0TpTzZzToY3G10L1251TKUiXJG8EM3NBNZS/xLe7Hv4+ACxFA9EYmw
	6jwUqliSCAZn6IIYZNG5RE/uCBD4xiIweL97udm7YNHX+KmJaMIvQuP+sqfGbCFV
	jFdG+HzJul9QvzWFimv32Uekz1D9OzONPm55L4v10KAVpjuV5PjXXFVFxoaI8JnT
	BxDYVRcXaQQVglWsWQRr9csougou+p6Vcl8OsXFVsxBWzfPS4jikr4nYtkw5CRN9
	z7oOHw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4bhg1hq5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 18:13:42 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a4a053dcadso1911475a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791224021; x=1791828821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bnQOTfjQ6wqdqHn/qVQ77fhq7el1lDrRBmqVerTW1VY=;
        b=IlFLi99+ajKWnN7NVdUaCCC9j3qv8esqxv7pDlassqbS8ljxMKSKflFfZjb28i4mrG
         GvhK6k/20tOWH6FlBZN8dT8QJFCFw6gULnqIDzo+yWaHQffQYGrPTveqlUVRzHFnQWax
         Lr9kpLXZ81AwN9fWYLWDvWBcQRPLxOR5EUtrP1EeouS/BVcMXEpTrJ+TR/AzbEXC+Xps
         PyBEEzkpVogaazva1dIUN0aN5pV8FeVK6wpvYZ79VK1KrCsuuc8JU/BO6vksdSeRmNE7
         EVK8kQhpY/ntIc3KcKjRSjewzcznKOkGXrXFRAFfGIKHBCO0HxQk6LEIo932IzmoC6BH
         gZmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791224021; x=1791828821;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bnQOTfjQ6wqdqHn/qVQ77fhq7el1lDrRBmqVerTW1VY=;
        b=k/b4PicPWvmE0hnpF+EmpZosLTL0L8Jr4+UzaKiuQrZnfTAUK6KnxEcBaCCPs0OTsP
         ggsG813ffJOg4F7zW5uq4HzPHt3jF1USdGGdNq6X6GXuyLFguE1I6fEiZVxo8+FJ61JI
         Y7ZRzgvPmdIBhrVR7t+OVQH6UjzdK+EmWg5Zu0zE08wC615PhLCd6fIbzJ9hPHBAdQNm
         x4KHswE+UXDuz4Cok7M/TOBs/fe/cNq0QSdoB2pgT7zGDWpbdss90GORwHZY66ApZuh/
         6DCHPi8QqN0PdRpDN1r5uXaX+WDVE3ejUN58YlxA7KNRQknRfb/xdv70a87Tm0AURkG8
         bQcw==
X-Gm-Message-State: AFq9FYItqYmlDzvjr2YRczzQEfwBHmrZxEpwJ1ybUrOsRNt3VlaitugX
	1ma00J0ALSd42pEPMxI3bGb1TgEHv2qie8syPicZ0LG7xZt3g2PHdb02tBwra57pG/a7J+WHwed
	Yph2l1wZPRgcZPkl0IzW1TNWwwnbXUGpq/FR7ReOfYQxfneEjoj6LdSukdHGxfJXrPV/N0A==
X-Gm-Gg: AYBFou0nWwbVXljJfWTVnFplH9xSwskNWpmUBiZBtCSFat5pU4lfwo59SeFksM7wTys
	gvyfEnJOCgc/1iwXkJgSOADhhFQI2JgU2opuSs0tDlP7IbVrMnzca7CKrvrpQVLyC+oig0G4AFX
	iQTpdAw50UcYHGyHq5CSaW6SDACU6PWcU+xZCLhWbYXExeEjbUoqsOyB/4j6fSN9TuLOJ8H2QK+
	B+HdTMEq6mRoP8aDowEYXMV+FZkYKns3y1Cz02jsjtTZx4f5obuvdEa+cyYV9RlLc7tGpjlMct5
	XCMug/Fqb95tLIbBFZjcLiOPIXAj95eLOBGV3uUna61KwesTrnYLsmu1lM/fePb1DKOGsqQcA7z
	F8t2otVDsV8OTg+jT1gmZKndMdAqWAi4ov0hQs4H/JYhcTSkYZVs2uMzGOQ==
X-Received: by 2002:a17:90b:270d:b0:3a4:97ea:f0d8 with SMTP id 98e67ed59e1d1-3a6ced37137mr10882916a91.51.1791224020934;
        Mon, 05 Oct 2026 11:13:40 -0700 (PDT)
X-Received: by 2002:a17:90b:270d:b0:3a4:97ea:f0d8 with SMTP id 98e67ed59e1d1-3a6ced37137mr10882884a91.51.1791224020329;
        Mon, 05 Oct 2026 11:13:40 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a854257d18sm646373a91.7.2026.10.05.11.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 11:13:39 -0700 (PDT)
Message-ID: <f8284643-64ff-4f58-88c6-8d7a9669c5df@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 11:13:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] Revert "wifi: ath12k: add panic handler"
To: Yingying Tang <yingying.tang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: HxaYxlhplfF5BLRuogdJDh6DOnABnUdA
X-Authority-Analysis: v=2.4 cv=GMGdgeNK c=1 sm=1 tr=0 ts=6ac3e8d6 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=HRj9tYUAe53e7GmFZk4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA3MSBTYWx0ZWRfX7+tAUMsmm0nX
 VcFB1pb5g5ZHkLPNVexwL3EgNP2s2qvYdMFvLbKxDZkt8UXMVXx6L2phKqpk8cusf0p6hJbi1Vz
 XuqvNUl/xD5zyQl5Bg2HwE4ms3eoZZs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA3MSBTYWx0ZWRfX/T+USiE8V7f6
 nIQH7mOPgrw3kK4LE/uH5sG7BQ44JmjEEChYBxPYImvGS4WwnFQ+GfmuKXtLUKNPZ9zPT+21jNT
 G+xMaCbEHfrWkT4SN3vhZ6zmHP+MdGcE+JdQxWnbSsAq7b3m/8dFXDDKQWHl9Ueblgw483ckw3C
 h5Od4gf56lEBawAjU3tUUlHktQV2bsOU4pLPOodOLPeRPUJZdQzyFCIRAANWWFLdf5yLhA+Cptw
 ltdN17B4sV8mATxhV7HHWvNFnFIB4sNlNlSfGoy6FvPzOArx638bXixwMwZz4h3kFeQtSmfiWVT
 /9B0dVou8oHwwWawR8Wc7+lTT/2i30KfuK7nBuAZ/As6ScVVDpj1T284wxOJSBtutXAHd9RAool
 bqEJdw58crSEB53wZg1ygwoK/ine/GBjQvMxl0oqDIwTo9PpDCtvhQbQD/gLCv5xu+cPlgvvRr5
 ZmRXxm+S7qWrtdy64pA==
X-Proofpoint-GUID: HxaYxlhplfF5BLRuogdJDh6DOnABnUdA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050071

On 6/11/2026 8:23 PM, Yingying Tang wrote:
> This reverts commit 809055628bce824b7fe18331abb65e44d02b0ecf.
> 
> Call trace:
> rcu_note_context_switch+0x4c4/0x508 (P)
> __schedule+0xbc/0x1204
> schedule+0x34/0x110
> schedule_timeout+0x84/0x11c
> __mhi_device_get_sync+0x164/0x228 [mhi]
> mhi_device_get_sync+0x1c/0x3c [mhi]
> ath12k_wifi7_pci_bus_wake_up+0x20/0x2c [ath12k_wifi7]
> ath12k_pci_read32+0x58/0x350 [ath12k]
> ath12k_pci_clear_dbg_registers+0x28/0xb8 [ath12k]
> ath12k_pci_panic_handler+0x20/0x44 [ath12k] ath12k_core_panic_handler+0x28/0x3c [ath12k]
> notifier_call_chain+0x78/0x1c0
> atomic_notifier_call_chain+0x3c/0x5c
> 
> ath12k_core_panic_handler() is invoked via atomic_notifier_call_chain(),
> which runs inside an RCU read-side critical section. The current code calls
> ath12k_pci_sw_reset() synchronously from this context, which eventually
> reaches mhi_device_get_sync() and schedule_timeout(), triggering a voluntary
> context switch within RCU.
> 
> Revert change "wifi: ath12k: add panic handler" to avoid this issue.
> 
> Tested-on: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>

I've posted a version to my pending branch that incorporates the tags, fixes
the Tested-on tag, and rearranges the commit text. I plan on promoting to
ath-current early Tuesday morning PDT followed immediately by a pull request
to wireless to hopefully get into v7.3-rc7.

I'll pick up any new tags, including Reviewed-by:, that I get between now and
then.

Please check:
https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=1606f6eeef30f540a6b6ba9ac47b86fa72198228


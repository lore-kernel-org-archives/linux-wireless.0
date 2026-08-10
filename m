Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0447421CC59
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786329032; cv=none; b=H5OuOkzgEx12Crsg7rQ2q3JTlW6TQis2KROx35i9vdBbl9k7lxk/Z3e6zmEawqRRf6thVZzcLPm5M0/+vgHLNdykdgGAzq6P2stIW4+OwNetxyJJmYmhVn0UvgdjgVSRvnDhG2U39AGsPpfB+6YYmW8l3PEUrzXeMmiLQ9KMOAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786329032; c=relaxed/simple;
	bh=/+QDh6ogqdh0ss4hICifM1l8meq4zJ9h70JS0n66h4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zg0RYZjSPjzC7O/u8mEwupA+bYUHfNBXP+w9TbcfZrhVqweTQfO/kQO6GHQ2aJXTHBgXp2Z5NEjGEnsWbg1xzPrYPQuN3g2rfDh0mUUxoQcpLz3vLaRVW9DFFz6rc/eBXLcVyewx7qP0E3/CiPYz7ktGS/DrDRopzZ4tYiTB1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ycea5ciJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i9ILlYhy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ycea5ciJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i9ILlYhy"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679L6Wpj3434385
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CZ/XxeklchZuwNvNenrboYqktnOIUOLHiWEgmn9GdIM=; b=Ycea5ciJlvSJkmg4
	SQUnPuCyckfSCuCy/wdsSkX6ef296l69hV2CQ0JncaILx8SVitseas2XEIzAXnsi
	VmuHL23OgE8ss7BsJZNcX0hKLUC4vj2RismShqA2oMhlDh4BJvP2J1qSDLd5O3EB
	wnAHyTEu21CtVesgAyU6ihyIFpIjUY7hSEdGEybofwI0JQB80UIRKRko1/mntwck
	YPHLmi1myytdUHOx2uC59YMOTpBWjV2Se+3WnOxsHZbXKaU9IGyVqJBHHrdALFEi
	w6ABChTm7geT7C3Fq4AHqQ727BC1o9ImSJ4OP3wGmv4Ch+EhHfOWkGA8HcG/QOKY
	Z+FlxA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwwr9kxaf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:30:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e25e4b41cso1785411a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 19:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786329029; x=1786933829; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CZ/XxeklchZuwNvNenrboYqktnOIUOLHiWEgmn9GdIM=;
        b=i9ILlYhycWINTBeIi04LXNcgKjFwZCEV4i50SL2b/gnx6jLEQXXAb3Q6Ldf8M8I28v
         +IrnDdKCgUz4YWphoQPmXWrHTWJ6iPjMqlS2ZBIq9hByC/PIC5app8lkiGF1iTgZErtg
         gbrAHMZb+yy54hPmpOOe4vZkUIcS6DoE1q+/jT5KbyJQOvcyck83XbKv18Twi2+FR7c+
         a7nw0paNTZpUsBkUBArjXV4E/kZEVC5B4p9jzlRSsIHLxzbp6FJCNNmBqOBUdhxwaS90
         F/dxNkOVv5SahnRenuznaJejDdjZO+CV1o27ZKZi81umw1xZ6pKZioyQCkr9lv+o9F0M
         XC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786329029; x=1786933829;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CZ/XxeklchZuwNvNenrboYqktnOIUOLHiWEgmn9GdIM=;
        b=oAlyhWXPlI02hKNbvPub45A8PH8rijPUfs+8IrA7umRRf+GGkVhDgp7oIvnOYmcoJu
         n5flcB5223BZ1NVIeE8KEuvJXEDCfhd0cwhtMDq4U+I09DH2r92w+XMtjLqXAnP/RvV1
         R2fngrHiMetVbqMVnM+yhxUrjIgEYKKg8yLItARSohL3sSYXSCbue2cDbrXeq8lwyrmn
         ltpWMPdJlbsaflrnQeVjay+e9NDLKBNfhn+eMVXbMDJTjo7aQxRLgI6/VUMfUEOVLylz
         +WG40esktYOeYdEKZE9g+CLjgWdhuv9//ng6acODLj4/K03oQqz5p3MUz5kH2XEBrMpv
         Vk/A==
X-Forwarded-Encrypted: i=1; AHgh+RoqvgvxEnli/hw8A970k32ubQykp01CTaWcfrKsD/v0UkYgXVNXtw+ifkgAD71x/MH5kSd2U3rPB8oHDmYTgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwniA2RWqj9+xZj9ZbvK0AMcXubEqq17pUe26pIeQ4tUUk3rz62
	z1WeuZta2WPaRP09ZBrqPGg5Oe7qBMvMRUVrVo9t4F68oFuuoT4LjU2KIxRFvCpbLRrT1IFmpgY
	jrsLS/1gh/y5UHcvvfTNqnLHp2o5UJERPsvAf82na8AbZCth1it++avjRyxBPM2KbgSyUzw==
X-Gm-Gg: AR+sD13J/w+PDs6Ucr3M4qFuTu3soMG3pSooQPYwchwWETHhV8XISZ0Io7ELkBJbDLH
	QNJScLvSbCGJp43XYjIOqhcGOhwLbuStuetmup7ut2lYggtDFVfBO1Mnvk0rT73/O6LmVqD0Wfu
	oJw9xFwwNBq43eygCtwjeJijRvEv0dsOxqTtbYkGBNuu8Df+lqBvh7fBHWkxdYkO9unL8gjRkPB
	XIUItX+7mrr9w981IOh5zm9cOb1upb/kwwOqlL39e/ez5LmCIsDjADzs8l3kndRJ19IeDSulu0n
	tr7BZECZ22VZy08vM1OV1GzGJQ4/fHybChS3zBya9btFJYc+ENkO2yTntFNptaf3Zth+ZldSDDc
	VJ7lJ1wpWGP4bAnIWXoKsqmcyglaGt3DrNX2fTqoizSHEBZ47Ljt3f8USFnXPCu4myOnbwU3V
X-Received: by 2002:a17:902:ef48:b0:2ca:329:3da1 with SMTP id d9443c01a7336-2d0ca77f94amr469476115ad.16.1786329029423;
        Sun, 09 Aug 2026 19:30:29 -0700 (PDT)
X-Received: by 2002:a17:902:ef48:b0:2ca:329:3da1 with SMTP id d9443c01a7336-2d0ca77f94amr469475395ad.16.1786329028960;
        Sun, 09 Aug 2026 19:30:28 -0700 (PDT)
Received: from [10.133.33.47] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14da67e21sm26995875ad.37.2026.08.09.19.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 19:30:28 -0700 (PDT)
Message-ID: <e5e412c3-185c-4230-9dd1-ac4aaa2ec942@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:30:24 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 2/2] wifi: ath11k: initialise the CE descriptor
 waitqueue once per device
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
References: <20260805192129.61113-1-julius@bairaktaris.de>
 <20260805192129.61113-2-julius@bairaktaris.de>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260805192129.61113-2-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=d73FDxjE c=1 sm=1 tr=0 ts=6a7937c6 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=doWGV4GgMy9UnfXOfyYA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: 2WBG9l-9fTIJBaxxWVOIWnodaFTO1CW5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAxOSBTYWx0ZWRfXzHh54VlKprcn
 ACRbXdjIfMLbenevHSVd04BbMzfdNCvc6l3Y7IVSpnU+BS3ViJTm1t8l0Q+4bSashcMSTgs5V3q
 Zcb8rpIL12OFdwXriMjkNM6fo+5QAGCffvTTECKjqnsOfkIeVKMI4Mhh7LC5KBd03YI1bXQujtY
 XTLRgQ8dDn9u8YNa3N8uoyvw4ehjTTpx5z0p5kXC/iuj7Bm3odm9rw6xEIrbg4qVGeKoSGFWy3c
 4HXk47id5pVRtlX77OTfIop2UEd/JxPVYYiKZFn625A0p8O15OnkLzzGiGcojgj76Y0Gg88VwHA
 rxLNsKjFKfVcP1s22zZigixsmVNZC/qfTpHqEnM5xqZqUAj25z8EqvfNRmPYXCoJ0KSKv58DAca
 FnmDwxeq08qhLAarFn8iukSNr5koFJrRFJ2sqxQZSNxUwanorap7hVVKdaXQ5SwSce8zOIwF1Sr
 xcpJP866Qk7unmPwwYQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAxOSBTYWx0ZWRfX75z0rU2w7Dem
 SZqb1JsaS1Sv5FiPR+1x5JMOQMV8raT5dNKcR3LdruDMBsUYqJYZ8MqHUNStyme6Ye7NFteWR1Q
 +HrxhVlxObhRC3HW3/GSrB3PUtZ0lg0=
X-Proofpoint-GUID: 2WBG9l-9fTIJBaxxWVOIWnodaFTO1CW5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100019



On 8/6/2026 3:21 AM, Julius Bairaktaris wrote:
> ath11k_wmi_pdev_attach() runs init_waitqueue_head() on the pdev's
> tx_ce_desc_wq. It is called from ath11k_wmi_attach() ->
> ath11k_core_start(), which firmware crash recovery re-runs through
> ath11k_core_qmi_firmware_ready(), so the head is reinitialised on every
> recovery - including while a task is still queued on it.
> 
> Parts with hw_params.credit_flow clear - ipq8074, ipq6018, ipq5018,
> wcn6750 - take the else branch of ath11k_wmi_cmd_send() and sleep there
> in wait_event_timeout() for up to WMI_SEND_TIMEOUT_HZ. That is longer
> than a recovery takes, so an ordinary WMI command issued from userspace
> just before the crash is still on the queue when the head is cleared
> under it, and finish_wait() then deletes the entry from a list head that
> no longer refers to it:
> 
>   WARNING: CPU: 1 PID: 1861 at lib/list_debug.c:62 __list_del_entry_valid_or_report+0x110/0x154
>   CPU: 0 UID: 101 Comm: hostapd
>   Call trace:
>    __list_del_entry_valid_or_report+0x110/0x154 (P)
>    finish_wait+0xcc/0xd0
>    ath11k_wmi_cmd_send+0x150/0x2f4 [ath11k]
>    ath11k_wmi_vdev_set_param_cmd+0x64/0xd8 [ath11k]
>    ath11k_mac_op_bss_info_changed+0xe8/0xf60 [ath11k]
>    drv_link_info_changed+0x118/0x160 [mac80211]
>    ieee80211_link_info_change_notify+0xe0/0x100 [mac80211]
>    ieee80211_change_bss+0x1c8/0x250 [mac80211]
>    nl80211_set_bss+0x1a0/0x330 [cfg80211]
> 
> Initialise it where its credit-flow sibling ab->wmi_ab.tx_credits_wq is
> already initialised, in ath11k_core_alloc(), which runs once per device.
> The array is fixed size, so all of it can be set up before any pdev is
> attached, and nothing on the recovery path touches the head again.
> 
> Reproduced on a Xiaomi AX3600 (IPQ8074 hw2.0) with a userspace loop
> pushing beacon updates while the firmware is asserted through the debugfs
> simulate_fw_crash 'assert' trigger, on a stock ath11k with no out-of-tree
> modules loaded: one warning per recovery, on all eleven recoveries
> observed across two builds, and none at all over six recoveries with this
> applied.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
> 
> Fixes: f951380a6022 ("ath11k: Disabling credit flow for WMI path")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

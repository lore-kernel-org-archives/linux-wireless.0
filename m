Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496749620
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786329097; cv=none; b=OwuQ3JkEUKCJAW6FrlDVTI9ll4juI9X/3qP6X5BJu3zDI+CuWlvz9EsW8iQl5Cfp2S3v+eXbelZo7IBRGBhInnCMzPzKz5k+vt+uXuFHmYezug9lBhmr9Uu6H3dncRKXugFvqGM4ZFPDDWVik8yMbSk+pktrWs4RnwcNNMr1lGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786329097; c=relaxed/simple;
	bh=+hIwyz7zuBbwrjK7rbqtzT6TVbMXVKwD3eTEU0lKNDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAp55TtOtCH5tkIJQ+csPDE+4v9M1Vd3OzFGwBdv4NB3TBvSfFTnJiJYCdAyxUrXKmoJRK4ApFoJB0BdQP44peEUESx+v3LlsTPA6toTVi261/Yr4ptbf8BOZE3CiynsOuyVd9IqmAgCuLs2Ek1Qqv6rXLZRThkE2lhluvll3xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BiAmYbKq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OAKRImn5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BiAmYbKq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OAKRImn5"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679L79xD3778587
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:31:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1ElQOPq9Lyno9HZC6L2tTTKCPAbVkzXBSpJnNUmE3cU=; b=BiAmYbKqYwnXEPuk
	IcleM0++CrHTMf+nx8gnsBhYsc4LjRj5j1gm25CIpHZHzIAFnhhbmd9Bx5aL4zHJ
	tWofUy7OT9Ykr0UBemG45pwxJBh1nhAJ82Pi9lBnMLzvgEq8HLoMjOQEVpJw8HzU
	5c41grZORtoDNemlNfgfYjm3K8zQHd604DHHuyyWganBd9uF9OY7+5SC8EmJFpO6
	cMqcdP/DYIpkfzui6OQrm/eXtgLdzvadlqTek6xJ+ePvSd0q5omfDQtyVbcdTgSJ
	TdO6mcIOLsLQwTEegkpbBwrNmwoPfQz4yMwEI/+z435ynnTHqRVySCjpvj3PPAos
	7OqMbA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwvhvc0ya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:31:34 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8484b9fb055so3905008b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 19:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786329089; x=1786933889; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ElQOPq9Lyno9HZC6L2tTTKCPAbVkzXBSpJnNUmE3cU=;
        b=OAKRImn5K7IgsCyvHb1AGGmEqy1FQ1zW64gqPKe9A/Qn6hyzClvnJL1NX8KD4UPRG1
         9wkphVEaaGSTAiux0zoFl/WZPW3WPgMzV9S/pIhu5s32EXQYn3x4/FBUny5AlXNQnvWA
         B1SgBkl2brfV5BNF6cT82McuDEeEW5a7X/vs0V9eFWlYk0Wv8RjmCulf16Lol4CsdP7g
         4J2i7F0M4bfIAPu77HIHMMhp10WEjU4QhIkpxnx0FqlHqwAVaNW/UoOEAaFyjmd1uahh
         F50zA4RbjUySDIWhleu6tRDDl3cYmPCqZMOLQ4Ti6xpYX+yInYjJk6YL4W43+7ps40V0
         vE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786329089; x=1786933889;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ElQOPq9Lyno9HZC6L2tTTKCPAbVkzXBSpJnNUmE3cU=;
        b=iMdm5GBPn04zmw5oZRvSesDsBi+vLnZxRKrWg/MONettxrREe+6/6cZAyll1Eqw3fE
         0ritTXgAlLh4ZLYuI4vn6B+m/jOPwtHdDKHT3O4dNaS358eH5KP1yLXzvVBqIvILi1RE
         bDxA54LGA7bSo5K3NMP2IZOA+b9F/poNor+zBmnJN6Q+c05JBRKUkuy5Bz2ovi1AVPH6
         T4nzq/WWYT1LCTysJWCftN24CnnroH48wosqEh8HdvlUR09/gZKJboURjG3SaW5q1juy
         OQp7pYIJ3oFpnWPWhfz+TdisXjWiAowA3dAel705AzQ0UtE3k5gaAgg+jpfHE3yC6TsC
         FMJg==
X-Forwarded-Encrypted: i=1; AHgh+RrRS16QdxBfBLuU9lw3Jsfp8DY49jTdXVkIiZe4AwIqb71pDdak8ePkWMdP531gPEOc57gHihQKSZittr484g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Xoy7Duf5qqUOJHmAX7Vtf6fDlhAzOSW0P2hcc6qSA7upPzP8
	xYRPFCUw6hdvdjYcU99jRhhgcLPVCRPd1o4HogY0gtBmvlBNUuVxFWRAzOcbQP2f0hWwsD4q3GF
	kikhLU0vc5Dw8KSTmL/MgB6UTIy0O7laB7PFjN8dP12yAwQD/wfzOBeHNBvD78PJTCl9t8w==
X-Gm-Gg: AR+sD13K+mS++bdAF5tr/vtNsF465nfL6tO56GyqrUUUaA4tQRwgubLMuzsgphuMWpc
	EeNvEuwXtrAHLV4WedxQTh235Pq4mdKi48ZN95F7EymuN6uutWmDna9CDUjJVv9E+mYBvzWS17x
	4PG16V8gOIx50hBHvt8KoRALIo/xzzUdD2FqSLq5eQGeQmbsxOOp7aEaEd2MqDIbo/S2B6hhz+B
	PFhuyHyVj679OEjkjh1ebj/KzTzoXCLSqypQ20vHAQmcGFTBwQkChSzdRj6B6PFGmhHnFgzPLWb
	t48tdq1LwuytnpQHKpi8mTnFVqbmTpmL9pDpjA3ICBx0CHOZKuG10utNDk8m2ZZOeBw3Oop/V2m
	ejKDEZXlPaxtcIy3IaG9ZyuZTOACefHHwOma/h3T7qV7KSkScrZdNM6s7ZDcEEdv8icb9EMPu
X-Received: by 2002:a05:6a00:f03:b0:848:56d4:3288 with SMTP id d2e1a72fcca58-84f5df36ec9mr22848552b3a.4.1786329088879;
        Sun, 09 Aug 2026 19:31:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:f03:b0:848:56d4:3288 with SMTP id d2e1a72fcca58-84f5df36ec9mr22848505b3a.4.1786329088424;
        Sun, 09 Aug 2026 19:31:28 -0700 (PDT)
Received: from [10.133.33.47] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f372b5bsm3043615a12.25.2026.08.09.19.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 19:31:27 -0700 (PDT)
Message-ID: <52dbbae7-f399-4f59-81f5-5d920c0b5e47@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:31:24 +0800
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
X-Authority-Analysis: v=2.4 cv=eqbvCIpX c=1 sm=1 tr=0 ts=6a793806 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=jssK9KqoyDg6S70j6i0A:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: wFFNxbCrupCThw4jVVM3EC6wKU-9lkHj
X-Proofpoint-GUID: wFFNxbCrupCThw4jVVM3EC6wKU-9lkHj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAyMCBTYWx0ZWRfX2avLZY0UGdQN
 4XIRADweY6/YRfdiY+N9+qJWg2yJnjCa7Ky/l+3V46NgMzR5KLv8UWisKSU5J6xOw0iipPW246H
 qW24Oh5AgLvl4hlt01WbxyQHBgDnSk37JT84urEWzmgtLQbTzvHcosleZrW3lCY6QJFmHZE9B9+
 BztLnJExAnhANFIDzbsmS1bh41VHat2Jz9jeUU3yrbqhLhopLhTJ3sizH9OwAY9z8wTngjBspn3
 u0KzW8k7tCRM8l0KIRVS1lEgklyBo8ezii0zp2nVnoLEahKCqtA5uw0ZUK7G8rtDZz9K+yqlWu0
 4Els6DGIet0LmNVqO5jvRLXRNj/5wqTTpPYCuWFyNAG0EueIZEBLTjcAEISoWmem+Hrigs0RoVO
 j3uzyDwizR+bmvCdo9kamS1NHjpnyonQCEYlf9HVAK3ybSAb2krB+T6uKRwfURX14yObnHEU3IV
 vEm8eZ6qncLHe2dnr8Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAyMCBTYWx0ZWRfX5lbR38tepQQX
 V68R9DXghLYefotvfetj0lXUK4j9AWt0pN01If3uh+Q2H8NP4WEjxrXfuhp3ADYma9f1BXdbmv4
 T1YYS22+DhBZZAuK6HCQRXFk1eHt6hg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100020



On 8/6/2026 3:21 AM, Julius Bairaktaris wrote:
> ath11k_wmi_pdev_attach() runs init_waitqueue_head() on the pdev's

did you mean ath11k_connect_pdev_htc_service() ?

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
> ---
>  drivers/net/wireless/ath/ath11k/core.c | 5 +++++
>  drivers/net/wireless/ath/ath11k/wmi.c  | 1 -
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -2746,6 +2746,7 @@
>  				      enum ath11k_bus bus)
>  {
>  	struct ath11k_base *ab;
> +	int i;
>  
>  	ab = kzalloc(sizeof(*ab) + priv_size, GFP_KERNEL);
>  	if (!ab)
> @@ -2772,6 +2773,10 @@
>  	INIT_LIST_HEAD(&ab->peers);
>  	init_waitqueue_head(&ab->peer_mapping_wq);
>  	init_waitqueue_head(&ab->wmi_ab.tx_credits_wq);
> +
> +	for (i = 0; i < ARRAY_SIZE(ab->wmi_ab.wmi); i++)
> +		init_waitqueue_head(&ab->wmi_ab.wmi[i].tx_ce_desc_wq);
> +
>  	init_waitqueue_head(&ab->qmi.cold_boot_waitq);
>  	INIT_WORK(&ab->restart_work, ath11k_core_restart);
>  	INIT_WORK(&ab->update_11d_work, ath11k_update_11d);
> --- a/drivers/net/wireless/ath/ath11k/wmi.c
> +++ b/drivers/net/wireless/ath/ath11k/wmi.c
> @@ -9064,7 +9064,6 @@
>  	ab->wmi_ab.wmi_endpoint_id[pdev_idx] = conn_resp.eid;
>  	ab->wmi_ab.wmi[pdev_idx].eid = conn_resp.eid;
>  	ab->wmi_ab.max_msg_len[pdev_idx] = conn_resp.max_msg_len;
> -	init_waitqueue_head(&ab->wmi_ab.wmi[pdev_idx].tx_ce_desc_wq);
>  
>  	return 0;
>  }


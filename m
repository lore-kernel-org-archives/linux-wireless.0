Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8A32BF4B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785476484; cv=none; b=td5wfL9X8SA3VrSLlSD185pfpSkNU2XyYs6CuY+A1y6XmhKB23i3H0tKQbMVyTFakBloPx4sgLZzNI5pun4OZC04/RVHVX+z5uNNv9jfqC+j7fZ7xWGAuAJZF25tUEZfiHlMz0KATiWCYEg3feQDBlErHuxq36pgH/bgP7oaySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785476484; c=relaxed/simple;
	bh=nMpKaR9+0cxCIKgp8W1MvMvGO8IveWheibV25oUB3eA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MfGoHJUdmr1R8mrm/jFYfXwThyui928u1cU5BuEeuGMQlXTxmtYb4Vx8X4WyqFOOR50VjGOtgo3SJ/jJeozNE2MTFptLl/nx6tb4wTjKachwfyYtAQxG4DMhJ6IJo5ZzKnjsZcfPSnLUF/PTwFpt7jjqfsOsICaztC7FFitKeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FLkF40Ni; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MFk9GhEc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FLkF40Ni";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MFk9GhEc"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V5S9j63061472
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NX/iu0bYhziICD5K+z/Rbj/ZTb4Lq5nCvI8MiPr7q7g=; b=FLkF40NiXSqVmjIW
	zNZ5EGqu2gv8A/aZcogpGSvLV9d2iza10HBXUqP55QgiVPqTdWtS7aqjYN7mCu6m
	PbL9yuMnHevYOk7V/mTHkAWh1klnhjFfgqldlXBetPyJc8YP+8Yrzi6nMP6uc0Jo
	LQJkOV6UXViDxR9znB0PLh6cpA+yk+pZ5tL+xfZszJhQuDuhuy2SutYbQXbJ9jcE
	eCkG3k1RmIg4lsUwyt1gOSS28MLRDpq5dLq1hXmTLbBNDoz6CxHCuBzqy+NCjOOv
	q3xPS7oamO8SnddhmgkV8sYBUSNxiiZRVT0/uMA6VXeIAuW8LaUlT1f2vHdhvAsf
	4IkBYw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frnk981ar-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:41:21 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e375d9736so999899b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 22:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785476481; x=1786081281; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NX/iu0bYhziICD5K+z/Rbj/ZTb4Lq5nCvI8MiPr7q7g=;
        b=MFk9GhEcpUPMZ40D4QAq8pVfwYqa8AQymekTX8vUcrQWBTmdpdXjERrOTyb2uF3Yuc
         vUhLR/uBVSrK3u/aSqZYloQRMXzBt3vW1f5lqv7IdyVnuEXs841w9ganG7F1u0+vMIEB
         zhyLsUNlzvcVviBt+mwjoh72OM8ioRl2X/IzD0YRgKQbj8fDB1WVENbqK+Np/f2ogRQA
         9NO7w4Wg00k7EDFrcdvz2ieJuZWvH7gytr07SHzm2bGV2ZFhJLeRnsERLT99yklsk9m/
         /cbzGoBS1NCkRlMf3pCt2n9FY9cRhnJlyS+bZwD1+9yBsoEqB5P9GmQ08Qpc694bkljr
         AUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785476481; x=1786081281;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NX/iu0bYhziICD5K+z/Rbj/ZTb4Lq5nCvI8MiPr7q7g=;
        b=fKshmEFxA+RQEgpcgrpKQz5Z2RcbOyGjUGDbJWk21sujPo7ii7BH+XTWvdtApUU/iS
         5sXhIozz9GcrSnjkiq7vFX9riVVdOMjDwAk9cb656p+QTUjxIzeNz/3+3AeXLdGKtREW
         zck058L+C/XUlHCOk8GTBbBn/GmoxLogR0R4HszlBCTYrOjVN+fzi0N1kYo++IjOYFB3
         R/+ErDu2+xtB0byca2BmZMnsh3YqsyUUtlfdgy37XtOFKBLkTUs/Vpni2FtaEyc3Jdrl
         w1mmpMx2ayIZK5M5IucduVMJe9l4kvxZFI7WHDdBDjoDI4d633CT/v+hRi2LXIF+HIWG
         r4sA==
X-Gm-Message-State: AOJu0Yyb1WLUPZWyXcswHK/I1btgTXKntMQo9X8HoahLE2CsYV3zmqwh
	+Dnd4bRJBzlrFqAcNnX7HEHAe2iOQGc9O1C72RQM8sXERXEdD73G+SPPgjVSfsmFHKnjRXZ7qMt
	Bj2PvbwP2GSoazl5y9nt2gLIe0JkshFtuuiMFbhntatdwI5VLUi8jGo2jAD7jvmfpL8E5SA==
X-Gm-Gg: AR+sD13pB1uOJM+d+ScuipLozJh1tT99SvTRgpH5veuvj/xHprfgC+QGsfhRclr/h8a
	r3aNYhnyfsQHb35UtvvWC94cR97lVJOH751QOp4rUoeAIaJ+84BySY/Oh0K6NY5KvXuy7KbvKbB
	PypHDSh6um7ovWkA+M5bdY0lsemEm9xdiNTiLuy0dgjbNJeMJ2r8Dkwga8q5PqJ39pxzmsTPeBB
	n0Ov0T2b/4zKqiXSOKDXgLn/pWBLqkJNipuldjmWxcX2WSVhlVuSCcop5NBYDb4zxH/+5ffIS1+
	7Uvtb/R9MZqmB6FwM0tzCNN0926xtlp01ONm3TFa94i/If17W+gI/LlVcUJeJMuzGA57DM3VVAC
	xKVnowBWL11qAd4G0wwAULq2eoIYmABw9HAg9WIMvd/t0NulYOG83d2Gn8aXv6OITulHLYrj68g
	==
X-Received: by 2002:a05:6a00:399d:b0:848:30fe:da34 with SMTP id d2e1a72fcca58-84ed6f19e00mr584193b3a.45.1785476480619;
        Thu, 30 Jul 2026 22:41:20 -0700 (PDT)
X-Received: by 2002:a05:6a00:399d:b0:848:30fe:da34 with SMTP id d2e1a72fcca58-84ed6f19e00mr584178b3a.45.1785476480074;
        Thu, 30 Jul 2026 22:41:20 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ea11c0sm102663a12.24.2026.07.30.22.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 22:41:19 -0700 (PDT)
Message-ID: <4160b5e1-c82f-4083-aa36-18e4a42f909a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 13:41:17 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140306.133718-1-nico.escande@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140306.133718-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAzNiBTYWx0ZWRfX3+grxh6/d3Iy
 qrEx22FudPfhzB3/SWVfJA9gS3Ce/+XNcx1ida9QQWnlrASkpkVxJ9/FhZyyLY2VoyFmEbgfq/P
 oZeHRqYoBDIgFCODLW/qVVPCgQR+nO3OUCnB24VMVApWaWYXZsfWP3p+MIYkM7vIVA8+nzk9PZc
 jvIggUgJla9Xc4EbDHBJdxbtIslGKH8qEMuEyJQfroK6O3LiiLLtd1FwrddbKEYDQjmrEnl1VGy
 jwcP5LqlQLT++jd/+YCeD7icVcayTh1KHaFruhOyJzDlQmZWN8uRQeA9vTlnJ0GfDu65AB5Q4Ry
 qgwOuLma4nBOS4z+fhikJoDw0Sj6EP1JLqxfWgnRG9Gq36JL3VXqUiEERolgB4dSndfi+OJfTas
 zALK0YuaAgQfoW7lVwPKJebjDVLz86zI1TtusAaOfjAlEs8haomzKrpUB7lYw5zHcZ9LQH1K8t8
 ps6f2JBvEpv+etXWXvw==
X-Proofpoint-GUID: OPhOhWxgTuDBrrhn0SZ_euPHDBSxS8TC
X-Authority-Analysis: v=2.4 cv=c7ybhx9l c=1 sm=1 tr=0 ts=6a6c3581 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=pGLkceISAAAA:8 a=YD6fnDvLbndNWp0Zy18A:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAzNiBTYWx0ZWRfX3/yVsDK+rZwA
 kICrmI2fKY2Vseu/fbg1edw+0KV5Ido+x4OFNmA2WhS8U9c7zRN8mQ19/bEzGVzwV8VTo9fFfGR
 hPgmjpqkSHuu/xzGvonYwejBUgM7AAo=
X-Proofpoint-ORIG-GUID: OPhOhWxgTuDBrrhn0SZ_euPHDBSxS8TC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310036

s/ar->num_station/ar->num_stations/ in subject


On 7/30/2026 10:03 PM, Nicolas Escande wrote:
> When (multiple) hw restart occurs, we end up in a situation where we

by hw restart do you mean firmware crash and then recovers ?

> cannot accept new stations / mesh peers. This seems to be the
> 'num_stations' in 'struct ath11k' that did not get reset properly in
> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
> that did not get reset so let's clear it too.

the root cause description looks confused to me: if it is firmware crash and recover, we
should run the path ath11k_core_reset() -> ath11k_core_post_reconfigure_recovery() ->
ath11k_core_halt() -> ath11k_mac_peer_cleanup_all() and in that function ar->num_stations
is cleared.
> 
> This avaoids problems like those:

s/avaoids/avoids/

> 
> 	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088029] Modules linked in: ath11k_pci XXX [last unloaded: ath11k_pci]
> 	[1248828.088053] CPU: 0 UID: 0 PID: 12281 Comm: kworker/0:0 Tainted: G        W          XXX
> 	[1248828.088058] Tainted: [W]=WARN
> 	[1248828.088059] Hardware name: XXX (DT)
> 	[1248828.088060] Workqueue: events_freezable ieee80211_restart_work
> 	[1248828.088064] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> 	[1248828.088068] pc : ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088070] lr : ieee80211_reconfig_stations+0x94/0xc0
> 	[1248828.088073] sp : ffffff800025bc10
> 	[1248828.088074] x29: ffffff800025bc10 x28: 0000000000000001 x27: ffffff8027b19640
> 	[1248828.088078] x26: ffffff802a5619c8 x25: ffffff8027b199f0 x24: ffffff8027b19880
> 	[1248828.088082] x23: ffffff802a560e40 x22: ffffff8027b18880 x21: ffffff802a560800
> 	[1248828.088087] x20: 0000000000000001 x19: ffffff8027c71000 x18: ffffffffffffffff
> 	[1248828.088091] x17: 128c0801a9c37469 x16: 766e692d32464545 x15: ffffffffffffffff
> 	[1248828.088095] x14: 000000000000001f x13: 00000000000000b1 x12: 0000000000000001
> 	[1248828.088099] x11: ffffffc081061518 x10: ffffff800025baf0 x9 : ffffffc0808097f8
> 	[1248828.088103] x8 : 00000000ffffffd0 x7 : 0000000000000000 x6 : 000000000000003f
> 	[1248828.088107] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffff8011ef2e80
> 	[1248828.088110] x2 : 0000000000000000 x1 : ffffff8011ef2e80 x0 : 00000000ffffff97
> 	[1248828.088115] Call trace:
> 	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
> 	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
> 	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
> 	[1248828.088127]  process_one_work+0x178/0x3c0
> 	[1248828.088130]  worker_thread+0x280/0x440
> 	[1248828.088133]  kthread+0xe0/0xf8
> 	[1248828.088137]  ret_from_fork+0x10/0x20
> 	[1248828.088141] ---[ end trace 0000000000000000 ]---
> 	[1248828.090658] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 0
> 	[1248828.090667] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 3
> 	[1248828.090670] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 4
> 	[1248828.090689] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 0
> 	[1248828.090694] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 1
> 	[1248828.090697] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 5
> 	[1248828.090700] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 6
> 	[1248828.090704] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 0
> 	[1248828.090707] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 1
> 	[1248828.090710] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 6
> 	[1248836.686596] ath11k_warn: 39 callbacks suppressed
> 	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: e8:51:9e:d6:93:22 for VDEV: 1
> 	[1248941.120126] ath11k_pci 0000:04:00.0: failed to flush sta transmit queue, data pkts pending 2
> 	[1248941.120186] ath11k_pci 0000:04:00.0: failed to clear all peer keys for vdev 2: -2
> 	[1248941.120190] ath11k_pci 0000:04:00.0: Failed to disassociate station: 92:14:23:65:57:fc
> 	[1248941.120196] ath11k_pci 0000:04:00.0: failed to lookup peer 92:14:23:65:57:fc on vdev 2
> 	[1248941.120200] ath11k_pci 0000:04:00.0: failed to find peer vdev_id 2 addr 92:14:23:65:57:fc in delete
> 	[1248941.120204] ath11k_pci 0000:04:00.0: Failed to delete peer: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.120207] ath11k_pci 0000:04:00.0: Failed to remove station: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.121319] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248941.121326] ath11k_pci 0000:04:00.0: Failed to add station: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.123036] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 
> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
> ---
> v2:
> 	- rebased on ath/master
> 	- no code change
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 2d55cdc4d165..0baa46df1fb9 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -6699,6 +6699,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
>  	ar->num_started_vdevs = 0;
>  	ar->num_created_vdevs = 0;
>  	ar->num_peers = 0;
> +	ar->num_stations = 0;
>  	ar->allocated_vdev_map = 0;
>  
>  	/* Configure monitor status ring with default rx_filter to get rx status


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54287207A32
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785466977; cv=none; b=qdpE3kyosBKId40PFs/7046t2Vr75rSMhWdnHqHhhxSxA/bzCntSL98dABfomUQBFaA12lV3GekvmkxCG3+S+o1H7iBQorwMP+dAI6t2+nrkDJPV4PJy/PoyE9423Duqyv7lGv0lEtPFJEFtPsbCu67cvYBT7f/Iyqy4LC/hkhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785466977; c=relaxed/simple;
	bh=s+q/HuQN5V63R4HXyo0C9pI16rvumJgbQEhtO6XI9Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9EINpSsAswRFrlM3z13puIbOKsM2QIUQQaHNLiJdwCg0Tkhk62U6per1xjXKkgTaoS0c8n+N0SbuEXEH8tdfj5D0au6tUWI/tgXLFvPrbVGerIR1rRf4fQoaCScDsOhbTVF3NWqu2kA48O95qkIpJdb6VxLOMv7u1m4WrH76uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I7YQky1z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K/mqX1sA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I7YQky1z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K/mqX1sA"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V2MaVW2921854
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hzd7HiAYU90PZDzWOrAkwis5s2xwB7hkmSB9GxwH6r8=; b=I7YQky1zuAsGBYd2
	zYz0sty4B+6L7rwHg6mRTdQDUj3xbM3IB6CNUwwilszrkS5KTRpeHuaUvGyq5VvO
	K497+bUMT9VT5BM5iMM0WHIF7g3WA6tHuY7xtWZCdrPEnVtAOYcZrpqYr78KCZl8
	ZkIxFWRGWMVW1NWd0XYiU7pX/7fM+/93vWh4l1KShXrv1foGPSpy9ez7oIf8ymb4
	Q/muY9mLqKTTwf52gvnTu6vX7iiIAQZWmxPSDewxBnRkhcd5bOCBT/zPGiWd9heR
	XOFyse+MAdY0CZGjvbwJ9MvE35GAps0YUPUIp6l+ptZU119ALM3tXJGan7K/KBex
	ssN7tQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frjv58480-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:02:51 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c9c26587e67so348698a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 20:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785466971; x=1786071771; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hzd7HiAYU90PZDzWOrAkwis5s2xwB7hkmSB9GxwH6r8=;
        b=K/mqX1sAKN2pUQr8pghhm1bHUZxF/Iz9SZJEBxxYBvSyEBFNLEx7UeoDNAP6fEpQsS
         JcAS4XNPC/t8nzUfz712ipyvil2d3MZw9xE1q0Ny/d7LuhMS8YRHR/ONFvHrrY+PRh+o
         xmt+K/qkRM6stmpb8YfvUriqwlw9B0jcRrGsqvFuDnrA40+UsAqz26HX/Ylot5UpOQts
         4SyBwbfRcKNxs/8UIzeB1a8L2fuCGNeevAxq0bjX6chMvY0KEGMZXA+rjdbyYjcGSNTu
         vRcGckd/ppF/qGQvYebjtozdpCEM1DfyTAkoVTGQ6jPj7Xa8K2xeeorU4wMj8ioH8b0d
         c5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785466971; x=1786071771;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzd7HiAYU90PZDzWOrAkwis5s2xwB7hkmSB9GxwH6r8=;
        b=Df81Y7CfT+zOoW3axr7ffRsi6FDMvYz+wmjpEcxGoTkDyNK28L0vnhJyekZY7Lx9Ef
         2Ij4eodSpVyUb6mI4JABwMPw2GWJ2/MuE3WAQxcu+5cXrhpoCchuM8tHblwUzOm/WIR3
         +h6kiigI4v6wdTemE2kld1ep6p+vt/HR3YVWY8XuyUHXQZemg2MICs7tyLgRU1BGjqkh
         VhbENQ14zUQ/CoSOkEA3RF5fOsR/7WnanSXguLISH9QwrT6FT2P1GAeCDhHXIdnGMdDZ
         Oim7rLUBthm0slKjBx/ImjFyFlO+nU5EuIL07cXSKZ0BwyYxxvT9zsvH3YtWdHQVYhvd
         w8vA==
X-Gm-Message-State: AOJu0Yy/C3TA85t290jhlXBwbHWUwQS4nvzcaub3ca0f5J2mLihTzeXt
	Gw6L8JiCNcbQEtRR5y1bYgALVHlXyq31GKcovEtujtAbqqXWH3IoLn6FFgkGsE0mpXD38h/UxVl
	vjb/ByT57vTnUNpQ7cS3+Ny7rjnDB+d1jKqn28HRyBMhNO/zvvbAcYUnfaxUt4CQnfPanxA==
X-Gm-Gg: AR+sD11v5OIRGxRylxAFF9bLsF2G83BmaACBHS5GXJVCSAEJpspxfyDLH8fV1CCF+1P
	rQYwRhr2gkkJEz2q9CIfQA1I99r7qZTNC3mWJlaJFgQvGZwQ2hfYm5DzXG9L80C0clwuOGJpTs1
	GNVylX5jj2nBfNgw/Gdn4xFDNZADnGPymTQn+LJvRDGvG9OcvBclYqLtV3+SPb263V7UIAJFmq7
	yBcUP7Uc6PDJxqACvmNJrXXNd/TRmr+WlSBaBfbiw+wyuSGU1CfaYkkWTdDwlra48xiH08lGdMh
	o8lipM/F16UzYfBXPTdOnf2x0Mg+t0EE/3BNbeees2/jlkFZMXGOV5VdegrF3A2yWGpgTDvl+jq
	PSZ7/iQXqIQXY+JfGG4HBllp7N89eo/pa7a9uEI7H3gg2YoxCs8bG/Bkgmrc=
X-Received: by 2002:a05:6a21:3417:b0:3b3:ccd0:cf62 with SMTP id adf61e73a8af0-3c91a9ebf03mr237451637.36.1785466970695;
        Thu, 30 Jul 2026 20:02:50 -0700 (PDT)
X-Received: by 2002:a05:6a21:3417:b0:3b3:ccd0:cf62 with SMTP id adf61e73a8af0-3c91a9ebf03mr237410637.36.1785466970071;
        Thu, 30 Jul 2026 20:02:50 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153aeaa6f5sm991434eec.25.2026.07.30.20.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 20:02:49 -0700 (PDT)
Message-ID: <071813f8-c384-4e81-b395-c213330a6745@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 20:02:48 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: cleanup arsta in
 ath11k_mac_peer_cleanup_all()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140232.133500-1-nico.escande@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140232.133500-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: a5e361ixlzxaCWrfnxz_bHKo933Rvq-A
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfX33I4zPmzbgoP
 Lch5W4WIbDblZ80xCtrl/ojV9J2U19mQ4TzEKx6ztlV4aC4XVEIesW4oFKW22e7RUocz44CYhyb
 LjIZ/HJAupwx9ultRAe/Tz6dOSk1lwo=
X-Proofpoint-ORIG-GUID: a5e361ixlzxaCWrfnxz_bHKo933Rvq-A
X-Authority-Analysis: v=2.4 cv=co2rVV4i c=1 sm=1 tr=0 ts=6a6c105b cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=pGLkceISAAAA:8 a=fPzbls-HzLpkS3J7q7oA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfX6Axb6cRwngx6
 ULOEJ5CgQxcYZyueZ9VlpGhEGAQcgwFPS1+wOrJYmMqjRmBBqHuIjVhHUKnWrd3HUecZk/v1KjG
 VjwRVr7U2knYIoiCSa4lawNQqmKJDye0nWMcXZF6IFasFCeKsDveHmwj+6EvD0gUy+ff0A2DSq0
 EiLHyYpOSzP0cxXETFC6H5QDa3gaj0prMgn3gfeoQ0kBBVhmRmH4DoLQ6d9hnxabNc8V/RGM2ob
 yFO7FgqENKAnSyGspX57/cur7JhQmYOdUIcB6Dn3w0LF0moimNI07y1e74SZZKeq7cpH/gP3u45
 h1IKR5F9DO8RHUPVZ2frnzB78bv0Rs0oYT/M7f3I9cHs+O6IMCFhKhk3ZvE3oUAJC5i5i5N9VpX
 3OwrEbDb/5EDuMbFEXCPBWmgl0TEYB9uNNliGRY1h1lCrPeWrLV7p4F7TAyHPlLpvR6cRGZCy5N
 9V3W5UP2kKpOGbh73BA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310017

On 7/30/2026 7:02 AM, Nicolas Escande wrote:
> When mac80211 removes a sta, it calls .sta_state() which in turn calls
> ath11k_mac_station_remove(). In that function we clean up both  peers &

nit: extra whitespace in "both  peers"

> arsta related resources.
> 
> But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
> assumes that all driver related resources are cleanup up beforehand. This
> cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
> in fact free arsta->rx_stats / tx_stats.
> 
> So lets extract the arsta cleanup from ath11k_mac_station_remove() into a
> new ath11k_mac_station_cleanup() and call it from both there and
> ath11k_mac_peer_cleanup_all().
> 
> This should handle kmemleaks reports like:
> 	unreferenced object 0xffffff801ae66400 (size 1024):
> 	  comm "hostapd", pid 1306, jiffies 4295011565
> 	  hex dump (first 32 bytes):
> 	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 	  backtrace (crc d61c08ec):
> 	    kmemleak_alloc+0x3c/0x50
> 	    __kmalloc_cache_noprof+0x2b0/0x3e0
> 	    ath11k_mac_op_sta_state+0x1dc/0xb10
> 	    drv_sta_state+0xac/0x6f8
> 	    sta_info_insert_rcu+0x314/0x5e0
> 	    sta_info_insert+0x14/0x38
> 	    ieee80211_add_station+0x10c/0x1a0
> 	    nl80211_new_station+0x3e8/0x680
> 	    genl_family_rcv_msg_doit+0xc0/0x120
> 	    genl_rcv_msg+0x1b4/0x258
> 	    netlink_rcv_skb+0x4c/0x108
> 	    genl_rcv+0x38/0x60
> 	    netlink_unicast+0x190/0x278
> 	    netlink_sendmsg+0x15c/0x370
> 	    ____sys_sendmsg+0x120/0x290
> 	    ___sys_sendmsg+0x70/0xa0
> 
> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 9d5f28c1366f ("wifi: ath11k: fix connection failure due to unexpected peer delete")
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
> ---
>  Note: this problem is in fact older that the referenced commit, but as
>  it would need another patch to backport to older kernel and the leak is
>  quite minimal & seldom happens, I was hopping to not have to do it.

IMO you should have Fixes: identify the patch that actually introduced the
issue. The stable team will backport to the best of their ability, and you can
always choose to not have it backported to LTS kernels that are too old

> 
> v2:
> 	- rebased on ath/master
> 	- no code change
> ---

my review agent had no issues with the code change

/jeff

Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274E435C1B2
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922046; cv=none; b=ePgrXcfiEkGrE2PLg7qiPkHPwJyFwVIuU9wGMH+xZk+nlO/lsrTRjkz89fH0XYugLFk0/uiKufJuVuMO4l9YplJeQY+53D4+drD5fltUTqPkYSkv2CQOblZN3yz7pqSk3vVa+mjvnB53gfZxAWdtpqBOpEL6r/RagTd7o8Yl6T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922046; c=relaxed/simple;
	bh=bdGwvGNW+Cwss57anNSyddRFMF7wWP4QbrUCEea6uZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7HUQnWk70eMIvpasL7YjOgBiYJkhvsIKuS4pZkbzes7wQ5yBSLFLBxf6LQVuklijyOP5B45Pr9RV65qQd5ayE8D1AkG5w8ogPf+4uwptfypvJpli5vnOfU6TnRAlg6E1XC4AyStr1HlK8zGf+Hj8U/lf6l05OuPKmoLKQM3szA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lY0S42E7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fjO77g7r; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lY0S42E7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fjO77g7r"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6759DfG12442038
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 09:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VcUBPbLFrH43P3Om1CNUHd8LvyM1EvziGffpmXDyf2A=; b=lY0S42E7+zWb3oas
	qaE2XHFoIVT6TFAHQ445Mep3mxh7Hk+QoBM6f/N71/7mkSfDmCkARiEBbeSUIWvJ
	sWKGF9Ho0Ye6uNMeQLTlFviW+r4rgrP+O2WilZ3p0H6e9oTb6lvseaB0huZlf6Wq
	tiItayEn8snm6j1PXCTCDYWh913lTiIjpoCYmwoZ2iqVRPKAbm6DcgbkE6LHl0QI
	GUDsiiOArUMAKMervzEZS2Z9w9ICpasuGjVx965po+iUBLOTOBskse5cnMzS17Ns
	pt2LSylLANmgP4QU5UuaLT8YLpzBYH8fhidYeDSiTQArAERF0tLPSNeiuEzyPjBQ
	axov8w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv2c0822y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 09:27:23 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so881913a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 02:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785922043; x=1786526843; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VcUBPbLFrH43P3Om1CNUHd8LvyM1EvziGffpmXDyf2A=;
        b=fjO77g7rgVSE3PQOBPSYKMQe1j/2vko3WjhREl0A6gHFIUwE1iQHWJmnO8K/T8Q19K
         deCmM65eh266p594EqhhHklEHp4F8BZRN0og7D5SxUYmOHZ63BUT/0Lj4lGSe080FesU
         ZGkCgdT0Ia5P3S3kLNuEm5xovIn9HapJHlkCAE4YCG/Lg5BXJQucR2wY9nRkxI9j07ch
         Mw6vMEjNWZdPEoqk0heRUNVCRmaIWEGcakn0rzGLfoE7wHTk83Ejsa7NcYOeCt/KotaT
         rPGgAORxE6QuWq7GAXM0cq4gJ56uBz1Aa3yMG94fHCiGCcjwZs8yYE1UI7Z1gJmAH9hP
         7CQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785922043; x=1786526843;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VcUBPbLFrH43P3Om1CNUHd8LvyM1EvziGffpmXDyf2A=;
        b=DXx3bOxPxR/QMLfpM9aW37kygqOpVDdonNLEU6Mgxsu1/A5HAA2a9qFobUQHNQxNGc
         SPzGnIsK8GqeAw0V7BLFbsBGhLXoPGaXlV+curGgV/YiQNL9BheRhWr62cDg0t0foAbK
         7dx2oKUqpmnGUZYStyR74TqyJP5ADi3wEJrDLK1Ql92eXI8smfYX48qrp87EQxBWfV36
         bqS5MVjHqPS+J942jS1uARDWW19pvVRCTR5kGHc0SK6RgtNsRzIHpeo16AXvC/Ld8Xbu
         gVtv4/ZeeDLUDX7PnGx7GYlH01nfUz0ffzMUjivY7cpYpcRQ3KNh6y95v/n/BKyUmIpl
         SsYA==
X-Gm-Message-State: AOJu0Yy/nIHlAIdt4n6nUbrGD1kP6BFesinRridcJYAJ4mb4zHl92Lfo
	5QeiSmcj2D3lOtxynf8kAasjrFoOdrd8e5FectARr5QTvuVynZ5cDKmbHikF+a8md/2jD3Z65Mo
	CBAsngzWswfMSZQj5311lC6OR6bzOQviBTCIdFS7aseA9cGsPm9I96Q7BvbvZWq8kDjooF5AU+G
	/PhQ==
X-Gm-Gg: AR+sD13qG9aghMM0G9ZHYbVSWE7IDZdWWC60kBHQqJ5g+JavelywUi6IvAhfsdGMieC
	URpU8tKK3NIvWmJwyS0HvJl6fMNtmlPEWq5r2vstNYcfrNpH7keExg0FLykkAjgdZlmRqnzWzNR
	TyEu7Ug4WpcXdugS2lZxwuRoPY+KiIuptMcTGmDyJOZE24dX29k3FAbB9OqoxACvpyo/7Gsx/oY
	xT8bJ6feWIVA3R+FxdZ74u2JdIgYyEkcfMdVDleK3BUIMQINxKE9IIkTuxmAMigjDC4QvgxhSze
	chU6AIpdp6bNybPzHI/BB5T1lXZFEnOLwCGvFOl5d2lkoEvOs6FI9E1IU3wFLhhkMIOVTgJqiNx
	9ClqryCAi6UMwLqpiCPeVIbARq5xd3YMK1Qpcrdcj
X-Received: by 2002:a05:6a21:3397:b0:3c4:46ca:3347 with SMTP id adf61e73a8af0-3cb85e2b693mr5968752637.2.1785922042605;
        Wed, 05 Aug 2026 02:27:22 -0700 (PDT)
X-Received: by 2002:a05:6a21:3397:b0:3c4:46ca:3347 with SMTP id adf61e73a8af0-3cb85e2b693mr5968710637.2.1785922042151;
        Wed, 05 Aug 2026 02:27:22 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863b0c61sm15105674eec.6.2026.08.05.02.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 02:27:21 -0700 (PDT)
Message-ID: <f835081b-991d-4622-881d-e75e723f1059@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 14:57:17 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v3] wifi: ath11k: cleanup arsta in
 ath11k_mac_peer_cleanup_all()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260731145830.769811-1-nico.escande@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260731145830.769811-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: JmNWGklLjVt6NJVa4NkpP2rckhsKDUDw
X-Authority-Analysis: v=2.4 cv=aOfAb79m c=1 sm=1 tr=0 ts=6a7301fb cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=ET-C_lD-THr5xxlFSyEA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA3NCBTYWx0ZWRfXwupY1ZC2TCl9
 F0ZthsH244m54IIsGC/1UnOISG8mti07Xd5l/leoGxNQFTEI08asjC6Oj3PNM628H0FsDoyjsH9
 l/3y+c0avb9SY8/c7H+hh6Bo95Z/dz0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA3NCBTYWx0ZWRfX1beaRZ7m5d0j
 JtW3xqyM7vtlr8jkGaYKCpzlsSSf0NARSQl/HQ7QNvAToL3PXEvc/pv8+boqwrRmxWIKYbtmXvT
 V+T9xIO/sMZifabgB7fKm+q9qCANqa883iaD/dzw0uU18cqivJR/202hUpQzolDiViNJ6eFOaMx
 r8LDuLId0Zfwc5ATl2O3SlfD4q/cOUKEs5c4fhQpdjGdcipg3NbkhY4rF4Fpkwy9XB9s5niOLZQ
 he+jR3JHnC7p4H2fTeiaf0s9yQNILqI5zz/cmFN+9kOsGtIJK6IARRyBJ5+ZbG+8AxtNKetVcNx
 l6vNOR3vy8eOTv6psWinTJuQGjMZkVi097SsVSpv2yPS62cPj9wJ6S/j2YRLDzv0q4EjTF4rDrP
 rNNlqZRa6H+ch/YZSvrrzmgHNGYzj4jdm1qc3aCOu/Vf3H/h3CJjc+YXg2kPn6McuxjqGzckvx2
 4Iu5Y/srIhduL/RXYow==
X-Proofpoint-GUID: JmNWGklLjVt6NJVa4NkpP2rckhsKDUDw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050074

On 7/31/2026 8:28 PM, Nicolas Escande wrote:
> When mac80211 removes a sta, it calls .sta_state() which in turn calls
> ath11k_mac_station_remove(). In that function we clean up both peers &
> arsta related resources.
> 
> But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
> assumes that all driver related resources are cleaned up beforehand. This
> cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
> in fact free arsta->rx_stats / tx_stats.
> 
> This extract the arsta cleanup from ath11k_mac_station_remove() into a
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
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E043345EC9
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516185; cv=none; b=HHkfjOK4siI1lRNVEjRSAD8X1yKPmZTT6MxdjTsJN7fxd/FVe5F9hYmnGpay97EaKhSrzbma1RmhHc38wQ+W+27Ui0e5bXJ+oq6pIzfs0eXj4u24Hw3ZYrYdhbiPS1SOHDKyIhYAALWu/1XIXJBUPRaegsxjMdoraLOQ5ZHCvF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516185; c=relaxed/simple;
	bh=b6Oa4VlvwNaUal4cbsO3CDf/0HMiNq2ooy0zoV+h2rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXGlWEnOfljU1W1Bd96UdG/KrqA2SzD0BNZxtKKTl6jpSQEYdMy/el2CoBU40sj0jb09dWTAJxm/QoA5lhIQ1o+IPyP6kAII7qs7Is0/p7hTC8ihWjEaOfc/414x5OTW3WuijX20FLM0F6t5lHBYvEUU1v6cy3O0PbpEdxTgwrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B5T5KwFh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PeCvwwuU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B5T5KwFh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PeCvwwuU"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFO93m1399382
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qfuxMqhwzMkVhbfUi3o9OQG8MFvHtQpWhutULoqcRSY=; b=B5T5KwFhf101rGfD
	2hQBiSDeCjerONLSuZwu5gPJMp+5g91AYQwQyAkGoUkmX6ZxDi1cf1aaksgUwPQ3
	WAfe/ZsbRB9e+gxNZEaBclShSDsfc3606rngw+NIKLHwBRWAd60thfpYnkdKaFJW
	s2AzS2LTNFIrtDOXhstz+Rd0/BAj6+XXASh96qtHQe35JfK7MS8ohEC001t2ReFf
	lMf3lT7P0NZlrd4wfToyIJE4mQloy3roKIncEyoEbuexioKMISdFJkBpkSjmOpLN
	Asp1NUvUEH2uPd3gNXDOzEzpug9JdC8Gn73r+6OOa/Ss8A1PxceokFbgNHQzRvaO
	t1V+5g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru1x9a64-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:43:02 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1269314a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785516182; x=1786120982; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qfuxMqhwzMkVhbfUi3o9OQG8MFvHtQpWhutULoqcRSY=;
        b=PeCvwwuUjnHYLlkJogOd4V9J4LN3jiDdmAfhljDaDmawEwAKlUFxIT41HNlQ1zf2H6
         x6T4Hz8yLdHctvnKI3Xgp3G02/7f+8PaUMW+0UpBBhun6s23EMC3fT/FaztZnS1/yGnO
         bZZrX077CH4fwwv276/S/7vtyrmPAAIr4A+cdF3L0bA3vTrvxv19VjSOp8W+KAPI0KDF
         K1R5Ko+Jpn7uiSzlAcoj6c1yyIwGj9G/f3hmL9Vw85ahkyjjY5fOeKZxRSMAOWukFHex
         vhBxJPbnP+68OMFdPPg34JVtHLjzl3MecBXGTCRmyjD4Vzg8Y5XOB2+3hz4gpWE7Hnax
         6UnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516182; x=1786120982;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qfuxMqhwzMkVhbfUi3o9OQG8MFvHtQpWhutULoqcRSY=;
        b=foxpCAG6xIrDzpFwx8VexRGVcYn1o7n9v7zUcBeguV7XbCRYJIkp0iEfabyHXRkV1u
         nrk6wXHwp2avSw8A/md9ad36OD9AgqhNLD2NtsbTIPZfDubuqA69A0Xw8PuLlsZ0b4kC
         IjqEtlzMEm9goM1Xx3r1VeijKk+TbLPkoA1jutccD8gkL171l60rnXUGcdQe5ll/rpKk
         aWbgqRCcBVvfs7LP1SPwSN82lMsFUxJjN7MnVG8TtAkLctEkwwSZO8oMolVS/sF6fmrq
         NAGcpBGDBbtodH4iLrnTIJSoNNRYYKtOV/mZ2kIWFBT14K66S0+zMHfhNMsGqKcz+UR5
         yaxA==
X-Gm-Message-State: AOJu0YwKzOGo+wLsc8B7QIoC8MZA05puenrFTaYdhkOWU2Y/XZzubH/A
	juNJOUvbsJTZmMBw5wodVjCHPi7SrKpDrj7Yy0Jm4d7/y66snDVEj6gDaXno0MGUsUVFTc+ooVB
	PrvyePwCIno+YcMnUJnkMxM2tWquJs3MKs2FbvTAGlSfiDHtGJc5GQGwGdrWSfuTtTCPiTxVn7M
	TL2Q==
X-Gm-Gg: AR+sD12QvrCU/nOsjWoaiNkT6ujs4dfGRcSmvt9p5c80hpa1OKNpTGvME/aFYKE/mVI
	a5wA+DoZNB1WoyffoWUVsNiPyV8QjCSadKqrxx3IAEYCYKkyXCMO3sGp7kY6r3NilrDm2aKox9n
	x2qcQ6EOm+bSANGmSHurZ9WJTa4cO4Ab2mq7APw0preYYxFk/8LzbC4qT9bXEBvlNKNjmAeMu85
	KErVfvLKKKMebGudj3bGdNQcgFxZQ+hkMOsPl7LTm77zQm0UC6WxeEiNqVNMQ+IadfAs+0u0D8M
	9CBUkSPuPPa3NgpXitnXbg8oL04AowJi8act+n9zVXFfJMvn8bw8oCWax72RXSMyxbR3PYgDuZ3
	eI1JsL+6QIxU5nr5zjdqtxwEOXd3G0EHSlP/ET6e1LlZ1Y+Cnuxd6+yojIbAD
X-Received: by 2002:a17:90b:3c4c:b0:38f:159:f6b2 with SMTP id 98e67ed59e1d1-38fbc574232mr475508a91.40.1785516181832;
        Fri, 31 Jul 2026 09:43:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3c4c:b0:38f:159:f6b2 with SMTP id 98e67ed59e1d1-38fbc574232mr475465a91.40.1785516180654;
        Fri, 31 Jul 2026 09:43:00 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4cb51asm7148284c88.9.2026.07.31.09.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 09:42:59 -0700 (PDT)
Message-ID: <53c36618-10e9-4e62-83f0-c872ed51847f@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 09:42:59 -0700
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
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260731145830.769811-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyNyBTYWx0ZWRfX4R2hLCcX2VMT
 kT6ORpSCy1qnzenlBPu6SOdPRvfTvHftwexmww9Rtdd5VU5pv2ssnP8FzB9DXBG9TKN685jQhFC
 3FDgxmXaaxyxomgQU6Yq+khQNudJSnc=
X-Authority-Analysis: v=2.4 cv=GpByPE1C c=1 sm=1 tr=0 ts=6a6cd096 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=fPzbls-HzLpkS3J7q7oA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyNyBTYWx0ZWRfX3KGTfCbAcdjm
 vrLw/ndpMnOqeD+ztKEmPIUQ6ljPZgiYwDeraGfGOrFpy6qNu1iqscEgP3Sp5nxTIUsuDiuupB5
 5SDSsZAn0UZHaMQRwfR5PjHci9u99lOGwctRxZKFkpYYpu4HfxcoY6EbxH9x9mowM1PsFuqfs8z
 IPlBnTYU5GYVTDl6fq/Nvr6ojLxLhrhUIGJpu4TTw0Ib9sB0wCxyX+L7xxTUSUI47aeTE7wiAnM
 jec9NX2ZNUSyBVU3RjDRWQa+lpfo24POy5inxr/lJsCDnc1YKrfzaj0XFCWANYkCoXhGoFJQeKn
 tbqvYDomPbXJVF/YpSlvoHtMsI/gWd7wkMM+QDKu/KE8PKVh9ytZi/Nr983QvzMmIlcySxG5my4
 BSNCziXSwk1ZJpqWtc2EZihTIdXfZhjxGLQxm5qlV4W50wc+Fwcy4g2ITDNeOvg7A2M96dWua4f
 QEYBu/juUTCj6u7Xqlg==
X-Proofpoint-ORIG-GUID: Y-YmgZDcbA-RAEt32tzKZHixjBvY0NWx
X-Proofpoint-GUID: Y-YmgZDcbA-RAEt32tzKZHixjBvY0NWx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310127

On 7/31/2026 7:58 AM, Nicolas Escande wrote:
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

Since the new version just incorporated the review comments, you should have
propagated Baochen's RB.

The following will accomplish that for patchwork and for b4 that I use for
maintainer work:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


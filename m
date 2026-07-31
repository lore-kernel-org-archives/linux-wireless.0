Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C036631AF1B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785469607; cv=none; b=FGyDv9IUe0COZzKcAbN0HV2GeTD4y+hhmG3sbDJ2qQtH7C2c1/b9/GJMgkG9byMmJaNBq1CA1oR1GIqQPMzPGABTlUTW/HgWalkeDeAfSXbsD31mRJTeIqvmNPffAf4T2DuEfzAdowh1drny0r/lv+/2+pTGZKbq3Hv1+d/53yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785469607; c=relaxed/simple;
	bh=mMszglkF883MAWOEiWDayKgHpOKLTRtyIFNZqzm944A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cXTFj//U2Z3J78GUPmu2LzFNI2WDfpRtkgYaYQjZ6fswRsoYHEk0lgJjPghV+/NjstAtdDh2QZUP05MJNU1yP0QsS3NGbxs8RcSvtRRp2xQ1/DQrNT7lK19aPUeLeIpF8kC7cRv8AWvg/9V/ZLDkGQtp1TtN3NpMOSGhcpUrtos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KL+tviAt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aOfNf1ke; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KL+tviAt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aOfNf1ke"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V2INUU2781091
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9b8YMivGLuRGJ7njNNRJjG4dhOdOjQ2LVlgcWgR8Vd8=; b=KL+tviAtk9a3zcxs
	d5uGNorZlf45tdkfa2wuB3bH7BBWAT6GPwbFUsL9ISBOjYPjiXO9K76h1b9Dnl0x
	N4b8omMT7XaS2vMGmsmQAMwqJy7fcbVip7tViutrrxxS6io3MMkFdXi0Y/OSs73i
	/iyuUMZI8ToLcRFwkPnltOBD69jNcRfFeTPaJqrcRHTuQr1x2TKmy2o86Ul1SmeP
	2vDdS1zThSnqYeyVvaqxRyNnQX5ufXPHAh6RcfXLbDsi6QhqFTwrBL8vBUtroXjc
	vYfp2Gct6Sfpsn0Qhbv8jeZaASIp9nZbqWjOJ9AeDH8PQHyPnlxQy53IsZAKwI4e
	E4C0uQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frjtag92y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:46:44 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce7dff6253so12832815ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 20:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785469603; x=1786074403; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9b8YMivGLuRGJ7njNNRJjG4dhOdOjQ2LVlgcWgR8Vd8=;
        b=aOfNf1kenFEyHPRVw0XIJydhELHyrI+ZpXJOXLYEY6hzphD2fXCvd2KP5Wj+ChOCT5
         XDiK8H83K7baXrjXIOCZnzJesEttrMZW9qsSSElTr83IajL8+E/3S02OwD8KtD/eDN3n
         /1U1Ab/pVuYOZpHXiC+FlpiuF4nOa8T55dIoYRmyOszW2lbgtuIuocIk+l44mcyZcvEZ
         emZWVwU89iKOQNUhoa3eINyn2XegowmH6/asnsh/ElpUB2kWIkISVy2PCOTqfVko2vaB
         8Qk7seNuDvZosUzhyDA5E9j7QASvVMOUXbjVCndI/fvLQ+W4D5xK6qg08GyIeKNSCRmU
         IPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785469603; x=1786074403;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9b8YMivGLuRGJ7njNNRJjG4dhOdOjQ2LVlgcWgR8Vd8=;
        b=qGFs+jd6G+VsoGEtoPOFgx9GlX7zrJavjFaKAHSlxteDBbLExT4XO2id3nPv7SJ49o
         psj3RXvlSIh3OCeIW3EMBTbBCi/SH/+mFXlNub/+5qHeWpnc0wPLgWhVNsde38NpzzIx
         RDv4a4pDmykAvwXQLnBcctwG4jraSyiYKvQ+OS1Kd7MMdvZT31T68UFGGjtjr4rQjJWD
         M17QMZJj3+TDN8Zq9pvmonrBFdxsNq9YiPPyQYXYLg0tYqmTUAFqIevMD+GIXSA/zzQH
         3SLMcHYhRtuRqI+/CZ35s5ti1ocfIy+bPTB69zfitq5o7FgZrAFEZFqO1MHIoTCiMeXv
         rhSg==
X-Gm-Message-State: AOJu0YyroV/6lQIh56q0YX7YK3GZlgF3ATLT3qDalTpYK5BhXb6NRMRn
	7Bq1tbWPdSX0FgZsjelVP+HXkGlqZjRIrLZ9MECYi2PdorUMy4JJhXAKqajA+mDZDK4EBNn+R2/
	iCxB1LtH7nZHV5+bG7Zq1toM1lgzNNffJXPFWvFQmRlSsO9NCuWSOb0bI4wsptsZ0m7EzcA==
X-Gm-Gg: AR+sD13PtPYD1r4EBz1TZU3arkkrvc8acE7p5wllN5Ye7nHFYix20KodYJR7eXGeEvo
	1JVoQp0h8VOg01kpvThR1NMspCN6ol+8S+xKHErhSNXnE1gGq+SoXa05At0uiVc6ZJg6THmAa9X
	n+8J+Bsm9Xk5Thp2pcFNNTxtDMQ3imk4fMx7rI7VEl4fMe7k/YIneQg1gRPf1RO+hBxXCEySIRl
	RvnrPG9guWgWJ3kDIzw8nc0I5eX3lckL0XyPdmh/cEbhI6KBls+SO5RkKShtDTbgoV7BF2n8+OP
	2PJ/4jLzJMnyNC0+EVR2wn+ttIYL9Zfb0NlMH37LPh9xdLOMyiWABQRFNsP/7TxOLxjsFJSL0V5
	BKPC/SRKVveIyIxYAKB3b/nGU7RO3Xi3O+jff9ssM8Bn8EDuz1y1i4OTDbq+sDdAcAHm0DApTQw
	==
X-Received: by 2002:a17:902:dac4:b0:2c9:e846:a589 with SMTP id d9443c01a7336-2d04834f2f0mr2097115ad.13.1785469603577;
        Thu, 30 Jul 2026 20:46:43 -0700 (PDT)
X-Received: by 2002:a17:902:dac4:b0:2c9:e846:a589 with SMTP id d9443c01a7336-2d04834f2f0mr2096955ad.13.1785469603172;
        Thu, 30 Jul 2026 20:46:43 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04793f650sm1173805ad.29.2026.07.30.20.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 20:46:42 -0700 (PDT)
Message-ID: <94fd180a-2288-4894-931d-109cef042479@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:46:40 +0800
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
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140232.133500-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyMSBTYWx0ZWRfX2N/Zg3caaw2h
 qM2Zcy4KXInAyc0vdhbPhcR3LLbi0ifZXW+mv+hLWkoGlmuWJc6pibZnxFN501/Idaxx/nItwFR
 Smr6oN+DWBKTiDs+/Wro8Ox46fbgIqUg93p8hurebS/ZDJBhGujMNimk0qU0DlNYUCAXW4LDVKC
 Fmpv9fkvkOc7sBMc0d5XLiuaEOOubrxTGg93gusih1Z3Zkg6wkPlg+A7Ln+EFbqTK0hjkhocLCd
 MZepPG/0S4g48xgPKyd33QmKLsE+T/uXlm/2iSiih1MKbT9cMqaVnH65SLoH2NDafgW4fmjXgIA
 Ioe4gf68dN8DWiGb6+ZpgI5PeSMDBOxBUs/lU0LLivGTOYdgV/2tp0pWpSSyWQG8nJ6wC26pDf8
 xIq9GGsktICPs/iwdQKDvJce2osSepZw8nMeYLzd8khKIj94FFs8c97C7iz4r3D6xd2ObKo5NIz
 PPyeSOMh9P9XLZFWulA==
X-Authority-Analysis: v=2.4 cv=ZdYt8MVA c=1 sm=1 tr=0 ts=6a6c1aa4 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=fPzbls-HzLpkS3J7q7oA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: yr9jP4zZ2Mdwn2CiRTikXU2Hylgj4z4j
X-Proofpoint-GUID: yr9jP4zZ2Mdwn2CiRTikXU2Hylgj4z4j
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyMSBTYWx0ZWRfX+yU5x+ggB7Z0
 JadVMu9c/NUHVstsJeopNwvqOLQqH0b62G3mJQFT2MO7Nl9QHxLBLweyVhsoF13CsdZ5lLLsC8i
 Tke+LSZL5CY3loD/XH1Rz7I2KRphOlA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310021



On 7/30/2026 10:02 PM, Nicolas Escande wrote:
> When mac80211 removes a sta, it calls .sta_state() which in turn calls
> ath11k_mac_station_remove(). In that function we clean up both  peers &
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

I think the right commit introducing this issue should be d5c65159f289 ("ath11k: driver
for Qualcomm IEEE 802.11ax devices")

> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>

with the Fixes: tag fixed:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

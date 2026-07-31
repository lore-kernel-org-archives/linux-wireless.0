Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E292E03EA
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534868; cv=none; b=PymPurQj50tKPHonfTfMg4QbCx6KrXdHlSQJAFJEDqT5YqoX6n+ery2XAYWgvVEV4GqHueBBXXC98M3gswlZ5ahMixD60pWjMy93kKiXryvCj2nq4dsdGLFfQYAgFIYiyebJgg6LVIc1RkA1CqYr489O2Dse338Zthwk8b+GM/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534868; c=relaxed/simple;
	bh=td/KVGng/qkFP/jGT/Hn2Bj+H4lnBgqXHn9WJIEPSQk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IhlochYikPjGBr+qtFI5gha6EZkDHxkvJKBzJS76PLfo5mfgIhkCIGTT8PvL9XpvQBn6q0MlHNcFnUH5IzIEqY/Dyg7vHma0iNlPjA+tM8v/V0o2uapUh0vRUo5HzQRcSv9W9xGWy9qhjN8rGEAiAYO04vH8C5xEx2UBPhoe9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S1IRVGb+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HMXtoAwA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S1IRVGb+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HMXtoAwA"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VKMHMC696037
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KyL63mK++l5sw6+BQZdb83d7l2zlgQEos01najAXNC4=; b=S1IRVGb+Uqf94eMb
	3yKvcdBzHlVdSDYSKtTPq9+DbBGjcBcn273oH9gAZJnrZkvkdUsT6N3AyoOI2IPB
	3VBWaxP+g5K8ph+bGOO38JZCH3W1HQBuukoy2xYeUMmpeh8/oOqnoRlL3mYYws3d
	meIqAAjOSBYJpi3P0JxQYPANVXAwsxjSrXgYfQdo/YtjseFMDvfH0vMDyyiT++tU
	kwskAMhzRxjDSe9R80mIfN7vVBw0dOoJqN1Q54VBmnKivdTtWFPaSyBDa1vSpRIa
	U9N4k+12dNfbbDOb1TXEse3eK1hY4cdaoUaoF8+OuNNbptWxQ/44fA/HPsy3QiIl
	X8JT4w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frugh2f17-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 21:54:26 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca860baea9fso3351499a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785534866; x=1786139666; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KyL63mK++l5sw6+BQZdb83d7l2zlgQEos01najAXNC4=;
        b=HMXtoAwA+cpL/X2IuyHsmTzwFxzoTIH2VuKqnTWZWmLShCTz6vAtshz+lEjss3RLVK
         gw+qi2mLBVVVlNN0fuV2TCIrHUhK5sSRoi8LLAnBJe9TAE53cQSQZ9Pw/RrhpXj0VMBi
         aVXInz87ISD7lNX0H9c3nIm+u1GeWUOP16WzESOFQWJIOIFz5wcyUgl3vrS93fcbTwdg
         KunHpY3nbq1abFCQF/Lb1ollTFq0NN6iWkl/gI8NdX+1xKBSREa4my8QWGgLukRPL2W1
         GqXwjIf1fSeptDQr5BSCdJ98Q85KPve19iUHvPPxiDUtljJPFPcelUXlhrNOUCOhStLC
         dLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534866; x=1786139666;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KyL63mK++l5sw6+BQZdb83d7l2zlgQEos01najAXNC4=;
        b=Nd/quk5G0vTu5LOiRF3MQTGEkM7ouu9EPkhiTbNfLXi7Xb4xxne9mbqk/DaWQcgEMZ
         uYbkDtUZhjth0I37ihpAXTJ0PaVWtXjVnPHx2/Jx1fTCoAKG4Htg/D7Icrhb5TwJ1wuB
         IC4LrUICKsH2+9UXmFtOKoevPDQthpKhjq6utwmsApb1xUknnrCUdTAQ1d7lZ23oQjTe
         ERmglD8tIN8PrRVf6VwLPyJu7ZEPOcVHK4zP4iclF2dN2CD0xwYzH2EDuIi59E7IvmHm
         xk1OG+VBTBJjmUnlsx9lnuWN+1AuVVPp2TwUh/zDxO2mNXdp1QuJwkFPSiHiwwd5YxOx
         vVjg==
X-Gm-Message-State: AOJu0YwVKTYPN1Wdwdkz6Sz7SIL4aUN13vclB0cLjzkMk+8U8bbvCT+s
	R2+wgyc/6CyuMY5cr6xyXBA7IeOv9TdE0FHG2o6KRpI8npIZqlXHEtQoDK+zfXBwih2lcwml5xm
	1Cf7dDYGa1vll3mwtLmD9Ej16eABHJ+vDQTv/tBOt6WVmdzuyFcSE69L7amqXOhk0N8N/JQ==
X-Gm-Gg: AR+sD10bWREVGahe4nXe5A0gsL7JImSIsn82XRD0E2w6BS96X0zVFAOlPfJ8o3rHNvB
	DJDmOTtbjRu+sDGiYZoH6VteIcoMvfTXQIbkYH/JMCF9aezaasvmDGnNzUwGUUThZDC+LsxqAs/
	8st5Ck2+ghRNpl26UdYKtzjVoTNV5vaMkFhhTcx6MNlGu0gQZq5Du5bhqtvpB30Wvco4RByaJLt
	SWIyFlSaHHyvy1aoazcdpPX4LCY20LD/6uGfjj53oYhTRpp7bRT4MOXPCqRtSpVWJMVr7GUPct2
	CVWj0JaZ015GFIt0JBfPZFKqyiH62Wo7fRhdzOk1cnrobQo9jEQjxPPCY9sbL0yjTjxmprFxnHs
	VLxoAiYB+ABIr2aU/BzYFiYlsW31jwqHArZTQ7zZXBS34J/ihXsrA5vavcT8=
X-Received: by 2002:a05:6a21:7002:b0:3c2:dcdd:a861 with SMTP id adf61e73a8af0-3c92a85c953mr1280827637.43.1785534865768;
        Fri, 31 Jul 2026 14:54:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:7002:b0:3c2:dcdd:a861 with SMTP id adf61e73a8af0-3c92a85c953mr1280812637.43.1785534865384;
        Fri, 31 Jul 2026 14:54:25 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e47dsm13745328eec.3.2026.07.31.14.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 14:54:24 -0700 (PDT)
Message-ID: <38e9f9a0-d74a-429c-8830-5552fd1b32c4@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 14:54:23 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140306.133718-1-nico.escande@gmail.com>
 <272a4819-d966-4be9-a533-eceb7ae0a552@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <272a4819-d966-4be9-a533-eceb7ae0a552@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE2NSBTYWx0ZWRfX414vRYfHvOyX
 LDXsNOujh384XSq3F6zodgVE/gWY/c2zQ2iBkaFINmu72GjiEQ/ByAQ4XzNFveZckq1ZS50fXpu
 KsgEyIhFFXAjmn8ph5dYdbWgioqPn355HziB6I+4oRwNU3lb89hXiFIcS9T55kmP0zg8L0fjVYL
 tpQchUjRmuHfrO4GG+XmyfK//S1EzM6Y+fuCWiYt3H1GadI5DQfbGlgu5SgZeKnQbmYXwvCwoVo
 +IBfgLx9l5/eDoNZeGA08oTcc3j7mmvtBRe7RyFJI8gE64Hjhj+PD/5ss1NjEIDj/qozvS9MWFx
 HEA+sUjKbTqXbFZ5ygh8r7UKn9ZKpsMV9Tf+NCb1P3C+jWtUaPj+2CSXdHDEB32bF2+IrY3pFZ+
 zFUavZpbyXrML77H52PlP0y0VhtLTyg1Y665YRKlnDLN/qiMCl9otT2fZq8sS0sM9qLI+RFLrPf
 W4gvT5/R1cPS4SB2q9g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE2NSBTYWx0ZWRfX/0D5fO4+wjC/
 yzPVS5I50HkTqp2LY7R75NYPxsIAxMBZ8PvBeBdbGZlrcSVm0GtSqPSsO/0nvDgQoiuqXwRH7dP
 PMKGYIA8ydJOV2nMHxi/e2LzACnZJ/w=
X-Authority-Analysis: v=2.4 cv=U+iiy+ru c=1 sm=1 tr=0 ts=6a6d1992 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=nBSiXhH3qYJRaR7yieIA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: 3z6HBE2z_HgK8YewAAJQtsNLoxD9C5xd
X-Proofpoint-GUID: 3z6HBE2z_HgK8YewAAJQtsNLoxD9C5xd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310165

On 7/31/2026 9:35 AM, Jeff Johnson wrote:
> On 7/30/2026 7:03 AM, Nicolas Escande wrote:
>> When (multiple) hw restart occurs, we end up in a situation where we
>> cannot accept new stations / mesh peers. This seems to be the
>> 'num_stations' in 'struct ath11k' that did not get reset properly in
>> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
>> that did not get reset so let's clear it too.
>>
>> This avaoids problems like those:
>>
>> 	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
>> 	[1248828.088029] Modules linked in: ath11k_pci XXX [last unloaded: ath11k_pci]
>> 	[1248828.088053] CPU: 0 UID: 0 PID: 12281 Comm: kworker/0:0 Tainted: G        W          XXX
>> 	[1248828.088058] Tainted: [W]=WARN
>> 	[1248828.088059] Hardware name: XXX (DT)
>> 	[1248828.088060] Workqueue: events_freezable ieee80211_restart_work
>> 	[1248828.088064] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> 	[1248828.088068] pc : ieee80211_reconfig_stations+0x98/0xc0
>> 	[1248828.088070] lr : ieee80211_reconfig_stations+0x94/0xc0
>> 	[1248828.088073] sp : ffffff800025bc10
>> 	[1248828.088074] x29: ffffff800025bc10 x28: 0000000000000001 x27: ffffff8027b19640
>> 	[1248828.088078] x26: ffffff802a5619c8 x25: ffffff8027b199f0 x24: ffffff8027b19880
>> 	[1248828.088082] x23: ffffff802a560e40 x22: ffffff8027b18880 x21: ffffff802a560800
>> 	[1248828.088087] x20: 0000000000000001 x19: ffffff8027c71000 x18: ffffffffffffffff
>> 	[1248828.088091] x17: 128c0801a9c37469 x16: 766e692d32464545 x15: ffffffffffffffff
>> 	[1248828.088095] x14: 000000000000001f x13: 00000000000000b1 x12: 0000000000000001
>> 	[1248828.088099] x11: ffffffc081061518 x10: ffffff800025baf0 x9 : ffffffc0808097f8
>> 	[1248828.088103] x8 : 00000000ffffffd0 x7 : 0000000000000000 x6 : 000000000000003f
>> 	[1248828.088107] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffff8011ef2e80
>> 	[1248828.088110] x2 : 0000000000000000 x1 : ffffff8011ef2e80 x0 : 00000000ffffff97
>> 	[1248828.088115] Call trace:
>> 	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
>> 	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
>> 	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
>> 	[1248828.088127]  process_one_work+0x178/0x3c0
>> 	[1248828.088130]  worker_thread+0x280/0x440
>> 	[1248828.088133]  kthread+0xe0/0xf8
>> 	[1248828.088137]  ret_from_fork+0x10/0x20
>> 	[1248828.088141] ---[ end trace 0000000000000000 ]---
>> 	[1248828.090658] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 0
>> 	[1248828.090667] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 3
>> 	[1248828.090670] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 4
>> 	[1248828.090689] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 0
>> 	[1248828.090694] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 1
>> 	[1248828.090697] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 5
>> 	[1248828.090700] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 6
>> 	[1248828.090704] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 0
>> 	[1248828.090707] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 1
>> 	[1248828.090710] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 6
>> 	[1248836.686596] ath11k_warn: 39 callbacks suppressed
>> 	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
>> 	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: e8:51:9e:d6:93:22 for VDEV: 1
>> 	[1248941.120126] ath11k_pci 0000:04:00.0: failed to flush sta transmit queue, data pkts pending 2
>> 	[1248941.120186] ath11k_pci 0000:04:00.0: failed to clear all peer keys for vdev 2: -2
>> 	[1248941.120190] ath11k_pci 0000:04:00.0: Failed to disassociate station: 92:14:23:65:57:fc
>> 	[1248941.120196] ath11k_pci 0000:04:00.0: failed to lookup peer 92:14:23:65:57:fc on vdev 2
>> 	[1248941.120200] ath11k_pci 0000:04:00.0: failed to find peer vdev_id 2 addr 92:14:23:65:57:fc in delete
>> 	[1248941.120204] ath11k_pci 0000:04:00.0: Failed to delete peer: 92:14:23:65:57:fc for VDEV: 2
>> 	[1248941.120207] ath11k_pci 0000:04:00.0: Failed to remove station: 92:14:23:65:57:fc for VDEV: 2
>> 	[1248941.121319] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
>> 	[1248941.121326] ath11k_pci 0000:04:00.0: Failed to add station: 92:14:23:65:57:fc for VDEV: 2
>> 	[1248941.123036] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 
> In addition to Baochen's comments please review the guidelines on trimming
> backtraces at:
> 
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#backtraces-in-commit-messages
> 

Also s/num_station/num_stations/ in the subject

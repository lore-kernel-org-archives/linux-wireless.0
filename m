Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537964B2052
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216295; cv=none; b=WFE2M56OU3Hmqs8LS5Xei2VaTjrlY92J3iCxpybctjo0y+iccIUwWjhFKvHOG1XsIGfoNqnLBl/hE2oAFv4FjiReo30VHrxzTaElkUz0PBX0HGdfviY4nLSLWKNf4vJQchXmghkYeMSkGuo2xSmvghjI8TqXKc/csNSQZmWTmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216295; c=relaxed/simple;
	bh=Rpt4oW8sJJaggwjSBh0eiIMx1x/qC2qz+OsVuP80yLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LaVParjni5QVXPotgY4R8TYQh/1K4gPJ+N2BiumMA4P8KhgWvmerVzpNBqNcbRcQhS5yagkyTA84nqp81xfkKvBV9rYLQTYGxMHb+LvIcdniLKBjandxAr6GoRnEdaN6heX7eXArX8y+Y9AxlEmxp3y+9b3/MauAw2Y5/g+DNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i/mDKIuX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BXc2UZM8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i/mDKIuX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BXc2UZM8"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP6UN2214873
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 16:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FM60F6UFMJkr6PPLfxEgZGQ/j9cnztIokMuOoiCzVUA=; b=i/mDKIuXKyisk9Iq
	bCKIQfHwc9/ZrvRJdjb1EqfV/uCLIGkB/+tPx4DsrEZctygqL9Dl2I9Kna6TQl2B
	Poyw6djRU6ggS2TAgQFYPCIXoWIKHCoJhoTCuvUOzdoCQ048rj+q409tSdnCjK1G
	11P2PaaUcooHjcRXOGrzVfob6u70qKr3948vUV9Bd6DH2+IzD6ag/UvsXOnxMfTf
	xzciFW0A2H3KRsP1NV3juGVNEbHIwxFPLdHDYBo0wLvRDces3a6/Em0/uJiO4HnM
	3sRVREUT3wtPKiNpy3Q+akcH/2Qmo6DQyGlzyBmMcXAc9mdeFWGczifEem53F8IA
	OyY0Ww==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h3xgyu0dj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 16:04:53 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d7443e0f0bso33159105ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791216293; x=1791821093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FM60F6UFMJkr6PPLfxEgZGQ/j9cnztIokMuOoiCzVUA=;
        b=BXc2UZM8dzIWr3Lukua/Ju4ety4vhkDPFBESV9oVpzUP8w0ar3WYCyQPHhLwoberSi
         tDPht3s4nDb9Hk/31XpwFSxZUlD0N7b/8edKzBk12a+sdZbL5lL9a5+d4ZzZU7qUPCAV
         GWnTudXvydkLIp5flbx+VadX35koGni1Ey/+8DAqJgMK4u8TmAbWavj0BWWl16ocqyCm
         9ahPOX09J0mmRBWjL/H+1bm/tImUn6yoLgKLGCk+xG9y9keZZz1bP1S1MUZDBTrMGFQA
         W9OTUjGzfRqWYYr5QDCBebeU/+BjiDRyPTqi1Hw8PgTY4E8tiVnM23RVpSsjfOgB+dj3
         mx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791216293; x=1791821093;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FM60F6UFMJkr6PPLfxEgZGQ/j9cnztIokMuOoiCzVUA=;
        b=d3Woz7cCPQiU8U84rOi+wfXvsYWb7gAyQO6C+uVIHsMd+Qg0f6PsM1isldhGFmRfZK
         0fGDisth6pQOV25iaEUjSjJHfe8Gtj9ZiRBCgAZTJRnBY/IbAbyXD2Q6luvTf5aAA4gf
         gLmGbaoW/tfvlq2LB6h7jhmnpgPbW2f0DOeLzT5Z33Gw/k9tAUYSA6E9WgwTRzQ/YHmK
         VicPiKHBNj+CHpSrPJUH0z5NCQ/y53Y7q8ugX051wXp0oIYXW/LwP0CxMvhCDCOwJZP+
         tXROGTd9Um0VpVMykPugGkPXX161dCFsJCMsrKP/gRAy3pM594hyJTICMUPwldFi5Bs4
         y5ZQ==
X-Gm-Message-State: AFq9FYKl7mYoJbOT/pYYCFqYNlAobO2oXvQSQ6lqcSlHkKkyoc7r1ERh
	VE08hXntOnY0W3k3/nLu0o++JkZ47s6bQIflb8NuQT6NhfZh99TWAMw6+r29AXhlUj0Ea4XU5vc
	ck6NHZB6lZV5DNxw+WUC842O0BG5mUGq7v/R0u0tpMDROLDuLaAE9LFeBGDIGvl+nJsIBvLdUeZ
	eH
X-Gm-Gg: AYBFou2XgMFp9nv4JeoFfrAVk8/pHoXBnB7r3EObHG2xtzCLkaZMfdgnk5MLMiCjUsV
	WvOVEMIyjtrK/2X77R5DFBk5/HPRyyxqG3V/+bf56PDgWyaCslm02wOb0HuOY05pLH33a8Nt49p
	kTJg70Z/2gg/HT08HLds14EeXO2Fe6mRZGOsYSw+/ZUtwqxQAkgCPp5gPcUoGg3FT9y7PUromVF
	cSIL1pFXiRc0b5I/3o2wSizdntgIr0r18nen1disQOXw/Fs8HPU55uWMfXLdI5ctSmMibngvbhI
	0UruMhYTef+0InKigKoT3aq2YgJntZH7W7Q39ijrETcsvFOq146NOstnrgzjrM0nSA1tAyOGbF2
	8ryGWKlQoo7O/rMZVOna+S5Tl5Sa6Mc9VcFn4IHYbH2FgaheP1aqhIufaxp4DZnzccjcqvMI3hW
	WAotYk7caWQkr6lBtL
X-Received: by 2002:a17:902:d98c:b0:2e1:24ec:df54 with SMTP id d9443c01a7336-2e49b4e8092mr105086785ad.14.1791216292584;
        Mon, 05 Oct 2026 09:04:52 -0700 (PDT)
X-Received: by 2002:a17:902:d98c:b0:2e1:24ec:df54 with SMTP id d9443c01a7336-2e49b4e8092mr105086435ad.14.1791216291995;
        Mon, 05 Oct 2026 09:04:51 -0700 (PDT)
Received: from [10.50.23.243] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ef67f2sm10169045ad.76.2026.10.05.09.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 09:04:51 -0700 (PDT)
Message-ID: <c354da3f-857e-4de2-92f5-e300842c2276@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 21:34:48 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 02/16] wifi: nl80211: Add kernel
 interfaces for Seamless Mobility Domain setup
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
 <20260924-smd-v2-2-bb40094da1d4@oss.qualcomm.com>
 <bb6a1ef2348fd1d43420083b8bfa81b95fbf571c.camel@sipsolutions.net>
Content-Language: en-US
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
In-Reply-To: <bb6a1ef2348fd1d43420083b8bfa81b95fbf571c.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 26lpmSzQbyr8yzgRg-lkhu_znnI_h3dc
X-Proofpoint-ORIG-GUID: 26lpmSzQbyr8yzgRg-lkhu_znnI_h3dc
X-Authority-Analysis: v=2.4 cv=A6b5rKWG c=1 sm=1 tr=0 ts=6ac3caa5 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=3skB8q0RRGRTqEDuc0AA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2MyBTYWx0ZWRfXwd5TwuoPp7tc
 dM184Zuywfnf+vr5ON5nEOicm6onA9AVdPYgQfWm8TjD08XWhQpCqY9X3aocimxG6nR6/AobI+W
 MyYrspYpmH7Cm+vQnIbrRi/Wwc6w0DGypOxj4+46Xw0G+LhkN6AviwSGzPOTId6oWcUU5fQrwFS
 8goB7h03yTGOUNTF4ccUYtKlguakFBtm4zXBohtDC4IAiyYBFm7keWzYxLEaVXHtgI7i3e69uh4
 8W7hrnaco4l6+NOk2g6iJR1ZGMJeALP8O5nfGpUiABzrNVHgwYSNaK1xhHA/G17xBNrIP9gvzPW
 lzgdxXS01/urJ0d2GZ5KWD8SStt3Tri/zeOek+pqvNWIBw0Hbdf9gvbDabVgcwwjMR+AmT9MdBQ
 /HsADB3lIS7jCHkvj+LIniDb/5Vf8KrbqcBXDj2ES4Ej8g0voqHXO0YRmlWyo5TwgrZwyFJL8Qj
 pnlLW/dZw88udZeUGeg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2MyBTYWx0ZWRfX8y8xPNVNyEF+
 CSnJPXXxPMnSpRQUfWiLMU3XXBKEl0dAC7Zr6T3slWU4a/0Qg22ohvG8LGv0cJIGHEimhCZI6T1
 HmDi4AAK7sNgQ3iOeNlqAaEqVK5sv4I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050063



On 10/02/2026 12:20 pm, Johannes Berg wrote:
> On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>>
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -3190,6 +3190,12 @@ enum nl80211_commands {
>>   *	known station to transmit a frame. This is relevant to know whether
>>   *	MLD address translation happened or to disable it when sending a frame.
>>   *
>> + * @NL80211_ATTR_SMD_PARAMS: Nested attribute to indicate support for Seamless
>> + *	Mobility Domain (SMD); it contains parameters to define capabilities of
>> + *	an AP managed by an SMD-ME. Valid if the driver supports
>> + *	%NL80211_EXT_FEATURE_SMD.
>> + *	Used with %NL80211_CMD_START_AP. See &enum nl80211_smd_params_attrs.
> 
> "Valid if the driver supports" doesn't make sense - it should clearly be
> arranged to be "valid if present" (which doesn't even need to be
> stated). Then you can get rid of patch 1 entirely, though my request for
> documentation still stands.
> 

Sure, I will fix it in v3.

>> +/**
>> + * enum nl80211_smd_type - Type of the SMD
>> + *
>> + * @NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP: Separate MAC SAP is used per AP MLD.
>> + * @NL80211_SMD_TYPE_PER_SMD_MAC_SAP: one MAC SAP is used in the SMD.
>> + * @NUM_NL80211_SMD_TYPES: internal.
>> + * @NL80211_SMD_TYPE_MAX: Max type of the SMD.
>> + *
>> + * This value represents the data path models between the non-AP MLD and DS.
>> + * DS mapping for the non-AP MLD is updated if
>> + * %NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP is used.
>> + *
>> + * All AP MLDs within an SMD shall indicate the same SMD type (refer
>> + * IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.2).
>> + */
>> +enum nl80211_smd_type {
>> +	NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP,
>> +	NL80211_SMD_TYPE_PER_SMD_MAC_SAP,
>> +
>> +	NUM_NL80211_SMD_TYPES,
>> +	NL80211_SMD_TYPE_MAX = NUM_NL80211_SMD_TYPES - 1,
>> +};
> 
> I don't think this makes sense, any given driver might be able to
> implement both.
> 
>> +/**
>> + * enum nl80211_smd_ptk_mode - PTK Mode used in the SMD
>> + *
>> + * @NL80211_SMD_PTK_MODE_PER_SMD_PTK: one PTK is used by all AP MLDs in the SMD.
>> + * @NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK: Separate PTK is used per AP MLD.
>> + * @NUM_NL80211_SMD_PTK_MODES: internal.
>> + * @NL80211_SMD_PTK_MODE_MAX: Max type of PTK mode.
>> + *
>> + * This value represents the security mode of the SMD that dictates the PTK used
>> + * in current and target AP MLDs to protect communications with the non-AP MLD
>> + * (refer IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.3.2)
>> + */
>> +enum nl80211_smd_ptk_mode {
>> +	NL80211_SMD_PTK_MODE_PER_SMD_PTK,
>> +	NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK,
>> +
>> +	NUM_NL80211_SMD_PTK_MODES,
>> +	NL80211_SMD_PTK_MODE_MAX = NUM_NL80211_SMD_PTK_MODES - 1,
>> +};
> 
> Same here.
> 
>> +/**
>> + * enum nl80211_smd_params_attrs - SMD Domain parameters
>> + *
>> + * @NL80211_SMD_PARAMS_ATTR_UNSPEC: Invalid attribute.
>> + * @NL80211_SMD_PARAMS_ATTR_IDENTIFIER: Required (binary) attribute of ETH_ALEN
>> + *	bytes used to define the unique identifier for the SMD.
> 
> What? Surely you're not asking the driver to advertise the SMD ID vs.
> hostapd just setting it, so I don't see how this makes sense?
> 
>> + * @NL80211_SMD_PARAMS_ATTR_TIMEOUT: Required (u16) attribute to define the SMD
>> + *	Preparation timeout (in 64 TUs, values 0 and 1 are reserved) for
>> + *	the target AP MLD.
> 
> Doesn't make sense either - if anything the driver might need to set a
> minimum or something?
> 
>> + * @NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING: Flag attribute to indicate that
>> + *	the device supports forwarding of buffered DL data packets.
> 
> What am I reading ... please get someone else to review this code first.
> 
>> + * @NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS: Required (u8) attribute to define
>> + *	the maximum number of AP MLDs a non-AP MLD can prepare with. Value is
>> + *	the maximum number of AP MLDs - 1. A value of 0 means that the non-AP
>> + *	MLD can prepare with 1 AP MLD.
> 
> That doesn't make sense at the driver level at all, each individual
> driver should have no notion of how many others a peer prepared with?
> 
>> + * @NL80211_SMD_PARAMS_ATTR_TYPE: Required (u8) attribute to indicate the
>> + *	SMD Type (&enum nl80211_smd_type).
>> + * @NL80211_SMD_PARAMS_ATTR_PTK_MODE: Required (u8) attribute to indicate the
>> + *	PTK mode used for protection (&enum nl80211_smd_ptk_mode).
> 
> See above.
> 
> johannes

I will clean this up in v3 since these parameters are not required in lower
layers and can be contained within hostapd.

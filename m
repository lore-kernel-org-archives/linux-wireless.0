Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052119;
	b=IilpmRGX70rv9MojJ6RrWwBEoV2saAI+OWZRYbPRqT0tZIycssL8Hf4MkukPu/vMPPf/
	 aT9kUYBwNnKCKUlkS8vghYnPQ9vsEMlD08qbQFRbzNoD7mIz/N0g2SqY8sezUASaIp/hZ
	 /OGAA+ZO3JilenJa3KuabIvTyDf52KFAsaLA8BVJb7b9Rb5juC+M1uCncH7eTcGcXvSGd
	 qTc3YYE5+jS3Tl9Cd6uKsyXVD3o3krSjWbb68ms4SMs8ZSPFseVtc7vbdD18vwXGweOM4
	 aOgJjYQ0sxsbZSEfNzGM164MDIMo1+mpmaDdICGF2y8QFz1cgNwEurMUUX7uLIgu2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052119;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ET8ka4qtfEv+EdZP3zMkitJSumzzgQOgC9axB/fU1X4=;
	b=UyRcAXvy+DiUzj/hnoh3zbdf5sHiOhnJR2UjqerFmCV+gn4zSG1uoohFjiDoD4b1ii86
	 JU+YpYAOqeW6uuokbyqFloAIIbzcuaoRPtPeXX2tuMUdj8egNGLFEF05YS69oINV9sAw4
	 V/hU9mVN0butW0mgqKg3J6BR0XXF5CyTPQZJjvvIeOTXk36ZMfm28pMKKXMzkGlQ1g9vm
	 H/fcXNmiAJTqrD5ZYfbNe8Gcr7y1ZDE35ny+uvPu4+jeNDSrE4JMEKbLwe2Ofz23CIZgr
	 /g5/dnwrJr0+pmrKR1uClUR6q1vh042thwsvn1RfN7FllnopPMFwOf6T3KcBiUI2t/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=md5Ubl9F;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f3SlIO4z;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACE6606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ACE6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=md5Ubl9F;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f3SlIO4z
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QKdUDj1210112
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ET8ka4qtfEv+EdZP3zMkitJSumzzgQOgC9axB/fU1X4=; b=md5Ubl9FMi7cc0ij
	rzpSL01q5iki/iNDVVb3+fQMV88oV81yGYIpIDRpVK3z7mzBPEi3UudJl5t11Itt
	4QGqGDPY/tdsuTMdwirUAYXNAUzkR29bLNEBSeohZB24CIUprGafJ1ZxdoBeBgCB
	FgkNfs0bQ++OW4ud0feqpIFai8nMWwTFYVMSvEK0Ctds6L9dHWMW03yBgwxEIfr0
	HOjgMD3rVhIqFe7ce/zo1mw0l7N97WznagxNemK5SGaZzl0vitCa/uMcIyPgrR16
	/lOW7FZcqzGyB0ubqAFer2sf/xIM/wYkbbg33yOlm648dGqstpb9Kdm7CXaiXeH1
	tF5Q9g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hje3d87c3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:01:58 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30c0d568830so9509429eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793052118; x=1793656918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ET8ka4qtfEv+EdZP3zMkitJSumzzgQOgC9axB/fU1X4=;
        b=f3SlIO4z0pSjzPXChcZsyrEnpp0BToDODLgESVcbRMvbJmwRZyuaxsLeaPb7iti/oJ
         LbhBDuiez+DJZuRqy4vwzqMSnvzY2J7mRUrA9UQFTa4ioLWBImIyepvGBVd8EF/blVcn
         9+EZrzn2WJXpcYAfzpGF4Xp2xaaSU0D6TDCidQgKNzmzxYx0INLgYCgUPcyWb5IfSQ3U
         WkQvnWZ2yVGxLFfsrArfTbRcgLyJJfdRljjidkmjf44quPja5Zt8dL5t0TGhf0HAyvSJ
         atZXYkdeDl8+/BJr4szLgKtTaUVri2SCJZNT7xtHbExdg7r3HZlqeZjEzta3u+P4rm+a
         3nWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052118; x=1793656918;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ET8ka4qtfEv+EdZP3zMkitJSumzzgQOgC9axB/fU1X4=;
        b=y+ROSFYaVLTMCLaW9XNMb6/ueYSgWSHuF5R+jXOQbPXaS7XyhLKwekounCuylq3CO7
         ueYsz/TnLSPRWz+K0dq0ouxEBfouXR2vbGGBcbItod4V6iMctMqjyCP3VO/+eEb0Qpeo
         yBOPprrjTY0ZDkf0vs7FCX/ABFFa7gSBQGQrJGLkMXpMERFnu3bPTvQzyEZD/QkdaddK
         zokIjORNWPzRxXlebDOMBru1Dxx5ELGoIccuqa4oYPZbgtpwA3/spJ5yhhkrK0vtlz5Z
         phBwYWue4tt46DY0ny/Pi/xkSeL6UZFY17Uf4fVEvrX6UMr5yJk1xvOfSe8GNMVsO+kz
         2r8w==
X-Gm-Message-State: AFq9FYIguHzsgUrQJ/56850r5czLliZ8AZmBxzTw3NfqH9TDH/1gLyVJ
	n0GGzbOp7tKAOyPmPEIaMfYrHhEVo2C+d6rQ1BmF0NOr4FTxqhpcFhf+13v6rz9piNGbIsy4Wsd
	EwD0rjAz07d7VbLej86k2WZWnEEUaQ5zMx4LEKCJIzYvR5ZjOtCNK0NM2L2Q2XLHMtM2srA==
X-Gm-Gg: AYBFou3oxCZIVyiuoONmYiIL3kkCPymrfsc2tEcO7kUniqA2TdqfivcxXSdhUt8+28h
	yS0gJFdk15hsRwV5duViQI47/FX1ZIfLKEzFRn6yso2DG//MFttHllEtLb5KJGkvSaoA1Yv7TAf
	eGRU64Y6cell5aMbrv6zq0cwHA1O4y81shquBj1675s8k4TqOXZGNpc9Jof1BxO7f/4PLljqckw
	vJfGdO4wJWCyjHPBpGzXIHpSk9TAIR/KVNW0etbbEIyqbj36th3jrzqUuCo5aMzm1q/xSldDqdJ
	i+Px2Hr0RhKizDcyBB/bAz7npADqosSi9LTpQMmx/wYFOFxRmjXcUeKVlxjFbCThrE12TBwBuJs
	TmiPWRds+981p+8NheTWpWiKAu+q+wBalzvuAY7FAiDbpBWJx3bH6Mxy+fHGsJ3X5GnrfwP0lDn
	BtqBGS9HbmOlH5HhYXO9shZoahEM4=
X-Received: by 2002:a05:693c:41cb:10b0:36a:279:c93f with SMTP id 5a478bee46e88-36a0279cf79mr4893074eec.33.1793052117407;
        Mon, 26 Oct 2026 15:01:57 -0700 (PDT)
X-Received: by 2002:a05:693c:41cb:10b0:36a:279:c93f with SMTP id 5a478bee46e88-36a0279cf79mr4893031eec.33.1793052116612;
        Mon, 26 Oct 2026 15:01:56 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a03bea5d4sm8443486eec.6.2026.10.26.15.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:01:55 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Benoit Masson <yahoo@perenite.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        stable@vger.kernel.org,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
In-Reply-To: <20260928213322.98949-1-yahoo@perenite.com>
References: <20260928213322.98949-1-yahoo@perenite.com>
Subject: Re: [PATCH v3] wifi: ath12k: assign device id from the WSI index
Message-Id: <179305211480.3326479.9381266425749962152.b4-ty@b4>
Date: Mon, 26 Oct 2026 15:01:54 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfXw2Uzjd1FyZkF
 VuXp7fSchmlWtxawClEjC21S0WfX7623E2TzVIyrGdmLp0tCKUEXPVe4zEhy8OiYUtlKLsAJW8I
 xVOccklmbJMzgeZKVgszFjVfO8Mtr1g=
X-Proofpoint-GUID: aO1J02d1liL9W_-TTNni_uE_S1ePHN02
X-Proofpoint-ORIG-GUID: aO1J02d1liL9W_-TTNni_uE_S1ePHN02
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX9NvPIxhcNQmt
 KUOoeUUbVsX7fukmbd23mm1g+QwmlVd7edklb/ScYBNVAk4gOnsKJ2QXzIweCwmcrzlY9kQqooX
 SgObTDbyXHfM03vbLu3Lmjoyq4JHSDyVkU/7CPZBgryXeBNQoIFNIszLu5OE0yl1hYzl4Ijx94P
 zCy60BIeSzAGzpPwcbMyPDogg8IqXixtcKh2vVQ7RwsgPCx4AAerJkAF1hhM9/VGO/s8MWMUQ/P
 6p9v+8qy35Khx4bhZA1GYJ6OyByYvSUNktuv8AWitykm0JT9BG1WrDByj0do7POklwLhgVTrC6F
 UH+BAS++k9FluLIiGMsC5SDfmZyZ/N7wCXA08hmkqzsSgoAIRJlgDrYdOcKqmMP80hU2NV04oSP
 hWiDWudfmDX6w8mF2S8aQCmnNUNEpw9U+YPK7o/sENyg2DcTy8Or7/9NhhiYS9eSHwumKg2fm9J
 MZrMIU7dLx7oZEzv2Kw==
X-Authority-Analysis: v=2.4 cv=SN/Xx+vH c=1 sm=1 tr=0 ts=6adfcdd6 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=go08DCD3T2PDlqsEJcsA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260087


On Mon, 28 Sep 2026 23:33:22 +0200, Benoit Masson wrote:
> Devices of a hardware group are added to ag->ab[] in PCI probe
> completion order (ab->device_id = ag->num_probed++), which is not
> stable across boots. The wiphy radio array is built from ag->ab[] and
> the wiphy device is taken from its first entry, so the wiphy sysfs
> path and the mapping of radio indices to bands change on every boot.
> 
> Persisted wireless configurations reference radios by index (e.g.
> OpenWrt/hostapd "radio0"), so such a configuration attaches to a
> random band at each boot. This affects any multi-chip group with
> single-band radios, e.g. TP-Link Archer BE800 (three QCN9274/QCN9224
> radios in one group).
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: assign device id from the WSI index
      commit: 81986a81f09fae73926c7c44863b335880269c90

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>


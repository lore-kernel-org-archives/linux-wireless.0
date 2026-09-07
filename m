Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E754908D2
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 12:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783800; cv=none; b=di+O16hydYQzZe8jfeyAqE61A/DsVvUVHj1u69kjAJL5w5j1dbcMHPZRDZ+hTWSPGi5lwsDNV0sXF01E7zxdekzkDLN/n+5ZsHD3kGLNHy9T+C9Zn3F12RkpyFNnAYqcubBaBBhnskJEQqZW9G4NeiNSMfTtvAuwVy/12y0FlJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783800; c=relaxed/simple;
	bh=/XM0H/BpFes8SMdWxdYnx0QwysVEnKtoRTcf0Nut+jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQ/rZwCAU2NvMAF0GibO5X0Ol4YocCE5iDW9+cOSzpTOO+5tw2cSQz6UNkXLhRJCGyTwf479vP1Xk18xE2TgdZlTRXKx6SEChixP5xhB5JBTe7G0IANXkhCsjrBAUSqTC+BRM3l5ToMyB9VU9TDpPNqt9EOrbv1OhmBwO25VmtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K1yfMNWN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JREZrrbY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K1yfMNWN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JREZrrbY"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687AvS4O496314
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 12:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	98atpqeEqErvQfy5RYHFK/T1sDHuewTFDWq2WDqd5Sc=; b=K1yfMNWNwBBEvCHc
	OoQnFrYTTT2rLDg0t36O3FatvedHHgGqIlzewxJab26AD2yABThHluPPSBD5PMVf
	2ldRPUZj9GcB5ha1OpHzVa7glAr2Pl4GMC5a/9RLcf+OxHYbl2THrzXsNua9dLez
	sFQ/unJDvaKo96IyQgtkMnuPXKn8apYKoohRK8GJnnSLRWPBvIMIQKAZ1/Y/98KB
	gnUWpVanbXz20Trjk53Hm1wLWOHoMzHeCt5t7Cnk+j/GERGYnHdHk7ygwpcj7Hgw
	dYgmufwI7y3LfgGN6IHHgw15RkBOFymZFV6iffBpW0/Rw+auFlPc9aydr9BG+17z
	EBY/nQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghuyk892y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 12:23:17 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-85f1f3620bcso4334145b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 05:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788783797; x=1789388597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98atpqeEqErvQfy5RYHFK/T1sDHuewTFDWq2WDqd5Sc=;
        b=JREZrrbYoN4j2MEofQ1gV6H0dqIXlKGVYAVXv3sob8QkLe4rtTvkAQLqHfQ8ou3BQ8
         JtjpXPhLPdVKESyVo67z3As62BR9p50cLq7nGC4rfVnwgkzjWCov67VpTkExVK3iKGuJ
         vgcaBamdudkIBvQJbxsk4OHYrbxK47lL11A0g+4wNcyn0/yAWN0YhcOYkHTYoOIb5NuJ
         KcmSY5L2KNbWzPFUezjtwCPqnSWQn9Rq0CfXPaTGBfUgSmDjJsUlNC36EwkuE+ZhSoFN
         X9muF9XR9qFAEYhrOa88YcHFjVpzbHkkAMlMyT13WCEcItpGXGzl3xmXuiQKIunz6tc2
         hyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788783797; x=1789388597;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=98atpqeEqErvQfy5RYHFK/T1sDHuewTFDWq2WDqd5Sc=;
        b=mGVRdahxcDQWBcHsc7cZOkHeIrXUbckCivuarI5OTAZ2mhTIwxGSW6pZFXSF6unpmB
         UX5PIEpQ+/9Vxv7P+BXNHW2O/yWxMfxCBDuUEwEjgdF0MWPFEquBUcot3sdpYff1tvZv
         madG1tj3lXfQKgtxV3ePnwO+aNknO77DKTya3ZhJI6uFrPr6SiUOLnIVksYuQ1ymMKMt
         7cfDSk/N8+2AYzcgZjH1426BOknj97aJYuWIU5Opvv9TGVTAbeUi8TyPJESCgygqACH/
         GpV8BdUgg+K5dv2Mzl9vX/aCdwwYByqiembGWOBBORHrZt8KdCqtfRQiVwN726vhjGvp
         PZpw==
X-Forwarded-Encrypted: i=1; AKwUvBzufmmbhYd4xSed/fMk59/F3YhRVTjIF09HMXXznurK4Czb4M1LBLqK90F/1IjTSJm51+Ta2hZ9SVYHhNpttw==@vger.kernel.org
X-Gm-Message-State: AFuF++l9LKH5JIOB238tOnh6X3qlk1W3mhsGuso52b83wzB0sR4nUd1e
	a6LH3PKPXP6zrD+27gGm2Tji72F++4TY06qOWRHqRep5EmqW3sAiygf82Zzh99LZew3eYO/Okm2
	dDmwHXHCH8y7UlmJ9oqjjxjTOcaBvIOKZjK5xNWomiy8rTREg6WCz4A8iQx2pIxRSBBNZQB2hYo
	TmcQ==
X-Gm-Gg: AYBFou0pARAgGzFVaLg+j/P8jxPbRs59ukkQjLXTqJw/MDSUD5COmYWtaRqKc4wMEh2
	M4FHSn4vIigptJERG/4+fVVlm8nNIC+uWzhfsG139I8Tkt3K/h79HzEgJVu+mf1kC6YJxi1yhtU
	lr/hgi/T+eY5xAbN1t2y1k2JTpw6fYXxgzm4xdYtYQzrbi7rdbUEjF1azX3lcJ+mQfai10AOEIX
	SGW7eV8gyF2NVuXtvrZE6vv/bJr5LxM9S/Bf8beZEmEctpqMOAgAo0swyQ3UDUM83JsOxPaBp1c
	DUV6UuOGDn+jaCabj7bBEDvWLAqL6y3QZEJH21C4x5C6N2HViBa+beCTJNPgs+X6duZGHg2Ps++
	yqoGYOZA0KeAl428N5J3MF9foifbGLHFDdzM=
X-Received: by 2002:a05:6a20:1602:b0:3d3:aed2:6f23 with SMTP id adf61e73a8af0-3da21638008mr27894221637.23.1788783796932;
        Mon, 07 Sep 2026 05:23:16 -0700 (PDT)
X-Received: by 2002:a05:6a20:1602:b0:3d3:aed2:6f23 with SMTP id adf61e73a8af0-3da21638008mr27894181637.23.1788783796321;
        Mon, 07 Sep 2026 05:23:16 -0700 (PDT)
Received: from [172.20.10.2] ([152.59.48.104])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-338778fb926sm2794285eec.31.2026.09.07.05.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 05:23:15 -0700 (PDT)
Message-ID: <dd02ef49-2e37-497b-9a37-32a5b2c93539@oss.qualcomm.com>
Date: Mon, 7 Sep 2026 17:53:09 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IPQ5332 multipd: missing text PD level and qcom,rproc ownership
To: Hideo Sumi <hideo.sumi@mugops.com>
Cc: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        vignesh.viswanathan@oss.qualcomm.com
References: <20260902041339.7665-1-hideo.sumi@mugops.com>
 <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com>
 <20260902192434.54709-1-hideo.sumi@mugops.com>
 <9103ca95-5e27-4979-994c-e14f123cec7e@oss.qualcomm.com>
 <20260903124238.59908-1-hideo.sumi@mugops.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20260903124238.59908-1-hideo.sumi@mugops.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDEzNyBTYWx0ZWRfX8jPRP/HFCiEb
 QVAWaQgOuretdrvn/r17ia11R73uwUzSFYDXUXQ1m489f/AVGMh5uTdHnRJZwKVMrZbvEevmClO
 LROkvKbU+n3g5M6I7o7nY8Qex9/A71g=
X-Proofpoint-GUID: kiig5lh2a6XIdyXJbmoR2Ngo5NgKG4TS
X-Authority-Analysis: v=2.4 cv=ObSoyBTY c=1 sm=1 tr=0 ts=6a9eacb5 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=LjvNJr9HdsU1EkKhf9BFDQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=aTTwR_pdSoFANY7pt1YA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: kiig5lh2a6XIdyXJbmoR2Ngo5NgKG4TS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDEzNyBTYWx0ZWRfXxfopkYg8OX0R
 QJhObpG1N9qfSHoXKa+lroy/E3CL3B41aK2BBhtyZyYSs9ICgt9lSldb3Hryffqhy5bOVbTpSxf
 g6d8jKv6nbt/xWmIvgvaEr8XOfJfq9rHr4+2p9dRW6uzIy4sJ4I7F92cOYXhNwt6iAiGXoz2rUR
 dNRpLgVh8AriRHKAZV56+0KNx9oKL1rs9oTrfd6FxJEs5zTv+CsftrnmPbW1MxN7nAUpmtm2ouc
 7fkCuHKHJXfUzJ3I5T/PwHITlyTfM8xwOItjspWww9A/yN+Gg+teyyIGJFF+cDue3YeHFpVh2qn
 Y4o9ktJYpiNiJI+8UTnjci7ecaABsX/YpA/G+shxhpaV+qBF3lZoOzl/VfaYcybPZnDIIvYVZr5
 GshsSrwggST1mRI5kpOCs66vtT34z7JT5yl8SK89+9Tl3yeaPNhpECggrpy/Qu8kpLT7prXug6e
 ep1ZjSN9xqH2L5Eiw5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070137



On 9/3/2026 6:12 PM, Hideo Sumi wrote:
> On 9/3/2026, Aaradhana Sahu wrote:
>> Before we look into the SMEM handling, could you please confirm whether
>> you are using the latest ath.git ToT and whether the remoteproc v14
>> series is included?
> 
> No on both counts, and thank you for the pointer -- I had not seen v14.
> Let me be precise about the base so we compare like for like, and then
> ask you the one question that would settle most of this.
> 
> This is an OpenWrt build, not ath.git ToT:
> 
>   - kernel 6.18.44
>   - ath12k from the OpenWrt "backports-6.18.39" package
>   - the multipd remoteproc support is the *old* series: Manikanta
>     Mylavarapu's original multipd patches (Nov 2023) plus Ziyang Huang's
>     "split q6_wcss to rootpd and userpd" fixes (Sep 2024), carried as
>     OpenWrt target patches.
> 
> It does not include your v14 series. So it is very possible the issues I
> raised are already addressed there, and I do not want to send you
> chasing a three-year-old base.
> 
> The core of my first mail was a *text PD* level between the root PD and
> the user PDs, which the vendor firmware for this part requires and which
> the 2023/2024 series does not model, so I added it locally:
> 
>   q6v5_wcss   qcom,ipq5332-q6-mpd         q6_fw0.mdt   root PD
>     text-pd   qcom,ipq5332-mpd-upd-text   q6_fw3.mdt   shared RO text
>       pd1                                 q6_fw1.mdt   user PD
>       pd2                                 q6_fw2.mdt   user PD
> 
> So the question that would settle it: does the v14 series introduce this
> text-PD level (a shared read-only text image loaded between root and
> user PDs)? If it does, my local patch is redundant and the right move is
> simply to use v14 -- no need to debug the old base at all. You wrote the
> series, so you can answer that far faster than I can by porting it.
> 
> I am glad to help validate v14 on this hardware if that is useful -- if
> you can point me at the base it is meant to apply on (ath.git ToT plus
> the series, or a branch), I will build it for IPQ5332 and report what
> reproduces. I would just rather not promise a blind full rebase, since
> 2.4 GHz already works here on the old base and I do not want to trade a
> working setup for guesswork. The OpenWrt device support proceeds on the
> current base regardless; the upstream question is only about landing on
> your track correctly.
> 
> The details you asked for, in any case:
> 
> Firmware version, from the Q6 error record:
> 
>   WLAN.WBE.1.3.2-00067-QCAHKSWPL_SILICONZ-1.128291.1.135427.1
> 
> Platform: Qualcomm IPQ5332 (Xiaomi BE3600 Pro). Two on-chip WiFi
> devices, two user PDs, both attached to the single Q6 root PD via the
> shared text PD:
> 
>   - wifi0 / pd1: on-chip QCA5332, 2.4 GHz, AHB
>   - wifi1 / pd2: QCN6432, 5 GHz
> 
> The multipd DT (our downstream form on the old base):
> 
>   &q6v5_wcss {
>       firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw0.mdt",
>                       "ath12k/IPQ5332/hw1.0/iu_fw.mdt",
>                       "ath12k/QCN6432/hw1.0/iu_fw.mdt";
>       status = "okay";
> 
>       text-pd3 {
>           compatible = "qcom,ipq5332-mpd-upd-text";
>           firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw3.mdt";
> 
>           pd1 {  /* wifi0, 2.4 GHz */
>               firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw1.mdt";
>               interrupts-extended =
>                   <&wcss_smp2p_in 8 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 9 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 12 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 11 IRQ_TYPE_NONE>;
>               interrupt-names = "fatal", "ready",
>                                 "spawn-ack", "stop-ack";
>               qcom,smem-states = <&wcss_smp2p_out 8>,
>                                  <&wcss_smp2p_out 9>,
>                                  <&wcss_smp2p_out 10>;
>               qcom,smem-state-names = "shutdown", "stop", "spawn";
>           };
> 
>           pd2 {  /* wifi1, 5 GHz */
>               firmware-name = "ath12k/IPQ5332/hw1.0/q6_fw2.mdt";
>               interrupts-extended =
>                   <&wcss_smp2p_in 16 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 17 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 20 IRQ_TYPE_NONE>,
>                   <&wcss_smp2p_in 19 IRQ_TYPE_NONE>;
>               interrupt-names = "fatal", "ready",
>                                 "spawn-ack", "stop-ack";
>               qcom,smem-states = <&wcss_smp2p_out 16>,
>                                  <&wcss_smp2p_out 17>,
>                                  <&wcss_smp2p_out 18>;
>               qcom,smem-state-names = "shutdown", "stop", "spawn";
>           };
>       };
>   };
> 
>   &wifi0 { qcom,rproc = <&wcss_upd1>; status = "okay"; };  /* pd1 */
>   &wifi1 { qcom,rproc = <&wcss_upd2>; status = "okay"; };  /* pd2 */
> 
> Thanks,
> Hideo

Thanks for providing the details. This helps clarify the setup.

I checked the backports-6.18.39 code you are using. With that version of the Multi-PD implementation,
the root PD and the Text PD handling is done by the remoteproc side, so for the issues related to the
Text PD, I think it would be better to confirm the expected behavior with the remoteproc team.

Regarding the latest ath.git ToT + remoteproc v14 series, please note that the firmware you are currently using:
WLAN.WBE.1.3.2-00067-QCAHKSWPL_SILICONZ-1.128291.1.135427.1

may not be directly compatible with the latest upstream flow. The WCSS secure PIL flow expects the Q6 DTB
rather than the bootargs-based flow.

I am also not yet sure whether the v14 remoteproc series contains all the changes required for the complete
Multi-PD bringup on IPQ5332.

I have added Vignesh from the remoteproc team to help clarify the Text PD handling, and also whether v14 is
sufficient for the IPQ5332 Multi-PD setup.

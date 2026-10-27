Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090073;
	b=04agy05mB24+xzJwkpyQKlOrWis0VHRx6SHsewdbgz8m3jnSbO7+B+IPfrPvNRAxFJqH
	 MG2fQT4hoIwQpnK4b3woPEQzcGXIEkX5twlqFrETT2IRJR/FHWbyG4UTYe+unUkiuT7vA
	 q5IpFERBzuy2w3YLHbIrmUNgb9FAfXCtU2tC7EvkmbyMbuZ7cE6W1HLagkniat05wuQSr
	 fwHcZj/KjS8rUOzsul2yK5jmFf/mZwkheDmHvy0KuKwciMZBgLjUjXnEAAojpPyz5tYvM
	 evaz0i1v6K/mns9+e7Qf/udADqVJuvbuhC4wQyrNI3zB/NHgEFPMAsh7pyFm8Z2cMyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090073;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4wrQkMaK+dW/8z6fl3qfa+S+gShoibCmJmmER0g7vrM=;
	b=D32RV5B9DVE1QuTZ3WRdTipI4HbQpX0DJYEyDR/54BmPgUnKSc57w97ESZRcdfiGcXAI
	 sqtdM92JBbgkzyzjlmPXuTC8sblX0jtc5qm4YqJY1P20QT2D4d3h0i0uwc35gNJmiEI+Q
	 i2xD0E1pETNTs93HIynV0ZzpLfRUWyu2b+KD/eN5hrUkmpXR3ap2f/UGY2JkoIZ8XttZK
	 zANL5BI6MGgopUbdatOzs+T2kVlowxojbokZCyyoVh1jlTxdL3vMjgmIMSsVIWLZxbfC5
	 7LZISJl+6iVtj4STDg00VAtab4VGbfnHliY1HmEo76OrUhhV1GxRyqEDM8yZbzCSkkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kF5My7A2;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WkZ3Opre;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E38E606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E38E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kF5My7A2;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WkZ3Opre
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R5YsRH2336765
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4wrQkMaK+dW/8z6fl3qfa+S+gShoibCmJmmER0g7vrM=; b=kF5My7A2IRd6QUBi
	LDTYgdiZ/J3U/lZ/GtNQZpoNmIiPeD/WZfJ2vEo+v5WVHLqxlGvePKQH8aOLYeB/
	JNQ7aOJzzqefKSquofAmkbedrb5n2jlEQvZSxXa9tkajc+Ku2+BqMjz9IkEb/9tP
	CjgoVSDwqgLw1/H/4j6gu45p5MUH/4XoiH4djvxfGAhaZ+txFJ6DRxcLm0wmE8Pz
	Ii0eD6WaM92n9RQdEqhrgpBocvY90oLPn1OX5k0n/AzxtGukDq8xYvipujlZrbnw
	F1Owy/Qb1vLiVqIARITwyXQvCI33laY3SizEWol549pAazrsgAN0gBvGIN67KjM0
	eAWY5g==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hje3da4bh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:34:32 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89e05d31e54so2661155b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793090072; x=1793694872; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4wrQkMaK+dW/8z6fl3qfa+S+gShoibCmJmmER0g7vrM=;
        b=WkZ3OpreAQb8BVy4LA27hGCZAGNgGCGbi9Jl4i3eoSIA6QinNB6dw+zEiuvI7fNM3q
         5O2LqR65CO1qNKs+POfMM+gzrAWr/4+HhI+uS0TchA2wGexh71gZLwm4uklTkuoD+xVx
         /xNmU1n/tk9eJNUpftST7IGfm3BNLY0a/7qgMMS/T4WAPoBpBQLuNx2Bx9i/yPqC+NPP
         t1zRBMmcgaj8VL9NkU0KzUCfvjDb/GVcM9R3XFgqbxf1Fn82nr9Wiwt+PZazKDshTpq2
         qwo90GDjXXCDkbYkgD/J4UBnRvRl+cY7wifGAWBexIQfUEa4XAblu9MzZqcCVukmYq0e
         MizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090072; x=1793694872;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4wrQkMaK+dW/8z6fl3qfa+S+gShoibCmJmmER0g7vrM=;
        b=ua+d/2qoUNnVGc5k896YpK/FTktiHVV8avEjOsZ941HfHuwtli9eWtlQWzeKf/h+Tr
         EJ+Vt8gpUPpv3oEI20+lMKcnxsx602yAGR4GNzLVXEEnOPduMYOzolEXdEtaWvwY1qWG
         ETFrT/NrpSMuPJLUMdmfK3zI860nsOn7hhdyLisBXCj0/VKKuesf3lKLcpeUlq2cBkh2
         et7kvSzf7SB1Thc9mEhtgQskketRpDb82xsb2K4YzfCqLE/hswJgEUL8S247AiinnaGZ
         9jksUbJ8nOHVFw5iS01ijsn/v9RriD7EbVA1PbKZHftt7AHdjji3JxdpJgaQZNCVIXYk
         Ipkg==
X-Gm-Message-State: AFq9FYLcpvYmH3jh9HRWMN/KYbeXdP8tqI2fJWWO3SrKgYev+z1b3m06
	qW1DB7uYDYOwy5jWVSMWZmH732V64CZCrmo+2eiB+MdaJxuEGhxJB5IVxl5PNkIn7uAc9KIRF+p
	JJnUwnlEtpuLrL+wwAzr61b7zY/hTUSGWVRUWyoaUxEml4SQHlzzOK8e2S4lFfHDPr0pCaw==
X-Gm-Gg: AYBFou1Nspo0sOK0rHJVxP+NirUDPWA8tznWj0VB3H2fUgPEl5h3S75QtMvZ+s3FyhW
	5suggMQvGSso7yymm2BKGU4wyFedZGAqgPQTI6XgwMVumhHYwL8TqxKevLjP7IaTKQA9E5/4xXc
	YRWKPZoDRyv1cASdyWflIbRTpq7RSdunFC4DS8BD9tYikBenGsY90HmBXdGN+YqIR3WwbrV4pjm
	xwzUCAB+2VJXnpEiOAqtO8vdplkuAOIUGue0g0K2IMTLVnpMgSlZLg4vum3NFikfQcYHqZHnCU9
	SUMgpVuK1Rl+xZynva6PIRqGxbi79TzMidfzPccCotMO1G42OcLAF01vqjmWGBqOGwfvLy13nyg
	YwQDdHJMvghYcNvUlUfD7FzvWiEs0r1yepwvi7QxFI7g7UkcFdTcuAmAV35nNvO0+u/2dD0/bFA
	==
X-Received: by 2002:a05:6a00:1889:b0:89e:7bfa:f884 with SMTP id d2e1a72fcca58-8a367a3cf01mr7107764b3a.18.1793090071591;
        Tue, 27 Oct 2026 01:34:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:1889:b0:89e:7bfa:f884 with SMTP id d2e1a72fcca58-8a367a3cf01mr7107751b3a.18.1793090071132;
        Tue, 27 Oct 2026 01:34:31 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d87afasm2119266b3a.7.2026.10.27.01.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 01:34:30 -0700 (PDT)
Message-ID: <87eb6978-74fe-4ec6-b76a-b09210ceea7a@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 16:34:27 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix lost 5 GHz range by
 tracking reg ranges per radio
To: Ahmed Essam <mrmrmidoessam@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shenghan Gao <gsh20040816@gmail.com>,
        Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        stable@vger.kernel.org
References: <bbd65b93-816b-427b-8abe-1d1fd1cf4e70@oss.qualcomm.com>
 <20261027015919.277156-1-mrmrmidoessam@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261027015919.277156-1-mrmrmidoessam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAzMyBTYWx0ZWRfX/q1B/mw/OMFN
 jv18J54vCu9UEEHlfF93JRyvsQW21HVy98Ed8uWKwwnYSAtcE+b+n1bmWw14BvXLfH8nOvXU/ZP
 dMq2kG3rPEBLBXR+CAFEHXcIqEIF8gY=
X-Proofpoint-GUID: wcckwNx2k0VZWC8rviHJDNHcvmaJEySI
X-Proofpoint-ORIG-GUID: wcckwNx2k0VZWC8rviHJDNHcvmaJEySI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAzMyBTYWx0ZWRfXwZf50t5r6ARe
 384mB+uAwbhYuKjGUg0crjYGnjXZmxO+Jf3XAniwybPgj7j6o1sHVMXexkImasvZfYE2GNNsFjd
 K8eXAus5fKf4OCIiiAybJzxzIH1tOHpkE/wIwH9LKoIxjXQWKysrV1DPvgHI8BFxb7/1zMiv5ar
 GfRuhRyk/djrnqnBKEbZEwR1T2Coe6DvZlZDXGxKKUAqbniYHc6M3A/PufR/zYAAVCbkQLj1G/w
 cljjuCvPM7nKGo54U6kB5UYLMj6jwLjVRUhAcxuFB3VOJivaVpSmQvOb1HHbe9uwvn/JBV3SZb4
 9i83my0IT1CNvZphQoZAXMR9aROTiNWLqLg8BpeK3O840o8bhuF0/LpVzebWKSMUaRm0bxyMIMV
 2hDq+kqYiDfVRLuyglw1ioBDlLhoczNtYXlJie/2GDdsIUtPROJ4nYySqms9zFXmWnylcfNniDf
 2WREonuLx6GKlu0u3vg==
X-Authority-Analysis: v=2.4 cv=SN/Xx+vH c=1 sm=1 tr=0 ts=6ae06218 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=JLF8xD7Yat_ry6Ihdo8A:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270033



On 10/27/2026 9:59 AM, Ahmed Essam wrote:
> ath12k_reg_build_regd() records the frequency span covered by the
> received reg rules in ab->reg_freq_{2,5,6}ghz. Those fields live in
> struct ath12k_base, but firmware sends WMI_REG_CHAN_LIST_CC_EXT per
> radio, and ath12k_regd_update() uses them to compute the frequency
> range of a single radio (ar->freq_range). This causes two problems.
> 
> First, ath12k_regd_update() cannot tell which bands a radio received
> rules for, so it uses ar->supports_6ghz as a proxy: the 5 GHz range is
> skipped for any radio that supports 6 GHz. That is only valid for
> split-pdev devices. On single-pdev devices such as WCN7850 one radio
> covers 2 GHz, 5 GHz and 6 GHz. When firmware switches to a country
> without 6 GHz rules, for example after an 11d update to CN or EG,
> ar->freq_range collapses to 2402-2482 MHz and
> ath12k_reg_update_chan_list() drops every 5 GHz channel from the list
> sent to firmware. From then on firmware no longer scans 5 GHz, a
> 5 GHz-only scan request fails ("received scan start failure event"),
> and 5 GHz networks disappear from scan results, typically shortly after
> boot. They stay gone until the driver is reloaded or firmware moves to
> a country that has 6 GHz rules.
> 
> Second, by code inspection, build_regd() resets all three per-device
> ranges on every event, so on multi-radio devices an event for one radio
> can wipe the range of another radio whose regd_update_work has not run
> yet, silently dropping a band.
> 
> Move reg_freq_{2,5,6}ghz into struct ath12k_pdev and fill them for the
> radio identified by reg_info->phy_id. In ath12k_regd_update(), include
> a band only if this radio registered that band and received reg rules
> for it, instead of guessing from ar->supports_6ghz. Checking the
> registered band is needed because a radio can receive rules for bands
> it does not operate on, e.g. the 6 GHz radio of a split-pdev device.
> 
> Also fix the reg_cap lookup for single-pdev devices: pdev->cap.band[]
> is indexed by enum nl80211_band, but was indexed with the
> WMI_HOST_WLAN_*_CAP bit flags, so the 2 GHz lookup used the 5 GHz
> entry and the 5 GHz lookup used the unset 60 GHz entry. Refresh
> reg_cap for the 6 GHz band as well, as is done for 2 GHz and 5 GHz.
> 
> With ATH12K_DBG_MAC enabled on WCN7850 and the firmware switching to
> EG, the range before this change is:
> 
>   mac pdev 0 freq limit updated. New range 2402->2482 MHz
> 
> and after it:
> 
>   mac pdev 0 freq limit updated. New range 2402->2482 MHz
>   mac pdev 0 freq limit updated. New range 2402->5330 MHz
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 657b0c72c4ad ("wifi: ath12k: Fix frequency range in driver")
> Fixes: 13324cecbb2c ("wifi: ath12k: Update frequency range if reg rules changes")
> Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> Cc: stable@vger.kernel.org
> Reported-by: Shenghan Gao <gsh20040816@gmail.com>
> Closes: https://lore.kernel.org/all/20260715065218.41232-1-gsh20040816@gmail.com/
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Assisted-by: Claude:claude-opus-5-5 sparse
> Signed-off-by: Ahmed Essam <mrmrmidoessam@gmail.com>

Ah, I have an almost-identical fix pending internal review, but I think yours is better.
Thanks.

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


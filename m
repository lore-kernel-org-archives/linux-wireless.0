Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330553C13F9
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 06:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415847; cv=none; b=szqKVsHZLyNNzCMcr+68rO3bIM/zk4hKogQRglOdjZeTB1DaIz42LEhdaDISMV3+yfslT3V4d//V5xkBls4aYKKgLVjwNJNGmJqvTGlNN0mUq7LvvZ2xErtm6Z0gcn5b+vqVX0UrPViX9WBK8NRog9CFQ7f/vMGQZjSWPQUviAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415847; c=relaxed/simple;
	bh=TL14WKnq3VP7H6+KE6bwqJt9IOv7RxYKeVsj5vtJSSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aG0oUmBQ8lJJn+teyYbZHjAcTochHc6LCFBTrvrl2s6CLVT0qjqliy9LrG7ipoKyJ0XEPecezJ1R+Uk0GoaWVlOrXKJVY5PkQz5RpdZRRTLwqk9YVfx0ZCgFtxInAARzPWHUIn7bAAhb5k6EkrSOzNEr564Rf1DbI3Wu8R66YlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DCRDpbru; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iLaal9kd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DCRDpbru";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iLaal9kd"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6835luv43750225
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 06:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	91AZ6ySo2GU0comiuHGaun1xtRTKFM9Pkah81PE5WJ4=; b=DCRDpbruN1ez9GpU
	KfgUTky2Y+FAuqvRGCYnir8of1GF7scmCKO0PRr6PK8H9E59xlbsA+I0f41BWsI4
	o/jv6eb80z6IUT6IqVE5O6nPdNGEk2/HfcWVd0MPs4kOSCIPMqbt5i3eXAPXSdYY
	LSTN0xNcwAYZILx3QOB0VNj7B71eQCXwqD7en6AAOvKX8EZitq5D2OgIhLptoF4D
	3Q+417+fdVzzOkml60jA8GlvBpFXhlSiqjz9vDx/lDs2WqZd8kjKWzKOMkNKPTiL
	pJiAYhKqsU3KLjA8cb3HlHRHeSK8j+li+i/92/rVeSFwODJo6fFqyGc320UwKWME
	RYqw+A==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gepv5u4du-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 06:10:44 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1eb205d31so2740632a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 23:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788415844; x=1789020644; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=91AZ6ySo2GU0comiuHGaun1xtRTKFM9Pkah81PE5WJ4=;
        b=iLaal9kdz4BW4y5WkFgSQgUmdDQZCk+ngTSRw2pycjBS1YrzS8Ynhw/0Hi9j64EeHQ
         C0WZiN7aWiUNzIC7Zh0iPOwL1+nLc15HUJS3TMNTC42nsYkMYyhEmcC9RlEWuOR48o88
         5mVL9oblCcXQOT8aJ4KsUOY2qF9RBi5db7AsuZMZkSTqLBpLL3tp0XzaKZ4yak7xsQVq
         IlMmNAngWGNmkVaiXrpDbqVQmOzLrGjxX403B+TQZXtv6wR4TH5u5Z2bYfW3XjZo5Gdr
         JHyRKr33tCLj1ThYYfPyNIvn+7wOSM6RU/ke5ilWCc29Qmz8aC2kxJBk16r6VLL9RYSE
         CmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788415844; x=1789020644;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=91AZ6ySo2GU0comiuHGaun1xtRTKFM9Pkah81PE5WJ4=;
        b=EIeLCbE6QgXTRw8fJ2s8WjTpjr8ocN1S4U3H0gtH05uIRja8Fd216QMounKJ8wH65F
         JfO9pbC3xNDteTN3XU5PKhsNAUmwvKWUpULhZCr/acDKmPD+DhtmeY8ZyHiKIBQF8U6N
         k9PvLSuzrrQY7Bef0IHEXYq27djv614/PaYexGB7PBx3hYrzUCyK05yHlquWsdOjS9Zh
         gUNeUnlAaC9paYKKL+5JoCdTekk8ImS4wjBoxn/c/ctuiGm7l79n8o+qrG5qz1g/WU6u
         DEldXfB5urThlOeYWIhbDmD+5rAT/HByTzMlDnSOAI1LWhHLTpMGLw9JYS6z+N1n3xD3
         PR8w==
X-Forwarded-Encrypted: i=1; AKwUvBwxOdEWgkqavSHaDJ6EaYCf+dMkry5kNr6snbOnSx7zidrHtMs8TotqczmAM/yJ2EkH6JNdvy+4226jw8TMlQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nZeYzjLXnEL50VDHQy7+4AvP5P1t+y3F67YKj3S8Nx7WAynXH5
	W7wv3UKbi2m1wyqrtr8kZJDe5KZ//VgZSq+rBUfuRiKNXv8MFhvZkue9ZQNdk46NauCQxnxQJR1
	M3jUn9d/1TpNwzO6spMPSb2ob0ZmEzkLbPbrG6VBXOG9G/aS2SMkUMk9SBb+gTdBRwuCxOAEo+r
	HRcg==
X-Gm-Gg: AYBFou1NQMLlMyx6q1Ys8oKo4CXSaRYPCtwZXoBEvT4/s5kEI7//xcp39sO8hpLybV8
	Y3tDemrzUraZ0SOMox058rfdcF5qfoBGOxKoQ6nCFXROjoa7WDCObqZ9/B/fga8PKVzs6rvjAJo
	saHHmikpBJofi+AZERgsoE/SMGvIhYFYDJ3oCDZUGmRpCCA2ndy0C5X1Rw1bAfkO0MKQBcnpOLW
	6oWim8ZqaCkGJaEbYknY2py4WL8gmIs3cDQnIMIMP8tufrcPGdwrMvlynoMPwCDcAXMlfX+HU6r
	W6d9wqq4M0qwVMDv5ACd/vhD/Ne7Vk2H4WO2O6QVcDEwQnxD9z7MLyEKnO+IUSRZSLv4yH/yGI/
	aEcDwVflFm9N0BVK4afVOJGTAyrAUK2Hn9g==
X-Received: by 2002:a05:6a20:4304:b0:3d3:ae0f:526a with SMTP id adf61e73a8af0-3d9b0420a54mr14305570637.22.1788415843876;
        Wed, 02 Sep 2026 23:10:43 -0700 (PDT)
X-Received: by 2002:a05:6a20:4304:b0:3d3:ae0f:526a with SMTP id adf61e73a8af0-3d9b0420a54mr14305487637.22.1788415843240;
        Wed, 02 Sep 2026 23:10:43 -0700 (PDT)
Received: from [172.20.10.2] ([152.59.48.67])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-332501e5447sm4873959eec.0.2026.09.02.23.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 23:10:42 -0700 (PDT)
Message-ID: <9103ca95-5e27-4979-994c-e14f123cec7e@oss.qualcomm.com>
Date: Thu, 3 Sep 2026 11:40:36 +0530
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
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20260902041339.7665-1-hideo.sumi@mugops.com>
 <741d7c3e-6eea-4a84-bf4c-8d8eb8032c83@oss.qualcomm.com>
 <20260902192434.54709-1-hideo.sumi@mugops.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20260902192434.54709-1-hideo.sumi@mugops.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=T8y8ifKQ c=1 sm=1 tr=0 ts=6a990f64 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=xmPyY564vjej6uAyVk/9Uw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=N4V0GIZ52OFWYRwfAJIA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: 41Ylp1rDJVZ59IRmly0hZp47mERrPhJf
X-Proofpoint-ORIG-GUID: 41Ylp1rDJVZ59IRmly0hZp47mERrPhJf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDA1MyBTYWx0ZWRfX2qdPcgLqjStP
 wXcoZnQ+OE4gI1S3gSY0g2cYkPb1n/Oq5lL9I/LMf0xX/bLSumiUddVouLaxcIAYXubsMV7IcYQ
 6sHcPNRMYM87caAnkQ3N1CbWqorj+AqDHnSA8/u8ePqn3jIO7oCgOEY+oesS567N7/YQeXcJGu2
 Gx+8IrtsAaRxHdn2GBmBUoguOEI9Yr+Q2HvWB6bT/Cl+Rw9taliwDC1nWktyMdKcV/sOr7GCkwD
 Toj0kwfiq5iBH60l1tWH9DY1Cl/mOQvdpJ3tuJKT7UwafwHPXWYpRZvqWaY8wWVDym4JXBtR8/l
 tRFOHSNOwT2eZqq/SXvBAwsc8x4lnuLT3D6CQcJL7NzObkE7tEtpQaazEf9K3rGBdo/nnZfXBhE
 WCI1FB/Ss4IEUwnoTcEUYaokNttlJhwVfl7TL84MY0O/9HHZxeRe8w8gn2kHsvdnlAtMe0jqcX3
 M0HXy1K75uMRr+fD7wA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDA1MyBTYWx0ZWRfX6IsOjbGXxtU0
 /5UnaKtB229aSUdjm9CeOkCajsymR5d9lz3d35eq/bPNKbPI0jfr5kpxnddBpMUX564icihcikY
 WstOV+sSlx0aQlkem3r7KEqCWa7nbVo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_02,2026-09-02_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030053



On 9/3/2026 12:54 AM, Hideo Sumi wrote:
> On 9/2/2026 7:47 PM, Aaradhana Sahu wrote:
>> The intended model is that the root PD is completely managed by
>> qcom_q6v5_mpd, while the Text PD and WiFi User PDs are managed by ath12k.
>> ...
>> So, qcom,rproc in the ath12k DT is expected to point to the root PD.
> 
> Thank you, that settles both questions, and the shared firmware patch is
> exactly the piece I was missing. I built the model you describe and ran it
> on the board. It gets a good way in and then stops, and the last problem
> does not look like something a board can fix, so I am reporting what I
> found rather than guessing at it.
> 
> What I built, on 6.18.44 with backports 7.2:
> 
>   - ath12k loads the shared read-only image itself, your patch [1] ported
>     to this tree (it predates the common/Wi-Fi 7 split, so the mapping
>     comes from power_up() rather than from rproc_info)
>   - the text PD node is gone from the DT
>   - the user PD nodes are gone from the DT, so qcom_q6v5_mpd does not
>     instantiate them
>   - qcom,rproc points at the root PD
> 
> Three things came up on the way. The first two are, I think, plain bugs;
> I have patches for both and will send them separately if you agree.
> 
> 1. ath12k subscribes to the SSR notifier by rproc->name
>    --------------------------------------------------
> 
> ath12k_ahb_register_rproc_notifier() does
> 
>   qcom_register_ssr_notifier(ab_ahb->tgt_rproc->name, &ab_ahb->root_pd_nb);
> 
> but that lookup is keyed by the SSR name a driver passes to
> qcom_add_ssr_subdev(), not by rproc->name. qcom_q6v5_mpd registers
> "q6wcss" -- the same short name qcom_q6v5_wcss.c uses -- while rproc->name
> is the DT node name, "d100000.remoteproc" here. So the notifier registers
> against a name nothing signals:
> 
>   remoteproc remoteproc0: remote processor d100000.remoteproc is now up
>   ath12k_ahb c000000.wifi: RootPD ready wait timed out
>   ath12k_ahb c000000.wifi: probe with driver ath12k_ahb failed: -110
> 
> Subscribing with "q6wcss" fixes it.
> 
> 2. wifi0's memory-region[0] does not contain the images
>    ---------------------------------------------------
> 
> ipq5332.dtsi points it at q6_ipq5332_data. The shared read-only image and
> the user PD images link below that:
> 
>   q6_fw3 (shared RO)   0x4aefd000 - 0x4b296000
>   q6_fw1 (pd1)         0x4b2a3000 - 0x4b55b000
>   q6_ipq5332_data      0x4bd00000 - 0x4ca00000
>   q6_region            0x4a900000 - 0x4ca00000
> 
> so qcom_mdt_load() refuses them:
> 
>   ath12k_ahb c000000.wifi: segment outside memory range
>   ath12k_ahb c000000.wifi: failed to load shared firmware: -22
> 
> Pointing memory-region[0] at q6_region loads both. If ath12k is to own
> these images, the region it loads them into has to be the one they are
> linked for, and on this SoC that is the root PD's window.
> 
> 3. The user PD nodes: removing them is what the model requires, and
>    also what breaks it
>    ---------------------------------------------------------------
> 
> This is the one I cannot resolve from here.
> 
> Leaving pd-1/pd-2 in the DT does reproduce the IRQ conflict, exactly as
> you said:
> 
>   genirq: Flags mismatch irq 31. 00002001 (UserPD1-spawn)
>           vs. 00002001 (q6v5_wcss_userpd1_spawn-ack)
>   ath12k_ahb c000000.wifi: Request spawn irq failed: -16
> 
> Removing them clears that. But the root PD then stops during its own boot.
> Its crash record says:
> 
>   pd_stubs.c:137  Invalid user-pd CS load address 0x0
>   Thread name : sys_m_smsm   Process name : kernel
>   PC : 0xc000ae58  SSR : 0x018f0027  BADVA : 0x00000000
> 
> and ath12k ends at "UserPD spawn wait timed out", probe -110.
> 
> The address it is missing comes from SMEM item 507, written by
> qcom_q6v5_mpd's share_upd_bootinfo_to_q6() before the root PD is started:
> 
>   list_for_each_entry(upd_rproc, &upd_rproc_list, node) {
>           upd_bootinfo.pid       = upd_wcss->pd_asid + 1;
>           upd_bootinfo.bootaddr  = rproc_get_boot_addr(upd_rproc, fw);
>           upd_bootinfo.data_size = qcom_mdt_get_size(fw);
>   }
> 
> upd_rproc_list holds the user PD rprocs qcom_q6v5_mpd created. With the
> user PD nodes removed it is empty, so nothing is published and the root PD
> faults on a zero address. With them present, remoteproc owns the spawn
> interrupt. As it stands the two requirements exclude each other.
> 
> So my question is: in the intended model, who publishes the user PD boot
> info to SMEM 507? Three shapes seem possible and I did not want to pick
> one blind:
> 
>   - ath12k writes it, since it owns the images and knows their addresses.
>     That would mean moving share_upd_bootinfo_to_q6() out of remoteproc,
>     or exporting it.
>   - qcom_q6v5_mpd keeps writing it, reading the user PD nodes for their
>     firmware-name but not creating rprocs for them. The nodes would stay
>     in the DT and describe the PDs without claiming them.
>   - Something else covers it that I have not found -- the shared firmware
>     patch does not touch SMEM 507, so if there is a companion change I
>     have missed it.
> 
> I do not think [1] alone is enough to boot this without one of those, but
> I may well be reading the wrong tree; if this is fixed in ath12k-ng or in
> a series I have not seen, that is a fine answer and I will go and read it.
> 
> For reference: reading the Q6's crash record needed a change of its own.
> q6v5_fatal_interrupt() calls
> 
>   qcom_smem_get(QCOM_SMEM_HOST_ANY, q6v5->crash_reason, &len);
> 
> and QCOM_SMEM_HOST_ANY is -1, so smem.c only searches the global
> partition. On this part the record is in the WCSS private partition, host
> 1, and qcom_q6v5_mpd already defines WCSS_SMEM_HOST as 1 for it without
> using it, because qcom_q6v5_init() has no way to pass a host through.
> Until I read it from host 1 every one of these failures printed only
> "fatal error without message". I am happy to send that as a patch too if
> it is wanted.
> 
> Board is on a serial console with a recoverable second firmware bank, so I
> can test whatever is useful.
> 
> [1] https://lore.kernel.org/linux-wireless/20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com/
> 
> Regards,
> Hideo Sumi

Before we look into the SMEM handling, could you please confirm whether you are using the
latest ath.git ToT and whether the remoteproc v14 series is included?

Remoteproc series:
https://patchwork.kernel.org/project/linux-arm-msm/cover/20260803-rproc-v14-0-a1f87b0b0ad2@oss.qualcomm.com/

Could you also share the complete DT changes and the firmware version you are using?
It would help to know how many WiFi devices/User PDs are attached on your platform.

Once I have these details, I can check whether the issue is already addressed in the latest patches
or whether an additional change is needed.

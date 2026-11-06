Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960957;
	b=xYQqte2FbPSGeVYFTSK6xr9YLckwFZpyz9Ebb68RBvbWtj1fWR19Z9BT6bAmkPFs664N
	 Ovh+ubEc2bPVNept2hFAXNGNnT3Vkv+SMLGgtA6GCv8T0d9aTcqMD8+2y5uyDjq3xzRVb
	 QjiRcEgP3yZ+cnbQugE9iY67V4b2wQnvDUctW8keFhugI3E9f1hGt8fPX+iG0fSHFG5/s
	 xksC7G43qg1HOZuilzCL89LODgPpIq8ny9z6jiKvjoty2NN4qZethfZj5Jh8tAZxCf2Wh
	 F3HaqmWphY8UsaPQdgRyaLpS9DYOxcHrmI6V/Hm7ges86ef8VaY7IUNdm+ejUIJp+Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960957;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=8v3tl+9kpgG88CDZ3LlHDDVu3+mvZkT/wB+uI61EvJ4=;
	b=K3TcN7OHDgMRlYxsAQ8FWhmA6S2+GNH/1TBTkusSMOB/9zDm20ep/5u/ljx2hxHqbgpH
	 1vGPSL/KijqRs+1H6vjiN7juPtmriJA/Ko06yJhP6pdCkWeloMKewglnE/4UtQ1x9Y+7O
	 r5yCNstWclo6HjNPdL/LscGquVVP2n0IExoDNOrq9ZDcRrpbOR9rpTNVUDnn04Z7aeLxp
	 JEfdzHeYMIwkH5pkbgYlaQ4kaNXLK1GdfaNqOeEN1wTGc8Xx0fYIB5coExh5XwqrWlYMI
	 XkEqYUvmZspfvkyJIOAFTs3v7cluE+X4LVwqhHo257dtqwlgbRotPDh76nZdHdZBQeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GsE8gHqq;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JywnPnAr;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30333606A329
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 10:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30333606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GsE8gHqq;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JywnPnAr
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6APOes527642
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 10:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8v3tl+9kpgG88CDZ3LlHDDVu3+mvZkT/wB+uI61EvJ4=; b=GsE8gHqqxysxGZtB
	tdcgj0qPuOhiAAoIN/KHBNd05iHD+JLRPz1JZVtf+Ll0MKCK9N4IQ0G+XcLLwXdA
	JBxIQA6S2KIn0ckcqAgQw/OPZGFkV98rvw926JDHvaVmzuZT8riBekspFW1N9MVu
	tD+pB6SH72icvAozmO0BagqGlMzin98HjcMb1hTQfg6prYXQHSe4ivlvVUFrsMMZ
	0EctaHdZy/xsKGrihszKOHfYJSzowkVnRIkC4VDKDBlIFSufyoZSmXG0Ocw4tVjn
	Nh8TTFyPp8yVKk4eDmPs41/dOTHkynSG2Dvozq6hzoDCCwzUETGuML0nz1dIUawi
	7dgFeQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9tc00-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 10:29:10 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed2803f863so5751845ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 02:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793960950; x=1794565750; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8v3tl+9kpgG88CDZ3LlHDDVu3+mvZkT/wB+uI61EvJ4=;
        b=JywnPnArEkOh1xGSV6un9YxbzDB2kytwqviv/Y6PCwiW0Gca0e/E4QNlwyUeG8KMeq
         WrEsEeDevjDNA7LBOfTgUf5eRzJEArDy0eVv5S7zEEsCcx7KveWqpYWAQI1DghJcx9c2
         XXLFpN9aon3C/DZ6mnF/v9X52j/sW3Fwm783RE1a+I88P2AP5ZeptMi0yDZ2JHQKrJ3i
         cDg+whQQf+1G2PRuMPRL37s0DO2qdZu1HtROQr0l88CsadEOlI58CTREdvZkq8291UeO
         gy6aqctj+1jXWHlgmCVaecOyUSmPgxlhdOlZBWZB6yrQbcSJIEw6i52zBOH7zg9oEdPb
         uyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793960950; x=1794565750;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8v3tl+9kpgG88CDZ3LlHDDVu3+mvZkT/wB+uI61EvJ4=;
        b=Lxheg+UwA+RUxE7kSfkoD6cX884Wtko6aCAslmjac7w/OIk/Of9fB0YWEjz7pUggh/
         8FK2Th7I6orqYwW1CSiErty2vFzDwfzziGiiajgZNtD6qBNvCsdIr4emnlPMnPRDWPej
         xf3jxbCFQXF3O7JBnHHkIH1p/1u8DXu4Q6lNB+mzfktmN1RxxeHhapqq7m0LkSFilqet
         wSWwSBbGW6dMgwEFWDYj4RNoWdlqUHMlCmxsdzAHvsHgqwI+Pr1rV7d5354UdfG/Rr97
         67YN8LNEk4J/zyieWhGnZbZBvv8loM5efRG0ZbmveEBEzmC+k+3xSznaCSBvmT1dW0YF
         gNBg==
X-Gm-Message-State: APuU4Z/rEHNac8OhIZa1GYNFQOn0aQMy3H2W2sW/g4k587lWxTcFa6eZ
	tubq6Qzz1QMj5lvPTkophQgbcOhDXf+pitodUhbdKEptnSjJDNB93OBujmI1qc/RfmQ+N3b3sCy
	9xz0uZWdWlBnVHT/pVIJy/eGKUCW18WaPP+CdHrYoo2PeLhZGNlwFBp3Pt7rwEwz67jjv7A==
X-Gm-Gg: AYBFou0CjkMtLu1gbjuZRKIFT+iWfi71nS23rdiC70SxV/qvKVQLdqeW6jR7Hmbqc3Z
	f/s1Pz7zL8BJwIfoRla0V1FOuAmvzi1Y5BUC5i/Qf4yepK64upYJDAjn5FNvruLDbJEqijj4m2H
	yE+VEy5sCSy3DBMLbtZJiyaGOifhzDYp7FTTPmoT1+SE2B3Yw78hSa/bP3WhTtkGI2WGDYNYFMu
	Zbrgp2pZufisW+2pTNghQq5QGFsZRb3AaBvMPAALZG+VWRJv06FqD94327fwM7eExj6MDsAVF3+
	7Rt0Z4r2/Z8TO+u8IVn2kpvjz1FLH1yl7ITMeFysTDxRB5/l05NTeBn2x7S5SD/fceLmRj3xysP
	RZtSPkUBVq6zXnaKv5yBxbOKs8AP+mLlf/PcM4bs8MgPwlSisMAQPkyPv5uZDstNsEJOFIHF7gn
	p3fMJgtFmzaW3kgGTng4+04de6NiD47ahB/slU3oxd5sQ0jA==
X-Received: by 2002:a17:902:ce8d:b0:2df:9057:8bf4 with SMTP id d9443c01a7336-2ed40c7730fmr25500365ad.43.1793960949543;
        Fri, 06 Nov 2026 02:29:09 -0800 (PST)
X-Received: by 2002:a17:902:ce8d:b0:2df:9057:8bf4 with SMTP id d9443c01a7336-2ed40c7730fmr25500135ad.43.1793960949057;
        Fri, 06 Nov 2026 02:29:09 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47da1652sm3898885ad.74.2026.11.06.02.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 02:29:08 -0800 (PST)
Message-ID: <7081fda5-7636-4d64-bb42-545b40957bc5@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 18:29:04 +0800
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
Subject: Re: [PATCH ath-next v3 00/17] wifi: ath12k: Add support for QCN6432
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA0MSBTYWx0ZWRfX0XuzNFx1AARx
 +E3gIAF0FM79lXWlHwTmlrh9XFgKdGAwZmc0uYr2F5Un9RfbSX6qrxMUuYlaAopNqFuttalteXG
 OeqgWtzKJyBGMIYGhO8V8P3+cX9Ee+8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA0MSBTYWx0ZWRfXwdzIL7Xns7k7
 01WTaLK92fR+XddvF4NiiFmj16/jaw6dV08JLpY6KR4DJwBxFMDhd9yJxUz1x4zH8rKnfC4GnSB
 84xMbrZTDamVatPBKTasz6UzZID9nyBQbwsQs+a7srpyNKKi4QVpyc/W/lwchmNuCd9NN79jRZt
 F+StPxOKm1pe9pekLW3OlCytDPNYgPAZ46wCqsXzXwld7Vym0OR9riWQf9YdraP+gZ2wGnfaxJY
 yoAjYpbGd7eYnCh9aMCZezWIUbWOvJG2ZTN9A1WF+ErZ5rPIVeU1qHSQjp96v1WVAPofLGby7Wx
 06AtRyZB5wpe2OFlLwefxVJZWK82QzXDh6sco2Ms6ZAzTkXN29vFo/Tnr53jZxH2E6tIgLFG5Rr
 xFPB+3YaJLE4wybSnMFvQ0H09fjonX82aull6pVHuuxr4vN2+GfJeNtRsUmbTVwkCrpu/TtcZHG
 ukuuNPdaNR7Thj9yojw==
X-Proofpoint-ORIG-GUID: v-aG3F7HVyVGi0Ovdapn4_igfOq3HRB6
X-Authority-Analysis: v=2.4 cv=f6Pdl+yM c=1 sm=1 tr=0 ts=6aedabf6 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=L-72yP8G5ZwXlaZ1uZYA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: v-aG3F7HVyVGi0Ovdapn4_igfOq3HRB6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_03,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060041



On 10/23/2026 3:01 PM, Aaradhana Sahu wrote:
> QCN6432 is a PCIe-based device attached to the WCSS Q6 processor. It is
> registered as a platform device (AHB), and remoteproc APIs are used to
> boot and shut down the device, similar to other AHB-based devices such
> as IPQ5332.
> 
> However, PCI APIs are used for device setup and register access. Since
> QCN6432 requires both AHB and PCI APIs for its operation, a hybrid
> AHB/PCI approach is implemented.
> 
> Overview:
>   - Patch [1/17] adds DT binding documentation for QCN6432.
>   - Patch [2/17] refactors PCI operations and MSI config structure to
>     support different MSI configurations.
>   - Patches [3,4,5/17] add hardware parameters, ring mask, and registers
>     for QCN6432.
>   - Patch [6/17] moves multi MSI vector flag to ath12k_dev_flags.
>   - Patches [7,8/17] add hybrid_bus_type and HIF operations support for
>     QCN6432.
>   - Patch [9/17] adds support for unified data-region memory allocation.
>   - Patch [10/17] moves MSI config to pcic for better abstraction.
>   - Patches [11,12/17] enable MSI interrupt support for CE and DP rings
>     specific to QCN6432.
>   - Patch [13/17] uses CMEM write for PPT on hybrid bus devices.
>   - Patch [14/17] stores and uses per CE DP MSI data for QCN6432.
>   - Patch [15/17] derives QMI service instance ID per protection domain.
>   - Patch [16/17] add userpd ID mapping per device.
>   - Patch [17/17] adds support for QCN6432 in the driver.
> 
> Changes in v3:
> - patch 1/17: Update the commit subject and change the file name.
> - patch 3/17: Initialize qmi_max_chunk_size for QCN6432.
> - Link to v2: https://patch.msgid.link/20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com
> 
> Changes in v2:
> - patch 1/17: Update the compatible string from qcom,qcn6432-wifi to qcom,qcn6432 and remove the | character.
> - patch 11/17 and patch 12/17: Fix resource leaks on probe error paths.
> - patch 16/17: Move the NULL check before the loop.
> - Link to v1: https://lore.kernel.org/linux-wireless/20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com/
> 
> ---
> Aaradhana Sahu (10):
>       dt-bindings: net: wireless: Add QCN6432
>       wifi: ath12k: Refactor PCI operations and MSI config structure
>       wifi: ath12k: move multi MSI vector flag to ath12k_dev_flags
>       wifi: ath12k: Add hybrid_bus_type in ath12k_hw_params
>       wifi: ath12k: add support for unified data-region memory allocation
>       wifi: ath12k: move MSI config to pci.c
>       wifi: ath12k: Add platform MSI support for CE
>       wifi: ath12k: use CMEM write for PPT on hybrid bus devices
>       wifi: ath12k: Resolve userPD ID per device
>       wifi: ath12k: Add QCN6432 AHB support
> 
> Sowmiya Sree Elavalagan (7):
>       wifi: ath12k: Add hardware parameter for QCN6432
>       wifi: ath12k: Add hardware ring mask for QCN6432
>       wifi: ath12k: add hardware registers for QCN6432
>       wifi: ath12k: Add hif operation support for QCN6432
>       wifi: ath12k: Enable MSI interrupt support for DP interrupt
>       wifi: ath12k: store and use MSI data per CE and DP interrupt group for QCN6432
>       wifi: ath12k: Derive QMI service instance ID per protection domain
>  
>  .../bindings/net/wireless/qcom,qcn6432.yaml        | 149 +++++++
>  drivers/net/wireless/ath/ath12k/Makefile           |   2 +-
>  drivers/net/wireless/ath/ath12k/ahb.c              |  54 ++-
>  drivers/net/wireless/ath/ath12k/ahb.h              |  10 +-
>  drivers/net/wireless/ath/ath12k/ce.c               |   7 +-
>  drivers/net/wireless/ath/ath12k/ce.h               |   6 +
>  drivers/net/wireless/ath/ath12k/core.c             |  10 +-
>  drivers/net/wireless/ath/ath12k/core.h             |  24 ++
>  drivers/net/wireless/ath/ath12k/dp.c               |  39 +-
>  drivers/net/wireless/ath/ath12k/dp.h               |   2 +-
>  drivers/net/wireless/ath/ath12k/hif.h              |  30 ++
>  drivers/net/wireless/ath/ath12k/hw.h               |   8 +-
>  drivers/net/wireless/ath/ath12k/mhi.c              |   4 +-
>  drivers/net/wireless/ath/ath12k/pci.c              | 111 +++---
>  drivers/net/wireless/ath/ath12k/pci.h              |  21 +-
>  drivers/net/wireless/ath/ath12k/pcic.c             | 435 +++++++++++++++++++++
>  drivers/net/wireless/ath/ath12k/pcic.h             |  24 ++
>  drivers/net/wireless/ath/ath12k/qmi.c              |  83 +++-
>  drivers/net/wireless/ath/ath12k/qmi.h              |   1 +
>  drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |  45 ++-
>  drivers/net/wireless/ath/ath12k/wifi7/hal.c        |   7 +
>  .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  85 ++++
>  .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.h    |   1 +
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c         | 143 +++++++
>  drivers/net/wireless/ath/ath12k/wifi7/pci.c        |  22 +-
>  25 files changed, 1214 insertions(+), 109 deletions(-)
> ---
> base-commit: 2d57db8fbf72b1872e7411e917166bd12ed5bc98
> change-id: 20261015-mpp-bringup-75f457bef8ee
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


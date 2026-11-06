Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793932610;
	b=4bqM0x/Tl108Ao1JO34voVYFqk7eQ75XxGUWc3a/CAcu3sKtRbK65qnTa9dmEtvuSXLo
	 PUaBOQ8wiXtQnF6WrVyLX4Fvp9Xj5r5GBu+Du9lSE0d1gJJtmExzP8HuQSHH5S6SfuHRm
	 Sg2dgXUsm+cCMk6Ruq2EFK2eAXDriUJkwqeeU+b0Rikzrf1qsk3/l9h55uzugEwzZPIfg
	 G5ADex5nZ5ScJzda90VQJQ0/gl8/s8Nld1c6J4FdndpUKJLTZydceCEXXqKLo5J5zoDVl
	 UHVdNSt6VqIrPlRn+TCUYDrtQ8sYqrITRACj0XXB5Tl84vVNV7Aso8OgfuYmXZZGXJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793932610;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=btLkCHzI95QaiIhMfSZU8feJfkCOCp06xvLCxfxhQIc=;
	b=sGPXRGGVgKtp9Ncx+NNiSApC6qm+eLi6SulibILEfuzQBxIbXhfvluGfzPnZHyt8fxlr
	 SUtLGM4LSDsdm+njDdY5gXRoCLKo2d/5ZQ4FDjP2QVqSAYEw5jAfWtqN2KzA3vU+hb1mh
	 OCsRAWy+R4odbhod/fIDZpe2VddiZM59bPdsf/7/YquFESQWiDUHP8a29z5DTHyXpzl9Y
	 CQ2C2d+Vf9YqMqbc+FXH1mjHOYUVFLZ57iM4XhuzDHqpcU8AftE+frf3hN8EI6hBHLw+D
	 24Gl5yxv0OQmj2e8MIl/mW8nKa7cJQDwDC/Pv0XRJEVbat4rXbVqPiibnK838jmP3MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W1vpMfHG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GIDBeRXQ;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BC3606A31B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 02:36:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0BC3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W1vpMfHG;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GIDBeRXQ
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5NetZm2880989
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 02:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	btLkCHzI95QaiIhMfSZU8feJfkCOCp06xvLCxfxhQIc=; b=W1vpMfHGgPo30HEJ
	9bBx8hzYIYAapGcKSKIpR+nLEmzKOOVclknMYKm4P5wuYj8zb6NFD5fFgpH/ptlC
	tCS6jvBGcygUoDWBXjKMLBd3ApLGl6sLxZplg7ksWa9wXhsjXchOqR4T97kRSmPC
	dH8Ih8hrBWzjQU5tWshRLhnGw4AMmTXndqwvrMq6DWe1tP2cok0dMuUDSwhvzc6L
	Bcg2WwhtMIkrj/eXcjlv+1vSMJlINS9HBwCy4BHzmVE4U42kZMv/7+m1OZePxU0h
	rPB1LI9avM4m3S9Jm+bS1AcGIloWR4beQ3fOraO2WpWiktSuGhIqARlD+wjHI3x9
	PrvglQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3parhum-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 02:36:48 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b0a528ca65so204368a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 18:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793932608; x=1794537408; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=btLkCHzI95QaiIhMfSZU8feJfkCOCp06xvLCxfxhQIc=;
        b=GIDBeRXQhoJp8zuuhxYVRtUG6rrv9OlyQ4wQNJGn2FQy8f0BJf/10ythPGBBTpKFMr
         cr2W9SReisKKd50bGygwbJKUZm3I2sBft8dwA1WeMh/rr/ljFx6r19g6MbtpRNMT7Trz
         3Ws5OyasaT4P6n5UFjnZrKoT6WjSMCSuplt2fX/8L13qEHEkLzTNA7OOzd5U0KtE2WOi
         IYBKn5CHmUnKu/voCkUF7zoPZOqUIIdTYWjCCVv9qNPlSULk/hV4g9HgqYxJBjW+F+wX
         MUf6T0HzKoAIAzrzzGIHRpTJor691GwZwT1jW0OnKI8W7vYgD3kG92lQrsIl0Tfe+Z/K
         EQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793932608; x=1794537408;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=btLkCHzI95QaiIhMfSZU8feJfkCOCp06xvLCxfxhQIc=;
        b=Plgw0Zm+arA/68J2PBXgrOwCowP/cmS6tjcCkBCd/9LeC1g1pJraPxd2qaju8cBWyy
         mXmPyTX1Hg3TnNBDqlM48mMwSFh4NtmyoAF3eVVybFDC0BC1rz0efUOtn0MNxs6c1OzG
         gy7mZ3f8bpUOArZ7rggMX42tLg31LjZ6mRVYhkFF+zoqRbSHfDuxDjfFjoWSmFepEiiT
         lde0yD7YjT3AJOzjrcUahsWoVrdI6cEu6MXkOuoyAEOLvyq9guwRq2l5ZCmof5F0OAC8
         xN23EM7+4kbDusjI8NkuMair7n9ailoWxJuR0HFETOcJ098vOHZ9QJL9QLt99fZ39OtI
         WP8Q==
X-Forwarded-Encrypted: i=1; AL+hErFZSADbhJtZzyz9aHaiLoADtDyE6Yx+fe1kXZxOS2gYGVqLXCINgFul4zwFaKCw4qTAD6W5JkKFJi2n3jxoFw==@vger.kernel.org
X-Gm-Message-State: APuU4Z92245uwXokUl0HKX/5WUf+zgtlaQJxlgw2GMCVzfSgDR2UQ0Nr
	m7ueiVQNu9CiIo6Qf7DTtSF5u+8w+PF5WKo5F+qhvI/Whv8as32dztr0JLu6SNwvJ1Hfvm3OFXC
	PWBFEoucet3eeGG/n433fX7daJGUQp8rSkva2yHOOZXOkTOMyFlS1H403LNSgpAP0Lz3UIA==
X-Gm-Gg: AYBFou1MQ5EbXbRSzi+Dcc4lFWUiApK8A+YZ99qRbFRPePNaZeqoMuzZjZpXCguu5ao
	zuSe8CWUgXE0XC36Yfd0/G12b2p0sJIc+B5jS8gz03KWxlE8AzXY0dcqlxih7Ny/BMk0MYGSEpk
	1WDS/6Ty1PHxaOtXCgVvuTX8FXEu23VjmZ2CpFyqYcCl02ziuFDr/RTWwRHNK7U0+S8EeKGU9vn
	Th8y1vFxRdXO0ktATw8LcMCL9x5yNxRll1IU314VCgQX6FeI3CRfMH0BWZ+Z1J/9ORf+szG6N5B
	i/Q5MT5r2/MLclbD7t2T6orl8IGhVFtT+H+pSRcZNQp58pNKHt3Ce01jGJLHuYr1Z6iyJEvGndI
	E7W6i8YxthqmoA4Qy8jEWE4p68HET7/PIdlq/k2ZXAeRXjnocwNVxwNQ6MAuKbXNKVZQmkML5JQ
	rKUBvqOM2R2ibgIZ+kkFYOBfqRoOf+q3qsJl01lA8Jh4dv
X-Received: by 2002:a17:90b:39ab:b0:3ae:a531:4e73 with SMTP id 98e67ed59e1d1-3b0db6210b3mr1026752a91.7.1793932607628;
        Thu, 05 Nov 2026 18:36:47 -0800 (PST)
X-Received: by 2002:a17:90b:39ab:b0:3ae:a531:4e73 with SMTP id 98e67ed59e1d1-3b0db6210b3mr1026728a91.7.1793932607031;
        Thu, 05 Nov 2026 18:36:47 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323cd3csm5753094a91.3.2026.11.05.18.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 18:36:46 -0800 (PST)
Message-ID: <d8f645d3-6648-45cb-934e-1b232b0f6896@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 10:36:42 +0800
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
Subject: Re: [PATCH] wifi: ath11k: Reject short management RX frames
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260926114037.3231795-1-yaojiale02@163.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260926114037.3231795-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAxMCBTYWx0ZWRfX96SCw/86mn5N
 UX00nROgZZ36ABxfs2JwZGQE04AqDcFlZkjHW9rbl79Ygjmqz0iPv53EU6Hr0IOjNzZ53GPtdV+
 2PtB07SrqgyAiDNP9VIJDsh5fZMlGjJr4mfFEBMxyHt9kHWlGyDOLE4p/7gpV2/Hatph9StTkmi
 1NBdcqcLKT9XejMnOkR4JTUlIBBusiWL+LBrMzqP81+k4iKigOgmLF5brC2V3l11z+Q38zKGvg+
 2qejk5gqxxDKnjnES6KW4SNlshDXBWXoD/sfm+cWSza2M6O0eBtPCX+qw0nhQy9QbF9K40keUFP
 nSfsk2pQOvdojzSw2u2eD4GgXYOjQ7UIK1OoxbDc4JQUknyPf0Haw+JtbYA9muBkZGrqfh9GgnZ
 VRWtVhiYRxB+A+GkUE9ch9ovCfhn3FGq0Q7RQexmrCN+fmZj0tmB/aoeRX3iYeym73TBAAWMJoi
 wBOalNrj/TNfhpu13qg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAxMCBTYWx0ZWRfX9BHKPaok02yB
 BOCNP+KVJAsAaDzpYWPXI5up3KlikfO0aCjb76CM/F8eeRlObM7c0M1Tp/ZVFOSqm1ZLeFnALtP
 MY22pSN3DaEet3iU0Gyh1fHf47nQKz4=
X-Proofpoint-GUID: UrxXn7LOoYu4Rt9ll54LvcyT3FDSfITv
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed3d40 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=nvCuiLfjozt6xqLnoboA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: UrxXn7LOoYu4Rt9ll54LvcyT3FDSfITv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060010



On 9/26/2026 7:40 PM, Jiale Yao wrote:
> ath11k_pull_mgmt_rx_params_tlv() verifies that the firmware-reported frame
> length fits in the WMI event, but does not ensure that it can hold an IEEE
> 802.11 management header. It then sets skb->len to that reported length.
> 
> ath11k_mgmt_rx_event() subsequently reads frame_control and other header
> fields without another length check. A firmware event with a short buf_len
> can therefore cause an out-of-bounds read.
> 
> Reject frames shorter than a three-address IEEE 802.11 header before
> adjusting the skb to expose the frame.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

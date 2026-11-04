Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758862;
	b=DqWvDZbk79O9SKUPoIZG1tkFTIvrIrsbZGDzTNHltTLjdtlUuj1enSTCQaZ3nHWrl2Zl
	 tJMHxUNuZvfgpnzuMbnDEreSwrFVykmt+PJ/Jv6gGnSgjsu0l3Waod8V+nqXpBdPp67Zs
	 /QCcsPerv6mZbKgOJD4udIbJDsdplXYRGGG1HAKdhAz94WYHwXK4ZwsN1a/k/dclQ8tF+
	 j2f6nnVDyuxo4m++gUYU9HkT8ZN/s0jP3yqOnBWxIQvgwGFeAsgsdGkCfvPVZNAsiKZkM
	 1YBqBCAN11N1SHQnbTobkJNwVW6OsUExXGiD/sS6JP+SnTd11NqzYR+BMKUrKcHr0tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758862;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
	b=sxsy4OXv8E8IevjW3orES880Txt85PR945k5tePeRi7L2eiBynMKtOr/H3goWH+UUB0h
	 x25Zkqh7c316t4D5eYkQ4nEXcUc5ZsRw5g8+zMQehpsNQhabElUzTBPamNSjVwnx0buz9
	 lmxW281WmWluv9OHKk7OUcrND7oER16yA6quF0zqs5E+tVVc2wWM2sN85bK9c1HBOmPq2
	 vlNrfjVhjmfSJGd/5VpE60IOHMOQ+emyy0zWLOWzSRIHGEHodX2Z65tQrM2Rk1o4G/zpc
	 2ua6GWUI2Li06bZ0WzQKB8WorXS6rmReKKiy+rDqlvisB/shGZhuuyYdxd0FtNfCEiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bIKzyY8y;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gom+YPrk;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD7606A329
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 02:21:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90AD7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bIKzyY8y;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gom+YPrk
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RdWh3867705
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 02:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=; b=bIKzyY8y2jx0Frpa
	nKtsex6np4V5URbg4n6iQzikaPLhk4f/tguF649x1J4Uxo/PD9kYKa778tr9P48u
	UWqI+xRWZnovo0l+/BQ/8lvneF2GqyeSJ96MgfXMnTdH5ETA19IrQXQmyIQEtGew
	RRCZqT2VzRH9k5GZKvSBZL64q6Qzntjrxwx6zb5bFKZ4Qx/unvpMZQ0dDq4wb4Fs
	1FOnEARozHXUV4BpfhRQtSxggu5ZP0feWFoJD0puKy44qZTeUsi2mcTqw9UWKeal
	Mz4K6KErPrd5CBONpUkDFAfUWCKGOEchAxLS+R/sOTfEzRiPZDl1qzkeoWoiNR0d
	knq2Fw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8y1fka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:21:00 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so429836eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 18:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793758860; x=1794363660; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
        b=gom+YPrkR8wmBySnDtwVzsrHTPGI6GSSqwexT4sDfGSUfgbQhSyiRlbsxYm8XMdF3R
         NT3Fz4mqyc9Apjk7LDEU/AY1zreV5gaqgEIKVRKkSLpX6iPpO3pxdcMgvSU4AtE6uT20
         JQUxkrulp/hGiEtWmEyv34cIns/jSk0deVvZNnJJxxjviUWEIX9sIZ40zDdNxz230J0L
         uofxxllBur0HgEb1WDgx48Er5rNt0wb6T9ThJJHxSVtjGsI0Ppjpt5xSkXz2cd2rDrx/
         mdfp8MIo5kJ+t6P1Hn0KgzqaAVBwFEGS8T81b8D03XUbvcDX62jejE1+jlii6SB8Tq0v
         S4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793758860; x=1794363660;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
        b=GhoOuoZd0HgJZR6Xr0VqOjJXF03ddQaVMXslDZpLnGEY3kgrBrPQOompjtcWiJFEtk
         dYy/AD34RokhqpATC0AQORYGIdJIUtQPqo0sqVcTE69r1AsJKwlxX/e4UlzlKVGlXoAJ
         WMGiLkZHD/zR9VlzYqv3qo4ogqhIglv5EQw622MCTnHNkyT6yRszITlmMuF2aXIQpdmV
         HPsRx0qDHGTg9qi03SGZz8zRROS6+SH+/yL3lD3SFs54TEriTe13xhduEDHenzAw9F0Y
         BN2f5itTIMQuskQNpFf8O9QaQdgP9UzZlY/ffpJnIfTtxNDln9gglsVxof7OIlnuaHOU
         cBmA==
X-Forwarded-Encrypted: i=1; AKwUvBw2v5/cxNL9NbRwWq80x9BKInqq0rjRaIEpI/A9dES2jLrZr2okqvgmh8eIKE5U5y5EJ9q2zfW3YgoeG5E46g==@vger.kernel.org
X-Gm-Message-State: APuU4Z/M858ysNRsZZTidIKQZQXB5cQtxwdJfSLxe0sUndprBz+S1Tvv
	T+0rmVE60QcAbu+8ykrHisVhUA8AN+MdDBuGeF/aE3Am0HY6ox0JO7gG1nwSF5OrkzjWV8PRvMQ
	m8YI5wt1j/5tGElfR/6zut0uvG9C1/jiF6J64iDMmEnYuh2PTxItjskD/2bns08AoI/cm1Q==
X-Gm-Gg: AYBFou2eIdZ17k1z7+O4UVi5uQsMeTKecRPTJM32gJAAzJxQmLZ2rV+1RkJjH03ty6m
	gHRx8oOZ1CjIXBs7k+0rf4KPgTQTP2M5C5Jh16G5CS5Rw0EHqKL7jT45IBS6SEuql7IoE+0KJ3u
	Q5khd3gqx1HZcXQvG1IegECZ0DXKjCRDPuoMDX3f3qMQvfS/gCcOxo8crjvvItbOnezQ0H5L8lq
	fkcRcpeirO4lmh+Q4d2b/ANXCxoZqvvbfyFjiQSxvOjLH+YGAak61tR+NaiPj3BG+WFxXadfjf0
	SFDpU2VEBi61L/pI1Fw5ZGq5MWJJ5s+yzHN+tqQ/gg8G1hmp5QQjqz48IQq9vhvYQmknP8odLZH
	Gz0q35uX3igyKWs/4mZrfT/c2vr696htF8Du/YxCJDtBF6Dc6u2NrlfbhqokoFd8di9peCvHiZu
	oa0ST8t0prbwNql/KnpnEYpOqxbdprlg==
X-Received: by 2002:a05:7023:904:b0:168:3243:c907 with SMTP id a92af1059eb24-1ad85de518fmr24952810c88.24.1793758859912;
        Tue, 03 Nov 2026 18:20:59 -0800 (PST)
X-Received: by 2002:a05:7023:904:b0:168:3243:c907 with SMTP id a92af1059eb24-1ad85de518fmr24952760c88.24.1793758859092;
        Tue, 03 Nov 2026 18:20:59 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c57430sm3379855c88.18.2026.11.03.18.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 18:20:58 -0800 (PST)
Message-ID: <32dc994b-a4c5-44a5-beea-469b970a1b63@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 18:20:56 -0800
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
Subject: Re: [PATCH wireless-next 3/6] wifi: ath11k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
 <20261022101836.148512-10-johannes@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022101836.148512-10-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: yqr-owuzdsNYI_QM7H74sVYB-PYPBMk1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX9udKSdD9GGx6
 zlxJwB7jNUyfwhvCIVxl/xTSc5D4cRwlLuy3gegeA6AZvsBvbG/hlR9+95muWGZW6PLFE+A91c8
 qjzz3s0VYIQI5jDUoIMc/85YzAr9zhw1pirHpL6eT4U/aDFEHC3UBJMJIW1lxBlGnWtJllZYUEN
 N9JF+Ctwp2pAgdLFKh8iC6uV/aof1fjxF/CzOj6NRI+ZdjpvCnbMRO8v3QbrthaFgu2bJ4MmZvr
 sEDGGOzLiwCK955dxlYUcvObDf80yiuOWBpczEORIiQjENCRuFBs4Ms6OwGPueyl+kpnd34UkFP
 vteDdvZ25gLMq4JCCu3t2gveM3xLxK26J8UcNjoZ5ujcdKFYozMXp6Kcl74TVzILtCN4zuIK1H4
 IXQf1qHwbiq6q2HERqw9GJiDWTXH/mqDA17Ro4Vuru/QOZC02kqxuJXyDKjbyAUzuDoT6gVmux3
 6DKKADzB6OkPV969Y3Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX9oWmmI1V4VCV
 SHA093EiJxdltMTipdw3R2Mn453IUqt8zoNievntairMRPOAM3J78q5hWedNv6UId8GMpL5GPUi
 vhCsi0u/oqPptR04UEkHBatPTFhWTSQ=
X-Proofpoint-ORIG-GUID: yqr-owuzdsNYI_QM7H74sVYB-PYPBMk1
X-Authority-Analysis: v=2.4 cv=NP5AaE6g c=1 sm=1 tr=0 ts=6aea968c cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=10cwVI0W7ijM4euAjnoA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040009

On 10/22/2026 3:15 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This order is going to become required, since userspace
> can query the regulatory in the window between the two
> registrations.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>


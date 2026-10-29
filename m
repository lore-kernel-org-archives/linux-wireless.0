Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300820;
	b=1DIAkMhYAcYZu9ax+WTDdCkhmsEd02R+P0SdJwq3Q9lOoJ1tqzxCnTfAYl3Xd+MDb5nW
	 u8J4VsyiR8BY+l8OKoh+FkttZNQI/d0VZiYZqTd3SHy2dYqdOpslkl8Vf+8W00rusghKg
	 uNa2eSSBKWgjMUUi9hAPR+m8KzWtUynb9i3xlLT5fq7dk4EutRaTNsWR//mcylAhoYvex
	 D+QijcTiMs3Iy0EwtbxkWq1kw6iERXa3scq1l3r6yQblGSVJNg3BfN22wYdRx5pfoTmD1
	 Mxz0eBgcagcmg3pUUM9Kan24cRg1DMZNLPcpVDJpUJpPPKevL6c/aaHC7xbupsJ1q3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300820;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=SbVpyDql3inxK9qzMK6BHEd6RqxuuC8A1QD8rz90QUo=;
	b=oDlYyIRPpuznewBBWo6f0BINRvsp5r/Y1wCQ6HogSEfnWdZ7rWaI967t0sR/toL0m5dS
	 g65Ti/4Bn+cBwBuHsYAiEXUlVGoP03xW/80J+XCP8C9Kps0MJLt9fBTLRyWUsWNrahyf8
	 2EF9gnapoMQ//u5FVmUiqLUuExWEv4P2EHWt6gmMF24h4ubiRcvc+VgLBnUccS9nvZ9VZ
	 dzaHjWqhpZfQf0aEL/flGBUIzvrfgKGSdUfNGiur2O0ATe9l7TR9oardUWv8SVkcnkqjT
	 3jpM5aPy2NOiIphGPCovjCXLs2xIZDnom3GENAHMqucwXVJBBM+cbZjTfgKIH+TsOhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fWDHYWQn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="FYan/M++";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3124606A326
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 19:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3124606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fWDHYWQn;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FYan/M++
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGDW8H3234206
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 19:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SbVpyDql3inxK9qzMK6BHEd6RqxuuC8A1QD8rz90QUo=; b=fWDHYWQnnmHUP94q
	IQ1NHAAHNw+xcFOUajUpdE0i+wT2sh81bmxC2YO3FSIcLn/aKz4PO6KbNqE3pcYO
	t4a1wqU8ncA4ES75eix6pTPnD1voaT/RR0UO1TnuxHd5cLbJ/v6+dz+24kXi/hM9
	q8RxMUdPoKJt1gCQhu6go5ZMWTCBzGgYGFrXSiZH9zN/pyMYcLEVv5xx4Kj4BHHg
	49jlrJle7O6S+kQWVqzrqs4ZLUIJYMQBPAvYbA5FJPDsC+qzmWXutCT+HkEaW1Da
	pVeOfRnDOWDwTeHOODT8BhLBCpaA/m4QBwoThLz3N28vq37xiNcO5pXJiuJlsU6y
	PX+gTQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hm31b2pum-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 19:06:53 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3662e7a9299so9515205eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 12:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793300812; x=1793905612; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SbVpyDql3inxK9qzMK6BHEd6RqxuuC8A1QD8rz90QUo=;
        b=FYan/M++8WGFeG/hztA3eu0nfkFthTr0nt5uaM9UKPXHFJykDkCBq3Ji7U1S1CrHss
         95KmgaA17S3U7Xtk3DopIFAwE3p0Z7vz6eNFeR2AmTXw0orMPGsPsC1FdSolJlyuQStZ
         rnEYbnjq9uJ8X8AYyM0gggCMYIIlyASHbcrFTjA7Pfni83RJ3+Gbxp+INED7xQTH1yJC
         WkVZkUuTXDC+kTzfCmUB6TEJ0jU4Ifyt8YzVvUG1PnBVhRGDvEGTnDWVfsoKzgKvGdNt
         xoIV+pgumUM82lveuWnYT3+fikkDGi+g0dhe8a3ES6/ndTpEtCnZXIuZUOXWMctLtQwi
         GoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793300812; x=1793905612;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SbVpyDql3inxK9qzMK6BHEd6RqxuuC8A1QD8rz90QUo=;
        b=bnd0UfG6ytlTCUBtPa7bvMNI1YB6uXSfm74mmoGzYlQnVUe3k6yhHlUKvJIicQGki8
         8SToG0aaSFBjcKc+ldvYYL75HCaHBwuK2N1yzKAYxM/3qoiN3XAwUVWSzUETOE2CcIVF
         6iqMYYog799W76UHh2h3YQJrTKf+VAMwnTe+jRV2aNUKv0DtF7P2HfMGlJZSXR3CHMKB
         ETHDuctzDeOv+y7s8xSAhWqBa168RfKNRMgTou+A1Q0XMkwXSCkP1FOjLPrxlcTR+AXp
         le9pUgg84O6jpfg3rSZQnpcoMZ+UZsfciyw58f09l7u54FRXgXR7/Jr9TJ+BuRSvBnG4
         nY0g==
X-Gm-Message-State: AFq9FYLdM3fs+j1w4QR0YCG2PITk1LTzPLcKxf12MvA9os5d/5yV9LpK
	n6Z4hF2k1hfQys5kUDZPvBGVL+RYKRE6L+W06W2tjEsJrj8PkyaM8qPdMfNLkaXsnOPQFVWIJrs
	2aOt4y0LMqrQCHT+Hf2y+BCtp3qYY+7YM3USCDa0z4rn/HNZ8I6G60+sahwbplUEiUXGEHdd7BE
	oENQ==
X-Gm-Gg: AYBFou00qFPBIkBxxgmP6ELwqU0U8hRseRp8FbhLPvLLqbFsCj3sb4ZA5gd68TtSHQ6
	ao62TuXw12mRdcpZLv3r6SE3dLuAtIJPt8r4VJrrzJ5rAHkXxJLuTl4LxZC+TBHGWFqGHR/1BOV
	ELUVGMyMQA57STgS/HpSExpZX6ibRnsr1iIG0p+HEi2aQwGEjTEyeJ0/rG2EHQBUQ3mD47iNZ9G
	4N1Z7Ovl9QDL6JA1g1z52603ES3HTC6icxQDj2Tsv+TIkxEhkx6+H5Jj7OQl/jqZDgDaAJiWEuW
	+0Mh/4rN4GkF//ZRwKiBs1Xa3lh+Ky3YMHLb51/bLA4Y8EyW9gctkKUy6uJr8tIgdk0wqGhfOOM
	XLoTyFPcl9lLFEfyV7/2gltwOJq9Ue5sqmG7/LELE80WFWB0Asu8O1j/Hb4oepTuW+twD1ciSu2
	28r/sV5M2IiG7+IMGuDbWm7ydlhdBRnSQ=
X-Received: by 2002:a05:7301:7d1a:b0:343:fb75:a5f2 with SMTP id 5a478bee46e88-36a42340bd5mr348881eec.9.1793300812089;
        Thu, 29 Oct 2026 12:06:52 -0700 (PDT)
X-Received: by 2002:a05:7301:7d1a:b0:343:fb75:a5f2 with SMTP id 5a478bee46e88-36a42340bd5mr348817eec.9.1793300810645;
        Thu, 29 Oct 2026 12:06:50 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a77c0dsm581104eec.26.2026.10.29.12.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 12:06:50 -0700 (PDT)
Message-ID: <465b7e9c-1dbe-4877-a68b-3b19abefb25e@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 12:06:48 -0700
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
Subject: Re: [PATCH wireless-next 10/15] wifi: nl80211/cfg80211: add support
 for NDP initiation in offload mode
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
 <20261014103359.1508345-11-shivani.baranwal@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261014103359.1508345-11-shivani.baranwal@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA3NSBTYWx0ZWRfXzT7DF1eQEEL5
 ISZkscvGv+7/XkQfgjwdCxwCc+T+OFFn0hBhaQ7/EQgIiqsegNifuIInwZfml9ju0YCtBywgfJg
 t9kBhrMcjuo/SHzYCQU8kYtH6BtRwrI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA3NSBTYWx0ZWRfX9FabSzgMhWu6
 akmaphX8NrdbWefQVRGkwa7nL378cUJYMYdBmyWmqgsucvZk/t0FDKS1uUOh4RVJ0K5VnD3tDI3
 RS6m+wO0e/CclIqg/NQl+F7ghU+E+1c5k3ZSP6mgph/yKG+jyl+eghLWJ3w+Kueft0C4EJGCiJ1
 lpowITXQAoIdQgFifK88rZel0szlDXbbor3LfRa19c0hXEIag/g02PN9QXK0CJpiXA/xeLH7cHG
 9VGhqdxHfXiHdrH2RaBsdOt84Aig3V5n7pf6IcJZMi2GkfVYP+ZQHm+4lqcdPa0lBVOH2QqDUsD
 K2TuwMu6Tbli0QwKflFw2TTrjk8p3n8k/zj56ABKPsQzL2desVfIugUwN6EckweEHJUoBc4l3zv
 Y1amp+poMk8GD/5kUvibSH0VnB2GX33b7ykVJ4yIxARQIVfYHux8WHxvvPnlyr9HVg2NnN1bapC
 Igu+q6TWXooXZdyUJrQ==
X-Authority-Analysis: v=2.4 cv=A8T5rKWG c=1 sm=1 tr=0 ts=6ae3994d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=-TvMEMBC6bV-ZKO7SS0A:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: OdqWCZUQxtilX75bec8IpatGtxw7O5S0
X-Proofpoint-ORIG-GUID: OdqWCZUQxtilX75bec8IpatGtxw7O5S0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290075

On 10/14/2026 3:33 AM, Shivani Baranwal wrote:
> + * @NL80211_NAN_NDP_ATTR_PMK: binary (%NL80211_NAN_NDP_PMK_LEN bytes).
> + *	NAN Data Path PMK.
> + *	The driver uses this to compute the PMKID and derive the PTK.
> + *	Requires %NL80211_EXT_FEATURE_SECURE_NAN.
> + * @NL80211_NAN_NDP_ATTR_PMKID: binary (%NL80211_NAN_NDP_PMKID_LEN bytes).
> + *	PMKID from the peer's

strange place to break a line?

also note all member cross references should use @ID, not %ID
% tags constants, not members

I recently fixed a bunch of these:
0fdd10cac442 ("wifi: cfg80211: fix kernel-doc %field -> @field cross-references")

> + *	SCIA attribute. Present in %NL80211_CMD_NAN_NDP_REQUEST to allow
> + *	userspace to look up a cached PMK.
> + * @NL80211_NAN_NDP_ATTR_GTK_REQUIRED: flag. GTK/IGTK/BIGTK protection
> + *	required for group-addressed NDP frames.
> + * @NL80211_NAN_NDP_ATTR_GTK_CIPHER: (u32) GTK cipher suite ID. Required
> + *	if %NL80211_NAN_NDP_ATTR_GTK_REQUIRED is set.

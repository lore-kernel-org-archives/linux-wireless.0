Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793204013;
	b=bqSwP9I78Ghh8XrIph1ybpzA0xHzj2ctYSbfcBC5i6wmy8m4ijOZU1+jjlTWcwc9m6mf
	 xklZN9CCVgEa77GQ4eKy/OeXAhrCMO2E1ovLlklVD0J5dl4IQZBekR/G7ffRxXrd7KnUa
	 C+2RncFvebTdVPqgWQOyNs62iDOx0/t5NrXZtAzgbdmZE95xNV5qIhrTI5H/eGllmSFe8
	 yJrcfE96vK2004fCzJVUcGGw5ZJgDxMqtjn0j8qMoVuXDaN6rQ8jmksXF1f6wV4aG7+kq
	 M3ZGVABiDVwtVbanvcn00xoRPqWpYnWzE2Dat/teSDz1fcjoA0XqGUHQTDrsx8biPFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204013;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=k5R7KHnBeicCpo5W1E+rh+UMdXZhhILADcMQn+NQmFw=;
	b=lwGQRw0klbXK8zoVBh7iMNWEvU5m4J3qMKwyhL3laFpWMRo6KqyeTKP2lRnV0TQmqwzR
	 q9XYwic/jEdMQ+HvdMWZvKTGRGK7LPlC6uu1XNKe1N6SmSuVvM3uOd/AjRkeiNM6zc0of
	 hHPPZqiP5Ek1E3H5w4yHL6Vx13siAZ73DpIx/6dYAge0w9MTTxDRlZoDGCl12C7/iylQu
	 RYh3mb/pmzpUewUHPal2MC2j0ZKnNItnqc+Bt4pHzQqbiijlPMV3EZ6jHvzARkTNhLLHQ
	 swwIZWgUOQnpMK5LsdsH/2iqkiIRHcxaNpsNKxg7NT9pYTap82O6ArU4OT9BXe491LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DKb2lrtV;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TYU649ZE;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D921606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D921606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DKb2lrtV;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TYU649ZE
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SFB5Gr2070782
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	k5R7KHnBeicCpo5W1E+rh+UMdXZhhILADcMQn+NQmFw=; b=DKb2lrtVAdVqBLC5
	E6MuHuLugpu9KbhdzAmdzFQaN8VhqAAKWGOGEwkNZS61aCcglzdbu0sc9ZSJkf22
	eb+ldR1oGZdCqWSluHfygY033P8C/i0xS+fMWXc3l3JkR7kPYSOLHOS/c/YTCf29
	a55KEnchOSUR/KQDArD6MjZTlERRKDjP4MnOT5F3STGG/8eXnJ/ViKGBxhpFZ1L6
	7Jj7Q5F1PrZNbkDOdYLnaNoTCutcuGcfyBxKWNW2nXd5qhcRSib2tB3G4Pj6WA2M
	dQpCKWtK9FxB8aAUsaNLTh8FOD2cKvzh9Xm/kBGBfXtOhOxhDQKz3x/dnW2gt/ex
	xxFfRw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hk7g7k5bf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:13:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso1866112eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793204011; x=1793808811; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k5R7KHnBeicCpo5W1E+rh+UMdXZhhILADcMQn+NQmFw=;
        b=TYU649ZEzFYrwNrEMYdM+BHqPWfFW8ymKUEyRF02WEdTEMqsTrd10c36MkeVrD/A2N
         JXjdu6zVDv6YbclO8k9U9LCM2UFA4kCcokIonaI9NymPnmZtKEaZGjH5VKV3jJTUXEl/
         wXgDZvMpoaa9VN7Xo5Pgus0W3mWCBN9ID7MK6JL/cehIJjJVPqzojuXHU0TEP2DDu5oa
         QWFzwezAKW5apYpX4OdfEXjl0EyRh6Vudc5KJp6Aj9K/wgwy7nHyvgN2ZpnMXOWRahBw
         8vKlSJaf43KWo3hfmYB4o/CMOCaB18WZa4hSczHpp04Bbk2DAGg0bMjKeBB1U1lk8pDD
         fzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793204011; x=1793808811;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5R7KHnBeicCpo5W1E+rh+UMdXZhhILADcMQn+NQmFw=;
        b=XxOms2l4c1JWyatUqtSLByu2RQGzj9R2XhxRIYeX5dRoQX/+Dd5dv/s88gW+S5tWGy
         pnsq8xyuT9OwwXDrhdACJbGiCZCD23+V1AAJJp40vpZ765OOuDdBI+XskOzaa7JPf8NU
         fqDs6YVRCGmmiB4Ep3mD3yw8Km7b2tiTktSDho8OfmK/U5XbwOeZg8z3pJ8+1oNEEqI2
         P7oehaySOlUpPwt4F+p3Nne2G0bkXXm8YYesIxk/S7dvp7saRnib2dxIhEO5GIx5ZhVK
         w6bD9+xNrJuSFo4nzpiPLt2dBiA3T55yOJcMaiESzW4VldOspO5wxPpwpY0BCGGQlT0N
         cbdA==
X-Forwarded-Encrypted: i=1; AKwUvBwyvrO7MY6DMf5ovMOjFTd/SaGgp8VEqmFhKKqTCZDE4PRHf58Ar6nIIu4xr/9hkdfAxCQ3rxcVaJ3qaxih+Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJPUdpimRu5Xwv34w12Bmw3K/q/gg6mZUajAfj5BbxR/GNfYWMb
	fz/PzvNTCtZL7AnZhBJzSQGoOyFUITc1AQ2ioBLpMt0l85V29kRf6ETXqYFqxAUoGKJp/XDPZht
	ao8R27yNSlkjEuCvmHSBZpsDh5G/h53krgqqPO2ljERy/nXtJ5m5mO6izsZ4DyCQi6b8urNfHdC
	a3GQ==
X-Gm-Gg: AYBFou33JXJILEPdZqteUoD7K41GUzeMJmQ5SEw6X2xXRPgKVPGLtxiVoZNLMRZo6c2
	XnzzUMdOF+EO8koAhyaqI3L4Fr7amjkXj7Np95tGX/DKTB00IGgJu4JYqT7x6TTCR81IPtW91dT
	5B+t4NOEZE2rOob/tRTIvIJG8nlU2sxAmK8dPkUHbXukODpyLxTS0G4uNNF6nRc0dYquIT+9UDU
	APzU1lgSIWFyCR1fQk0GW9MN3GEDrRm7jfi17FPo39BwElwqdGs+wmgKxWsWT8vudbvYZuGP7CE
	yFOsMYccMYX/rWE/qX/neEwyCVn6sXv0V3qPjBf0fVW90bakYACdb2y4s41UZb4t4mtJ2q9yoX/
	Z5z0+n3XcxTwa7ujSSPnMgirN8+hHiha6SLi635+LK6L84pr+o57ikR7QNt+iwl1k32dXoukH1A
	tLCEZ+xuX9M516yl4BCkQHSatTfA1LCLLFFw==
X-Received: by 2002:a05:701b:458c:b0:17f:7280:134e with SMTP id a92af1059eb24-1a6cef7a368mr3118588c88.32.1793204010332;
        Wed, 28 Oct 2026 09:13:30 -0700 (PDT)
X-Received: by 2002:a05:701b:458c:b0:17f:7280:134e with SMTP id a92af1059eb24-1a6cef7a368mr3118558c88.32.1793204009664;
        Wed, 28 Oct 2026 09:13:29 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75d4887easm6892717c88.9.2026.10.28.09.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 09:13:29 -0700 (PDT)
Message-ID: <265c9666-df95-4c81-b617-f92d95d1e8c5@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 09:13:27 -0700
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
Subject: Re: [PATCH v2] wifi: ath10k: Stop unanswered temperature reads
To: Filippo Falezza <effeffe99@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Loic Poulain <loic.poulain@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA2NCBTYWx0ZWRfX+yvsu2eFPocQ
 XE431grXgixKw2fQx6CA1huLC06+qHQyNQ4C2IOlMCsdjSfffmGFvno7LwojOFrquM+c+tg3xfr
 wmRZ3YGSwIUUKaQyDhuegglu0CUKGhM=
X-Authority-Analysis: v=2.4 cv=SoIFe/O0 c=1 sm=1 tr=0 ts=6ae21f2b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=XdfyhqwnpIJiiuEY1KwA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: IJZDDSwHP5QIUqvWaAXI71fuqCotsUgW
X-Proofpoint-ORIG-GUID: IJZDDSwHP5QIUqvWaAXI71fuqCotsUgW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA2NCBTYWx0ZWRfXzrUECHv94HWJ
 /H9Yo4q/S0RelWKIE0GP1MbMTUph4/m30SdgdCaMD4CiwT7RfXc81YtCffjOHfRFHu/3Ifr0VHq
 DhSyMyw2CWMKN2HDCqU8NEX+oqsgI39eBeO1jjuJGvS7XyIrBJb8yb11C35e6PdjYTnRQFA/o5J
 NgKLE+QckkH4a5l93yAJgGOeT01dt9o7EyRpuC3+pkYhwz9EIqBZo52S1zhh0qckATkZWZN/qM+
 TDsqCao42Qt2fMmL29Y/DnqNtuG+MDFk3U8bmCeSg95GT7gkptdG2iH9Ji7iB8uiSipnRgMZgJt
 65x0B8utjyRXs8L21M4hLtN1JIkZQBIKlhRgWTogqlBEaWEPdN4jITvuzWMGegQBhvN/BxYT9EA
 aWb/ax6ystgPdHUN+kZEQ0KVQpAhHCQ8jceVl0p3ycEwyuu4nhX7ud1yapup1t2AWajg5DQLuoO
 uNo32h0XmvfK1Tengug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280064

On 10/26/2026 6:56 PM, Filippo Falezza wrote:
> Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
> waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
> holding conf_mutex. Not all firmware answers: the WCN3990 firmware
> WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
> codename nairo (SM7250) never sends the event, so every read of
> temp1_input stalls for 5 s, logs
> 
>   ath10k_snoc 18800000.wifi: failed to synchronize thermal read
> 
> and returns -ETIMEDOUT. Tools that read all hwmon sensors, such as
> lm-sensors, hang for 5 s on every run, and configuration changes of the
> interface wait for conf_mutex in the meantime.
> 
> Whether the firmware answers cannot be told from the chip: firmware that
> answers and firmware that does not both advertise
> WMI_SERVICE_THERM_THROT, and WCN3990 firmware differs between devices.
> Instead, remember that the running firmware did not answer, and return
> -EOPNOTSUPP right away on later reads. Forget it when the firmware
> starts, so that a restarted or updated firmware is asked again.
> 
> The first read after each firmware start still takes 5 s when the
> firmware does not answer. Reads on firmware that answers are unchanged.
> 
> This change was written with the help of an AI coding assistant; see
> the notes below.

I've dropped this paragraph from the commit text since it doesn't add value to
the git history. The final commit will have a link to the e-mail thread which 
will still document the LLM usage.

pending patch:
https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=407f3916cca45de3720a93703d28b047920e6230

> 
> Fixes: e98199a8c27f ("ath10k: enable QCA6174/QCA9377 to read the chip temperature")
> Signed-off-by: Filippo Falezza <effeffe99@gmail.com>

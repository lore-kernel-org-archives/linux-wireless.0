Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD51376BC6
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618870; cv=none; b=R3b5RzoV10rZlA+8supcU2eukecL3kilkLgstSZLNxUl4naTCUGUtLKwM3mWH+DOqxuRN2ZAm4I0zjF8PG1fH1WkOMW1lGCOpY6FyzwaQ2k55nuIKjP4TcMvlnqZ6ekm41ci4BecDK910K/wvVr4iXDWL7TiHztW3u1aCM5biDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618870; c=relaxed/simple;
	bh=jrIzIqdsXW9XN0EginlPY9EUOCV3pktmyRnjeemZhGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ragrKcnqo3A21Ye3RZ8dW0p+FpAifso4Oa8sdO5QcL3glalLEn36DLkYID+0X3C2FDnkaU15afWH9cokURvZmAvUexWD57g46qRyV7xL4Vupm8Gbp4zriujyAKvmLSmNjSyvAXqgB7phpMqBx5AkuxHN3hc/SfF1LtYDVsYGoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UF4PHkYX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=io0sGgay; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UF4PHkYX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="io0sGgay"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SHwZE61683622
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 18:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	10DfQ6Z2QM6w0dvQ2IWLX5tdv1brJzI5V2bGF0Z9WzY=; b=UF4PHkYXxyKyuWg+
	YvrijZN9s4kTdVG+76g58Xf/qGGS4D+j4vM/RLAB0jZbcBEj5dsKI1Y/0VKhKEDY
	WATSKkaFlI6e9/p+U1e3lGER6B8scdLcWZiqgdodo9h9B0Jp3xMtpp5juNVArv8D
	4dyVvj/Sqdn2ltPNlHOXrqipoOHqDEJXai4iKruU5ow5YEYkz9OcmsObaXtpPnWv
	UyI7525NG58XratvJ9mtZ73ttkblrOqasB8N9zvfhrd4GUAgxKiiSb6beBci4bnj
	dBWxuaCBvfX5/fz5YSicpEMYmc9QAyXDbb16WzJhA9hhdfIySSWNYm9y4jr8vqFm
	TXcaEA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyvwn84c1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 18:07:48 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-14318be7d79so3346564c88.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 11:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790618868; x=1791223668; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=10DfQ6Z2QM6w0dvQ2IWLX5tdv1brJzI5V2bGF0Z9WzY=;
        b=io0sGgayWqOwp5+TYXcKTsLUGrjMgzi+VEgYURtm/bv8ZsUmMX9y+JRDU4mq9cRqFR
         i2Ja90U2vhYUpkSqP67YeBTLixfEb0wNj4PE5UdBdq7JSyzD2/2AWPURMBcD/Bu4GRCO
         SIygGGehi1qamzQ81Jxb11Mdg7nLu3DpG9WlBjSNDj/XR87cMwDa1KMbFi3vESzMISy8
         mbjm9DxKdUH1LrewI+Vko7BYKq+XxEkxMnIiP4kiibyWGcTSQ9G20snkRvsVIgUJ1f9+
         1ttTWx2UFaaDO58H+5UPVQb5w+ugaJfd0QQxuKQ7HaM6+0dVZLLh/VmIlY7R7dGEdtaB
         ZFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618868; x=1791223668;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=10DfQ6Z2QM6w0dvQ2IWLX5tdv1brJzI5V2bGF0Z9WzY=;
        b=vl099U2Ds6CxltZc1m88d5+qScJJWuhNotkwfDOo7U7CrKq2VFdExrWNvr+FJ8yGVq
         U6qjE+SsRENrGylWfHSxWjGvpCJ7xwKq4pyll0bkaPbRjwMxmKGNblDIfv04xYgqfHHH
         fknrK7Czwxi7F+/f/rAScgqmhsVVi2uzxNk/gYYoVQUa8G+i77aMXcU6x0R1Z+yx6dv/
         AhqfemkGR9R3v10cwfxGQ7tnJh3W2IJ5c8bWG0ElTuGjDsF+bImbl5iqWhTkJWzxvJAR
         g5F2s1DaSTt9aqKmcri46S6XBePABIn7cQN17JNj4OYHpK9vZokX83mFmUPNAhNb9LqB
         29Ug==
X-Gm-Message-State: AFuF++neXPwyp84i3aRU+UfNVugbR+ALgXU1HOp8PymmAVKq5rGiY7T8
	3lCnd59fyA5OFXz0EpupsdTDyympupDM5sIyr2HgoOUJr77bfQ8+buEvJj3og4V/3Fe6OhSqMZT
	xAUklCj8lKRBCIZKOVBPGVcOGoh/AKFJhKlY76T0MhXIxcYeIJsVMsHiuuSAbvXWVjRXYuQ==
X-Gm-Gg: AYBFou3QH8dBDCOguxqxTVZfRzD366fSN4rS/jZjsNcwHwJofoABR0SOKVQ1qeOIHdZ
	ZUooNu/AgpE2lZgXFq48YC7iX3o53RD6EW3soQDHFQO9U3IUsH7n3hRKXxiIsf2hBDW2H+Wib1c
	8DKBFU6cBgg1hTy4iWsqnWkRH/yKBR7MxvZZa05SWdEinQw7W0fFXcUD+d8ExyfRa/OpVealENj
	xmDxkpyKKC6y9Odbp1sQA61Cd3Q/EPXJd/4tFE2DwOQ3OGgZgxRopJ4v6bReeOLwOqNsJp3tlwf
	88qXePibPgLWL8SYBka9mRsWCWkVUY6MQqBmOvm4dl8Y4IKYeE2i1Vy+5JNZl9wNY0CwuW6NafC
	tQ5ub2vIKW4cXvOJDb1Yp68MPrKTaL5SVEpAbv4Kxzpj9DAeSgiKgHE84tg==
X-Received: by 2002:a05:701b:2402:b0:14a:d8fe:3396 with SMTP id a92af1059eb24-14ad8fe36b4mr1226560c88.27.1790618867431;
        Mon, 28 Sep 2026 11:07:47 -0700 (PDT)
X-Received: by 2002:a05:701b:2402:b0:14a:d8fe:3396 with SMTP id a92af1059eb24-14ad8fe36b4mr1226519c88.27.1790618866728;
        Mon, 28 Sep 2026 11:07:46 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145acd3d8eesm24802356c88.8.2026.09.28.11.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 11:07:46 -0700 (PDT)
Message-ID: <4af0fe72-4b55-47ff-91f3-06221e563231@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 11:07:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: assign device id from the WSI index
To: Benoit Masson <benoitm@perenite.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        stable@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
References: <3cd93e83-6103-457a-8879-bef8521bef9e@oss.qualcomm.com>
 <20260928154335.85628-1-yahoo@perenite.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260928154335.85628-1-yahoo@perenite.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Q532ZUss0Rq-FkT1Fq2-6wS-27gYmmIS
X-Authority-Analysis: v=2.4 cv=W42txhWk c=1 sm=1 tr=0 ts=6abaacf4 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=LV5C8B2hAAAA:8 a=33sO1Vo68oqyLtPrM3MA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22 a=uiVh3g-rw18WZz7NjXbe:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA3MiBTYWx0ZWRfX74gG3lgavrBn
 CXzVRxKrfEcjQBT+yuZAub9GSHN2s55ArZg5gjd45hXzDNgFAFU58DEJStXHCumgmrWdGiTr0S6
 sv7t6+WR7vCC/ePVA6zeRzwELu2tfQ3nhAQEMY3nkL7T0tRSRQIjDD3oY6Im6QT5CQI8NJvqhdS
 AWET3PfSALQijvm8GQDe2Jr4Y5dQJW5TsZ8/Exh2b+/SnFHdVDagNfdcGkTGdMd+jXe3WiAxdpl
 vrGOcO0NUf2MHsEDGOFGCXeDve++TCQqJr63P6Vrd6M2aTPH9N4ekj5R1HI9SNKSWUOI70VX3SE
 ddFubeWEtqRFDvVhPUzGX2tsZGrvYMcN8lGFmCFUcZvRidQV2gZu3AsKKqb+4lC7mynkbX7HbwW
 mHEp3pnztzlvVztwUghkrSdzrrDDz3dmaAAgv0wx535bDfI765aVlEQa7ASRWW05EF7/RRrEMWB
 UAGoPXixnWp3MVbLoTw==
X-Proofpoint-GUID: Q532ZUss0Rq-FkT1Fq2-6wS-27gYmmIS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA3MiBTYWx0ZWRfX365TKiOrk0jN
 QoeTGjnGIJfECs2LO/LGbRidl0uWGziNMDqYQ5oVWHYUVrjRiZlPz+6vosGsmEBL926C98CZ7kh
 PWyHjo87qq+LJnkorjLEzEI7o0+5EvQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280072

On 9/28/2026 8:43 AM, Benoit Masson wrote:
> Devices of a hardware group are added to ag->ab[] in PCI probe
> completion order (ab->device_id = ag->num_probed++). The wiphy radio
> array is built from ag->ab[] and the wiphy device is taken from its
> first entry, so the wiphy path and the radio index to band mapping
> change on every boot.

you don't describe why this is is a problem, and hence why it should be
considered for backporting to stable kernels.

> 
> Store each ab in ag->ab[] at its wsi_info.index, which is derived from
> the device tree WSI ring. The group order is then deterministic.
> ag->num_probed remains the group device counter. The unassign path is
> unchanged, it already indexes ag->ab[] by ab->device_id.
> 
> Verified on TP-Link Archer BE800 (three single-band radios in one
> group): the wiphy path and the radio index to band mapping are
> identical across cold boots.
> 
> Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
> Cc: stable@vger.kernel.org # 6.14+
> Signed-off-by: Benoit Masson <yahoo@perenite.com>

SOB doesn't match your From address. So you either need to change your SOB,
update your From address in your e-mail agent, or add a From: tag to you patch
so that From == SOB

> ---
> Changes in v2:
> - Set ab->device_id from wsi_info.index in ath12k_core_hw_group_assign()
>   instead of reordering pdev_map[] in ath12k_mac_allocate(), as suggested
>   by Rameshkumar. mac.c is no longer modified.

your e-mail subject doesn't reflect that this is a v2, and it was threaded
instead of being sent as a separate e-mail thread.

when you send a v3 that addresses the above please make sure to use a properly
versioned subject and send as a separate thread.

Thanks
/jeff


Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14056E06C
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884999; cv=none; b=IZgUHTSN3aCsnv5+XoCkKj3FnOcYofo247KvXFe6Iw41OAumWTpYeNVi0kYbcYaQYvHiV5Egi9dWd5MA6fe/1YOR4VxUA64OAguRw/i1RdCopkMRK0vyl42rGf7SF4eVoN3xVRlJvaIFQcv8bap0w/oF0xg/NtXL+gWtcWHyMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884999; c=relaxed/simple;
	bh=mVY7wxS3IigZ+4Ahw4XnBYIHGfHvOoDUlx8H/ZQmrlU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5KGIUwbf9wik6j0dNIGwgrWkuzhlxORUuGz63hDMEw6WIQiLRSE+X8qN7J0dmbaZtSnGDSBArz8Xx+GbHcJw4QXVnLxyJKQw6lVmn7B2VzmFYjL7pPUM3gJ1MOJfBqe4Pax7rkRX6/c9XSCmuILSjgmkXj5WDAjK5P9lu5XA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Eg59EeX8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T4HVSgAq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Eg59EeX8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T4HVSgAq"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fdc4k2737625
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 16:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EoFoWH4TXhUpMWfgBmpb9HIW4dVO2c0QaSn6V5lFK4o=; b=Eg59EeX81LxGTeds
	0FI+O7phSM9xwjLpwpZuSsXY9FckdWewcTU74/7n0oT2XAQMw7jAkkP97CND8ruC
	zVDUDOqgWiiBgeZTGP0xBOnwPx7PrY99czv7WDtxRkYVD55sNnJzmWaF3RpNe4uR
	tVLyAjoJ841RLMO0hcGmYRm080GLNFIgQG7tII1XaEU1fT6hONMVJxF7vzbb1Hm2
	9CcRqSJpag6ii8ffEECYO7WiX+QDQTUQ7EU8W96/QoUj72i9yn3WG6usE5cjZFZ7
	bpxV5qeCkvswLLUeHshijEP4KptVpxSkAXxHQR7pat77ssF5m92BSoRV7ilfBMkx
	n/nGUg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjatjk5t8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 16:29:56 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-395543dc382so6331957a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 09:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788884995; x=1789489795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EoFoWH4TXhUpMWfgBmpb9HIW4dVO2c0QaSn6V5lFK4o=;
        b=T4HVSgAqDsDTDtLcz11GDUQh2pxbtZBr9ps3VXvJ58OZCWql+/iodzMeoVM8IeovxC
         mwAYGXvQtACm6os47OIry+nFqCjMdJYsHM2iHYHu4Ve4OcOz+wZ4UdiaD09fhB+BwmHG
         0gU2/ae679MizfahKeAw/83zSEVPdceif4A4uxxLrPq7EjR1GYZ/N1/IyoM6Kg8GU9jq
         4Q4eLW8qIfGW+J5zetpQ+VYDoQeCRexrrpyC6lAGtOlSPy0LzCLLbPwlltiD0yWmpPhj
         rnq5clWjthokQwheRe+sun105fUGkewNSiu8ZHR2tNJpjQONBo6MZqDrR50H4vJnN0xL
         0hNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788884995; x=1789489795;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EoFoWH4TXhUpMWfgBmpb9HIW4dVO2c0QaSn6V5lFK4o=;
        b=shRUSBns1N8tXEGwlJNIRAgpTCP6jiqW+A/GTb/aI0XEMtXyxPpvsKza8lGHNR093q
         cLO+njc96lKG0o8OCM+Owng6lR9B4r9SH0O/a8TRNbz9A/E2+Ioju5AgT7JGyBmCtQ33
         4W+/xuZSYo3wC7H5jYbYkYleAlvgmeT6RR2ONl95lr8TxXbx8pbeoQk9l0jr+BgHI9RO
         9Z/ex5gyQKIHGl7QqEW43u4gkdHVc7ifWjpg4Tt0GZvBO9Y5MHucn+Hrx3d1ZBX9G/dl
         xXCPzF0dtg0bp2VF685C2xIZsM2+mjwrjxC65AbAFLdDR7fAstCq9GA0+mvJYiuFhX9/
         BHag==
X-Forwarded-Encrypted: i=1; AKwUvByIgLsDMpTCA78v9V1kP/5cNnCFVrNalnzcv5DM69KuW2GhxAo0zsix7Y59G0rWeo0QBLIcxkZQ0dX8r4n2gg==@vger.kernel.org
X-Gm-Message-State: AFuF++m+T0/Or3TWmqjFYqQHUOOmWDv+NrRTjHpAtCQT62AxWvidmH8Z
	OChdrWKkvKD708QdFKDGfJHOVjwYL/dcwubEqEL1M/oIiFGgd9hyXYPnUgHWuYcwFn/g9/VicIn
	73VsKxWbgane0hcb+QwdmWGrP5KDgq+8sx/idFP75BoZKPe4i2Fg7PEjdKMVGPuSluqc0GQ==
X-Gm-Gg: AYBFou3J/TnpsNyRDEQu3V2/qeaV4R1TPbSnjASQ2iddb3jZb4SY/hq86lOBnboluSk
	FXdg1xZGMcpQtWzgrgLrYc+OpOK0b/UXuQwr5cEzkmPdnhLnCHWpyew9dWn6GwhAWC/o1ONiWL3
	dBELK5O6YjX0vucG0lRoEW7atVWhmBGERuKAWe+yC0XETrwHaGFG4alkaTs0QO8LXED5/8RL1rB
	W4mMOiob1gLfvJj0QxLfu8daVuqMoWRhmy2y5BWVE44Ttc7swXs/7/2c7hbX5DSQ/ONMglvnF/y
	foZEP9i2qG24xA485lx2tdz42sppOkWdiKOLF9OL6Et4g1YkyZboYkVfdSH+Dg2r9+ZyuVsiO0I
	ukNBTkr+85m8ccmpaMNeRlyi+MX+nNVsdLgcZG0fXR3gYtA==
X-Received: by 2002:a17:90a:149:b0:39b:2b10:d05c with SMTP id 98e67ed59e1d1-39b2b115ba1mr31443474a91.5.1788884995353;
        Tue, 08 Sep 2026 09:29:55 -0700 (PDT)
X-Received: by 2002:a17:90a:149:b0:39b:2b10:d05c with SMTP id 98e67ed59e1d1-39b2b115ba1mr31443418a91.5.1788884994745;
        Tue, 08 Sep 2026 09:29:54 -0700 (PDT)
Received: from [192.168.0.3] ([49.204.140.17])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324410092sm34573025c88.14.2026.09.08.09.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 09:29:54 -0700 (PDT)
Message-ID: <cbbb5555-60f0-4a4b-881d-403decc53ca7@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 21:59:50 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: QCN9274 WLAN.WBE.1.6 firmware drops pre-auth EAPOL in TX
 encap-offload mode (WPA 4-way handshake fails in AP mode)
To: Michael Pfeifroth <micpf@westermo.com>, ath12k@lists.infradead.org
Cc: Kalle Valo <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        linux-wireless@vger.kernel.org
References: <app7ADVti1eiVQr5@mpf-ESPRIMO-P9012>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <app7ADVti1eiVQr5@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3OCBTYWx0ZWRfXxsF6TnNZ0j8a
 oICdgbQQuW8lknAbzR3//fvAOQgP0H1PARTztR0KlmAsZCdGvXfXelp8i6ezC4jZIVBvsaIxb0v
 S7LTALqut+1L0NNqQBei7rDBXWLjBaY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3OCBTYWx0ZWRfX5mksk4+WxVvM
 fFnWWLY6n8WzaeA0vd4r6iGtWGQKJ+9ubg2baY7RNoD80i2XZ8cXJ8KX4/frPgMfDqBFCip7Bdk
 4L1SXQNFq4+KPGhseeR12bvWI5tXjAchABdiCT7XWqbqhOKLUB5jYWLYvJ4vMo36nsNBE2nEV+e
 2qqA46C4N7fiHkyGwQc2abJmowW9JfdU5DyOgj3OL2mJwCOVlL5lbntDX0T7BdT34r5XcuC7zUS
 ZfSllE9Ev2UzMmS2ZSOcsW2Z0IHAVtCuM3NfTPQSswMNAP1N5xWBP+y7ecPqqaHEAtg5zShCCqY
 LEGPjULKaNNKZeju0EciY6Wxm9McRT3MbqM8ZqFa2W/Dc3LlAiWXCwegE8e1ts3OCSg/jSMQiEB
 e7/BDRe8pGl+q3B7rLxyoKl8Z/K30U0Epay1quMwsZCL3qM2vhjPH9cUNcGYklM8JOk7gwLpSE4
 61X88SwviZb4nWMoIug==
X-Proofpoint-ORIG-GUID: Ru2Y_K9ypnjR2jzYd82Er_9myoVyiuDi
X-Authority-Analysis: v=2.4 cv=QrduG1yd c=1 sm=1 tr=0 ts=6aa03804 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=/3tNsvzfJk1ENl4L86PcmA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=xENxMKR8wDSH8ws2yF4A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: Ru2Y_K9ypnjR2jzYd82Er_9myoVyiuDi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080178



On 9/4/2026 1:32 PM, Michael Pfeifroth wrote:
> Hi,
> 
> I'd like to report a firmware behaviour regression on QCN9274 that breaks
> encrypted AP mode, and ask how you'd prefer to see it addressed upstream.
> 
> Hardware/platform: QCN9274 hw2.0, PCIe, on an NXP ls1046 (ARM64, little-endian).
> Firmware: WLAN.WBE.1.6-01243 (QC_IMAGE_VERSION_STRING=WLAN.WBE.1.6-01243-
> QCAHKSWPL_SILICONZ-1, fw_version 0x160484db), from linux-firmware
> ath12k/QCN9274/hw2.0.
> Driver: ath12k, current mainline / backports.
> 
> Symptom
> -------
> With WPA2-PSK or WPA3-SAE in AP mode, stations authenticate and associate,
> but the 4-way handshake never completes: hostapd (-dd) reports "did not Ack
> EAPOL-Key frame", the EAPOL-Key timeout retries exhaust, and the client is
> deauthenticated with reason 15 (4-way handshake timeout). Open/unencrypted
> APs work fine.

Worth trying with commit 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1e33f8acd837420160ea088160d8648a3db54c3b, 
if it is not part of your image already.

Vasanth

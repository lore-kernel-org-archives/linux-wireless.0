Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3634DB4A
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377052; cv=none; b=AEwc0WCiUCp8UQj+l4SJ0hIHC4geRq+/JkMpDiQMEY+G+y0DjS1P9fFmfTXi6ARSETgV3X8+LMMjYdhFleyWYS+/vO9Cchf25N900TcnxZtig/VApbR//trhyBd5Nad63rSYNvyPX9Q/QtOk1xDp0fO8dQgmjRCqbAgSGQi1lz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377052; c=relaxed/simple;
	bh=LW6TYtf44j2istpPF6LgVMKhL4yCGId77xDvtiBC4BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P96BYiyjgfLvMfkHomZZwlAME6yZj0e2GAzVc+7GTPOlOdWawC5cM3eeqNealNN4M9EIdLG3aYIW+RLYS0LRBoAyKRVnFdenR0WZNvwSWbHHnave+mwMOwpLpWsfjaIhcBbTiWmgYhYCOQlhwctemtPOqPzdmLQkZOFjRBRho7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mYGUPEHN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TM1I8Taf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mYGUPEHN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TM1I8Taf"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U20nOn3795212
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+bQFu7vP2omksa5AIfbM6+5NRq3Hi2nkVcA8F/PSQEE=; b=mYGUPEHNGNr/lDb/
	1PSaDWMfdEZSd32SRjGKJ2Q3OvTDkEz09frEFmU3f8FrvwMEj50vMTQg8K6z6n0V
	atTDEZ3F9WQrrW5xI+XsSG28U25vvdyCoZlO3+Ad5wXt8Ln53uCGJLr9ieWinboK
	S3mnMzXD2boIumEwSNoIH+6YY3alx3eIay2Fkk7JYLszojDPRfl6BrO2pGq/IrDe
	fkc+E5ZE8jXZTmryhXXUY1hzZ2IV+pJppQmssdfZi9FyTflzTyntVOrBAl8am4jN
	qbrHkWNrarBJh2luKJUPMTAFXBXLBIa/CnaYPdvpHIK7DArKgh8fI3VCbV+E82sG
	T+MLEQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqwf2r0d0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:04:10 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb835525b10so1788948a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 19:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785377050; x=1785981850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+bQFu7vP2omksa5AIfbM6+5NRq3Hi2nkVcA8F/PSQEE=;
        b=TM1I8TafPC1fVcA/LuAtaM9ldHr9ve5jijYNjn6AKyw4GlFXz5Iug+xuYs+85Id5Hf
         +E1YEU0ZBECdZk4ytFouWNiOyHCdU9psLp+dMmI1GzLOfSNpAKsFowaWEhV5jqT1p8ZB
         1arZzkSu1q45r37rKzfhS3a1i8s8XensjdA43VzG10z7vkaHA1RS+5jJeemQ5YQZWYzE
         D/WIUECH4ZUCzGpPUn3U4/age7oN2uGPXKtY0N1+zsoLcPGjyXhsf9HBG9+NAEfayArk
         MNx3eb+6i4jMUHuF3t6QfJ1Whd/oEcyOO19xQo582KAwfJyGo2lmisXBm9HlKgYnUg8i
         LdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377050; x=1785981850;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+bQFu7vP2omksa5AIfbM6+5NRq3Hi2nkVcA8F/PSQEE=;
        b=ijBmoF7H6vULKzOWCNAzPWnq0IPPG5hMjDFxCHFoBHq5TfKHUjArOMidMydRzO3NPk
         TySxTynizLOKK4+6LlT+Bj1VtYEIU7i7X4Pn7Q85kTr9oDKnpYILYdMYKu/hRZ5m8BU0
         4lOibNcj7wkfRlCzu63PKc9PMxVBgAlkU1v/0gRAdHi+tiXXXmAtejuSIDej6qcl3a13
         UhfR9MjYTgPCMiahFFNJ8IqMhOfJfBna1Q2cK+FwbebxPLXL2iLj3d5Zt91N++2g9JYY
         NOnGRTiVNOSuLv5O7/gUt7UPmXSFVUcmBg6F0qWN2Yjg4w4EPtSv+M6Z5AH38sCMDzzz
         7xcg==
X-Gm-Message-State: AOJu0Yz3/Xpbqh/nAgVtFlQa1b8BWg6LhArYezkA4x2UUCoLfLbxsU5a
	IVqdai4IirQ5ItzglDiCOCWY687BVG8F4TF1ylQlKpCNP4i2h/TR4KZmgTlmVL6lPysbdGSgmba
	Ml1amjpiEUfcrKGFeqGOW/lyLLHeJBlBa6VNUft0b3pGLBSsbrpBp35K3XY3o36MclekL8nDfn8
	t0/w==
X-Gm-Gg: AR+sD13by8pvY/52T94Z7AD+3vYsJ7htKZpoPPmw5ELXPVPihSlQ02XHZmOTx02SFcB
	DjiaDcs4saUQ0HdlViH5q7cBntMLBWTC31kwH4k51f9wVXzBdpUGID8MeBPkzS3L3q9gOcQJxjN
	JF2lDoyTWavL4QJezuweHUe/Zub2pM+unywn8M+UTsEk3qnPPYWnQHFtXNnvhI/v4wlOuOX0oPp
	qhJOSXIQIy+EIEnOULhjGkZ8oYw9DzX8CuAiSSY7N11OfhHSSZEbKimKx5buAgEiG0Kxb5jOMU/
	qxpPe4MQP+2epG4gytZ4NaFaV6vIMGz7x8+Sa95uohEr75cHVJ57q3DbB6urnrwu+sgwGe+rD1y
	AYtXUXIkE24KivkhqHJs+6pNlaEkNsP32ey8l/KBDXFa7dnOwA1H0qgl3+i0FEN3lFAfeWZdK8A
	==
X-Received: by 2002:a05:6a00:2185:b0:848:2f7a:2e5e with SMTP id d2e1a72fcca58-84ebc466080mr702582b3a.77.1785376661813;
        Wed, 29 Jul 2026 18:57:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:2185:b0:848:2f7a:2e5e with SMTP id d2e1a72fcca58-84ebc466080mr702564b3a.77.1785376661438;
        Wed, 29 Jul 2026 18:57:41 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0300ac2sm2099431b3a.35.2026.07.29.18.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 18:57:40 -0700 (PDT)
Message-ID: <7c3d5a9c-7e9c-4d59-9932-86d05312e26a@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 09:57:38 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix encrypted EAPOL TX in encap
 offload mode
To: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=d+LFDxjE c=1 sm=1 tr=0 ts=6a6ab11a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=XimLFvTEBuXuzLDNtLAA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: PiUk-gtAj3gOoNrADH05WtTTUN9lnQVI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxMSBTYWx0ZWRfX+ibcJw1t0oXb
 sqUPCZqN71BVnw5KUPqKR+MPwb4wxf1LtpCBRFEiw7EV0hYQxOdQ7TaAAxujsoIPw5EXJGg4tTo
 HOn5spBf5NQDzltgePmrmgX1mcG4n2uhK+0bJbbeOx+2WR0d0PEt6dAjog5hUQLCINjjvaWKJVE
 rhbts7ZFtFBVfPD2staxR1leLgMFc7bdXbBS91DGo4PeNcl3VC3GPd9L3Za9ganhtCSOh+mAGpz
 /P9O9Q5gAZMbfAUMgwrRTWXQEIoJHVLav5Qbh82O3eQ15lsBnu7Ybi6wVFxowVRKjnA49OBeZrn
 nw6YTC4QdpK4yxKZ8mzTYW7uN9E/ZO/4Xqb96eRGyAOMJwl90TcrZko367vBBBfbLS5enbRiRRM
 IO7T2FnWLHcnQlHKKszeYeET9r9I11Flq97vmSJkuS2Z+nRmf+DCTmT79tgmQp23bU7Kq+DIxJO
 Cz2dY4P+cZXgwuE8K8g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxMSBTYWx0ZWRfX190S7slD+69/
 /cLJYWrr4F8R3mQfT7HGTXJTYz9mHoGSJYM3S4ZJ7R6GK2f9JasuYZxFgilbT79nLABFxSEScTe
 hKDS27iA9D5vk+/uggeTx8nkyNSelcA=
X-Proofpoint-GUID: PiUk-gtAj3gOoNrADH05WtTTUN9lnQVI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300011



On 7/30/2026 1:17 AM, Reshma Immaculate Rajkumar wrote:
> When a vif operates with IEEE80211_OFFLOAD_ENCAP_ENABLED,
> mac80211 delivers EAPOL frames to ath12k in native-WiFi format.
> 
> Unencrypted EAPOL frames used during the initial 4-way
> handshake are already handled through the existing
> is_diff_encap path. However, EAPOL frames transmitted during
> GTK rekeying carry ATH12K_SKB_CIPHER_SET and continue through
> the normal native-WiFi transmit path.
> 
> Firmware encryption requires RAW frames with cipher-specific IV and ICV
> fields correctly provisioned in the skb. Passing encrypted EAPOL frames
> in native-WiFi format results in incorrect IV provisioning, leading to
> an invalid ICV and frame drop.
> 
> Fix this by detecting the EAPOL frames that need HW encryption and
> converting them to firmware-encrypted RAW frames before transmission.
> Reserve IV space after the MAC header, append ICV space at the tail,
> select the appropriate firmware encryption type and request
> firmware-side encryption.
> 
> Introduce ath12k_dp_tx_crypto_iv_len() and ath12k_dp_tx_crypto_icv_len()
> helpers in the TX path to obtain cipher-specific IV and ICV lengths.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d29591d5b52e ("wifi: ath12k: Advertise encapsulation/decapsulation offload support to mac80211")
> Signed-off-by: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F06D433E63
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785417976; cv=none; b=G6NMnIyS7j2/+LDBvUL+DgaOyF8FOuzbrC7VD+qrWGsVQ4Q0Dq7pKPxxZPAue9pjTlH8csxsehbZD8IsCtkXfrZ2uHgOarCOnDMg0uf2BGKdQxEe42IW2sSvvia1vW86Z4XaUYsHORmOqEHY6zM5WwdeavWH1m4J1dNHHMqPcA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785417976; c=relaxed/simple;
	bh=35Spq/c0FstdidqgZA6bPT69MAXtpprJSYnyMs42IWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q1rcsuxtdTmr+d0QUtuWTnoK8jZelDwaYDuQm25z7w+7CGu0AB0REcbOM8VRKmeN5oCk1uajNUQCuRujXqSv60yOIsggejqbphDbBUkencoPHVunextqzWLuf4l0Wd+hvoG9sfJm2Cve6BjRnoQbXXOFfg0ojuyC3gXGObcEcek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zhh1KuXl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ms7UkzW5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zhh1KuXl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ms7UkzW5"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UCkWvv780128
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 12:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wgJRwoX5jF9ieOOgTJUnCTZGa0j7I5rZMC3ubgqeQTU=; b=Zhh1KuXlxoQvbDwc
	dHKo4c1IXabTrYA9fm3gQIaqNPTnnXD5lLyXvpkvrQ5qkRb9cZIR0kIHKSt+094s
	pjVogS8tL/oL+eEJGyUXzgle+2pB8PlAPXCipftstY0CqeXZX7jtS2SUpkn9ABY/
	0Dgj/tkg88y4/4JJxtpEr5sYBTb0RQ00TuL5Ej3iFoQ+ADBY/ZJHGS8o893jEoY4
	rAn2t9iEH+ozM/rcYFVG9v0IVGhnHkUigCRJlCJIKLJgODnGI6TJUlw4NTct8hgi
	8FeHCzofyMdf4cPxrOC8OIARIjGsbAVa3jXrGe6OIEyPfPvZYK7f43sBXEL8hNoC
	Acw34A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr6wmg0se-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 12:51:23 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d004f13426so26711095ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785415883; x=1786020683; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wgJRwoX5jF9ieOOgTJUnCTZGa0j7I5rZMC3ubgqeQTU=;
        b=Ms7UkzW5udxEg85eoT9ZdZPFTUcpjt+WaaxS5U3+7CRCypNlCpxGPFDXCZai5bPH9P
         Qf6laogWHSrPhNI3iXzv+7TPRlTJ09F/OaLOrdi/FbQUWX2zpHWOJx0rIGgJCjsPp08s
         MoxGpp0Ej7mjMF5AHtlgGw/HRKVJZ6kGnQzbn0cNxHoFZWkoK/+ilo2hFA7v3vQnmD5W
         frRuiO+h+3fjiuFn76HvCHhbYlHu7fR01Cp4VwUV/R3IHDuAndCHg9OfY1vvCEfHtDLb
         SM+fTpNdSlPKmXE0Yiy5o1sejaNlPzSY4rYxB+ovqZJ/80I7xrSUMuU05mko6gpVjh/n
         8Zvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785415883; x=1786020683;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wgJRwoX5jF9ieOOgTJUnCTZGa0j7I5rZMC3ubgqeQTU=;
        b=Mjdciytp+RwAsmJIn3LPhfy0tdJ1pRbVgjP4hib1q9aVpPJmK6KR9RRYhOcqiePojT
         MVSb2DLnOqf3p5i7UZhUoHW/ioLhzHT1gAluwthSizwsV+96SeJEUe2LLmfDhqd96cR5
         2CQYg45PCGm+OS7LwIJl88wdc5sP/g94Ah8vriu1w/DqS+RnjXWmAtaUsbO0Z89PGnzr
         UZUbeA34Rp99QXMKqHIi10RLoDhMwj/qHiWwHgbG8ceR1BuHNDdEaGTCr2pcONnow5Vk
         6nj3PwA1z52p7kBXmdNQbOaYdw4NuU32VlgM/a69PajOei+XtlyKwQpS7TpB1NLtds/A
         4Gkw==
X-Gm-Message-State: AOJu0YzaX8IOdaXS/XJrBHSwc4M1E7qMcmYW34ORHfkZjIyZ2k5Ij60s
	80LhFnihfxOXx71kndvFSMgrHNbzE6I0CgONMjZ7xNtDX8LoqxB5tcLg2wulvNIRPBh7ZLEhF8l
	sJDPuzSBUvUSPklwqnqG7Cf9zF1jQyA78x3j4QilhkeeiYxPJAX4bz+9amykV3WRll8uepQ==
X-Gm-Gg: AR+sD116lu2Q1P70FRzsGrT5zoyQTd2sHZzPuUiEXjNme9/YFIwdktuLLgDPtCVO+yS
	Ow3EMPQcD5AqDI3LPEPDBXNPPliTcGIbjieOI7CHCBHwUXGmm6gaiFyxb422MHfquHUBcwK12+5
	NT4Zt6PdDVFnaWuOkEnXh771jkq1XVTHxiv98UIIDqkBU6GJOCA0TruDFxxs1MTij8yjwwCAEli
	W81JeRcu96Hbag8yZ3lEwuDmWuYvAROTT2/hfI36b0aVdweCy/KZJPFSJNPEY31OYabDbRVxhlI
	pa/GfcSjUIk93OAYFsALPiNCEBZv0hSsyveH+IKEOlbUUjoFl8xILSueexq+rTBPnUxtgAPUEoT
	9MMSsP7B1gXssAzIehwjaX8G34EADr1+ZNohddRYmfHVj
X-Received: by 2002:a17:903:2ac4:b0:2ca:481:de45 with SMTP id d9443c01a7336-2d035bee380mr21485355ad.6.1785415883037;
        Thu, 30 Jul 2026 05:51:23 -0700 (PDT)
X-Received: by 2002:a17:903:2ac4:b0:2ca:481:de45 with SMTP id d9443c01a7336-2d035bee380mr21485115ad.6.1785415882518;
        Thu, 30 Jul 2026 05:51:22 -0700 (PDT)
Received: from [192.168.11.101] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504cc73b6sm20426776eec.18.2026.07.30.05.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 05:51:22 -0700 (PDT)
Message-ID: <a649a8b0-801a-452e-bc4c-fef153e07015@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:21:18 +0530
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
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA5NiBTYWx0ZWRfXyS7S7fCO2YOj
 htl3iTR7/bVrBA+FTUmZ7dFwRVq4egI5BRK4dfFMEAQBXgN3cl+VGoCxQOQ5QK+f+xsQ6QPM2Gm
 bNDieSX9oWbQvUxODQn4V1e1MyDcdI4=
X-Proofpoint-GUID: ROFgYRzPKWMj8bVKYuha_30_Ej4vffYi
X-Authority-Analysis: v=2.4 cv=OauoyBTY c=1 sm=1 tr=0 ts=6a6b48cb cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=XimLFvTEBuXuzLDNtLAA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: ROFgYRzPKWMj8bVKYuha_30_Ej4vffYi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA5NiBTYWx0ZWRfX5HGMLrYO4mrn
 bqOSMKuybooubo5T9laFuQqWQXuEsCJ/jkCalrTWB8Fs993Qn0UhFN/FPGDs1ldqJhHMCF5I++H
 nQrYx/1oLCgxzvci1ktORoncEgHEY6Q4NA8x91nmjJOaUrLjvl29PpAFblcMNCFCbNtbeixY5t9
 NEZ9q63OJgY3wFmCA0JTH6nE56oKnSISDR7N4FDRYbLQvbrWn+nyB8Z+0jRdFCMv9eft6EQ9AVt
 siGgiao6b720Yx9+aZKXiCAyV/tYBG3m2hdLDO/+zGBq1117SbNqbGoEzTSKod6pNzmOdRMMipa
 VmvGwzPn/LgCzK7ojoeD91Dh6PVursU84PHDqxDjgZeUZayFGMFIQzXDf2rtGZgih8o4k4E3bYF
 T8aEzNeLDfAX2alXDjupsl4Tcv6UXzGW/o+AVCyUa7h03GAamiGtd7EufqWYAJ4OT5OofrSiHpJ
 ggAiXO85Yx3AaXViGFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300096

On 7/29/2026 10:47 PM, Reshma Immaculate Rajkumar wrote:
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
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

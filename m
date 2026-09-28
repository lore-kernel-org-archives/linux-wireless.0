Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9666E3C4544
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790574609; cv=none; b=dtHL3u5Gqwj3GPE7jJ7evpDaDbsDqeFS4QtSNnokvo3385iKS1h71u0s13a4W2s2LjBn/ZsxXn2bJUXJbUhEY3+HERe2Nc8L6B+8rL1y5WjlGB+xtaIdIQ2AIEcVab0QOtsHNC6ELIOIe7qTpvl8HSsNYu39qB6Keu3Ri9PfIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790574609; c=relaxed/simple;
	bh=PvxMW8SITH1t1gSUYjYZPnBvawebufnDLNleallhZuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GgAXfqVvpNrilb7MRHNMIeeqoBt9Pw8YDHKXwegkepm6EeMd/h31/koIuDYxihGI8xCUqw4yGrsalrqGVLqbMndI7OpXGWHtDNgRICJ861vtQzuLrNHQRQippY6WVZFl2GpVmbz3U8jUQSaLJAdWYK0Qjm1QWLEZK6J4MgnBrgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FbnMUt3y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IS/G8zT/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FbnMUt3y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IS/G8zT/"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S5P3nX674763
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 05:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GJNlotP/6/HHnZicU2LMqHCQHPmviWTeBFEUH89dLfA=; b=FbnMUt3ycDfdq3q9
	9ofioAT2dYyptlav+P7LhQ/qoXIGdVgq4LhtEi6hF370NEvIhDT0vdCwSQ8nSF3r
	2NNp26XPFUgw7Z9FnOCpjy13eC5HVsM2kO1KmcFyrniVM2YoK11mypVCfQhlBN2u
	dWOxKUe7DijOn9g02ZaD3D6xrcsNZZojBmB0RMEsgLarKOORs35uloCuec7UPW/T
	W0jdrYrVakHDp5KhgbSge83XOWl+DUJmWDUDqzS2LTEfljqc+QLczaRPGdhh+PUS
	T+fUhat3F3C0IVtFsG5fUQCl4VNxQD4biLgEHAnRHVD23OBNdbXuNzXDXqXPo4xg
	QQnYJA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyj2s02bt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 05:50:02 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso4800086eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 22:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790574602; x=1791179402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJNlotP/6/HHnZicU2LMqHCQHPmviWTeBFEUH89dLfA=;
        b=IS/G8zT/4Hk4KU59ntVAKadumaquiM6DISOL+fDgLX/NxwQv5pbqpm7QQMmmDiU3/5
         szs5H9bVCNs3TtSEOzx1cJNPSeIz8T57q37dhzP8FzqFuGKZDZxoek8jV5lTfDS85BYG
         VT7D8l8tBycdL9MmXejY0AQAjNAECzBJ6TTcKzpnkaQHUXAQlcaDFuSAUhzQT28CAES2
         0EfusIJmUI5hKepFSItU8ue8AjR5+6/DINeSOlFFFy+zYSlck+nmL5W+LXe8Fe+19MVL
         50wyNbAljY8oW5iZkb95Csf9hvh9RDwdcBxZ25rgxPMABRjt+S81INeHNytwzQJCBogk
         uHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790574602; x=1791179402;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GJNlotP/6/HHnZicU2LMqHCQHPmviWTeBFEUH89dLfA=;
        b=yjN8WJhBNgj7m6aawFkuPdNqP3C4FHne9gh+hFxuyc1GeMBPp+wpLA3DV3W7uEcZdE
         Kk1qFq27Qm7EuTBcaaUYmMIS427UOcOz2mpMUrmJfyQBWYu5Ms4t0bnPSmpFKWl0MpzD
         h/Eahq3/aWGhVls0+Zlg3M6dr13c/U/z/a+fNLWa/xG+sv/bBt+W95PbA73JK4suxyqm
         nzknjs17o5PBDPcp4nQUged/TyPuFg5ItLHx22YciY1VP9GGacY/R/dc4pALVhSXvK54
         AkdcEjVGJdhe/e1Qbl78NBoxIV09CFf+NkMtYYAzKKVE7E7b3f8VOALFDZvWU3aXdBdK
         R+5g==
X-Forwarded-Encrypted: i=1; AKwUvByhUftIpUBzaFHY1g4KT2sZQr3PR3hdls030NWJQPB1dXtmE8ocdcaLhpVdFnTmQMWtLYk6HPcFqY85grL/4w==@vger.kernel.org
X-Gm-Message-State: AFq9FYJt5F0eB3brCn3AkVlRMJIMpFXooFnU6iWANAkLim58yADPRigw
	gWLM8FstcELa4UGwB2MAmue/LEPoCfa7X3SWr9HPP+W6JRkobid6UkKlOFHaxZDIWXI85TZr2nO
	nVFC/lk74bhk2+XjHt/izbUOFpWId20qA6rdfpTPYaxJxeJTp5jtb+TTtOr62CGADKdsLgA==
X-Gm-Gg: AYBFou2FIL8kr6qcwVIO1/MHTNHvgcMd5e2IqCPWvHJgSC5E7xNxN8FPR/bfILLuxwL
	id3kQTIOKW6xDVQyu8unzI4Xt5JqX41XHN/y8si+5h1oWDpRbE1rlEpqPYlE9Pae2chrVzJK/LA
	T60HxvOtG7SoEPnNuq06mL2fJX71kE6qaX125VWkkz8iKi4dC6ISRxctt7rRfLDLZ07e+myQdxk
	D7POTBGWUdTG/mhyvqCzYcmQ1Nm3JR/hr9yrEvtadduQVrJlzAnSzqH1M4BEyYDEWCo4Si+A0Wb
	zgI1g1oo6s8OqfchK0OUwpi6AF4PJg2JrtwrQkUzWGYvQAovNhlcaoAE9sxNMwad7Dey0LiwGc0
	tcIFgjUHOPcEvI1ET4LCJZovO+ndav/xIFT+LDI15
X-Received: by 2002:a05:7301:678b:b0:33a:f8c8:1d47 with SMTP id 5a478bee46e88-3427236f831mr9001078eec.28.1790574601430;
        Sun, 27 Sep 2026 22:50:01 -0700 (PDT)
X-Received: by 2002:a05:7301:678b:b0:33a:f8c8:1d47 with SMTP id 5a478bee46e88-3427236f831mr9001051eec.28.1790574600831;
        Sun, 27 Sep 2026 22:50:00 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34141a4a00dsm27014719eec.1.2026.09.27.22.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 22:50:00 -0700 (PDT)
Message-ID: <773e57da-a9d3-41dc-805c-cb38b38b1dc4@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 11:19:54 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] wifi: ath12k: avoid IDR mutation during pending mgmt
 TX cleanup
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260926154824.75224-1-yaojiale02@163.com>
 <20260926154824.75224-5-yaojiale02@163.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260926154824.75224-5-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDAyMyBTYWx0ZWRfXyPmFlyuCldc0
 uk+RMdZ27vA3cEgHm5NbdF0RwPS2I0Yfk8ia+jEZ18PgO8ZFTGYaeBVZ8SKBThGzOxjVcBeVmxl
 bA+tZgX/NThUhzi3Ivco63BW4mONNhs42fl9/chRG2CENJoJZV0f6BVAzBs829glCOLBLGdjg6Q
 C5+yyNNddi80AZKhDcqD0p/NCsnxaeaeRh+tx7kO0OsAo10KZx/GsPdyOt5uC2IDOZY8vgSv2UF
 K9Vm/0GEGJPGSZZKpvlAtQHXrjAe6xN2uRErchgzN8ugTZKM/uEzD/YFEPzb40eeXzqBskXgFcA
 dTRFnf4OFGYRPIBQ06YH940hIA9K3s4biX3JZ1ErEgS9EO8VH090pxuAE70HuMJJA5ivB1yKr5V
 UIABa00RPYyNV9NXJf7nWwthGygB1DCHcrzLx0XvpsgAG/cWHTioLvNlU0XOx8qbDWv+R4EytxT
 1tjWxwv3MUC67sfzG8g==
X-Proofpoint-ORIG-GUID: Gbx0uLZukG9vIy-TXhk6FcoBicWVMvCX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDAyMyBTYWx0ZWRfX98ucqkhLjiJ9
 Y4lHipCPoFEYfMwSn7+0gJ6l38gs3t/F/x4huUiF9o05ONEv8nTS31OTpt3PAOaCmWjbIv6ZSif
 zRhJa9kSxZO2VqVQ+zX8htfnTDnkWCU=
X-Proofpoint-GUID: Gbx0uLZukG9vIy-TXhk6FcoBicWVMvCX
X-Authority-Analysis: v=2.4 cv=TptzFzXh c=1 sm=1 tr=0 ts=6aba000a cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=Byx-y9mGAAAA:8 a=X_UHSqtvQJ_SCcS1l9EA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280023

On 9/26/2026 9:18 PM, Jiale Yao wrote:
> ath12k_mac_tx_mgmt_pending_free() is passed as an idr_for_each()
> callback and removes the current entry from txmgmt_idr. This can
> invalidate the radix-tree iterator retained by idr_for_each().
> 
> Both callers destroy the IDR immediately after the walk, so removing
> each entry in the callback is unnecessary. Split skb release from IDR
> removal and let the callback release the supplied skb without updating
> the IDR. The following idr_destroy() tears down the IDR itself.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>   drivers/net/wireless/ath/ath12k/mac.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 99bf5cf79d10..7695b21149d1 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -9166,18 +9166,11 @@ static void ath12k_mgmt_over_wmi_tx_drop(struct ath12k *ar, struct sk_buff *skb)
>   		wake_up(&ar->txmgmt_empty_waitq);
>   }
>   
> -static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
> +static void ath12k_mac_tx_mgmt_free_skb(struct ath12k *ar,
> +					struct sk_buff *msdu)
>   {
> -	struct sk_buff *msdu;
>   	struct ieee80211_tx_info *info;
>   
> -	spin_lock_bh(&ar->txmgmt_idr_lock);
> -	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
> -	spin_unlock_bh(&ar->txmgmt_idr_lock);
> -
> -	if (!msdu)
> -		return;
> -
>   	dma_unmap_single(ar->ab->dev, ATH12K_SKB_CB(msdu)->paddr, msdu->len,
>   			 DMA_TO_DEVICE);
>   
> @@ -9187,11 +9180,23 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
>   	ath12k_mgmt_over_wmi_tx_drop(ar, msdu);
>   }
>   
> +static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
> +{
> +	struct sk_buff *msdu;
> +
> +	spin_lock_bh(&ar->txmgmt_idr_lock);
> +	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
> +	spin_unlock_bh(&ar->txmgmt_idr_lock);
> +
> +	if (msdu)
> +		ath12k_mac_tx_mgmt_free_skb(ar, msdu);
> +}
> +
>   int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
>   {
>   	struct ath12k *ar = ctx;
>   
> -	ath12k_mac_tx_mgmt_free(ar, buf_id);
> +	ath12k_mac_tx_mgmt_free_skb(ar, skb);

this now keeps the freed skbs in the idr for the whole time 
idr_for_each() runs as opposed to previous implementation which removed 
the idr entry as well which looked safe.


>   
>   	return 0;
>   }


-- 
Ramesh

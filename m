Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FFD2E7383
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784854935; cv=none; b=AQBei3rvhvLeXygYjAJNTZ/RXM++Qq3enSJJBZkdi6+uFAnSzkDJUe6oytcnk9D7IFcy9d7yRryXh7ANaqmGaRg1zmsxj5dwBD0ttPTKiZ/vqQDr5K222gH7NvB7Vh7V8FczCa7UAlsvkAQnKmcIWEDL+ycW9IZyPwtTZ59Lqbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784854935; c=relaxed/simple;
	bh=0QIQgiOEK5NJIWnKZK9yMgHzaOP6+TMdCUWhJVCjoxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tgUOib12UhxH9tS774eTjb4Qgr0nNreSU5JLYo6CQes8vSKVSYxhVQfj5kt65SfZ+r3KcUmEkS/ZgV/wkeT1EacSFNCS5f/M59yf1ybZffjiayBRozfDYYtnb/hOdFg61OfG0tFTlKZKgvg7F09F0WOdWXEXHOVJlBLjUOxGkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G4kfaSh0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BigBJb/4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G4kfaSh0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BigBJb/4"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeVd01217918
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WblrNcLsi/Jl44g9G73gbyP9Kj6CCa18WawMWQHVOgg=; b=G4kfaSh0GY3IABY8
	Fs16utljFixWv1jqvV5aqkUM05FpUg6ZMMH6ZKLFnnyyf2iKHHa1cSY3I6C1tt0A
	CV0rgXYVG8ILdPPadGoJaC2b79WumJT60NjZ9R41e1HDcDHylq2+ihtAfPLyGuKZ
	U3ci0cIys5cTT1lLm7vl7vcLJ5h6aCyvL1U4W5atOSEktnuDiYFquoCTkDO+bMw+
	mOOQpmQAN8ZPjPYV3HpcwUyy/or4VeCbWlyvTMUa5UHdzYzJpOMDu8iV/RdMnovc
	kIHF3gq0G6LgZMaIbGVMP/Gq8NRBidkOBdrjP2oSVU7KLH8TxoWIR1XXzY+7WGZB
	IA+cww==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqa19fev-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:02:13 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso868325a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784854933; x=1785459733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WblrNcLsi/Jl44g9G73gbyP9Kj6CCa18WawMWQHVOgg=;
        b=BigBJb/41G3BPhjGiP6GmRrt93e1e4vblvYtqTXG9vAOrfoOheuDaoer2oOMqTKFzm
         4gLQCvyipf/v4Rq3Qug5Wp8paDmWw1VujzbMIw2fjQoPKrlWHEu2Mc7C/InwKInw2Q9W
         j7+dVznz9+6XbdBGYntbEYBzCi6EISU91j43IWvamyRzmmDagUqRALheVgqhWuLw4RZb
         JLex4qLYk3xkMJS2+FTxePOMzgT48cfhJHoE44iLZz7eBAEGyqkkphgLE7TrermpSkrV
         R2uuX+evCiG7rcN0x3IZ6FL5pdLJDR68Kv8PbfPXXH7riB+oIV+KcPYdN4RJNe/cq+oQ
         QkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784854933; x=1785459733;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WblrNcLsi/Jl44g9G73gbyP9Kj6CCa18WawMWQHVOgg=;
        b=b2z3Qy2SlZ46XC1AGm+fDcyyGHrk0MMGLzH/OHNABfFf7URPDHX+Dx9FN737W66DGE
         YrIacFO6mM7jAmE62BGC47+rcXLeeHiu2NDwtpmxunajLcyjmbbK9LsvY7npETisyxF/
         AipVhk3hbTw0hJzCsTWIA7t2rH6c5TelbVddjL2cZwl/AGm97gw9j5RFf2iLOm6CJNPl
         X9Hjl1Py84j+R9gJHSIaFSiOlD+PqPyMjkoY7mb5iVAfe2ezlLOPhBy2LK2e0vJOYeW5
         2moElbir+fT2XJ/wU7VW7wPF/5YeJnNxJvkgTKkVM4Q2Tgo8FcPlcEz5xIjkzbr2RP8U
         lqNQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq41OF8NR3OJzzy2TtJ7oCiK4VzM6rawy0FWk5bjFF6z5Qyej8+l6qQWqdzkQoKFMHvwDZprcFmy4Nk1RlZ8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLgfHG0f5XZsSuiCSev0KQDjR8nA4YI6BH/OfptHaK7Az2qmmj
	eQQlgHCWNA8JU+BV9+yNb3wsCCi6rQYsTOtWwqOvdK8fGdObCUSjwwbTbcDKNzk4pCXfQr0nz7+
	4st8kRyAkhMkokt0Wv/9y/oabknBN/G93nXmH7QSIQ5LA7GVG58AyKu8CI08pNh88ta4nGTgOuH
	hhgw==
X-Gm-Gg: AR+sD12qS794e/rixg9YCVKNI1SME8LJFBp0Yl+948gHiWWDatdl9jj4n3X5+K4y+/I
	cfMf8eAp3js8WaWo2pe8AJ4f2rNPuoB8KvpUY9Lm2iqnJA69q0JguLV9ZUpuOxalXLPH6bzenma
	0R1NjveWC3YdxxA19MTbvYmBXGywqCfbGzZ7thkj4cpD/cfUIUwLEiFwg6euIDSs41PLR4MHuzV
	ahFDbwdS+UsesfxT6C8LibEBlkcSzG85VSIBoV5VJrI3TRCWimI2lfQq3l1tu9Gtz+qMRtrcSld
	7hJmnVX8BPyI3No/ra+o/BZXafO9CvsIgC+aPNLyVWTdA6fxs4CkSLm7xkwQO0RVQxP8QsBcppl
	R8KDQxeQkPa3lHBM+G8hCngfoem5myF7tT1ZKIK2sIuelsSrgllBWIrsG9Q==
X-Received: by 2002:a05:6a21:6494:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c44b1a3cfdmr6067889637.46.1784854933175;
        Thu, 23 Jul 2026 18:02:13 -0700 (PDT)
X-Received: by 2002:a05:6a21:6494:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c44b1a3cfdmr6067856637.46.1784854932699;
        Thu, 23 Jul 2026 18:02:12 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1b6a45sm24180258eec.28.2026.07.23.18.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 18:02:12 -0700 (PDT)
Message-ID: <1c554956-4b33-4b29-bc65-ae6dcbaa124d@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 18:02:10 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] wifi: ath11k: release QMI handle on late init
 failures
To: Guangshuo Li <lgs201920130244@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org
References: <20260718074026.3085688-1-lgs201920130244@gmail.com>
 <20260718074026.3085688-2-lgs201920130244@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260718074026.3085688-2-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Fc5BhcDyjrLNEkeT2TyEvxXzSmq-TC4H
X-Authority-Analysis: v=2.4 cv=L4wtheT8 c=1 sm=1 tr=0 ts=6a62b995 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=COk6AnOGAAAA:8 a=LpQP-O61AAAA:8 a=pGLkceISAAAA:8 a=iCY2eI6ydM37Y8nmTysA:9
 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22 a=TjNXssC_j7lpFel5tvFf:22
 a=pioyyrs4ZptJ924tMmac:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAwNyBTYWx0ZWRfX/OTNH+Eewp+1
 lfxacKOW7+PRXJy1wNBkPC3pIm6lL/gA98XRBFJ9u0+vquFhDs8dynKYMaqnG8/cbb9tN+ZZH7T
 Rf7kkndqfz160iBIhlcFIADZW7sF7v/kM8oQMJfyG3P6MhX24OFbJIVJIHcAMAjFKBLceBXbNUS
 XgxhrM4UvQBRlgRkC4VAeDn1CdllwaLy8bicPVpm3zZJBIbBLHG/y7potR6rU9MH2mr9RLBGF0w
 0ncWfXyOgWRCWkpXvlXP4Snf7jKZWBebdb8q9eB8LVZQTIPnSdqR6CEAV5iJJUR3iR2y5KjY8D5
 5wbrzSOXATFcySZDF2veJXfTD2/FJleU4jEeaKDMxTdtVK8OjMwbUKfiGahwctD7O1g8o7th4e1
 Fl2EQACGli8dPmO3szIk+FD1cBmCMxUj0mNkd3lxU47I4HXkC1jfIisBYi9+B5f7EBZxBRPeDMf
 /rLkMl029w57Su3kTJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAwNyBTYWx0ZWRfX5d5Ju3owEyxC
 I3xTHSqx09STQlf1LuH/zElRwpKbNqRlT0iZSo3XbDu+HcvWT+rXZ2DgE7PZbnrU3GYnwCwGcUM
 KqASlHU5MkrI3nTx1z9PS5DlMEP90AE=
X-Proofpoint-GUID: Fc5BhcDyjrLNEkeT2TyEvxXzSmq-TC4H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240007

On 7/18/2026 12:40 AM, Guangshuo Li wrote:

(dropping obsolete @quicinc.com and @codeaurora.org e-mail addresses)

> ath11k_qmi_init_service() initializes the QMI handle before allocating
> the QMI event workqueue and registering the service lookup.
> 
> If either of these later initialization steps fails, the function
> returns without releasing the initialized QMI handle, leaking its
> resources.
> 
> Release the QMI handle on the late failure paths.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
> index 410a7ee076a0..6e3f82169d24 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.c
> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
> @@ -3329,7 +3329,8 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
>  	ab->qmi.event_wq = alloc_ordered_workqueue("ath11k_qmi_driver_event", 0);
>  	if (!ab->qmi.event_wq) {
>  		ath11k_err(ab, "failed to allocate workqueue\n");
> -		return -EFAULT;
> +		ret = -EFAULT;
> +		goto err_release_qmi_handle;
>  	}
>  
>  	INIT_LIST_HEAD(&ab->qmi.event_list);
> @@ -3342,9 +3343,14 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
>  	if (ret < 0) {
>  		ath11k_warn(ab, "failed to add qmi lookup: %d\n", ret);
>  		destroy_workqueue(ab->qmi.event_wq);

Since you are adding cleanup labels, it would be more idiomatic to have a
separate err_destroy_workqueue: label to perform this cleanup

> -		return ret;
> +		goto err_release_qmi_handle;
>  	}
>  
> +	return ret;
> +

so here have
err_destroy_workqueue:
	destroy_workqueue(ab->qmi.event_wq);

> +err_release_qmi_handle:
> +	qmi_handle_release(&ab->qmi.handle);
> +
>  	return ret;
>  }
>  

same comment applies to ath12k

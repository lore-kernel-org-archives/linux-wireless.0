Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA648F001
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788905262; cv=none; b=JgSkBoum4KG16Qp/ASgr5JzteUzpsXcnPamCmWGe0ujHYYYE183NVHJ7nRrZKkO9NtvAxqDuf6LtYAvcBt/QYyaGql2Bo2gH1ZRpT+zKV/ZgTEPbbg0OB8IE7WNbyXJlKHzTnYzDeWVrw5kI4OmqEGaWj9MfVdLGJ7dENIN/l6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788905262; c=relaxed/simple;
	bh=WVTjgZ0H4OmwqSHoDOZy3JFapwtM30xR3hG0IewrimQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZKQQSs6KGghoIJpfA3nOh7L8T1XdUc0WDRQk7+SoFsV4sKMmRKK516q/nOHyR/t1CQhSNcHmHWqxjyeQaSiW8xpZ7+/Eui2vEq8kaRIPiCaWshGojRcOx70a8tK3z7SVSIJiOa8MZr1lf+GLanuRzbV8np9bXCIO/TE3GsL1lJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B2C6lMsx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F6mhynem; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B2C6lMsx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F6mhynem"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688IHE1B127903
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 22:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sDx0rDDViSXpY0EaEWg4SGxVXchArhRyGAl+I6Mor5M=; b=B2C6lMsxRxGzWSR6
	4JtaA1kbHeEj7PKX179JB865ge8thWxDRxZgp/ElDdUm1kt5dm9efT1b/Jcq/qLc
	6ZoHZehzUIbVVAhFv3qZ0gR4MuEhSlzR7XDbZIswJK7UAg464+jqY1+GzxgdkjhE
	rIbMb8qz0WZ1Xp/iEVUMyVemJvEeaPiXj3qMOXxlCNERXNx2H/vW0ffuEDcwlVxQ
	2dy2nIK152o0/93BKQ/iC73fWa+UBQ325sxGA/wSPsmroH5w2bYy8y8qm5fouvi4
	CIQDfP3NUMV6JFaz35FRZaT52I+ft09u5d9jgsNYvleS1FxD+I6vtEhu7qEm8xdF
	ztYwNA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjfp4ba79-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 22:07:39 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6fed0652bso60738705ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 15:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788905259; x=1789510059; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sDx0rDDViSXpY0EaEWg4SGxVXchArhRyGAl+I6Mor5M=;
        b=F6mhynemJe3s0OyMLce4ld6HYUgGDiAwldbPseGZwPzHl+biflT+Y9KpvKM3iZDE5l
         9AIa2eTsaWjbciJtomOzdna0vRYfyuarnkNEDLXbBEu7gtM4kfblheY+v8vlOCMYf4gw
         equg7BQzt4wIKBXU1ZoyNXmZ0K2pPpZaCdBD6fCpkSyyGOqamkUmISmCI4JOB4GB34Rm
         vzVlZUdJslwPx58km2YVTDG+WgJxGXsgFKXXEN7hsnILXi7YF2cQuQ7Dzk/uA86oZ+RY
         mK7bVL3d5H2Xytoqh3mckBpu4RQwbFYJRhPOXpXT8sO9rlbqPpQsDkptENhxUW2EK18K
         gH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788905259; x=1789510059;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sDx0rDDViSXpY0EaEWg4SGxVXchArhRyGAl+I6Mor5M=;
        b=fXOy8Klfon7w/0TblItiVhTqzEQfRb+GVLPRTn5rDqP0WYqoa4BO5NNEXFdycGBZtT
         SvZ2YMuK16RDLnK21v3ggQxF9eLUVUisGCdPHa/RSxk92ATKevr3Dggk+odKU1jfrLwD
         hF8jQitCtCDBbTvUDryD9apKYY6rZMOjFFHOpASJcnBYltMGiXCYPsV/PjawB10gglRP
         QoPJios8uruzFHeTKYptfDSwIp9m7xcZYEbkQn5LhHWpu0kOyVE3jWGuOJzuLK+IQ/JI
         V/Owckf0R5jEnhcVF6FTHIKY3DmBvZcnMdNrxiWeTbgSPS7ZSu1LyEFacSpDjD4BCLKn
         DbRA==
X-Forwarded-Encrypted: i=1; AKwUvByo2NlgKG4mMhHiicAri1ENJtHgNEqiJDHTnbQeDsaLoPBEQevLARLR1BV1oulIthjk/VuQFKhrxYLddbZWKA==@vger.kernel.org
X-Gm-Message-State: AFuF++laxmlJnSmfnVxnJ+2mBtIFKzN7A6pQAR0rFNBetrPZ2wtRADjh
	EJvAKwE5DYzPcFLHdMDLezYvVgq9hP620LYXh6RYGUxXbHj/OfiL5LKmlLvljdwYxPhI5DsQyOp
	v6SsKNvNcKUSzjSUwfI9fjyheK4AF1KKxvpwVC+c61GFAn/DTB5kkVKno2jVJedORRmJ6Gg==
X-Gm-Gg: AYBFou3ovq9Te57pGktoTB4StE8GffNXfVCDCTEWT2SnKEga8x2sSU+aAHcHeAwin9P
	2P8eg3giQUk4HPIKibWOfX81joXZ7Gjg0dgFp7wOWkYbb0w+fWwkWsfZlQn2phJZUn5Yy/Av86e
	i354YioZyDFJ+aUv96FzH9Cb3dU6ECKkqxyTJxP59WLO3jWHRQ06QcM+3OKMC9q4FlJFynyo2Vy
	0jtb/kDJyCTtciK4VaI+/fZ5xZpmT+/nktKDSvjqs4IO1JDG4kXqOY7YASL8rXy1kfcp4U9jplb
	qNRffQKe1lySJS9JzUWdATz9N9yZXPK6YK930mffI7TLRemxoAChCwWaWUiqnx25wwOpkFmZqLe
	ei5XA/mJ2H00ljBXUEoPMPEzsJnTu+lU1C23LgHM4N7AHlUhLFdCy2XI=
X-Received: by 2002:a17:90a:51e6:b0:39b:4877:ae90 with SMTP id 98e67ed59e1d1-39b4877aeb8mr21450806a91.22.1788905258596;
        Tue, 08 Sep 2026 15:07:38 -0700 (PDT)
X-Received: by 2002:a17:90a:51e6:b0:39b:4877:ae90 with SMTP id 98e67ed59e1d1-39b4877aeb8mr21450759a91.22.1788905257890;
        Tue, 08 Sep 2026 15:07:37 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm46411813c88.5.2026.09.08.15.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:07:37 -0700 (PDT)
Message-ID: <e7a1a2da-bcd9-4510-8c26-c049064d68eb@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 15:07:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: preserve PPDU state across monitor
 status buffers
To: Tamizh Raja <tamizh.raja@oss.qualcomm.com>,
        Kang Yang <kang.yang@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
 <CABkEBKYdFcUfMGj1pGmVYrdLQTO0eExq8Z+vMdjYGN+yjQ2uFg@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CABkEBKYdFcUfMGj1pGmVYrdLQTO0eExq8Z+vMdjYGN+yjQ2uFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Qu9uG1yd c=1 sm=1 tr=0 ts=6aa0872b cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=_6vQ7MnOLTxtXatyMLIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: JP1tSP6FoWv8RyJosf7GXskiZe5EYAqC
X-Proofpoint-GUID: JP1tSP6FoWv8RyJosf7GXskiZe5EYAqC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDI0MiBTYWx0ZWRfX2HA4IPKm/9B8
 l6r60J5sxjXwERLlhLkagKsHffIfWDLnEvj8t1e/bcYZfdTOg9jmWxRXpLhgURvkHa6JAbl01Oh
 DdMJDmtJJ+jZAuNuxPNfRV7zy0NE2d3WSkI2R+09/UWrGQY91wWcxPXcidKgtDyMXQPIGiBsiBh
 eozvFmx6Q+my1OTImYrxiO50QB7OXJakgcfXEQ23SHoofl4skAmtpLp4LasC5r69HA410Nz9rjv
 uduLYveUaT62gv3kaWWKCgLz291IUmY/A1AfnnjLWmUIu9pW6h/8rCPZz42pg/AM8EEgOOFWTIv
 oMHwx+umRZcrEE3E2lsKud7XuSnG6z0iMm5M8mq3VwoLYbo91ZqvFSGqASNoqvxSSPCTrPNEni/
 wUTTP2PnsMesExm5zbJ/C7LJzqH9NhtnGP1usAbhRJG30LrozrQh1qT+KbR5Rcbkt6nXJTe+hlf
 N9vpeEAFc6V4HNUyg6Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDI0MiBTYWx0ZWRfXzkMGtCcxz80A
 EeX8akxwr8cfcJg4juXHe7n9vFnKA1GFyPAeATzVvXgDxCLEqYgrGG5RkvyuVVG43oO6DY9C04B
 SkUO9bPB7p4VtOt8zVr9NKKpq0B8YSY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080242

On 8/30/2026 10:53 PM, Tamizh Raja wrote:
> On Fri, Aug 28, 2026 at 12:26 PM Kang Yang <kang.yang@oss.qualcomm.com> wrote:
>> -               if (ar->monitor_started &&
>> -                   pmon->mon_ppdu_status == DP_PPDU_STATUS_START &&
>> -                   hal_status == HAL_TLV_STATUS_PPDU_DONE) {
>> -                       rx_mon_stats->status_ppdu_done++;
>> -                       pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
>> -                       ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id, *budget, napi);
>> -                       pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
>> +               if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
> Consider HAL_RX_MON_STATUS_PPDU_DONE instead of
> HAL_TLV_STATUS_PPDU_DONE to match the declared return type of
> ath12k_wifi7_dp_mon_parse_rx_dest().
> This is a preexisting inconsistency, but it is good to clean it up

Let's clean this up with a separate patch


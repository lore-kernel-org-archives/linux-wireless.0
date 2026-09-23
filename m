Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F33851C327
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790196356; cv=none; b=dVQGFar5KThhSECieyix4xz39+5ZlLI4XDgTaVFzUoKrvdLBHWilaKIHvoA2ZwpFh6td5A53qQ4gMxD6nsxPSv/1kDkFoQOQ1SoSas/rYJ31CghMQGwuxL/XB/ZG5S9kK0hj05Xl+zwYegN2dssnhS3Gkot5BCOsQBuEWhmUoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790196356; c=relaxed/simple;
	bh=qRmfiSrCXLvpxs2JuT70jmASNnzq2Bj7/yemkKRjlqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfG/hHcJoSE0EyQv5s0hIEICZkr2bQNmRhTcuwtiXt+dbgrMXCgAVwCX/Ld5bwUUCOQfyBocy8TX+UYuOlDGdHc8tkwx6EYlxNZPD0TpKxm5KYjgtNR9XQSwFVJ5TWPmVMJBs4XYO/xR/291GWrMH6SE3F3BU7CTxbJPnP3FBfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qjq9375t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TwEIJfMr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qjq9375t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TwEIJfMr"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NJkkNw174560
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3Tutc0NA5XTcWaNPOzmZQGJ2sl+cDnPgadEfH3Im0nE=; b=Qjq9375tWyx1Azbw
	pU7nAiRp64qGgqWV/dF0paH4QDVPMhpy6LlVbXNHuWulmKxVPnmQAczVmvy4O3ZW
	R5Ysm/A46KGAJy8hcre18XqkK74J0Lti77PTQCsaPbFadKYHGEaso74fcakI7tAw
	6clam6mkIV2YoJhIqCYoeHEqNbz5C9i5Nr9gVwjD4PSRk7jarvzybt8DMjo836Fg
	PkWSQ6QFR7CePx/wqjadkWXqZ+CCFiEJw+nund31xllW3eZiY8F6JelTx0VxjsLy
	2T4mDERgjh1pi6+hUTZddVfTlHeDNzERre0NdqPOK6sE+D7Iacd4EAKwYMoY2N4P
	3AkBDA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvbwmawe3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:45:50 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-331b2ec616fso781778eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790196350; x=1790801150; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Tutc0NA5XTcWaNPOzmZQGJ2sl+cDnPgadEfH3Im0nE=;
        b=TwEIJfMrTzrehjwPUnHvdK/2s44M1xIIfSNq8dAuCp2X81wXc3CMbM421CnD8x1yXB
         cxqI2NOwCb1J864gcExLCo2fn+z2aSwi2Bcb219pTIx6uQd9T2NKhBG4XW0W8Ozd8lh7
         vuNVbUNfiNsQg5uYBeB7KAhE2u49cDS8XDRBzI5+oH0mh/e+uuSCyZhtSkCjvzHZAj1A
         EZdb3rdmwGikSqoxPJvXJd/NjTT5lwSlL+rCLqY3R3W2/j6A6GUv+HcsP0h3vpVO3LDY
         Hp398qq9xWmXGQMoldJqX5Om93wJO1eQUYV37+zPwLMK01B8wv6r8Hpf5S9MY7jHBUC5
         CYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790196350; x=1790801150;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Tutc0NA5XTcWaNPOzmZQGJ2sl+cDnPgadEfH3Im0nE=;
        b=h98HCFErvz7h5GkHdiazf0zjnoW7KEOyh6VwstGKUGm2uqg8z2LYM8RsH4r5Za22Ua
         DrKeZB0ZXVMj2x3hs4nCnNlE9NoFUj28K/WFI5o5NIaVWrlDUwzLg2U6ncp7g21vcBfa
         z/tNncKQ+vdvQfiPETrQV0bQ0d0lGCYy8S2nYKQLGofa/A0te/R7ldhIr8tYseNADmEY
         jvWISfBGoAr6C5vAPQ5YuwPGJ5fdC3RRnckopctJwybhEUd9scueBGOA8L9dATBC+4e9
         alMKROn64k3hpeAfBdprUEdsFDVFpVpC76cAqmdxxJ7MVita3/i3NXLkPrax1aksLkOM
         5g2w==
X-Gm-Message-State: AFuF++nRJhKt9sudaVHnPSUDDJC49CAHHw7dLkdSs5YJhAH1XhLg7++q
	t7zq+IniiBnR1+QINcD0CUT0cFtlieUECs2oWEEbXeYvymKf2t38/OmjK1hULIwudAkdaEsZt16
	OxKJgJjUKx8KJmNOcN1+d9m09UccaWkUMC/nCoCGlfP5n9/op+wQlM9xjHmrgMbhhEiwvlQ==
X-Gm-Gg: AYBFou1QD/AIK2wJOyj7FYyi3Ec2Vp8fw6bKz2eH5Ev8IP48YjQdAGKiq19A/OLOGq5
	UxnWoLyW1UelOH0AqA1h0gSgVJvqr2Q7oKyQOVc+2O3A/z/me0P0aVmiIlOo+E/WVWZf29Lj0+1
	S4VGC6nNii68I+XpA1lZVg/yDtRt6esg6Td3UAvlRtAInVsNmfrHFrPxRTNCxsfNL5VN0Y0FEgY
	TfTigljEr8BUHQfP5bRBjjcjpoX34zWycTWzXCBpQOJYtTJdoutpI2430ORl1xzGnjSDac51CoT
	AAUUQRAqJPdTr0yZuEIqe6Lbq4b23IoZsOBCTjgRCCH7VXYtZ1dGKCfMhvVnVYFs/i7dASp1oFS
	MIp+8KWFySXELwxtHsPSYVW8I7WcN+Yv3JvfeL2ovoK191YQLhdqW1lzJIw==
X-Received: by 2002:a05:7300:f588:b0:33b:ae91:1e62 with SMTP id 5a478bee46e88-3400459996bmr221971eec.41.1790196349738;
        Wed, 23 Sep 2026 13:45:49 -0700 (PDT)
X-Received: by 2002:a05:7300:f588:b0:33b:ae91:1e62 with SMTP id 5a478bee46e88-3400459996bmr221954eec.41.1790196349075;
        Wed, 23 Sep 2026 13:45:49 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96e498f0sm7469110eec.27.2026.09.23.13.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 13:45:48 -0700 (PDT)
Message-ID: <8340ba71-cc37-4dbe-a82a-b88d27c0703c@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 13:45:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: Aishwarya R <aishwarya.r@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA4MiBTYWx0ZWRfXxyhLlduBXosI
 v3aKgo4uDGyS3RD/lnX6SCD9Tlu727LHgCwTlnCUeWL6KPQnJp4CAHETi5o54WWitIEwVYVRKi3
 6SeMtuzlGFNE3gR1QPv/jV9tjSLMNUQ=
X-Authority-Analysis: v=2.4 cv=R/6WitRX c=1 sm=1 tr=0 ts=6ab43a7e cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bDFmln8m-5B1oVUy_N0A:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: 4uNARq6VTOC91PxCUaP5HSQp-AVWQxQg
X-Proofpoint-ORIG-GUID: 4uNARq6VTOC91PxCUaP5HSQp-AVWQxQg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA4MiBTYWx0ZWRfX9C4UJ0/4Mm1b
 az5lwRMXWwbreH5Xtdnd2QmpojvQ4sZwXH+H6Gn/gRFeJzb3AsakUviRCXMF0QDPZkCF2QyREGd
 tBnvUXfXvF93Zt0aqq/PDszMV/QpR85oaAXAuNHoWxZ6B3wNWdOxW6BOYAXwiecvhJLU7zF5+Gm
 cokuUvEX2Ya1qlecqV42ahypnJhidAousVijzlQFTF06+0+BYmolY9+ip3eVTqGvoLCr4azE6gv
 hLO/gmag7waaPSd0dqq4OaZaxKAvCtYAeQuXypPrWJ7SRAzaPny3vfB6VSoWzvnxEwT2JtHPHUh
 YVs83u1O2H1foGdvRnpVCpXqnDONIMrItHyU72HDYO4WLqmNtHSZdkSSPlKggKNKWKuQa6O7YI2
 98Rf0UdxXxatfua2Rn4uXe2urlgPeVVXOx/3PEmPXIftVauUuLCu7foSklFK95VJqGwOKURp+C0
 n1JxajZKRjh5cuIj8qg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230082

On 9/1/2026 1:56 AM, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
>   * Store the station pointer only in ath12k_dp_peer.
>   * Store authorization state only in ath12k_sta.
> 
> Doing so eliminates duplicated state, reduces bookkeeping required when
> the state changes, and makes the ownership model clearer.
> 
> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
> updates users to retrieve it through ath12k_dp_peer.
> 
> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
> updates authorization handling accordingly.
> 
> Aishwarya R (2):
>   wifi: ath12k: store station pointer only in dp_peer
>   wifi: ath12k: move is_authorized flag to ath12k_sta
> 
>  drivers/net/wireless/ath/ath12k/core.h        |  2 +
>  drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
>  drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
>  drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
>  drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
>  drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
>  drivers/net/wireless/ath/ath12k/peer.c        |  2 -
>  .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
>  drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
>  10 files changed, 36 insertions(+), 84 deletions(-)
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

This series no longer applies, can you please rebase?
If the conflict resolution is trivial make sure to carry forward the
Reviewed-by tags.

Applying: wifi: ath12k: store station pointer only in dp_peer
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath12k/dp_rx.c
M       drivers/net/wireless/ath/ath12k/mac.c
M       drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
M       drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
M       drivers/net/wireless/ath/ath12k/wmi.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath12k/wmi.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath12k/wmi.c
Auto-merging drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
Auto-merging drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
Auto-merging drivers/net/wireless/ath/ath12k/mac.c
Auto-merging drivers/net/wireless/ath/ath12k/dp_rx.c
Recorded preimage for 'drivers/net/wireless/ath/ath12k/wmi.c'
error: Failed to merge in the changes.
Patch failed at 0001 wifi: ath12k: store station pointer only in dp_peer




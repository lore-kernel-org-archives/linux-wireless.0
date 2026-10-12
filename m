Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68527CA4E
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784198; cv=none; b=MfeJJ/lwsm+YWfy4jEQOKSQR+FmXQ/6HePfPTNOIHnsjwoUVWEIn7fkzHJ12XUMBAL318+IX3isLwsYPnLWyc4xHqFJwR6hhtlwjctJTbBknYIbE+twV6S9bKurf+cHt03+4pM2p2ZbVnR/UxmiLOTyiUJE6ZCDy0GwN1c9f4Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784198; c=relaxed/simple;
	bh=cEejnuTxNoYUAGMwNf0H3DF/Refb8wM9pJqbSHSjCjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=riXNaXE5rMv8WvLioK6wowrhJasbbigvuymqPVGGRBfrDSQLgovfAqyueB/EHzYXLtfrNV5R78EYO8I30xvD8u3IX1e/adNJXVHG/JiLwRykEHAbl8gbqdEF3GYxImnY6nfrtez87Ybboh/Ta0wT01adWvi8fJ4t+S7lRZ3bV5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KNwi3vaF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A7lnuLYn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KNwi3vaF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A7lnuLYn"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C55Xmh2436428
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1pPPLwjmVufFsK6SDXsEs5dgYISVMn+cFpVZ28+JrPU=; b=KNwi3vaFD3SQfj1a
	o/nqZfjagrL2NX5VhMo6lbcNEGaP8yTkgyerpQb8sm9IehuBoL9qMJszqbmSLie4
	WhsJezbS3i+1n6ZP0PZJ4JJ6PXwlfC3zlRI2R9xLxV5oyXWs+7+wsrgGpWsUXQzI
	FIJxeI0pQFnYhJsOAyhiHcTDVTzrl6qjOsLVXAsOniQlmH0M1C7SbrBMOVxpPJR9
	6phyiEj3tRjf0RBL1Y/ADtZGScd49q+j8PPGeLev6X8zDf6Jtor1nzD68fAgKpuw
	PR5efBLge/4Tx+OUg8p9vclBerTopImzHXtkLLpbiuVpJfRHVJtYv0ZuEmfSmFCO
	ZTWlJg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7b2fd8w2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:49:56 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e818ca61bfso15133475ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791784196; x=1792388996; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1pPPLwjmVufFsK6SDXsEs5dgYISVMn+cFpVZ28+JrPU=;
        b=A7lnuLYnzlm2vS2XKUT/7tZFEzSMfpN0TfEemGEfYrHR86ZtBGI5Mr+JjBjWEdJGrH
         3qRBFEpn/hbwpmB+Yg8heIwYSwjJU/mthfQYdUuVaV5pPf+RFvU5jAQfwD28plFioEDa
         MhqEjSIaSwc2cdq7Tz+u2WSHYMbUX/3yFxqsWpEmz2DUKZTGd92+ueIsiv74zB+xOGYz
         UdvgATUNEMVtGLiDUX+J5iRtmzCbKiiSInr4WrvbZUAaLE+KoJc2GIEs5k0FTfj8OfxJ
         gBJx9qr3WWWIjknX2YlQigFAxnlvDA42a5rZIvVDigx62lUHjAFloIhsyQC7TvubgJdg
         2QxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791784196; x=1792388996;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1pPPLwjmVufFsK6SDXsEs5dgYISVMn+cFpVZ28+JrPU=;
        b=s2bELg6wh172qgePmS3wDWNX4S+Krf/ypSSr009C8VI0IbFnVQ4FkECXxjDaGaP9FN
         3e8rIo9y5gvjELIEBTXm1p6x5cmEsr4AVuUEQ6MbiZPBRpCyh3neH+bNKgQDmvd0RcpX
         E3sswFTl2Fd61o80wDQGlcNPAP4/L50YWq7fhzaOW/JCAuIkLLSVkzVS7kLWa+JaSUHL
         T0IuSCjkZj4ky7B8vdnIl2e2zlZnBCmpbbIf145VHLSh0x5OFOjYwd266V+lUNJhClZq
         H0T6NlIDOJr7rQt9WpzzC8lXcR9Q14Jcqrs2BILNbdgAaBnagyJGaS+2GW6cTkHPIA/Q
         ZTxg==
X-Forwarded-Encrypted: i=1; AKwUvBzKXr/BR80StoEkoU69TUBWxQJEPOBDMVzCeeKQc6yaRPQ89HEnF1gSUs5uEpzGnHh5jlOHCaJNuRTQMBLr3g==@vger.kernel.org
X-Gm-Message-State: AFq9FYJCcSIJI06v8zmN9upB8fDD0rQzEfSIqTLygtKpR9YEQ40a3GvW
	5ZK3SqJs8/yvwUnB0CoFwnJA1ZnWMo7Hd+G+12kOtRD/G6vjN7Sws2EhwAxzctZPpVsmeiUlEqG
	O9p2PIK4ILkLgEsRqj76QiAf3hEmpCY8p7/mGleQLgbGUO0RKP6510wGunqAbA/gS/EWF9w==
X-Gm-Gg: AYBFou2MnfrUE0J+apW2/2Dvp3AxipBB+vUjsauoOnw5v0GObK8DyuGpsTzBmM3+lfx
	CCYuk5vEhwynK8QxAIM+IUEx4LXqiN82mqm38e+ggpP3QnoZOnJFCVA1OTRCCjOK0Si9I29/5o2
	LvTD2aPsfeWtKZ0OWLKDsWZX8g9oMvW1B4peieYkSbhc284ZysmbiDmBmtbHDLZnceaBXG7EbEn
	mft5ooN/ginG/aw5/Bhfx/Uw7QtpZSz6Ty74+JEoJDSA33hWYEvMzzLUNHRhuPNJcccBj2WKvsW
	/A+M0lz8CHEc5sLRkj7rwghlE1RpfLj0t1H3clKEV1tgZplex9GXgkWKr8NiZoQwaaUbGWb7+F4
	3RfnxxHdG6oXF21w6UgqiZ1mJ0/nUA20=
X-Received: by 2002:a17:903:244e:b0:2e5:d33a:88dc with SMTP id d9443c01a7336-2e842aadef1mr75953195ad.17.1791784195768;
        Sun, 11 Oct 2026 22:49:55 -0700 (PDT)
X-Received: by 2002:a17:903:244e:b0:2e5:d33a:88dc with SMTP id d9443c01a7336-2e842aadef1mr75953085ad.17.1791784195337;
        Sun, 11 Oct 2026 22:49:55 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e4cf3sm37758925ad.72.2026.10.11.22.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 22:49:54 -0700 (PDT)
Message-ID: <8ec100c6-e8c9-45a1-9bc8-e4cef580af86@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 13:49:50 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] wifi: ath12k: avoid IDR mutation during vif mgmt
 TX cleanup
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20261003092104.520135-1-yaojiale02@163.com>
 <20261003092104.520135-6-yaojiale02@163.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261003092104.520135-6-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyMyBTYWx0ZWRfX/HFWI3Wd4xV+
 YGKBe+qBYLV2mYeAkDnmGQd6e7muQdroRT4XjU4pekd6KBEsZ7To4Tyda+aAagbm2yjFKbu4Kdg
 MmXYH4m+0BZ3Nu4ft2msOkBZjhW6QGo=
X-Proofpoint-GUID: TYlzapwAY1EBHywk7Rw3ygcutJ9nPcBH
X-Authority-Analysis: v=2.4 cv=NddzRGD4 c=1 sm=1 tr=0 ts=6acc7504 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=Byx-y9mGAAAA:8 a=YGf98eWBf9nrUm2w2I4A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyMyBTYWx0ZWRfX24+LuQ7tzjgq
 9NPP4LYrQjr8KS3Zye9yzTt3zE8iA/Jwm41qT6s0KkXCJ97a3icfc55mgZngNE/MPOC7xmJEx4/
 j64cEJECPUMSssVVg8jWdRx+tsgcOGe9cODnMTl/yHoRVx6A6JsL1upglM04oLrCelcqpyuNqqB
 x3Y+U6Xho5dl83bdJ+9bKR1wsfJRt2SsnX+RSZZtYu9whvwqJg1CThTY0NUpFg0WTnOn8tfdvEA
 5uYWcutHZYcYA+BV3jY4S3XwuuYzTicJ5UjdaAxe+p3rA2vgNfaDUYKpqYJBDq18wOqUiLe73x+
 qnizkl6WXLVlfABi9DLYpdloLfjNJzRtMGAJPfhQmGhNfi0ZM3EL/mi3QreuCVdjI1Q4FuJpaw/
 L+DcBsS2TgyfD+nlYQ+PuViYpjU29FO3brE7hlcKf6WlzjtOO9Wfv+sBGBCg0s7j67+CfawpjF9
 S5192OFBUiiKdx7hudA==
X-Proofpoint-ORIG-GUID: TYlzapwAY1EBHywk7Rw3ygcutJ9nPcBH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120023



On 10/3/2026 5:21 PM, Jiale Yao wrote:
> ath12k_mac_vdev_delete() walks txmgmt_idr with idr_for_each(), and its
> callback removes each entry belonging to the interface. Removing the
> current entry can invalidate the radix-tree iterator retained by
> idr_for_each().
> 
> Move the walk into a helper that uses idr_for_each_entry(). It performs a
> fresh lookup for every iteration, so each matching entry can be removed
> through the locked removal helper without retaining iterator state across
> the removal.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index c0acb92b7320..108ace48cc97 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -9196,16 +9196,18 @@ void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar)
>  		ath12k_mac_tx_mgmt_free(ar, buf_id);
>  }
>  
> -static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
> +static void ath12k_mac_vif_txmgmt_cleanup(struct ath12k *ar,
> +					  struct ieee80211_vif *vif)
>  {
> -	struct ieee80211_vif *vif = ctx;
> -	struct ath12k_skb_cb *skb_cb = ATH12K_SKB_CB(skb);
> -	struct ath12k *ar = skb_cb->ar;
> -
> -	if (skb_cb->vif == vif)
> -		ath12k_mac_tx_mgmt_free(ar, buf_id);
> +	struct ath12k_skb_cb *skb_cb;
> +	struct sk_buff *skb;
> +	int buf_id;
>  
> -	return 0;
> +	idr_for_each_entry(&ar->txmgmt_idr, skb, buf_id) {
> +		skb_cb = ATH12K_SKB_CB(skb);

this has the same UAF risk as Ramesh pointed in ath11k patch (patch 3/5).

> +		if (skb_cb->vif == vif)
> +			ath12k_mac_tx_mgmt_free(ar, buf_id);
> +	}
>  }
>  
>  static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_link_vif *arvif,
> @@ -10967,8 +10969,7 @@ static int ath12k_mac_vdev_delete(struct ath12k *ar, struct ath12k_link_vif *arv
>  	ath12k_peer_cleanup(ar, arvif->vdev_id);
>  	ath12k_ahvif_put_link_cache(ahvif, arvif->link_id);
>  
> -	idr_for_each(&ar->txmgmt_idr,
> -		     ath12k_mac_vif_txmgmt_idr_remove, vif);
> +	ath12k_mac_vif_txmgmt_cleanup(ar, vif);
>  
>  	ath12k_mac_vif_unref(ath12k_ab_to_dp(ab), vif);
>  


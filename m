Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742847;
	b=FC2DGgIEsAzCpzjDI/9pQ1yxfsdiD79vx6kS1/r+Zoea/ONitxOLdBefKqOG5OJZ8d+r
	 e2yEwGC258veTR+/LAnReQpr+hK6Y7Z1oN70hlDQ63Sdivba0aLZ0yozYYMBPFpNDPCZS
	 oQJz72sYr3NiIAVz0KicvYZb/BcBK1SLrL5YBMILD/IdM3Nffq2kn1/W3hLXJ/DUyK1X3
	 CN1fpR4lQgHsAc4Lw219BNUNSacqrVVRPrzIljP2cO6uKOdjRcPVfgsjWC3InSBwiOrLz
	 ktj+rGjFHu5Cs6GK7cpPHTK61ZqyYWY2F4oVM2ADSEVKTjG6K/H6IuHCmVWwtxgNadw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742847;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=J+FBnRhZ2QnMn481TMIHmuO1R3phrSYLbDfpoygi7QY=;
	b=x0w26A6qJtogc7cwMMNFBL+04+NlZPVp/VP7v23VasHgTwPx4qysHvWx02+c3DMFFx8P
	 K+wC/+WQJhWk5LfMMI8C1AIf7fc1tsDNWCpthK1oPW4FcoZHmvVoToPKb9Kr0O1y5HKux
	 Rj9PMr+z5P/xD6w6hVFRb/BJyE0NdNF6XjT1ODLiO+61Qo/DJpR54giw1nSqtAdyQgaTo
	 UzGjRj7nV+iMJ44w185FA6hMdc7e8JXbV8bnb3BjIgvIiMBUTMrSeY+CN/3PKs2H+LWIK
	 DlIfnnDe5glWbAVgjYskCZUs8/OdgtyniFIvFNW+FQ2ZucIHBu8ukDEszqt5BOfqOVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CATH69gT;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ODTwXAFA;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4676606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 08:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4676606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CATH69gT;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ODTwXAFA
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7F8nl3154070
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 08:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J+FBnRhZ2QnMn481TMIHmuO1R3phrSYLbDfpoygi7QY=; b=CATH69gT/UksPUqN
	NTGTiU0p9T0kjVHeh/RxszIcC3m7wT+wn+M2dS9EXBhb4tIBQdPRKZXcQH2rWUPn
	Y4XbHnvuButfWwj9G7KKuxTPQvGWywJrtiULVVARCBYaVQY2WoC+UQWiaaRrbfKN
	yWrHQ79ARxOjdl/PdFGLiiQfhHcRB9YnBrgaCfhuaAOJfxCblWLd14rJdFiWQM/H
	QPQ93ZEhJYn2/8I9MXDhfDnkT8VfVxoLAf000yaLAgAPjB5CpQc0FICbcBfJ3JNL
	JVYDPCtwmg+N9RbcsFg+PeT4i15HzadMV4L/sY7bYvq+YO3OLxvUpK+oHVHMnQjl
	h5bNkw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmramhc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 08:07:25 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd67e98f68fso871680a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792742845; x=1793347645; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J+FBnRhZ2QnMn481TMIHmuO1R3phrSYLbDfpoygi7QY=;
        b=ODTwXAFAnsFVfn/HhYttQf0vFtynqUtJxxk0fS8GgJJLvxA03V746cXaawZULHhHTU
         hxtPiek0KUdrnDp/lGXWNwX/+JNKthUCW2XTesEywPRCDga6DRyUx7tcvctl9rAOxwEi
         BUCHpqr1LW4jv6czUl1L/OvsaSjGJYHNyrtVOO/KlDRzaEBA+cFG/DuyF/8V/+xEo6mi
         7BZtjjd/1CtQ2GVyioffJEZhaun7GtWERLc6MuKxjdvRyoF+FbQDUDt4Gb8swh+iZMAA
         mTJRF4kyi7Zv30sgDLwzC5/1D95nV2QOzARXKMZL8h8Lp7Pg1FqoGms3zgEphWQ2qNCb
         H1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792742845; x=1793347645;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J+FBnRhZ2QnMn481TMIHmuO1R3phrSYLbDfpoygi7QY=;
        b=iUtEV632FCxEqvyyCCdfPu5DSyLL9+BWlG3rhcPa1XxinGdMD3ezqavKIKFcRRIlZN
         aPLOUaD3XHRFR92V49+Y71DyFVPixGdmnZNT8uaLF/DXhXtF8N1+kGKz7w3NS+GZfiJL
         OGxldYlyfdLeUoY3zGDZaitdiLQ0KaxXhvnKKzjFL6vs+B+hZej2TSA+y3qJ55RfMJyu
         yGvcD713KEb91Ds+c9yp7WnkCjt4tbJExsjV9PfX14tUnR9lgb4ivta6V7HWmur8oxCE
         7IAlJavrM2Hh6kT6lFbK0NB79bTXD/w50LWzD83By8UBAM+1zqBfeFHG0YmK/aSaTg4f
         Rvcg==
X-Forwarded-Encrypted: i=1; AKwUvBxtK+1/U30z5j87ORK+NjQ7kMZvlEExqzJ1BgQgktIcQNS0/t3TRtmZzTJu2poUNwuYjydIG8KNtAt9TtKOiw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLdh2gP8urGt+rdN2qZ0ZYYiri4L+V6Ujm8gm710GwLrcVPtL2i
	TKOQyjjtjvT2/9xPq+XMOqgiyK62fTpwzOPzP+ClXv0rJMhfC/40+S/GMhcD7T22bbRQ8wae0tk
	VenzlrjCL1e92rbUw5ECVF7mqSipuIQpmcGccWT4Zskyj6c/YUBVE0W6W6l+AF1CxRKBhKw==
X-Gm-Gg: AYBFou29iW6pgnXBr1qoXr0MyQ4XAe7U9Dwiq1Skkx9qsYjqkJVS4P1yayo18rNF3YY
	GlqsJ4apN2zMyEsiO4BJhj9DqZjBh6BhMhZqPoLiGtv6XMcIOUoUanc7AnTnSiISH8mJHTZCyfd
	QJQvs60+QPiXqiAWd25fEz6/LN2ZD6o64XIhN03tmlYChmYBoP2rGXk+xKezoO8K3Zi723xQaR3
	BYd2JkaCwjgX1gNxaLyGjP1fSB68qnZhK3KaIIXJPaPvn7Kld5Ap8BnbRDqdEpskgOvmqhnZjG+
	b77F8KM/yua/7OAoNk13t9N157Gp74MiU+q3BXKz3SZwIrkwDUdOTMk+Nw390zWgfyrq77tfDHd
	FO1SJjTMRpBFN/PGUA8B7mLSGmtStL6wG/2CcenLh0s8ebtnYFHG1aokFQQ+KYn983w3mydJOJQ
	==
X-Received: by 2002:a05:6300:86:b0:3e2:a849:64bc with SMTP id adf61e73a8af0-3e359a97d82mr1320409637.9.1792742845181;
        Fri, 23 Oct 2026 01:07:25 -0700 (PDT)
X-Received: by 2002:a05:6300:86:b0:3e2:a849:64bc with SMTP id adf61e73a8af0-3e359a97d82mr1320394637.9.1792742844735;
        Fri, 23 Oct 2026 01:07:24 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8e6678sm529974a12.30.2026.10.23.01.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 01:07:22 -0700 (PDT)
Message-ID: <41eff135-80fe-4820-b9c4-48705159a013@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 16:07:18 +0800
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
Subject: Re: [PATCH ath-current] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: TFtkmmbpxZ6-WpXnOWiegVFaUYPQvxNI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzMiBTYWx0ZWRfX0uKt8LJC+Esa
 O9HN01qIef0QHmNM4fmeUJUwTroM57ZTl1IWqlSz0ITqE5LdZNX6exUleaqoFUhytgDEotlRuIj
 4Bn3i+FeXV2JSptDWj0tR8xIGsoRCqw=
X-Authority-Analysis: v=2.4 cv=VNZIDNPX c=1 sm=1 tr=0 ts=6adb15bd cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=l5KLu2utXcWZLmDjM0UA:9 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzMiBTYWx0ZWRfX5cskHt/9QcSg
 kzWs5VYrmdT4+4Om30jmYM7KzijtLpW5MIAiBRDTDHi/s8pn3WwZJiB4BhEB3QJMVmlLzaRCqRn
 IrrCEL9gUBPn50JmYrC+6EPVL/HaIOmTFGsiDGryNzZpp7j/GIN5zdumfZeMIHbSOVyoEyiLCUX
 DttDqOG0hZiDgqw0GGKuwfgabhLLigl7snXdVdJRNbQ33e1melsApRtSFb470K4uNkKF6Kf0enQ
 a72aKzBA7ItRavCuEUAbUKM6KC7S7wC+l2jmLZYW2tY3pmEIG4J+MtFQ3c/hQ9XHJIs5Wu0B3h9
 mH5gNc63F26CTnPd27qT+nCVcXB6eW1wn4Z5G0Y6z0OMrgOO7281UcNwoDRMH00d7NZmIaIhRng
 sgLHpOu7uwzi0W0m8lJ6m/RROncbGViRSqTJguSspDALr74pz5C3wldbLFoOw13m3tHncUAvfh0
 72TZ9GFS4c5OrO+0KWg==
X-Proofpoint-ORIG-GUID: TFtkmmbpxZ6-WpXnOWiegVFaUYPQvxNI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230032

On 10/17/2026 5:16 PM, Lorenzo Bianconi wrote:

> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -149,6 +149,7 @@ struct ath12k_skb_rxcb {
>  	u8 tid;
>  	u16 peer_id;
>  	bool is_end_of_ppdu;
> +	bool reinjected;

rxcb->is_frag already identifies a reinjected frame, can we use it instead?


> diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c
b/drivers/net/wireless/ath/ath12k/dp_rx.c
> index 8fa0e90b4531..0003cc5a3720 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
> @@ -138,6 +138,7 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
>  		if (!rx_desc)
>  			goto fail_dma_unmap;
>
> +		ATH12K_SKB_RXCB(skb)->reinjected = false;

These skbs come straight from dev_alloc_skb(), which clears CB area inside, so this is not
required. But for readability purpose I have no objection to keep it.

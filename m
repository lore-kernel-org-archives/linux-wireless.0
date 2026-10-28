Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199712;
	b=hKQMkb5dpEkR7+O35YbaVi09vNNKDf54GxHmjSoP3FF2vCaoW7/5+/vEqaEw4PTWRd8e
	 O/ic8uK9SDl+SoVo/a8+zilebBxvxIk3NZZmW+nqPKXH8ZPGdrkUQ2KYnu6Zor6tbAHtA
	 UUWTbbPsoXfDZZpBErUf7ZmKRe+q1O64ZyFCwyM+GRY86FKRh2M9wprqdcFIMBAvTAxun
	 0jaQYOHZbFrYptoSpKhlY4XY8Q2ze/WX3JrwhG1bM9YmmyeODV19rGAcKcqKHH3jENfix
	 sgubAGkPp4akqDlX9Hu5i2dVTYe7rhyrTEAjZNv2POxZZglwwH9iiWaKxZYSccsUKwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199712;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mVhCdDkhAXJ5S102mixnITdimIHOTHoGKH57O2P0pYk=;
	b=w3mkipVP2rnV0gOiikzmo4x+iwyYOK3nZwq0hIyq2VV3hsozxSoMBWjPMsPV6dLWUODe
	 2LT2MNaQl/XrYqGM3RgEJNFq4IEmHFoePMxXVMQL5/cURCR8HFb39UTIxc5tOSSxel6v+
	 +1+2KyA40y8PG5gh3aE2a1U2yySOHm9PGa34jUL4rNj6J+oWx6c7GZ8KoLWaTBI7kVwun
	 iX+RboJtAlylsvb3PMzk1K5q799Yp5DIZ5I5bNPo7SJZ9aZ/hPfn4+rWl1syOwPYmcnG2
	 spFqI727HyO2GGuTKkLerSZ1eSrgEZf7TiAnrjiOP+RCU/P6EO03OeAmDqro+uCwM+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QzAcC31k;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cFYVlePU;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C1460A2600
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30C1460A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QzAcC31k;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cFYVlePU
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBeVba2083948
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mVhCdDkhAXJ5S102mixnITdimIHOTHoGKH57O2P0pYk=; b=QzAcC31ktlmC2cCS
	LDO9UhLMk1H9E+JsuvEJv90SGUuvR0kWdzBFd1N55Vb24qADIf7fO2YSfkhikI/n
	nxYoIzBAJ8kk/mBrOS7zHyz3FZQdaReG04rLsVn1rjqhuZtgP+5gnOgEmD+yqkHg
	oxq/5E6o7WSEf2GgW/vqS/Aiw2Hl6I9UKBOEgS7BawkO+4qzhtuu6ZauV8oXHuQJ
	2ImL7ZP/cVrLBQwYGAwanwzJOnRbK8qOFEFKpsABU5J+EbsrkUf27tNh+uY2XNPt
	h/seLmU0kxBFcJ/VbJmDkJVJkTsnDPrCW5Fynxag64BjuXE12UaCuQ97zXxXfJyj
	qbvvAA==
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjyjpvks2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:01:46 +0000 (GMT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-70eadc5b37fso1543865eaf.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 08:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793199705; x=1793804505; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mVhCdDkhAXJ5S102mixnITdimIHOTHoGKH57O2P0pYk=;
        b=cFYVlePUUG0vlSUH/eTDP8he+7x9TTxigLm1sVnTWlvKR2ScQE15TWonXtJF1o8Dmb
         Zu8OiFlytJKoArjQEeu3zrToRMcqQ88I/loLP/vmayhEGCN4siQtWk3MVJVcWSGo0KRB
         KrNnjAAjanETkEuSiuaJKQjlV96sm1dbFMiJ4GM+40MTMBW4pvmNZWNKkjEItoj8tK2B
         R5raFQ8AlsBraTRRSg01O3dVMycyQS5kAabUO7U6+2E0Ej/0zAdD6n5K0McEh0AUXwWJ
         Tl7AUEX/e6uoLw2XggpohAabb1GqTvMZKpU3PMdRgULMlCxfEIUNi7QVPZLLM1NYFpSt
         qrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793199705; x=1793804505;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mVhCdDkhAXJ5S102mixnITdimIHOTHoGKH57O2P0pYk=;
        b=iPAh6pKE4u0LKjPM2tSioS/c8A9+il3alo7WnO3mMsdayrCL5WqYegv9gOpybKVwZV
         Q8tONdILcZ3tL373xiF76JYUXQrIBiv91JRbLhTbMvGQkcSQfPp/RNIAMKby260YuOhb
         JrU1sFZJdmDUxlNCFGV+UgifRbe+zxaNJq6QRl9LJ0RK3oF6oj79mkN2spFGVl5dBy8v
         8kNbDk94UUeXUTwiWoNuhL91ogbSXRoxP1VirDMTAO20ugr7yrRhYSnXZaXgMaiXlDmC
         fvZWVBJmZf9nBu3l0IjJ21Zdz/Qup1b0MNAKZUZh4cjKdbeYp8VyDpAVaMtwV9E0cUkH
         aadQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2SWYM05QzoJVni8oGc9D1CXvlrIex+Rcic09m94HpyUm07OzAW09TFWlUvy6mT9Uw9h8MtwSPlg08MNET2A==@vger.kernel.org
X-Gm-Message-State: AFq9FYK8mTUNEBKQ9WXEcaI6SrfoMtn+WDPCd5b6G8kPxo47TovFgPaG
	rlhgIMTaXfSG3WEhzdByjh37THjjxQJc30xjpDzNYnSy/2D1JfMUOFRWonzLgk9EBGRQJIcMeh2
	yzTwXWSfBGBYLlLPvJ34vkTBI8v+w/XCjM5Ry3wkGSkX9qwowpOm8OoPk+vBT8Kfb7lyn7Q==
X-Gm-Gg: AYBFou3u+NGKODZkl4MYGdOAsx2PqiNXwd2Sah09h0Q96C8QLCMnF7SgGyNu6BOz+mW
	MtfQ6tj4mLyL5bT54HokpYF3slWzCu6Bbs2Tc1NWgZktwf6n6cBNQJm45A/6uk2lM+ef3sDAcLR
	/L/GSFjS+t+9pQErFcpuerdPvWfqswI9gFnBTo30/luwiWDkgKfO8ga2OQs3NXsv18X2rtoygFf
	zOgiiJ9UYZ3W0vTKTH+AQq2mAto1lzqMPXXJTWgyoUaglt5Ogo23WaXbAxbK8P4+JuYcanNzzME
	QQmHKjD+oc+PhYpto5nFGTDA1k9/c4N9qIod77XG19gLGjkUxWHK5WzHT7iFcc6v8wfES8LnBWJ
	EBAt8Izg/qzoHCgrtXTVbHImDsZVJ82SN3QIzRZnfmfecL1ITc+F5YscVFBPuwCBIlwr6lIZUMr
	3k1+tSmwrpayzOC1sMZPV/c7xA0bwx/D8JrQ==
X-Received: by 2002:a05:6820:a65e:20b0:6fd:4277:16e8 with SMTP id 006d021491bc7-713f01edbd4mr1002290eaf.80.1793199705259;
        Wed, 28 Oct 2026 08:01:45 -0700 (PDT)
X-Received: by 2002:a05:6820:a65e:20b0:6fd:4277:16e8 with SMTP id 006d021491bc7-713f01edbd4mr1002259eaf.80.1793199704670;
        Wed, 28 Oct 2026 08:01:44 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-7142d317adasm1606578eaf.14.2026.10.28.08.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 08:01:44 -0700 (PDT)
Message-ID: <d094dc46-760d-4ee5-9404-9fa73a16a6bf@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 08:01:40 -0700
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
Subject: Re: [PATCH 0/4] wifi: unwind failed interface setup and recovery
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Ming Yen Hsieh
 <mingyen.hsieh@mediatek.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20261028050337.127464-1-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261028050337.127464-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA1OSBTYWx0ZWRfX7vseKqvY4aJL
 Qv4YoaaePi1wUz+dOUTXuFWbDw60kqV68aUjBhK/Lq9QAnBn4L7bm1RkpVkpvytMjsvJlSapBHq
 8kjiBAO1FynfiMVKIZQoEXXNxjhkRduVoM7ymmIoXx7F9Qx1Q094Rp3hgz4QPKwa9HqpABn7pwJ
 O8Nsc37b5vBrhDlmKHhiGOEy7AoQ1mg2gWgiOkZ8mqQs5ZZQWoBJmeMt7imqpdJuvdgVProuxOM
 i3LqAQSURXpR8wf4sxOqfsqycmk2o9sKBpcQdgxUjL9pSvxwAxfcU8PNE/yK7UmmpNGehnh6q7e
 SxOJhLMKI1h30gnBXZwAb2Go0Ae45PE+BhYQH2ATHNEXBQPi1x9K9aOHeTtSzs/Fmc9sGqoCBY4
 x1ITkXyQksAFEEzLxstWB/WX7AcSM1LOy8D4JFl8XnRWTZH2Q5kiG0J+yNKTlao6pcrDBkwPMp1
 we6phOLmK5VMtnevOHA==
X-Proofpoint-ORIG-GUID: -BVErMAin3TC5PJS-ncy_JOPz7HBa_Ag
X-Proofpoint-GUID: -BVErMAin3TC5PJS-ncy_JOPz7HBa_Ag
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA1OSBTYWx0ZWRfX7CDHZP1UFwKm
 6W9NpOHsHK7hZKwrk+DcacAC44GbPJ1n73I/8MsexHpoFlcwy2zF7bm/kZKinJ1lTRN/luGW41m
 po+5LAJfQpzeWsCgmpR447gwWecQ8f8=
X-Authority-Analysis: v=2.4 cv=JodkP84C c=1 sm=1 tr=0 ts=6ae20e5a cx=c_pps
 a=wURt19dY5n+H4uQbQt9s7g==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=JmONO2TMLgSK87zk2EoA:9 a=QEXdDO2ut3YA:10 a=-UhsvdU3ccFDOXFxFb4l:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280059

On 10/27/2026 10:03 PM, Jiale Yao wrote:
> Several wireless interface setup and reset recovery paths publish host
> pointers or create firmware state before later operations which can fail.
> Their error paths either retain pointers to vifs that mac80211 will free
> or continue after firmware interface restoration has failed.
> 
> Clear the published ath10k and iwlwifi pointers on add failure. Check the
> mt7921 and mt7925 firmware restore results, remove partial state and stop
> configuring the affected interface. Each patch fixes an independent
> driver path and can be applied separately.
> 
> Jiale Yao (4):
>   wifi: ath10k: clear monitor interface after add failure
>   wifi: iwlwifi: mvm: clear P2P device pointer on add failure
>   wifi: mt76: mt7921: unwind interface restore failures
>   wifi: mt76: mt7925: unwind link restore failures
> 
>  drivers/net/wireless/ath/ath10k/mac.c         |  1 +
>  .../wireless/intel/iwlwifi/mvm/mld-mac80211.c |  5 +++-
>  .../net/wireless/mediatek/mt76/mt7921/mac.c   | 16 +++++++++---
>  .../net/wireless/mediatek/mt76/mt7925/mac.c   | 26 ++++++++++++++++---
>  4 files changed, 41 insertions(+), 7 deletions(-)
> 

You are sending patches that fall into 3 different maintainer trees in one series.

It is much easier for us maintainers if you split your patches by maintainer.

/jeff

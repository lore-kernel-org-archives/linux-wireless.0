Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793314572;
	b=D9gS26D+ZcIeWQSVeeLmW00Qaz2HNGJMjSQdgyln9TLLT70/QEZTbHgwpZxkULQZcoiH
	 FG+tBCtf0hzGhENVGPGu3rxvkRlmY8Jno6BliJgzQdnF+iaUTu2HZvxsTWsHehkoJmUdi
	 tZp93T+sBNauNZNLAsSJ8/6ongF7scPMoJWZridCiplYPSXDDfApw+/wIS7neR9lJVY7H
	 Y6bI6DQ+EkCt1qb77CTy4i245xgowo4ebZhfWjbpO+AS6GrCKHaFBOPZc17u9uh+gV+20
	 DT7xfwdQY+LV9DJPkTnR2TI7tiLBF03/WdaQHi9ei2sk0lWVLxp+yUoM0k4o/o1qyOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793314572;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=B9/NPh1A1fWAcPQ4t6Kg8NwfR41ZSnHrZ6bviMgN+IU=;
	b=LUU2O7z8AZSPsNGS7Y9sWNsSgubOP+DGBz9egNsSSwWgGh2c0x1QcO/PUZSekjke+dxK
	 eTN1fKrXCX/MbByzIWN++T/9AAo24fxkeZwwdg7KECA6zivEzvaFGz13SnXM02+2u+8VV
	 37G/p+AeQpcyGeKXo19/iV/hZi7m+9kb7f4DCyFQR3zyqPDAI/xFvM95jeFkOZrSlPzVp
	 1NRfYnTmqj2PMmvLaNH6ZPtGjrzxSemqUWs124CPDF+vJb0bp+gMrCycihL5yo3hv5EBf
	 U3nKuijnNI8X9Supnat8uQqIXj4g9K/29WFzGFtwTzzzvtdRE89Ry5fNeBVF+L9Qksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a7t0Iq0M;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R8JZK2eR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527E3606A336
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 527E3606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=a7t0Iq0M;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R8JZK2eR
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TLaOot1891604
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B9/NPh1A1fWAcPQ4t6Kg8NwfR41ZSnHrZ6bviMgN+IU=; b=a7t0Iq0M0KPuZETp
	zeEi42ULnFdlMa2NRLNh2m6TDVKKxqYyp+MRNHEH9k+q0YU9XHv42iuTSsKXiaPu
	ptTjJRGK4hJwmCC2X3ks/keBOMclPrurC1UlHhVfl/epenH39L+zYhRHyFEOat0S
	SXLcKVhqJ8mVaAO9VxQgyXHFDYJam60YSahhG//nIKksNOW7M7ckKzijb0AlXOoX
	TxvcZkYjYwc0MhwiYT8Vi08c2s8x2B5rwHiVB8IrBWwajeTx2cIEcvfyNFX1BsZE
	nrjjC7/tHHEnRqbjdJWlu2wY8rVgekgdUnunPblzHtF7J+66x2eo5xvYmrpy9+RU
	PwfGsQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qg8ac-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:11 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33713e5e6daso200962eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793314570; x=1793919370; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B9/NPh1A1fWAcPQ4t6Kg8NwfR41ZSnHrZ6bviMgN+IU=;
        b=R8JZK2eR7i4D9BsXVF18eO2cv9TDmnZFXw2NnfLaddxKlS46G/Q2yIZ1SlwQXWchM4
         sf7joMGN1nkNZIyHH9UxE+rQw9hkrK46w/FEBfMDv0BzQfZMNpFgzilbmw2ZNN/e2qCi
         tWEcQSjl6+GBEjMlF1IaPevrpJPWTPX0KXit0ptC+UTvOwkCrgVdO7Ep8/YYdzDWp/+u
         uxwbYbms86XMvruTRkbZthxDRUkJ4y4nOYLjQTkSDLEDMn4JsRfpuIGyzo60zcyyr71B
         AxVM65O3abPWXGRGOl60VjxJsOrnh1i9AOLEUQZAKQMswi8MYGFq0C2Jrhsv9R+5cjyW
         hzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793314570; x=1793919370;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B9/NPh1A1fWAcPQ4t6Kg8NwfR41ZSnHrZ6bviMgN+IU=;
        b=w3afXigiceV15EqBbXhOZEViOAnPC+ZE/5R1MYJKV8/FDw50F2pTSn8Bn/iMMuRa43
         wozTBoEMMTCX2L3EuNSyFtJAASlBCYCYx+Kk7c/GXUZDBBbNPbzAvVBcBV8cUheABVJm
         oZ/G6GLLhITPhDN0CKMoz18miYba1tCpKtleA2VC8td7+Y21XD3V0eCQPk4aK+YFZ07A
         5Thu4KkcBDtk2Hx6r0ekzq/wQA1Pkx/gHi74oAELTsd0lkrHoVd7MAwJPLWWZoBIeIJf
         dfsR5iyF31ShxDSA83cEatPFWnd9sWvNLU+4pT4NJdR4fFRStJ5OI/PXVwUjeW4KXrpq
         zHdA==
X-Gm-Message-State: AFq9FYIZg1giH29CedwK8fwYwxKFCkREpYwDzAS+TxNQSfbJr4QJrsoY
	fIwl6vUNMWBq7IpSgtHeyRsQzrr3mFsY5Mv5WwgVzZKmNQmX7/tOoh1tzLr+AKd+oZweBecNMri
	w0dhnsidiSCivcMQUKHwe3PjyOIb8oux+zudPnu0Cw6sp607NgZ76og3Tk1bklTaOV0R+w7JjOU
	1Q5Q==
X-Gm-Gg: AYBFou2jyVBIAbFHK/PLGY1yoyaDzk2BE94tc3BsSLAv+zTrdAPRhVrnW7W9YiFCwqZ
	pWJqjuYFo6kKY4Quj6ZLVWsRpmEhJJ9QvGFalaF+o5igI4PL+As0ePw6jnHMV4Cx2iqiY4mUc3k
	ItvxGQCobYkcnkD8WSBY5SVrEY8neXQwkqtWD9F4at0DSQjIxbw1FOloPPmD3fAippR8Hgp7E19
	7xPdLyyOLvSrqd/62iKv7JhuJjuDvw6f1m1MdsJ4t714BS1AxYoCEEyHD+Rmj0MiGyzHbvRvx1F
	tFMuUku+g2cf8mINZD4qk0S1cQ4uReZSXFJnCzGX0I375SsXGgeyK86zeStTfluL4w2M+P4be67
	d3KwTgNs7AeSjr0BQXDpiix35dc+JcIvftSszfpVIGmTVjlcIW2pTGG7G2t0Bar8iFPuc990IQN
	rwzfd0ulTZcuasensMoKWmWqdX13yc
X-Received: by 2002:a05:693c:41dc:10b0:366:9f06:3c4c with SMTP id 5a478bee46e88-36a423f8794mr1088602eec.32.1793314569952;
        Thu, 29 Oct 2026 15:56:09 -0700 (PDT)
X-Received: by 2002:a05:693c:41dc:10b0:366:9f06:3c4c with SMTP id 5a478bee46e88-36a423f8794mr1088563eec.32.1793314569298;
        Thu, 29 Oct 2026 15:56:09 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm1644278eec.8.2026.10.29.15.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:56:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kang Yang <kang.yang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
References: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: set MSDU payload correctly
Message-Id: <179331456735.1083805.6096170574741429484.b4-ty@b4>
Date: Thu, 29 Oct 2026 15:56:07 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfX4jXvI1cmZOnG
 mwh5QWyhZBqvY/XorP2zH8Tzi1ZVmLKXgJipP3OCwTbHfIcDQ+wr7JPOoQ7H2FIOtGNv9+rKAi3
 fRQKr5at6JMG0ffd5kcLwqVvEuTk1cAGGfzv9kgJ2i0EYVFDw6ZgdLbAd1tGtmDWUS4SXjMUnyZ
 kDjiCuPgeH02FEk50Ks34SEm31GNLSgQ5OFYzwMp32ncNjdALEBey4s+yCzZUZClMbZMuMb1xzD
 7q5Mq0x6bs7A9kq9MBqcDFQoioU09KhkSS+0ROi9L4UOS7N6uA6QUK6prhEg42HPUdbzDNJRhy+
 JmlYVTrOkq9fflCdLsUwUwJA9tZoisQzQTCGQgqpcUKzcOqfLN2QU3BOfi/rmY8gIToleXxctqV
 19LXlBCy4qb7KHCuDrJox/GXUVa026INpH2qLYacYtudL+pzar4dg5mnErwyoTHQ8h7umg60Qxx
 k9ZipRlGzN6wlxUPF+A==
X-Proofpoint-ORIG-GUID: lPa7b6nKsAerptn-rTdY0L2iWQSYw9aZ
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae3cf0b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=grpZdo2CoZbIzhDbOCAA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfX+7CsiG13GJni
 n/8zDrkiIfD4uCVtPhN56BS4ad6JFnl2JENK5Ovcp+AYJnMv70OApMcmekMGjo5e0kE8eJZbHaC
 1lN3Gr5GH66NVtxv2E3O4qZdKcAyatE=
X-Proofpoint-GUID: lPa7b6nKsAerptn-rTdY0L2iWQSYw9aZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290090


On Tue, 20 Oct 2026 00:52:50 -0700, Kang Yang wrote:
> ath12k_dp_mon_rx_merg_msdus() mistakenly passes head_msdu to
> ath12k_dp_mon_rx_msdus_set_payload() while iterating over all MSDUs in
> the chain.
> 
> As a result, skb_pull() is applied repeatedly to the head MSDU, whereas
> the remaining MSDUs are never adjusted.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: set MSDU payload correctly
      commit: fe74d991f3387febfd57b65c7383d2d49e14e19a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>


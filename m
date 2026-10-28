Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198744;
	b=jLPKzfRHUoyJb8xhFB9AOgDS7st3ZCL8Lppdl/3VOAyEIWTE1S0+CZLMw/GDjBGT/N+r
	 +DbGaxa2dWeNRGsv5WXkQeDf6jBQ0zQnVRf7BREex94f6fF1oUvyEjRukYlsSHAalwL2B
	 mYqe5dwc+KO4xIxE/etUzRxuFhT9Hoj0WD9Ud+Kwuj+uYlNTv48H67BM/2GXB6os8S1rI
	 ngX4zh0HPTyWeffq9DGKroWromIxDtjYA0AF6ZVsKRvmqcz3NEjzgWLvpIblXPrtqe9DB
	 OX8zWPxi3NSiN2cBTrmWWBT9K+5Q+3IPrH5laxdPHDgEnVddCvu43ClEZ4sHER+4iQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198744;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=fyfglkoLZqY2aZVrTKhpOEDmOthsFifGeX7ssa0eblc=;
	b=qJ6yyPEGtfW3YeNu36elD4iJo0j9LS+QxMgpyNbg1Qb3B3pu3+v9e56BUyk5AdV8vMCb
	 ZNf0eKJyyJCmYtJVQY/+dJ0AXgrlrNOw0ivqFfAKMEMpBrzy4iJaN1ZoVYPd1750nI9eP
	 LQVCbZ23GI0HCQ0WzApDdFg/wIIC3Q//7ehyxBzi5mjms2IYalb4OeqMNVO3Gf2t1qAWO
	 pZGpIoFRxQToCmkeEgukYDHntfhuA+4Aa8o5jQtGGbw+JKgE+Hb6VLDVLCw3JIL5CwM1y
	 O8ynNfnhQXHZxMIoOROTVAaYb/t89/AgOKoojQXv+MJ0ky/Uf+L9JQkMOVvasSiZqYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=APAr7zfv;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Nnryk1qv;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB391606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB391606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=APAr7zfv;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Nnryk1qv
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBeAks1606934
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fyfglkoLZqY2aZVrTKhpOEDmOthsFifGeX7ssa0eblc=; b=APAr7zfvdOzwwt8u
	KcdGTMhRhSHHOQHPJOM6Zimc95yJAxLHQ5UIl3jtDesb8fHvDG6k3BKjqg+7n306
	TsNU0tjHTQwRUxcHesSULK6ixA5PSeU+9VkZ5BXfx3iN3rD1GrbTRM/tD4y9hlJu
	LCiqPuDV+C606R7MxROKZ2KtRYKVuqr4brKAZ+L53cPZp0rx/+UsPy9ogijrICeG
	yBVUUDL7XFrSdM/xPNg3PZXyGGcPcXX3vF6BX04XEiykif6zPG+7osHcmcE956PK
	K+MY5PfoSOU9oIScQJicZdKO7gQAsGf72xmQ8nvKlW0rC5ytl2P3RnoFRqOwEzHQ
	X0MZkw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hk7g7jq21-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:45:42 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-15c16792146so506025c88.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793198742; x=1793803542; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyfglkoLZqY2aZVrTKhpOEDmOthsFifGeX7ssa0eblc=;
        b=Nnryk1qvBcix0ddEfj4zsO0ZsncEFv2J88+tScWqdtU3iPpc3r3LmTAmrlH43GroKr
         ckdTWt6H52NGYoi6/219Zhy4eclx2pdaMEbgI3Tv95Fw6e/lNv8Yo97YLSawhGzAJRRg
         K9/SCeSJHbgvsa/6d41Z8Zb2XEQu/UWxderwb6npT4X5F5KhwnzcNvb3dgtKqQtuUT8T
         rzeIB+NWHB7lKOgm7RkbF2GEmP5sPsJUAZbYJugfQi5Yi70kWzxMM+ctQCWvK24gzxI5
         VsArRVzG5Z9QsCqDgwe0FwG/zCnTalkq4nvGEzQdVZqO5toux3H6SmCuAQHy053G5y+m
         ny9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793198742; x=1793803542;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyfglkoLZqY2aZVrTKhpOEDmOthsFifGeX7ssa0eblc=;
        b=bmNANzptglebmEGtRADImMv5VcrMsrDZ8Vh2MOQTELUhWOiGxPhLkSGdT5V8RNlRyk
         E0a642bVxY7BoBxmNAsRmkGV22aI0N3QXoJzMw2BEINeda4BdlsGD2ckfYuW5yiqucto
         MlaUzcJ6/ZeDvx1RZZkql0CUe7z10hphgrgtYG7rKbbdvC2AIyFwR+wsUncEvmlo9Fop
         /88VW7qy6nDady2vDVh+9h8qRiYV2yYzE4Rv8Eu+L2mSbNO5wjGuP82dDF8ECpvmCZ5q
         lyKupLS8lMJ/ljcLWPJNTDwQ4al4gUx7dB1XsoUXCUCszkQm9mMkvZkiPX5X09TBEXeC
         C+ZA==
X-Forwarded-Encrypted: i=1; AKwUvBz9mfG6iV8j2DYIBGXsqM9JI4hBhjETrMHjYw+I7/VbRrCi8iG7zldp4/Z//X2Mlr6P7e7YB/SHq0TNxBZmRA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLCxbAxayuUWLZWdfksGqWvw80AQ2j0PSVwO9tHXv3/49z8Vi5v
	HevB2sNvYkXESUH3FdSmE/1Nke6mZaPUBBlZ18RhHfu3lD8N+D6Smal+YEc+0B1Uj1v7WGDdz6T
	Qcr/U7omjn8vW8LfXKNco1yniNp6TmNjT3GcQXD191AD96dk4J7OJAT/uuwWaoSOJKbj5ig==
X-Gm-Gg: AYBFou3az7/nC+s8cUOSaN7K4zlZ0ATXFPfdroY0AzTui2xU75RRrEeXtg1PsOAUyBf
	kH2ob7s7uQBv7oJdtxfhYgcskeDC6HfoIiCqYRbSoW/zfh+T7i/BxI372BkyjAWEQNsUW51hPo1
	IKhzyXO6RWw5HKWlDv/NZJKc0usu3EoU4C3zppNU5V8/rR/KZGOFCCeX+XK5Ss1wqSiIH27xYNG
	y2J2g882MgpbiO8FJ4lQPeeG4yaWWs5cAkDigND3TmzWvY8A9gn+2AgMlNkeVQTo0gRNqPETy4g
	Q3M0z8kwOxJRNAJBwfFYsiOydkNaM4fIGMHaUCWgISmIGjbjfmROQFwZrRpS81ZcEz7pkHsBWdV
	eyS9otCkKGd/0xC+qe7ipsLQlzP0hz3ulJTSAEMhtHcKp2UVaHoY68U5R5zD7RipgApLcRtEa1Y
	j5eBl7uDCnRy5PbvizZ2lA+XJ9oU4IdQMPfw==
X-Received: by 2002:a05:7022:fa07:b0:165:dd90:1f54 with SMTP id a92af1059eb24-1a6cf446fc6mr4350378c88.47.1793198741471;
        Wed, 28 Oct 2026 07:45:41 -0700 (PDT)
X-Received: by 2002:a05:7022:fa07:b0:165:dd90:1f54 with SMTP id a92af1059eb24-1a6cf446fc6mr4350213c88.47.1793198738967;
        Wed, 28 Oct 2026 07:45:38 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75c814aa1sm11335421c88.7.2026.10.28.07.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 07:45:38 -0700 (PDT)
Message-ID: <938cba35-1f4b-4d42-9440-b6f948014ddf@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 07:45:37 -0700
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
Subject: Re: [RFC PATCH v2] wifi: ath12k: service all RX rings in an interrupt
 group
To: John Macias <dencity7@gmail.com>,
        Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jeff Johnson <jjohnson@kernel.org>
References: <20261025181955.2089498-1-dencity7@gmail.com>
 <CABkEBKZtaWkvxbhnOPBUjbh_iLx-Tyok0PskhduQk4O8qq=NVg@mail.gmail.com>
 <CA+KzPsoFGBe4PBJgjKQf-u+aeS9ckNALFjEkra_UoddRS1TPVg@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CA+KzPsoFGBe4PBJgjKQf-u+aeS9ckNALFjEkra_UoddRS1TPVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA1OCBTYWx0ZWRfXzdXXx4H4y7r2
 IXu4ubN9BnbFrPT9k6rwS/NDaqkup1bjHLLhROt2xoXrH7WhCsttRJUeEo1NEGkyDgKWBEV2n7A
 xC7wUic1O/n1o2k55Ivf0quK8+dehTo=
X-Authority-Analysis: v=2.4 cv=SoIFe/O0 c=1 sm=1 tr=0 ts=6ae20a96 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NmRTgjN7WBdEn4-ujX8A:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-GUID: 3JG-kDUzUYF05JIl3ZM-ieztKa-YXtxc
X-Proofpoint-ORIG-GUID: 3JG-kDUzUYF05JIl3ZM-ieztKa-YXtxc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA1OCBTYWx0ZWRfXyMJNO/895yf2
 PDZm06fhDIDQ/9UcB0DX+8OSFP1fcoD2M6HQe6ivI13AvzrVw5GxqKQQo8gDG7RWrwcZFNFGhA9
 yuEmUjk9P2ckQlsZckXhhahFsVJosXI6gbAmDM8zsOcyB9oMdjm4dmTqjV1SPtT0r5B8ypWy6/s
 zGrjJ7MUJve+IbHKsUdni7z0E6mLBilHkG0ZRTPAmhlBbIOsiI7QIPIxUyTCDthGqRnpXfOK+OB
 EznDEzL3WXm6rzSM+KUq5FTgNXl8DpDwSGkPmzZJvwUY2ziLBMRagdNdTScaDa7VH0vBUHLZn0G
 QJlLgPl4UhJAtKnGmOF44nYhehySobHaWZN3cFqut+B5heNg+fp1pQq2yBHYZqLnO7XAh7CTyeL
 TVRKVyt7AyXCpjnMCMqrzvgwFNeLdb1IJumXNSO9eXw21MMnOE6q9XPX3RNbjxiRgKvN+y4Dg3P
 4oXug0eGwZ22NGD694Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280058

On 10/27/2026 7:22 PM, John Macias wrote:
> If QCN6432 support goes upstream, it should use a suitable per-ring
> group configuration rather than inherit this grouped-mask problem.

Please review:

https://lore.kernel.org/linux-wireless/20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com/

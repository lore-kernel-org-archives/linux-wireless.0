Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793345692;
	b=tESSSQUCdrM8rV26JbCKmmH9vfrLaXGZakmCHm/+3eAXuumkEJMQ1hkLj3QBwnYv6prG
	 LPSICK9zv++MVPs/g8COeBnDvaAbF2/QVqy0Td9kPF1LzerxtInFpMOS/A597JfJMYKhw
	 FZQyhTcdi/NaEAyoJPZ/6jPZTn7XwaDJt7aZIIrN39zLsiX8YbVkCj64oaaQfGbRVTw1S
	 sSqdZ3f3XB7vBzcrQ4+B6+B1eGEmvWtb1TwEZ9jHC2ioIyGKvZt53JS4BITKECXn5kWX+
	 IxzH3333e7xyYyt3lcjz/6RfwSQV5I2ULczakkwxQboHP8hx15rm02ongqmf6WyGdnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793345692;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ufjNbysHjlfzLzm7FGJ+bKwvQEv7gJQ501Y0aDOU4V0=;
	b=hOprD2bAYdZD2bSzzQxecaUB7nlFz7iQ706DrCVwsduZUj5LRVAJ6r90Rq5t6hja+Fhw
	 wM1qrVNc0+cnPhuuRIvSHmUUJY4nXfbMip0nQQWI34k4pN759fxDyFbuMQjA9YvBDmmYl
	 /xRKvmBNbSWyzZTP8z4F3xe7JlVGllWIA+54eaInpR4WyFI/22TjmlMODSssIFnLJisne
	 jPM2LBR+FFOn5WTNmXioMUKNlk9fBlypNpzkdbFRA9tMo02aO5ZHupa9wnX5iIWBEguuu
	 fIguOcLANQaen/fUEfLr6QYOI2XJj97OP5jN2gIhkqM1VDOGiDlU4wAQw1sVGR7NOtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IMTeE8OH;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VaiQx0HN;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8C606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FF8C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IMTeE8OH;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VaiQx0HN
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5FCpO2337163
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ufjNbysHjlfzLzm7FGJ+bKwvQEv7gJQ501Y0aDOU4V0=; b=IMTeE8OHKfv3216t
	6fKdjiaBuH885AeBMd1k244iLgxqtwc9gN7GWtOAx2Fl5Gj1YZvJ30x8lSJkFFRj
	DbhCqvljbCaZ8J0eVvnIMOhpNTYijxigHRsfAndbHd20Tdi6/WorqdfopHH7k4ps
	22Wd353VXT3f0366wkhpUJg4hK2BWsxc4/56cfmMYb3drrNOc/Rr5grU3V9lM52M
	5dUtcah4ag/7uWcfRYWtwyOs3rSxXQzmW/yRIPhQfEhvFly/vYbQK+chS/s5eY7z
	5Xk6HLOj9bJP30+h9vBzbIDf2h6jqKB3MZ+rk/Ny6Jqskrh0bEsnR350bNDavmje
	DvEqag==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qhsua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:34:50 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f1f2fafeaso46263285a.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 00:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793345690; x=1793950490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ufjNbysHjlfzLzm7FGJ+bKwvQEv7gJQ501Y0aDOU4V0=;
        b=VaiQx0HNF23nN3L3absG844/xVougskYfmh2h8Mx8B4fHKWzhCs5x/mCjnjp9Ci9D5
         PjKleou+NRJcu+i2jiz92XsRQBgsPPIIPj/DmrQdNzajzn76PNdA6FuNoZuQwrX8hMgp
         7RouBWJllyDy6ir8fZWo3i3EJdOorqbsMt/6qwJyS5bx7QNxym+m1Ix1xZAO0a8pNORo
         LVS+IJeESS8DcTMP58/VHy1pneEfYpqD8QDlkRixT05VOtkDoyRpNB6rj0vqz/9qK5Xq
         8HeYNKpy41Qrvhnkx2jpee1vDygWay4gp+ovKF2JVP89xQ743XwyS98oL+8WxUILL1GM
         xSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793345690; x=1793950490;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ufjNbysHjlfzLzm7FGJ+bKwvQEv7gJQ501Y0aDOU4V0=;
        b=QqUoDDct0nSe3443NH4pxSsUQz5y7ct7vDIstRaJSDSthjXNOYnGjj9fG8O4MGqz0W
         BTChfiX5NWztp3SJhC74du0fqJgAqswV9ZXoaRqGlhb8vwh13FUx2M/JhmxFkKZcqjaW
         mJPSBg4XQXqosCZscM4HStgFfJtdGCRbMxetAHJ9u1mKvp5O6y6l+ieockxhGZiNRJlS
         z+yruL+YZThOw1Z4rj/Q9wQAZ/IArRlLG7qoj6vkfjDgJ+YSyQJsASyFjje7cjlrvN2d
         8cuc7EGiCZR11a59q99l8NYZdd9OnM6pdEzM2KToHeJp3ZFxACWiDOdiWVN6RijSkAtc
         mzNA==
X-Forwarded-Encrypted: i=1; AKwUvBy5UK6o7gseg3mxK6Qv/czFnrk7d7aF7TtA77ET/pbh7BOhFtIHDdAgJe7rKELwxcybobAEnEgif55eE5n/9A==@vger.kernel.org
X-Gm-Message-State: AFq9FYLAHOgBNub/lci3+AupWsct9RDmT4bNkBYD0JB+r+MzLOIP4RwF
	E9qo6m4CILbZKt02nzfzqx2VJaJ1h+y5oapQf2vIbigG2CwGKHSLPNmvypas46h5eZ7Yxwz1M0q
	BVFALYrj5YHN1zVxVIkoQFy1g3i5A6JS/T4Zv++vDILtcc1PsDrSFlYw00x//ciaMVjowCnaINz
	euug==
X-Gm-Gg: AYBFou3SqT3Sv9QKZQuRA1EWL/AG7giRK9ync2ZrsNUztXokuO7dTbUkh/zAdSniteu
	v7H9TD4w0uZcdiUru5Ev4EB2YC+eUf65AUu993zH+n7gzDsCHMfla0wASoM2Yv5BD9gQaxwxlJM
	Oicr3TJHotBFJ0W2puJtMrX1CjBt2q6TNQNV/jpQZ8IZ+4PrPkmaSwTGG0ubbYBPzeDFPB3AU/p
	tU58EZsy11IXUYkG2ICydGw1EbhhxJ9wY7iut9y7UsPkOlt+7j4ciKRFLr1mbGvfrDmClhnsAwu
	Wr121u8m9BzEU0/TwsWij347lbHZw81Bc10lsOCo/+DaZqVq/YRaGMmJ/kIhNlVEj6g6ziSdntT
	QufimUV8eoNyXLRnNXsg/hH2jcpzm5lB+/0kcgpVg/3xFNZtaUouIVJiFm9O614CEnPf4MqbXQy
	c=
X-Received: by 2002:a05:620a:1d06:b0:93c:7f48:8f46 with SMTP id af79cd13be357-944214d0ce5mr244551885a.4.1793345690348;
        Fri, 30 Oct 2026 00:34:50 -0700 (PDT)
X-Received: by 2002:a05:620a:1d06:b0:93c:7f48:8f46 with SMTP id af79cd13be357-944214d0ce5mr244549885a.4.1793345689914;
        Fri, 30 Oct 2026 00:34:49 -0700 (PDT)
Received: from [192.168.1.110] ([178.197.218.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm132997395e9.11.2026.10.30.00.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 00:34:48 -0700 (PDT)
Message-ID: <54eec1ce-5c47-42a7-a793-8c9f4619203f@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 08:34:47 +0100
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
Subject: Re: [PATCH] wifi: ath10k: Drop unused qmi_elem_info arrays
To: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20261030071912.107577-2-krzysztof.kozlowski@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261030071912.107577-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: RFs-xJlFTheNpJ-YBBKIys8afI3Gdf-1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAyOSBTYWx0ZWRfXxM8INcHvgZ4K
 CPza6kxcjMOB/nw27AaPVvak1PQBbjyplWY3qcSg3VnddUSrwpesGFedwDhJE8gErkCIktGHqB4
 8n45ee8Ldg24EiYn8SA08/0UH0ia8kU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAyOSBTYWx0ZWRfX2A2nbOE6b7eH
 yOnVbuAQfv19vXJXfL5vBAkR1eOEQE2Rnd3HEqpnmM5dS+7Q3JTMRqea0Fu23w4BGSMO+VmAinx
 98gXMzghQTd2sVkzo0OSdZcw+G1jvWvFYLLlHVlG3b90cRCo2sBHYdaU2zVVuUzn7iRbUE5xh6/
 a5yuYi+QphcXLpvqwQh6bvPrUs3MdrFPaECieYLH7QB5oWJD9rL7k7wTTBKaPcKfZh3+p5udsgB
 +3YY0RW9Qu/hPKw/4uyb165Pp0VjgDOEHZUWuPkUYoXpPl0lS9z2fGWymtXlL8hR1Syt6SCIvEm
 U9Kioz2BsZqF4v8nduMElolIoAF0lkc0nYVfQCLuc2lRzIHW1+1x3X3SrtOQ/8PVBaVpuF7cWXW
 4LQJaI4IXOM+ebOYI6jWV5nyNvbTsDpOQqaKGJxgMQ/7TN44jqGnggt55fULpEllixCwM7Lkkuk
 R/HkD7LTWvKsya6XRPA==
X-Proofpoint-ORIG-GUID: RFs-xJlFTheNpJ-YBBKIys8afI3Gdf-1
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae4489b cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=uyPgTw0bjBTS2cVxpiNm5w==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Yg9iZ93C6t-IJzi4hqEA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300029

On 30/10/2026 08:19, Krzysztof Kozlowski wrote:
> 'wlfw_pin_connect_result_ind_msg_v01_ei' and
> 'wlfw_initiate_cal_download_ind_msg_v01_ei' are not used anywhere.
> Dropping them allows to remove bunch of other code referenced purely by
> these ararys.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> ---
> 
> Changes in v2:
> 1. Fix commit author.
> 2. Drop more stuff (LKP, Jeff).
> ---

-ENOCOFFEE, Subject misses v2.

Best regards,
Krzysztof

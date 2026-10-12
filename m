Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3114B7A56
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823138; cv=none; b=teT+Vi5LlAZwLLgnNpLYmft4eF3LNw/o+V111luchuY1ulTb1ZEOW7HH1uQVFaqABuuhNBByNHtwWusHhtHhao8mbnBY2JGXjdN4alQMnNd5GzhILtyCIuR4UHscOE92a0OClrxVV1l7koeCRrhmqvYnFbMysdFL/Jd/9hlXZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823138; c=relaxed/simple;
	bh=r2aQ6nppuYAXx7FaIX4bzju76FGdPzsoUMRmiNPIsTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMPK2SiBBPRBDnXSaOz1wqhjxzNTZW5g4MiHaYQqc5Gq2Bu7Xk9gFGrD7SWyKO9/ufoGoHsAZLuPw1qyKY30aGx567gf4zZaNkArRgLz5NFSvntsQ7kpG3vuDGySVfpy79e9Cy9Xg94b5Njev9GdzQXWtibkcUrSIStQh5X20UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EFYNjBA+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kI3g8LM6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EFYNjBA+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kI3g8LM6"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFf1Yf2175331
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	W9hWISRKxYpfkDOhDQ86zNqoHmHjtrP19NViwFa2Ukk=; b=EFYNjBA+3Yb6xa16
	glc9d8L1Y0XzPvDxAeQRot+x408D7JVSsJL2xgYuxA8xb0ogUy5bSQDdo6V3sQyf
	S8NSbO5yXzIEhGVgZr9P1z+Ol5L8MkE1ZUGOvhmNOrIltWLKF4qC3rnSqFm109TX
	T4eqwsftgftWWotLNTGbfFg8ABTTxwUJ316Ml5FkcS2x50/+t3ZRpT6m54sPkFRN
	ykdfZQTxHCKZ3RIRWobGlVUvXbwAhrsYxuxyAy6pYkb5VYJ13487dg1Q/9/VtSqv
	K0WDg00TOeQbp9dJksSR+z+mn2O5xqYRbxKbutoybkw6Neh5XBEBqsgMnm/40NlX
	n8MRGQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8wbc1tfx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:38:55 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53568f05f8bso7119421cf.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791823134; x=1792427934; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W9hWISRKxYpfkDOhDQ86zNqoHmHjtrP19NViwFa2Ukk=;
        b=kI3g8LM625TE4j3RjzddBDWFfU+mO9HN4IVybl9u4SOfV2tNDXOG1xiY/Gu1/vYqzg
         k1lhkjUvk6uqs6p6mIvjAP7zZcqrHqZ4yl6qSUGNb2aXb5jfzzmNxKFcXYVEYKoAim6W
         7JTCP5Mub3MBUVBKGyWMbaa8bpDsN1VHZ/j0pz4IbLQM4cnTaBt9I3kyAezzqhKQPO8D
         6nTubllZDPdIUlBEgkgEL++WAaHMRYuRDHJBqnnI4r/y/grfVLO4Bfv6yUkXWQM49Nxb
         f2/1HkM2KHhdt/k0H3YMcY3bAbKpwMIMQ4WpDrMW/6C+OBDpLSQduxEi1vu61axpy3hm
         HmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791823134; x=1792427934;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W9hWISRKxYpfkDOhDQ86zNqoHmHjtrP19NViwFa2Ukk=;
        b=DkHsPHPbzb+dc+hE4XINGxnO3sf7yI4r8CswJrPyyu4YrXf1azhoGjWN+8LROd/mLf
         9zo/Wts7lxiHVv3OJruspN4Rao/2DR/hM4PSmRdq7uwNf6s6wIuN/3ywy6EwbDatqOKG
         JPkSzV8tA7fIP6D9BHbPH064eswcNIRtkl4ry9r7jdIiU9IHfbgfVmzFMQ2EAr+GMOOi
         uvEBF8kNcnJs9He9a7b0wi6KPwhWGaLb4HyN7qIfCC1718SIMt5JnwwlNnwcA2hNssa0
         UQOAxA5JYueK7DyOK+9Yi+4Q58dMcQiW6GNlG3ccOv1IsoFjzhuRz332Dmqvu3FguVYT
         oKKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNR79AUVagIcsXvW7Q4qkX9798ldiaUIYgSkAXzZmK6vYOIfN1MXts1UawgZrSogBjUUKZG4zJd8oN0zg66Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYIUpRWEbiXvrul6G+odamC4V0xFCxxqi2ATEfyKZGaCC4KmdKJ2
	DjEXMDCFSkstQz2EywHKkBLn4+tw+euBhdDxDHMHfP/JdzL401fxo/ZbcIkKCN8jijJbHU07dDG
	eS66dSU4dXG/8jWLKyWinsaXUtfHLuiBv4S0hrCn/DsbtU50rg1rMQuRFccy1TiqurMzCKA==
X-Gm-Gg: AYBFou0pbNUH5kWa2iQC1pUH9HJwDAdvol8nKxgvF2yK/YomzhxDPoeQP7quTYpXeL1
	B0upMnb7GUlF2NFLVfYvPzPo8zoRwH6guqaeBxvEaNTlaEMxwzxVsp0QUJ9uvOOQbVeoX0ke/gL
	+3vEJzcNps9WzQINPVMYFP/QvCfy6vrk1+wxfQfC/oeIj3ODSzT5arZ8SEltCvG6wXmSGxSfnqz
	DgQDlgcThtAZwKosyiQHjw5Qa4ZC7Wvs/yRtqRj9aQT1yW1FfKv6VJPMakhDViOAe2dlzHb+pYz
	NvFa4vpDlJMgyHld6vzluchFfeL8LA1CX/fvZByxyz9m/V6jK8euejtLmUrlSxScSC81eCOEEeG
	uzGRph8eoi13syKyOmbmWpg==
X-Received: by 2002:a05:620a:8017:b0:93e:5a3f:ac13 with SMTP id af79cd13be357-93ebcd2bc8fmr1731092085a.0.1791823134288;
        Mon, 12 Oct 2026 09:38:54 -0700 (PDT)
X-Received: by 2002:a05:620a:8017:b0:93e:5a3f:ac13 with SMTP id af79cd13be357-93ebcd2bc8fmr1731087985a.0.1791823133859;
        Mon, 12 Oct 2026 09:38:53 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c34adc25c89sm152588366b.45.2026.10.12.09.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 09:38:52 -0700 (PDT)
Message-ID: <571681d6-67f3-47fe-9a42-dce5aca13c99@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 18:38:48 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] dt-bindings: wireless: ieee80211: Add
 disable-rfkill property
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Bryan O'Donoghue <bod.linux@nxsw.ie>
Cc: jerome.debretagne@gmail.com, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hansg@kernel.org>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ath12k@lists.infradead.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Dale Whinham <daleyo@gmail.com>
References: <20251220-surface-sp11-for-next-v5-0-16065bef8ef3@gmail.com>
 <M7kfFb5fz-WB43U_xCUwgxpmBJ4TNdp4jE6yFu6HmemIcDx5tXO6H4xnW_pEQz6DMkKm-3POdB9hIdB092zhGQ==@protonmail.internalid>
 <20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com>
 <e0e9e690-c56e-4b56-90f9-2af46a7feaf3@nxsw.ie>
 <20251220-fervent-mamba-of-sunshine-f680a8@quoll>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251220-fervent-mamba-of-sunshine-f680a8@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NiBTYWx0ZWRfXz2zez/ymk8SX
 CmJQSoFu041eJX75IwdE5dOdYPmf5O8vnLgzJHUQIM4H/3XW6AT2kKnh2gMretbiZcoXYfvMsKt
 VftX2aDwOTmqMV8P9N1UlMY5tny0qAM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NiBTYWx0ZWRfX8ZOXj64Vr8Ww
 FFBqsR2ciRN2A2esHesDYcdsl9pYjXEOcZD/0j4WJC8BHniKIipFI671kDuFmjike1n5S693+aU
 rr5E/qsc6TSf6RPtcn+xbx2H5Gv1iiPLn9Gn1Kb/mHoIq05ItF0qf2oacJwcclQAyLOd7tmhLG2
 phFYUfwa9qQRFWAUWrM/PsifmWR9c9qqmI/gBe0mawNVvF5g1faBNrT3KstOKkt8DDDzcaj/pSM
 usPcHn9bwM1WXlgyJxf0mY3VvqtWTt4hm1Tn0OxlszVXLuMvr6WKvPscO9pr1MoNdHpFkls2DVb
 0jgvFRYIi55ZVY+E4B4UOzTbahYYVfx0/tmEt9e+CsWYOkpdnktEbQhBIyJUJ1wBcygOen8xBfd
 84fjvCUZFwpNSXIMqvIOhnfAOuzMA8x4ytOANxOZqvEnb4PME5XdAEnlbgzdGCFiFjkkjKiygXL
 xlBmWyY7t0Qo30dSdtg==
X-Authority-Analysis: v=2.4 cv=C4p8WgP+ c=1 sm=1 tr=0 ts=6acd0d1f cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=pGLkceISAAAA:8 a=TqhBrkvpmi7PlCebGDEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: AQw5xnMzaNPadGpGOhTG1lRtqvOisgfu
X-Proofpoint-GUID: AQw5xnMzaNPadGpGOhTG1lRtqvOisgfu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_05,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120066

On 12/20/25 10:12 AM, Krzysztof Kozlowski wrote:
> On Sat, Dec 20, 2025 at 06:04:00AM +0000, Bryan O'Donoghue wrote:
>> On 20/12/2025 00:21, Jérôme de Bretagne via B4 Relay wrote:
>>> From: Jérôme de Bretagne <jerome.debretagne@gmail.com>
>>>
>>> For some devices, Wi-Fi is entirely hard blocked by default making
>>> the Wi-Fi radio unusable, except if rfkill is disabled as expected
>>> on those models.

[...]

>> Is this really a hardware description though ?
>>
>> Its really more of a logical/functional description. It tells the runtime
>> what todo, not what the hardware is.
>>
>> You could also have a list of quirks in ath12k for this or have a user-space
>> utility look for the appropriate platform device string name and disable
>> rfkill.
>>
>> I think this logic belongs in drivers/net/wireless/ath/ath12k/ triggering on
>> a compat string.
> 
> This is good point. Either this could be deducible from the compatible
> or this should actually describe the hardware and whatever is there
> wired/configured, not what OS should do.

Sorry for digging up an old thread. The board-compatible change is now
I think merged into ath12k, but I'm not sure I like that, as now every
OS consuming this DT has to carry a table of board compatibles (hence
needing updates _every single time_ we want to support a new device),
instead of being able to convey the quirk through the property

Perhaps we could revisit this approach?

Konrad

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F617C211
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757195; cv=none; b=JZK4fFGzVs0Uf2hEPQc5hygzcp0PDVfjB3hU3X8E9gcvJpzY6puqbPgdyMC4WGrx9lGKpGxLIJHAH+7kL3BicS5Ak6YroLis3VjOKYadP6/cIG+AHmYxnp4nDfq7PgblodhdbXzVBjgWL3SultMsl4eUyxHnoXgtiYf/SrqbXZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757195; c=relaxed/simple;
	bh=9gcRPwX4KS4of8cWz3TKgFLqqe0thFI+ZDrAuJhdPRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S2igZ/xYYohZ/n49LrmJwnWAEfAKLXAfadXZR8sMiWKsdUPFdaIL4T2Js5jsNVTIe/DpheOM8//ZnfiZ/SWsR34jBf/0D9iwJ5win4460TBiM8lr/qjnP02OMEifL8itUGx901y/wVtgqOyr0E33x5PM6mLqGLRZi9VbGwgxOC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PqVepuDe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dOnxkRs2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PqVepuDe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dOnxkRs2"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6873l3iA1699694
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 04:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4whZOxnHdG9aly2zjOMfcepTeMJ8B/tTJlEIlYa/i24=; b=PqVepuDeTiBsjJyT
	qNeAnOnEGkFo9sVpbTFTEwqPoXR9yeVINTCFD+tGDRP3KCIq9lAEPAz89QVgKHZr
	L/QqC2BPXhbCAqKhDPxKP/Xus8vILDFNhDm9RHulYG29Tjw6xAqKtezRlBkPxkJQ
	kStse+OoRlg0T0g44V5jKH6r+TXLl8yXUIn3MTWoNr2SKoNdKBhIH+6eYoUIF+9P
	fH/+fi3JJf2LsihKkanZxt/3svANfvNarHw8IeR2TfZJfAkoG/USraz5C4Ca8cWi
	093OBUKj9alpGFiQRfKJS/D46YHSEXtfjdcNsgvAF/ayWkYcs+YPyGbbFQvSysMb
	SxELtQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ggc8jcyq5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 04:59:53 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc21bc2923fso3877620a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788757192; x=1789361992; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4whZOxnHdG9aly2zjOMfcepTeMJ8B/tTJlEIlYa/i24=;
        b=dOnxkRs2reALIPdNBGi7LCdwbMSoLgWKxJurIdyVq2zLkh7Ci+HphwylEENMYJrxV+
         YuMr5GqETbZ7IazrWde+chAs+WePx+/247ZpY0V1fZG95YfiNnvMVWnwd2ljPj7jPfa5
         TWbf+no7jqh+sFVepIi+RM8nv5y4HuMihQW4XdAloCSgLyZ1QOoyYr51KgYfeRcfcmq5
         C8nQYA4dhkXQMKcK9USC+YQfEvJhEsEPL1CD8/zA462upgdzqKqxOuLjW1W7qQr/yURL
         FxWatQ0iEVNDuFhXLNixruUDCdQyp+OfwzeFnYSLQRwAJJraUtiBRnyPN3FOOTVkaECD
         OVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788757192; x=1789361992;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4whZOxnHdG9aly2zjOMfcepTeMJ8B/tTJlEIlYa/i24=;
        b=e4dw7JvKn9p6+22rM3RhIB6A/ZM/3HKNJQRjy+WDTP2Ui+Wv47oECTkdbFrLVr0KZi
         X/b6dpj+ddhR4Y3Ew9GZyela+Du4mxvINY9PfUCu5e57UrEriqxPa7naZFuaXS1cR7/u
         czWu6QFaivvfjKe3K94UVk4jCCCVp+f0CsY2fmyJ8ZmR5ign2EzlqRGX5RWd/NfD4K3w
         HcDVlZm46OXV+d17/5URUWclEjBsRMs6cVkUxgtWu1V7ISUgVKvogJ5AqDrEfG63qxIz
         dMIgtk8ZrqAbUhiSITJ6nspw1uRxheEZ1UBk8wrk04HvjZYFL3u31+xUm2d8237p/nVb
         J5/A==
X-Gm-Message-State: AFuF++ktNR3cmU3IoVNJ9W/9IhpWJd6jzopdCDDcwHcj/kDM40YW5a2/
	MFZq8bnkp8z1VdBu1gLRZnH9VT3yCp7jPnORQQr5WfzHB4itsCXC1NiY0JRL0nHwNOAYGfPYBQZ
	9QQ1E2nqvEhQOgwe9o/OjSXCkcSMUNHYhNvmA77b4h4V4XNowgxpew4/ADC/0SlaLZgRHNmwpm8
	6iog==
X-Gm-Gg: AYBFou3jHsje+lG0t2IQYp53gGzT5barbKNUSBnmeT9T1pChzxDKNUljv6pCVVT6EgQ
	Ggog/hYgjd3G1RqVCCCAz4We3+dzS1knJcBY5LzAdYOpWT9pW/ueGCtgGUaP6hZOECAg+RnHD3b
	BJtNLjBlJ8UZAvcregqVLWTPzslrOeigd+1yjs4CdYXwies0JGSJ8ck9s/LRqTbR/60pVE0pOT7
	fr4BKgKyei8LXJhFznIrcptsL7Br1X1g3Zx91MhbMTt89vrqnaXujhi2u94rORhzDF2LSO4HG/b
	8CFWhRp0BKCH8VC+phv2pt4/SK3HK/ZfoNYhGfR0xcFjgKw7ELdsXEUgdqoNlkfBSlPjUdDjiqx
	COOsesQfRuPKfi7vWFepFA9Rb1FyVMiw9GAW8nSoyUWaVUVgspRZfqL1kdPc0TTtyUg==
X-Received: by 2002:a05:6a20:7284:b0:3cc:f280:ebc6 with SMTP id adf61e73a8af0-3da39eacf9amr28608218637.5.1788757192441;
        Sun, 06 Sep 2026 21:59:52 -0700 (PDT)
X-Received: by 2002:a05:6a20:7284:b0:3cc:f280:ebc6 with SMTP id adf61e73a8af0-3da39eacf9amr28608157637.5.1788757191898;
        Sun, 06 Sep 2026 21:59:51 -0700 (PDT)
Received: from ?IPV6:2409:40c4:36:4638:29e7:e0b1:d1ef:dcca? ([2409:40c4:36:4638:29e7:e0b1:d1ef:dcca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339ac24d7esm37726261eec.15.2026.09.06.21.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 21:59:51 -0700 (PDT)
Message-ID: <e1c37fbb-48db-4ffb-b1b9-bedcde507970@oss.qualcomm.com>
Date: Mon, 7 Sep 2026 10:29:47 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
To: Johannes Berg <johannes@sipsolutions.net>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
References: <20260820052426.3177309-1-aaradhana.sahu@oss.qualcomm.com>
 <47c4ba195ae49552538ea65f4f13de7d3dced266.camel@sipsolutions.net>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <47c4ba195ae49552538ea65f4f13de7d3dced266.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: -iERTcYq9I_ijnnULnDcR60Ud9J8Vs1v
X-Proofpoint-ORIG-GUID: -iERTcYq9I_ijnnULnDcR60Ud9J8Vs1v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA1MCBTYWx0ZWRfX04Xzx0Q6fFO5
 7WNjXynP32TR8MlXPKTfiScdFREJjHcAL9WwXiMMK1i4JQTX32f4O7UbE93bCu2NnnFvCzyQbRN
 QsdI0EMj5nIGfNGrva3vELaTDMlhP5F5DrrI90jv7KjHXxUFryhY+UE0pcRFtLbEF2UxUm0FhaR
 aGRc11zED+mbRqSVePyu42kmMkzd89UkrOgYR4Z1BZeTH7PHU/prYFAX64C9f7+7Nn3lYvVJBM7
 oVERYdguiT5r2u9mlSGYxw/viNY4ZdD0RJ/OzCjY0Ym+HYD0pUxoWi6+uEOyCRC326bEKpuWdW5
 H33RcsX5My0sNwCzpFREON+edmccLWMKQMA5KkroTNRxj00fgm4LFT0sUZrI7/F7/RwP1JFgpdW
 ffIXH7ZvKgotpiZPab1lggbmGnyD12xDQudn3rO8iJuFtG3Tr+ZdPDm4vT9MXECcEGQpCgWNdUr
 eGc1TawS6U8sSIKOZ3g==
X-Authority-Analysis: v=2.4 cv=DYgnbPtW c=1 sm=1 tr=0 ts=6a9e44c9 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=1VyEs0PO2QFJR4dUXpwA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA1MCBTYWx0ZWRfX/lACxr9Hz00/
 DiQ7FdJU5pR4na6NmcoW2LLJu6FYMIMpsW/t6hTI3u3Ifd0g9TS9suLIClfKttWHeBNHf/d8d5v
 NwKLLGApfa+LVj0ZAp3HvMZ+S3vjfCg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_01,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070050



On 9/4/2026 4:08 PM, Johannes Berg wrote:
> On Thu, 2026-08-20 at 10:54 +0530, Aaradhana Sahu wrote:
>>
>> +struct ieee80211_bss_conf *
>> +ieee80211_get_sdata_bss_conf(struct ieee80211_sub_if_data *sdata, int link_id)
> 
> not sure I think this function is all that useful, but
> 

Thanks for the review. Since both sta_set_link_sinfo() and sta_set_sinfo() use this helper,
I introduced it to avoid duplicating the BSS configuration lookup logic in both callers.
I can remove it if you prefer.

>> +{
>> +	struct ieee80211_sub_if_data *bss_sdata = sdata;
>> +
>> +	lockdep_assert_wiphy(sdata->local->hw.wiphy);
>> +
>> +	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
>> +		if (!sdata->bss)
>> +			return NULL;
>> +
>> +		bss_sdata = get_bss_sdata(sdata);
>> +	}
> 
> at the very least that part is pointless, and should just be a
> get_bss_sdata() call?
> 
> or are you saying you somehow found a VLAN existing with sdata->bss
> being NULL?
> 
> johannes

Yes, you are right. The sdata->bss NULL check is unnecessary here.
I will remove it and send the next version.


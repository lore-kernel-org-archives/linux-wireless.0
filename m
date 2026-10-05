Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A854C77A3
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216110; cv=none; b=hyZjigHHnVVs+IstSdZseHZftnFjkp5gRS0rS6Xq70rwY+UcWUyVm2xZbdR0l+R9xu93zK/O5GzYLWaifcwTczapZ8XtHEnvfKvpQPdJ8YSF0Uedkr4cX5z+60HnKpqrHSmo+TEutbgk0qTBIVj5QXLLVokUrXhSfX2N9xSJmiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216110; c=relaxed/simple;
	bh=GqNCCXtWyOhPNfQ52zoOEgaHsGqyNzf5rUtC9OD+9HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pt+cPiZaDr60cj3AcgFDEoTXLspfNN4Zpdi2wHMvGAR+78vbfHRqJZyHclpyHCN1q1h8lP+CmRlqHbS/Dz5d0ds7qVObc+RflmhG15Vhv52x7zWwf6WmFOw+XkZwwkhA3u8Lpb0g/6sY5572lZgmzJjihkIx7jiXA+ifwpVl28Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UmUuNH5K; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NRKn26IQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UmUuNH5K";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NRKn26IQ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP6Ki1583566
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 16:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rOuvQ212oevMUav2sZRGhr7azWQUWQWPF17Id9/838g=; b=UmUuNH5KhM61B+ut
	cNpzOftFxML03unTPYCn2FxePTxSbNFZxlNOP1muYAximDjasMWSpxlef8+P/6qp
	ONzxTZf3yBU5zaTL354fkYvGD770GW8HC1SokNPYPF/uvcMesWrHXSX+nW7Tir3E
	4rfKPt0DPLMZjB+bObv7TEF97/yLBHqDNJ4Y8PkAk4HOPzXmBG/lNV8rWID5utQi
	YqYeUYUTKxMoyF8dmF+SJphzwo6tnQDHqHU4CV/UeyZ9dpagHT4sd3pu4t+gqjfF
	IRHy2w/liQPaD5Vnlh1yQWOg6jV0Wm5OMEdQCEnZu8RQyKQMNNKMzchebRCZd2v0
	Ck/lQQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h41gnamw9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 16:01:47 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so1499862a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791216106; x=1791820906; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rOuvQ212oevMUav2sZRGhr7azWQUWQWPF17Id9/838g=;
        b=NRKn26IQrZET0DQjn25qojPn0nWVK58Ns/7h9kWEicOTXIEjOARTkVCJCz6LAZiC3Z
         XVQTB0j2OfyFdDnVzvXlVT/7u6CL2EZb9+7ET2IS/YUXnOucIx2I+OFimKT8vu+S2iW5
         pEGsJCHxL2uIFVP54xTfsMaU+nnkMQ6zoIysk3TzDJqbtYJ9uCWklhSsM45SdjVsvfi1
         FME3+52xUgll2vprxsfXlpKq496lyzds6URF+0Xcku/ttYHEpQ8ARM9vhEmRh51Fd4Pc
         Mo4s+T5/6HxQf7m9DpO3XOfOX71TRj5YXqtvCcTfpMzmYqpJFoJ5iEn9ja0XPAWrelwE
         6n+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791216106; x=1791820906;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rOuvQ212oevMUav2sZRGhr7azWQUWQWPF17Id9/838g=;
        b=0JFPrhQ/k1EO2UkC0gsNpfR3EV/XsMa56og7trTxqz0+pkScbVh3Ee3V0eehPlIi7/
         AT9aTmKLNzPbJl5Ihz4kLNJ+HzNmJb9iwUq+Wx2Uaz6VbBWoK1MvYIDr1wIOJlSxz8ce
         McgrobCI/EQqkI/XKfylMmyAjPb5yKUa5Nd2aPQSsx9iCIgWXLQ7acJHJqeiWP4MOtjL
         reLFRmiw3Q2ILvPL93UNjFW8DYfBVu44nhIwUq91MFEccpPzrlfYZsFE81iUiMTuD8OB
         iNoW+8gBR8A16Wtdi3C5Cb8JndA/hPyl2c1G4dT9mIfWv6U4NoPZRlo5voEcNyv7y/om
         ZVeg==
X-Gm-Message-State: AFq9FYLGK5xsd7wGrpYfy3ihmBrZFXaEEJF/T+XJX7FUn3icNz6Vv0qA
	v2jT7wI8/BD3qUxtjh/Br0Vjd+nysU5GbV5vWQrCQ7xImzTom+XASy9D27nXEIKTANcC8g8BXFo
	jNhdxdm/r1848uBbz2XHV9XuPzMXak32h6jtZn1j1rEUavmr3TIYUvGwBUueb9bRTlJXhEqWdpX
	q3
X-Gm-Gg: AYBFou19JT1Ysaqlhs280IcjEhzZXmnQYzyzJb3SP8BXp4BL7OJNXKpR6JFtuz8rear
	7MjZaDQhWg+ipLuTrvhxb0/0FvL8UssywEhcz7QQzOokdezotw970DAPnPDW0xxvrx8C7dS78Sc
	JI2rJ4/m8f66tCrhYjNj9hF9uPlguVvRdlMqOT4ufKWhopEPY01J0F+60MFpjpBh+x6ZaIUg1pX
	cD9oKwTUbtbjnr7vTIzoi2oyLIEQD24JipVQFJqDFqn5C3PgVyYU7ytcu5EdKYp6vQX+jeUXhgW
	r+v6U9YLi/60QAF0yu/5pZ9ct5SAk7vdcLhuBRd8k8mAfTKSIXnIj805dbc1p+rHN36hpcAHNf1
	PZ9f44blIusOy0ywE502wDTlK+qaXZA6vKH+gEtkOaGc44ZsIiRkSWqtjg/fNUYeQYWeBiRR3ft
	Mo0RJlI2XbQC2pHs5R
X-Received: by 2002:a17:90b:4f41:b0:3a4:c52e:8126 with SMTP id 98e67ed59e1d1-3a6ce7f75f8mr8501549a91.40.1791216106161;
        Mon, 05 Oct 2026 09:01:46 -0700 (PDT)
X-Received: by 2002:a17:90b:4f41:b0:3a4:c52e:8126 with SMTP id 98e67ed59e1d1-3a6ce7f75f8mr8501520a91.40.1791216105564;
        Mon, 05 Oct 2026 09:01:45 -0700 (PDT)
Received: from [10.50.23.243] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7c8d318f4sm4514243a91.3.2026.10.05.09.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 09:01:45 -0700 (PDT)
Message-ID: <f9d5f248-1dab-4608-9079-5fc1554999cf@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 21:31:40 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 01/16] wifi: nl80211: Define Seamless
 Mobility Domain (SMD) device capability
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
 <20260924-smd-v2-1-bb40094da1d4@oss.qualcomm.com>
 <ceb7d07781c6aac1ad3e26a47f688a36659cceb4.camel@sipsolutions.net>
Content-Language: en-US
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
In-Reply-To: <ceb7d07781c6aac1ad3e26a47f688a36659cceb4.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: M5uK9s0ogJe35_2KT9jP-3ERvISOA3zd
X-Proofpoint-GUID: M5uK9s0ogJe35_2KT9jP-3ERvISOA3zd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2MiBTYWx0ZWRfX1pBd6rAMbaYQ
 AVfWOAO/Uj1SZyyeosK7DQKNcKMUhUFcTGXlm75J75vKYwj6hVGmPlp5rAypW2w/mGzMXco5ae/
 xTOS2iP2htFVLOSwGkh4lD2uNNhYm6hr6ORrEPovbN9605Y73xETOL/x6nyHnLzc0F3vwWUoIo5
 4mUSvz9lBwSQOmY2c6n686B1W6ktDJ7fhQ43hs/1Dw+EkVMGHqL+9+rIRPH44xl4tdEIlVvlSbk
 f8v3QuYc4mfJDXL04aS7owTluRrWAZ2WfuQxZe2S1rygJxeRsx6Tp6wkYbVN3XbqaxXIkYBqnC0
 jnsGdEO8EiO3HlIqFYCFkxcJS0yUhpB/SdhaJWCjvh/sofKHenl6p+GOrtocRIscW3SxBZvHmxC
 pe7t9wNUtWKwYArqyB/4YQZ70n6TGHXuLbKKtfOjWPM++eZN9CVHgmHH0IDcJVKp0zQv0L/npQs
 RXXA1jG+df5Gt4mGoZg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2MiBTYWx0ZWRfX3hPc9WZZFwMy
 4CnCGrko3VO5Pnh5UPhZnY/ogjOG8W8TapHW59mlwrHkDKA95wsEJzLUovxUXiNZfJyHSWDqoXk
 5lFKpf0UXjHob8vjrdF9NlXu+G5ptHc=
X-Authority-Analysis: v=2.4 cv=P9WvFSAu c=1 sm=1 tr=0 ts=6ac3c9eb cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=aBhZnu2hFUD8Z5ll-XkA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050062



On 10/02/2026 12:11 pm, Johannes Berg wrote:
> On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>>
>> Subclause 37.16.11 defines an optional capability for the current AP
>> MLD to forward buffered downlink (DL) data frames for the non-AP MLD to
>> the target AP MLD.
> 
> I ... don't see how you would implement that by defining just a feature
> bit?! And you have no documentation for how it'd be implemented, nor any
> additional code in mac80211, though that would seem to be necessary
> given that it also queues frames?
> 
> IOW, "driver supports forwarding" doesn't make much sense without other
> mechanisms _somewhere_, and then those should be described (perhaps in a
> new nl80211.h DOC: section, which is probably a good idea for the whole
> SMD AP-side anyway).
> 
> johannes

DL data forwarding is not supported yet in this series. I will clean this up
in v3, and will add this back when DL data forwarding support is upstreamed.

Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE82E2EEE
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 01:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805759; cv=none; b=mdeAes5kZnDezzP4CbmovbirKQ+fVNi+90kATQGt9NkeEtK3H5NYbrRgL6EFp6oOXlOQSHoKqdr8MxAfOt6LM0l01XnZYDfE0uxLGBgjwP4vhKX1OnESw0WftlbsK/3O56d3V/wAQrcblTA3O+V5YVmL55Ut6V+SNC7bchHdJHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805759; c=relaxed/simple;
	bh=3s4oXMT/DiBioBXO3hXPccXgJ7D9e1R1RBpefXnIRJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vCMitjJGjHtf/E2Y9nUsDwo0jDwfqJuzxGTKnGadQnKwrfWbgLw8OPWDIgW4Qlz0kPr/WHef6hRuDTS7zZaOtpES9HMHq6OWMRB6nQDIPp9oifnkVm8b/n0RE+NXJgToO9ivVmCWBJnhK7S0pvU4pJ3hmT92SLVnedNQGSHmab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oRDhdPjG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gF5M8QlP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oRDhdPjG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gF5M8QlP"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67417CjX3457210
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 01:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	V5Nt7t9O54JUJn5K1xswpNIpU+FtA9K+zYQZQNsEmlc=; b=oRDhdPjG7ygu7P09
	rka5t7JUWCWXxamUHSZPDIhVfRB+GNWI1VzLHeGMw6HRJa6onBE6wVisKR+IWLXk
	/F1vVLMZyr/Z0mL5YWLH8phx7sijIGNXGrTIbeYO3Wl9rNxxDRwRd/HEOZ+btrzA
	Mk5InbC3LQjUVK/51KQFYsXIubNv53S2i2Zx1B5EQ/UahVT096lTQL4hnyXJG08O
	zhTASSmn9Lb6SSmquIuNnc2BGPZ6dPvGrcjNPCqpMO6hT5cKG25aVkumsqcMKdmb
	i+Q0yMRmdMZk7XLnOS27uhxTdEK2AD47m2Lw/bMaKAMwqgIBvG0jOvel1bhrHQ5x
	/DC8bA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftwhdt9cg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 01:09:17 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so4270893a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 18:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785805757; x=1786410557; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V5Nt7t9O54JUJn5K1xswpNIpU+FtA9K+zYQZQNsEmlc=;
        b=gF5M8QlP2BUfD+W0Rq3IIQV0PpLg3IGUufffMO2Oa9BuU7r9ZLHUSEEUlf90W6fSZC
         eas3cJHDNK9l7/mlYQ+aaF1Nefco3h/qVJZKvAj30ASjg/CINfm+KF3oUNWlLq9ZoGU7
         k9IioadppbtPQNqXpWwt+/gl8uRG/gYFp4bnZZPI8M43yEjPwOtGtsP8YcMxIcWD0eHw
         yGzWkS5DvgtIcYpYlQQ62YlIBQtMP6/rt1L4ES7/dEe60+m8kH/JTkE5CwlNzn6Gi4VQ
         2dJDlLKfUqFno+yHAAQ+4I4W//uBpsXy7DVn9dZ7gkkDApWbKaXW0UNxCqFMdMNypxec
         McMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785805757; x=1786410557;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5Nt7t9O54JUJn5K1xswpNIpU+FtA9K+zYQZQNsEmlc=;
        b=iy+rbkbYbLzCm3EI3ihltNhIFKEIxf7LwS8hCAewQO0tYNF7pZ8nj3F52g6FGzm8AS
         qK4UNj+angpd7B5WofIPfBneWaxj6CYIJFvpFm8BsgDl9gZRLiHAm8z+pYZ9/ngzYqdN
         MeDL4t9sCcxrEDh3r2YjvXqnzMyfq1Q/MmInAmyqsLvdc/f4msbcLxQsxdfjmDTnAKw1
         TCkjMSOOhuSfKIceW2MiVMe+mVBAh3Wz1xJxsieDnFrHygyzDEYd16iaZfcBYCMSTmVz
         lJoFCmAoyVUvC0PrGP+89I24JPibxgdmZVg2HmyB7RDyXpZAvwM6+GHcrrcrgckTQaM0
         P3Zg==
X-Forwarded-Encrypted: i=1; AHgh+RpKadWh1iMa1rGZXzaQbvjQAwjE6Sjg6ZyiDh9ViFXvKeIEUK47eZ9gaEimNu3abOlLEydVl0ypwJBTeudiUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnXfeC0H86RDvyAl5IDSpyKErgsNnqfge8hg9FhaECnFOdxgo3
	My0Ln1gGekujnjM1aF7lIBjFDZ4YPuY9rxma0MDE0K5qZjVE0R6L2uTQq9oWBi5yaA5C2rnw/O7
	jp0oOHR3y2MeeYAUF5gfuc3IIL+uQo7XDoZFS+xYRGzdsAedq3cYjHKYoblpE8Ugfql9K2Ixc1s
	lDtw==
X-Gm-Gg: AR+sD10OCB2nqg6Dcvlg9Hdep5nMxnrzU1H02LmJ+td4738KAT1020Zg9NJ20M+CST9
	VqfugCtmSZ/oBMgQ5hgBAC5yE6ScIlmuhMvHuIVVLPoYu7DmeSQ1Rq1vqnw0kvhm/JrNCk1q5R7
	MjfoV8fL+w7Ry6SlWjOB19VMBjHYaTXZSVWg30GsYdi8lf9UebJp+eREtvjOECYNBvzSuy7TPuL
	EhHR0jQrHcNt47osizZDYF+31Jg0D4QmagiNgNirKRiyL2orQcrn+1ck4IxBwmEVR75ErlcoiSF
	QNXZd8ApPortV6XmWJSXKXDHLT8gFPzvCoM1j9y65leKCfiYxUE1K/E/JprsN2HiM3cH+sZkBIl
	83ocIQ+J01G8wg6aezzT7ud8API8AzJ+e8Go/ekLm9WroRKakGWA7NWC6AFTj
X-Received: by 2002:a17:90b:1dc3:b0:387:e0db:bc28 with SMTP id 98e67ed59e1d1-38fbc554637mr10869818a91.40.1785805756826;
        Mon, 03 Aug 2026 18:09:16 -0700 (PDT)
X-Received: by 2002:a17:90b:1dc3:b0:387:e0db:bc28 with SMTP id 98e67ed59e1d1-38fbc554637mr10869800a91.40.1785805756309;
        Mon, 03 Aug 2026 18:09:16 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4fdb80sm33969626c88.15.2026.08.03.18.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 18:09:15 -0700 (PDT)
Message-ID: <302120c5-7303-4d32-91f4-4cf2d484e1f8@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 18:09:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211: store the ack skb
 before building the header
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
 <20260803141309.292711-16-johannes@sipsolutions.net>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260803141309.292711-16-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Zf4t8MVA c=1 sm=1 tr=0 ts=6a713bbd cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=QyXUC8HyAAAA:8 a=Fup6CUFJd-KwiOgJQwIA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: _3DEsVqlw3LPrn-wLaZdW8wuk7INhBNP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDAwNiBTYWx0ZWRfX99KrmmzMwm+Z
 OtOZ6uq8fWAL9FJspp2ixw9X8ZzP08fqLm2webJBGpECwRtLduR9UiyiKuIsEWRODcYijlLUvfU
 s1j2shcv+vlDUUgD3eD7+loFEE5JIq0Aor9D1Hqgio0pBhBDVUENmEl59ACPGezmIcPx3d8lYm5
 S5Dxk4Bvi0DuRZ9ZSVNPVSHuxx8P04QefwmDToiID9FVeEkgRjwUXmbklH6lKURTheJaSKQW5sM
 VYS/LqUSIrEmTE2HcVIvhOaZADfnVxOo+ImlJX6/EWEa5aEfAJZcTpBqwS6Ce4VJ80R2KrLkfly
 ChAhWkWpNcekadBZuDStFj8oepw14sfpgfwoEmgo+JP1/Iq2iOkrZEylC8tRM12SMVOGENUCV8g
 LSDOdCj80MJn9j85SZ1U9lgr7krFlpSaH9ogNNp0bD4tk9bT7nYp4hdDHZ3aqKDay2yiIFCWF5W
 9RvhItNaPTlydFTiOzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDAwNiBTYWx0ZWRfX843dL0crDOFh
 N0kfRXRoe3vk1GOlCSGvgApZJWOlYu/kSbE4Sek87pft/En8HfETt92V0nfeMo0U8ZcZl6f7qQC
 f30cTYlyj5sZno6hhFpKxQHYM/kjTaU=
X-Proofpoint-GUID: _3DEsVqlw3LPrn-wLaZdW8wuk7INhBNP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_01,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040006

On 8/3/2026 7:08 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The ack skb has to be stored while the frame is still in 802.3
> format, since that is what is reported back to userspace. It's
> currently done in ieee80211_build_hdr(), but that complicates
> it a bit.
> 
> Thanks the the previous ieee80211_lookup_ra_sta() change, it's

nit: s/the the/to the/

> now known whether or not the frame will be group addressed on
> the air, which is needed for this condition.
> 
> Also simplify callers of ieee80211_store_ack_skb() by filling
> the TX info directly and fix the free in ieee80211_build_hdr()
> to use ieee80211_free_txskb(), reporting the drop to userspace
> rather than being quiet about it.
> 
> This also lets use validate the link ID for control port TX in

s/use/us/ ??

> that code itself, rather than interleaving it into build_hdr().
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---


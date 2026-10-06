Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5A2AE76
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 02:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252960; cv=none; b=SS6WRlipiesdpk/GRRaax0M+VlKP0qzaPTNrvx9GmRNoeZNG3MwwmAwyHYubQTcDUkZdEivfDaiaJLPbYHun/srcd3CLW7N5V37BBFfJsyqMDjjYHbEXBQ0rh98HfWeUXzSepuHwWsOLMHFeDI8rrSt72M35eWBKQqSxeaY//QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252960; c=relaxed/simple;
	bh=JQAOy8crYoCVLLkBUVNwv6/5GLs+1A1/AH26dsbfVJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9/VqUO0e9lY+3ObaixlzKpnXTgwcfFtGEgpi6jXkpj0rZcdXSW4wyXg6DdWTsGrYTuEWCMm/BqKjpxC0S4B2AWdegwbd1hu2tG/Z4hOMt64FRu4LZ/MQ1DdFSw4FRMuYuaMMPbCzEL/TBIYu09Lk+Vh7a/B317sEzWv47E3SEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gsIJgmiO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=buFf8EQw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gsIJgmiO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="buFf8EQw"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695KMqTl1972031
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 02:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YhucmCh5FxYyQPtDcrrIyrj+mpj18kkTGljq3E1yG1Q=; b=gsIJgmiOypuR2sDJ
	SXT5AQXx6sANhNgMD+Z6HQ3ZekiQXF9xMUEw/NgWZrbzw4/OymMGlAKWTMvtZewJ
	Zl1ZVUCSV586BrvqQ79mQUi3qWgPq7k3Po9lfu5646d3Cugd6cyA/wFmsKtfwHOp
	f9zlgiZ0LhWKGAfuBL0a4syi1gPgKHL3P8oV7zm/AZDiznpHbUROyvEpGaPl7fVI
	14r3AXAk7SBMajP8wssi7oWBIx25UpGYuivq5XGOVC0+K85dY/nox4q8LhH3ptPJ
	9asLHBprjPui82RvxlNojhA3lHT01Z2kHk1dH9kDRPUWQJ4IK0jLibVvQWF7rlp2
	5tAWCA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4fkuht3f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 02:15:57 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1384427c3efso3361992c88.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 19:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791252957; x=1791857757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YhucmCh5FxYyQPtDcrrIyrj+mpj18kkTGljq3E1yG1Q=;
        b=buFf8EQwTHtHWBqGRcv4wP5vIecGMEZNxxMhQ5EMQi5qYkMP4xEz91kuLZsZ7ANm+a
         MPmsizBDFLkEumUemTZysY7qTGqPM1w65jtc+8+i8xm3LJ4hrZcdq+GLxIegBw0v+7+A
         LWU2uqeOdn8sQnyswncAqEhufl0tWH+VzenO9gdpgjXzKQgSK9CNKxUK8UHdr7eAcRdT
         pAliCEAYnKJs+dHQJ5tVfR2SIUT2kfgu0KxVWENpbl+dtgtMa7zUQwxybzBUHaGwWyO4
         AeNajrESqYRq6p7LUFUK5lFCp8AB6jAWhVxy8cQGdpn8lbpW205136yFugrt6HKMU4lf
         /+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791252957; x=1791857757;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YhucmCh5FxYyQPtDcrrIyrj+mpj18kkTGljq3E1yG1Q=;
        b=exlVYCXg+olbuXm9RuxBHs1iiff6eZv8ifkMYzk4h9+80ENjjFxu8rlwehuumhk4Fq
         Pqtd1ShUmU3vXU3EWhJ13U+kcImEKgMiw0++X2pMm5VMCtbe917T+a2b7fsy9rBLC8uF
         T8tWo9ZhonWnG8p13XCEHbk0b0+dNuEVH8q16Tzv6RW17AJRkF2lmu34WUXG+dnTzhet
         b60X9PCH9I9SBwPUrloIG0tPTZnXG41xElGu8EZEm81OHar6yxpxevU9b/Qn0qDt2ygV
         eGjwQf4reEXdJvoxDPFKR9RR4HBm/dgBvzGl1uXMoXo8W5lC7Errn4+RPShgwXXF3tOl
         t5eQ==
X-Gm-Message-State: AFuF++lsua9FIS0xN5yyYBynnONP4ZExh5PhDLzhz/+/+NDxLq9fqUis
	0WFxxAbu/6gNLdBBQMIGzq+JMPUTQ7KrtV3SOkdcbE+e/cjxvhcsIIMFkNI0zS68YS5hyZFPdVn
	DIJL+8yMTV7ihH2TgxBOoPhsDU1IcdqeVnjgDzV6noTQXjqFMA+trpCW00k5CnmR+O7JsSQ==
X-Gm-Gg: AYBFou3WH+C4L5ZmjWfPFOELz6Iy+stPXg4AGiLExABB9enV6yIDmMtnyzj5p3rp41R
	z5byp5i4qUpez8vWGoggaVrvNfIi6uXaT64ZQ2YexDrtV42x6b0tY0A+YPcnxGsWjT+xctLX9ms
	eJindect7qRUQkw8nhqJ1d6R1srd/NPXt6RffuA5ANtINhNTpDt1pVQHFTyS2js3r8cNnF1UVSZ
	MblY3qNda8gWkDOJS807eQKv5gSb3hlyxT4qe31tuvW12+x+eFHM89YKaHwxrazr/vhbUHqT1Y+
	ygQN6+9rcoisrDw6LsEawcZWcQKE1oJ/FSeHanJ5mUP5NGGvFB9JIlQpO9np7u07H6XrH7StxjT
	G1X5Pr+JYz2fHPBmhgS4Xhc81GGq3Ig7hxFP+Jo84izgr/oaSb5hZAVDWzg==
X-Received: by 2002:a05:7022:5f02:b0:15c:1679:1ce8 with SMTP id a92af1059eb24-15ecb4afc11mr102600c88.31.1791252956319;
        Mon, 05 Oct 2026 19:15:56 -0700 (PDT)
X-Received: by 2002:a05:7022:5f02:b0:15c:1679:1ce8 with SMTP id a92af1059eb24-15ecb4afc11mr102513c88.31.1791252953653;
        Mon, 05 Oct 2026 19:15:53 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-15d852a56bfsm2299440c88.15.2026.10.05.19.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 19:15:53 -0700 (PDT)
Message-ID: <d9eb2d99-79f5-4e18-8c6d-4877c73cd5c6@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 19:15:52 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] wifi: ath12k: service all RX rings in an interrupt
 group
To: John <dencity7@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <CA+KzPsr13czsH=k_UWJqj48C4Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CA+KzPsr13czsH=k_UWJqj48C4Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=HtPjiETS c=1 sm=1 tr=0 ts=6ac459dd cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=_95Yl18s_qG07WKI7q4A:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-GUID: KATQY-LudidMqNeFiRZyVpCKeFWGDR8E
X-Proofpoint-ORIG-GUID: KATQY-LudidMqNeFiRZyVpCKeFWGDR8E
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAwOCBTYWx0ZWRfX3aRjK4aa0MNT
 uoHyW7wigyzgkRP87b348RnQqi3UrDWlMd49SKjRlkRQt3WAn+JwhxoKQDR2D9/1mujr+8uw6mA
 wn9qWKnCuO5+hZg1gEczYkjYSy+nLZ8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAwOCBTYWx0ZWRfXwdVU1yystNUv
 nhmNkjsCTAjtoMWUuUmbdFnLTMzNy/oLt4DC9GTUvLoOFDD6Rk1STe3vY0f5jWbS2GJS5ZWFYr1
 0qFZPCVPJPwEAkCT6Nusmbtx/akdj9igWff6Ll8sTR0FNxg1W9UKM+1uJarhvOZxuySoUt0+pgC
 Ce3HGfbElYDgQa39cx+tEJ/KJQxDt8kRovv51fIUtgI3q3fxATrYeTaZVeXTlRrial+xoZo1x3b
 j87s3oj1Xl1akY3Z0u5Sie+SOnlWrugW/gBnkLKfYHhOFC+pNsJHD3qw+7X78AUnY+1lhzTGoYt
 M/mLKe4NiAWw0m5bJPSABMwwkT7cgRQ/ZAV6QAGzY00jg1UHnURZC4RubNmY0iKxf1OuGIGX7OY
 TRygGhARsUAw+AKD6UTfZ3i2rWbByidekKT22bDtL8EW8guUbilwY3o0Ta13SQhTeJ/HvRESB7V
 wFCecJhn/6r5rS1FktQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060008

On 10/5/2026 5:48 PM, John wrote:
> An RX interrupt group may select multiple receive rings. The Wi-Fi 7
> handler currently services only the highest set bit, even when the NAPI
> budget has room for work from another selected ring. Walk all selected
> bits and retain the shared budget and existing early-exit behavior.
> 
> On a locally adapted GL-BE3600/QCN6432, group 5 selects bits 2 and 3. A
> host regression built from the actual RX block completes 3 of 6 queued
> packets before the fix and 6 of 6 after it. Single-ring, empty-mask and
> two-poll budget cases pass. Descending priority is unchanged; this does
> not establish fairness under sustained traffic.

see:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag

For a datapath change I'd need Tested-on: tags from both WCN and
QCN chipsets since they have different requirements.

> 
> Signed-off-by: John <dencity7@gmail.com>

See:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

> 
> ---
> RFC validation and limits:
> 
> Source applicability and the host regression were checked against
> backports 7.2 plus the 230 wireless patches from perceival/openwrt-flint3
> commit 2365932733ca8ec3b346621d9cec2eb3df3b2cf3. The new patch applies
> with zero fuzz. The same source-block regression and exact patch
> application also pass against official ath.git main at
> 388d3c42e8aba1cfc3c6d2c52877a46d8cf740db (zero fuzz). No full module
> build or hardware test was performed against either current revision.
> 
> Historical tests on Linux 6.18.39 with local backports 7.2-rc4/QCN6432
> changes passed DHCP, DNS, 32 UDP flows and about 181 seconds of traffic
> after reboot. These are bounded observations, not throughput or long-term
> stability qualification. The contribution was developed with AI assistance.

see:
https://docs.kernel.org/process/coding-assistants.html#attribution

> 
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> @@ -52,8 +52,10 @@
>  			goto done;
>  	}
> 
> -	if (dp->hw_params->ring_mask->rx[grp_id]) {
> -		i = fls(dp->hw_params->ring_mask->rx[grp_id]) - 1;
> +	ring_mask = dp->hw_params->ring_mask->rx[grp_id];
> +	while (ring_mask) {
> +		i = fls(ring_mask) - 1;
> +		ring_mask &= ~BIT(i);
>  		work_done = ath12k_wifi7_dp_rx_process(dp, i, napi, budget);
>  		budget -= work_done;
>  		tot_work_done += work_done;


Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF74E0203
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073759; cv=none; b=LSlgUbePSDdTap+pOhZjFFyJYaNgYVOiIXwLvnDNSVFB0Pid5DIP2BDbHGYozexK4J5i9nHgsmuoVTQTIV78hNlZtfKs4SFhXLADf13q0bsaV4NSubbYC53xHZ7FGBnlkRDlPv+dVTSwfCq+s5GYy+hMgJM99A3wVfufMFqx5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073759; c=relaxed/simple;
	bh=7Pev21/xMXAZVy69Y7H9VAjDWF8LHAFtjB6ZwYz2x0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7a0pr4QCRLxNg90WTV9fAhDkET90XYFJAGnki566RC9rbx7DNk8v17hNb2LZvRK9NsISpb7SZasOWo7MKfUVNcOWStO/hK5c885fvx+6CtPuyIy0Q2BMHjnzS7UkVdAsZSCyri9pAEljqViq2tehHessvRQHe9P8vdjLinmCT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FQDr+lzh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HUybd9ae; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FQDr+lzh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HUybd9ae"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MA32G0801419
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X9Mke62+gaAnOt0SZy1qXuoQBKgzRrAMNO7a8M7rMLs=; b=FQDr+lzhfNpZk/q9
	ZVHr/LP2clap2Y5VnRWLzBCIbUXVq5s7cMc90rjTmTIuQ4EMfmk+9BX58jAjo5ar
	hqv4SV125rT/Dr009SqAt88QKAtufcsV7VI2v8ig7PBc8d75SLgacn5bbQ8eAbnw
	Acfw9BJwaD2//TAoX8JUe0hYzz0zT3WK0phPYAhH1O8YUwZKBcLhERWRvK0p4NNS
	rY4YElTu0rb6N77JP5nZj4ugrIZDJws3DQqyh77OYRDomraMsyrlPR1ZZhsL3KlT
	8H8YtBVV1QOmVTs47ndW1D2pU9IvXWLZXh/XsPZM41XTTAsmOhD9gE2e05rbKJF4
	heMUDg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guqk4r508-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:42:36 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc73ab90ae7so3511114a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 03:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790073756; x=1790678556; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X9Mke62+gaAnOt0SZy1qXuoQBKgzRrAMNO7a8M7rMLs=;
        b=HUybd9aeZf22KtnvJvo7KzwT3E3MtRuxT8mq+qdl/PHMzSIYqlHkuUMT65QN3UA4Ps
         UQ540g8AcSBlkL0BXgY2cASAcbFiSTKBqiSsUbsiaSBXoFkwOdy64exVC3i2f1BJhHAb
         DJMQa7TWmtrElTRj1sr3LthqA5XPUPuuaAIDUPJdoKvEQAuVfOq0kTlwYFYE3G+45yAl
         /UCLJrVH5ZJ0Tc1aXKPG/ImyqcggevtMVE4XhDXgJV5sYmV8dEv7y/Q+x8WMQTU+nYJP
         GwFafVfWVzj5xMVs2FEARB0DO1+7GZu2Z4AWTu0EYz7HXpWaC1jhm5f8sKBDtJsCEldh
         1RlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790073756; x=1790678556;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X9Mke62+gaAnOt0SZy1qXuoQBKgzRrAMNO7a8M7rMLs=;
        b=WTsRVmgiA+fGMU6DITBPMPBbwG8xAU/OhMQ+kpCKlWC/GImIeTYY0hOT4WWjgbZQpg
         oCQeoEBtyLv1Tjrm0xL9wYSO2pdfhn/eg85PyMpzq95vbLeber22YLr+tigC3YlJa4mg
         05vX++OJebqw7rycyAPJzzr3WvigR17Jck4hvhOdipioVHqhfeK76ZvUKyfMx9uoTRsh
         5Yx+zUiY7KmaTK+Zy97bKFVXeDGRkowvzPWfyzHQ5885+HRq+Ykt5bnG91VY6JMcy1BE
         MJgwyx2aNdgyAXGmAXpJFYDO984Wjc9shcP1bGBjw2VjV3wCa01elgYAwiPNT5c6Emx1
         yGVw==
X-Gm-Message-State: AFuF++mLVtMke2viSIkTb8tWl0nrwUI3MDNQ4OEtlttPoyNC80aMdGkq
	/AhJ3HO8XzJZEd8H7dEZSjmfgInhafSe8nH9wX0rwabAVGyUhBuO/V1rBxzYymyi2f+A8qOOqzx
	viqEKPzvh29qv0Woy0bqupw3MXruUwPS5vXt76Bj0WWU2VcSSs3IHCCNJTCZj0fuNxmyp1Q==
X-Gm-Gg: AYBFou2hLgsplq0rfTMTtVfnnplZ6HzeSBLuU3eCCkVnYOgRC2fzHTHywv1HeJc7gb4
	oSN5/R488EwuZCDGSSD0iao6ncPR2xea+ggJWBN54KNABXV4PRIavJwW8mYRMtYLQdrADR5pRlL
	saQOfwgagXbBGNm413gozuaUKdqM8ImW+yJQRdtMvAjPmB08GU6kGwgvNZ27l0hfBNuskf1oIfU
	D2Mv86EsGllK8zAgQZLvtAvFm+jM+ziMizDisD5xf95jUo7pWDnNY9ssGqV/BFutGvzLDFUCAEb
	0IJuKDkpfm4vXssmU7sMnpbqufRdxXQu8wdep28AyJ1biklXyRIY7baHksjeCcYPzbFAFuH5Fl4
	471vxbt2rXtK00rw8mnN3tYkQpSBuzbZ+kQ==
X-Received: by 2002:a05:6a21:b82:b0:3dd:a196:9077 with SMTP id adf61e73a8af0-3ddec87d604mr977524637.65.1790073756249;
        Tue, 22 Sep 2026 03:42:36 -0700 (PDT)
X-Received: by 2002:a05:6a21:b82:b0:3dd:a196:9077 with SMTP id adf61e73a8af0-3ddec87d604mr977486637.65.1790073755768;
        Tue, 22 Sep 2026 03:42:35 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61271041sm4824734eec.10.2026.09.22.03.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 03:42:35 -0700 (PDT)
Message-ID: <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 16:12:32 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
To: Johannes Berg <johannes@sipsolutions.net>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
 <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE1NCBTYWx0ZWRfX+bElDpWULtlf
 9YH3gBvpNOf3lpsof1JnlMg6ttQaFAwSy2uGZadUxM1mHrLRUI1T3A1akPXF3E+UXlf6hYHiH/v
 EUr/5KD8X2rxvXCAkZBsul6fxuqk3wrj0Qxy0gMm+slHUPBKbIItM9uWf1YO3Zor4dKW2p9Bfbz
 oG8cxdGo6svgdZeIuOXEcxnnRlM1d8b/KZuKjm3Ua19/uux4yItilF0QmSYpyhamMcbInVWD2o6
 oqt3V4Rk+BE4BszqtZ5wRBRJ1Dn9tPQo4kchrs1JMfREJmd3/cjlCWYY5gytPFt8tiwD0f2yM5B
 ZvuS6qv8dRzU7zPUOZzSOGkzshC5X5OcUYGq8rSu4FG76D//VWpO25+F++YdwxTJHXIz7mMPhMb
 cuySFcMzotv6IqxKbmof9dlVLKlAcCzEU8ZyQjQ1iXTCx8eOiaZnacAg3Z/IbQ7zZultlpyCbDT
 I818agJJSIs5K1xfBoQ==
X-Proofpoint-GUID: w9BMVaJUWHD5llb-XTrco7PA-e9fvG4f
X-Proofpoint-ORIG-GUID: w9BMVaJUWHD5llb-XTrco7PA-e9fvG4f
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE1NCBTYWx0ZWRfXz6dsL1fCi3dV
 ecmHZTdX7JIRArx53vuXIppH+A27ktWdMwEmLSu0Na4Cszb2CMR+0pFS/bsolKnGMOcMyCpHC5H
 U8v35UiODob0snLl1RZGeTYDhudnSHg=
X-Authority-Analysis: v=2.4 cv=XrVvqlF9 c=1 sm=1 tr=0 ts=6ab25b9d cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=9xC9gAlW16PiWnXnPz4A:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220154



On 9/21/2026 5:21 PM, Johannes Berg wrote:
> On Tue, 2026-09-15 at 10:59 +0530, Aaradhana Sahu wrote:
>> AP_VLAN interfaces do not maintain independent BSS configuration.
>> When station information is reported for a 4-address station, BSS
>> parameters are read from the AP_VLAN interface, causing beacon interval,
>> DTIM period and BSS capability flags to be reported incorrectly.
>>
>> Read the BSS configuration from the parent AP when populating station
>> information for AP_VLAN interfaces. This ensures that beacon interval,
>> DTIM period, CTS protection, short preamble and short slot time reflect
>> the parent AP configuration for both legacy and MLO station dumps.
>>
>> For MLO, the per-link BSS configuration is used so that CTS protection,
>> short preamble and short slot time reflect the configuration of the
>> corresponding parent AP link.
>>
>> Only advertise NL80211_STA_INFO_BSS_PARAM when a valid BSS
>> configuration is available. This avoids reporting zero-valued BSS
>> parameters when corresponding BSS configuration is unavailable.
> 
> So ... I guess I can't disagree with that - but is it worth reporting
> any of these parameters at all? They're entirely under control of
> hostapd, so it already _knows_ - is there a separate tool that really
> needs to get them via the station info?
> 
> I'd be tempted to just _remove_ these on the AP side rather than making
> the code more complex to report them correctly, in particular since
> basically nobody could actually be using them right now since they're
> just broken ...
> 
> johannes

Since all these parameters (beacon interval, DTIM period, CTS protection,
short preamble, and short slot time) are already populated in sta_info and
are visible through the iw station dump command, I only made changes for the
AP_VLAN case, where these values are currently reported incorrectly.

I am not sure whether any third-party userspace application relies on these values
apart from iw. If we remove these parameters from the AP-side station information,
the iw station dump output will also change. Would that be acceptable?

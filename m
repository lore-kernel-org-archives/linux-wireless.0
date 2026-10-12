Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5F4A4F0F
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824045; cv=none; b=FR8VFd0FmXFyVzKnvqvfkyHwPC4nU9/7mURSJ9QfQUJFovp2V1VzptZdgOaSnUvsWwNYp9btcbXn+9CbOp9TrBPsTTI4sT5hz7PhYxPt7cU8aVwXY/rTa3Caw9sdNmKiSkZ5Uc9PwMKpFcRiDWeIkoGJjZEoqUvDdX9xmwQLKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824045; c=relaxed/simple;
	bh=MBZlHXmk37tR5BT3xXEOjrgo/bHRwWaQK1AS7dscABU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Au0kwRiOd4340v8vfk+ik3+W4A7Qe16b6hwvm1/0dEOmjoePLKLx8N4/MsEK9Gu+aj/6KXdZKrgCZ3cGQ4R2TEieAhRbJgg6XnOvfvDpZeiiFfbBw+tbtPLNlBjCYctQIN96pIO+MsV3iQo9PgRWIjbPQKAF1fY1sI5tN3GgDtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pIvCpBSh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Utv2V9R4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pIvCpBSh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Utv2V9R4"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFescT3272314
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4AckRZKhrIfVKIkA99O7IMf96v0rYfiQrck1GyiIbas=; b=pIvCpBShCD+MhrCT
	LahX8GWl+Ogwdu1PhX9brdO3bWoKRbm/QmqwZXv5l3cw50rOzeAeMLrI82hQfGyF
	cadnwuI/whfPfe/6TM964zA30QZmxhxUW3d6NM1wArAfjy0WTvMkQq6ikz0HG4Ke
	tBPPX0+DfAox7nArJ6adgWlbuDsLrebMnk4Y4GQNe2B+7Ks5YgrHjeYsY/WCqRUz
	k32/08I1lxvfU0hpLXncrNLkmaxgpwj0owUbnr+fZO29VGwzu7daVQ04dsSUo4ft
	7XlOAIxtl4yEvqBzepnRDTFGYKSbCRWEXvWnCOTyq+BS81vTYHNyubTF5vgI2zYy
	zETIoA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8wffht4x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:54:02 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3592749a017so1732493eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791824042; x=1792428842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4AckRZKhrIfVKIkA99O7IMf96v0rYfiQrck1GyiIbas=;
        b=Utv2V9R4wBygEdiF1+LBcHo5RAZsXMf73BvNyxPzF0v8D26Gj6YOhguD6E7tnXhQkb
         gMxD+x4eTU+12h6vSsYsc9TnjvNglFN8Ge+LIFRmQ8e88mCOylKHOTtwYt3gHHlopR5C
         xXCamAiLnNYq2PpZsoyJn1fjPXPmf4Wv4Vg7ceFgkfN/DlKiAnQyxmwPfnfQ8dn94Sri
         WxQEbrZVWeekU4PBWQaDUQQu5GF6vmp4d0MNQldOgGNxCz8QH1Cgr72UYX1ImoyFrg44
         LdafeWb5bpdyYw/hSNT2Y9jsngLgQUqdcSBu7jbTAoERi7E42LANNtlasUaTjbxjsVe5
         3thA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791824042; x=1792428842;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4AckRZKhrIfVKIkA99O7IMf96v0rYfiQrck1GyiIbas=;
        b=GsdCbna7qwj0JFAhgOwT1dgq0a+WmtBxXmZXd8+mqVZx10NHbOPb8WQsY3ftTmy7lV
         nkN8GWhA9pv4hD4FhUIzHe1zue3oZQpM2uLNgUGDWm7xm4xKFAbjI8seHzCYEzz9JPEC
         sZ0zQhGL694ehND3kbFN188iKvwj6828hEpWfvA548Nyg5KseKYZIvUeBBpMQGWtPF7D
         tVhdDrOCvWlkrifS7xGBuxDTvzXkD2qrqz3fglS3ISem8ykIs9UpzRH96UolCESy4p5M
         uO8J7LzP4CL8SRTlFO/nsPqx4gLBj+MKA7N/N6GYp8VVVvfp3tBu40Tq0V8LhyRoE3n5
         YoXw==
X-Forwarded-Encrypted: i=1; AKwUvBw1xRgJPATkdXhY8Oy1AHocMmQF2G0pzOgYxJJs6dagRcrIXyV1eauhzuY4HPeM1GwLbqPOub45fannvdfuWA==@vger.kernel.org
X-Gm-Message-State: AFq9FYL6bxPqyQV73vyX1dZ4mtA3p3UzNRSSIZu4Bq4l8x+fzlll0x0l
	INCEwEw8xX7tULI6L9FVIWkmGJW7CG8ISEqeV8keeQVu7IBFh21cLSrnjIkLxcD33RMLN1XRTR3
	iDsdaT1DMqZOOiWDu3JE7rGOqo4mX7rUVEOZJUTBqXwHhKfoZCEk2Yvs7CJDOVw1UNaQopQ==
X-Gm-Gg: AYBFou0M9m9ih637cV0mBqMkB3lyCrVKRvVISveQn5h0jWMhQfGQ2004NgoD4jFQapI
	B1oRbh1xg06rsT8gPF6qvsIWDch6spROCOgXoxi52vil84ISca909izZlc6KrjqkEPfHgtbrgZO
	iAdut0SiqBU8laEZcrUPQqhAke8cdLfFwbxWEk2PJwOeOBxsKp6Ss5Y/s+8JkIYtzBxPpuqpyaf
	Dxw2k2vc9X3VHGcJaOVi2OhNFb7tWzll8NLMIXPOfb2XVrP+A83giI7Yhrmly8WJjCj579foWdq
	p7E2r5D59vz89htJhLLtPyY+XUCEwFWElMTOtCdKBNTEyP1e4RA3KeMkwjkJJFevDOG2+0j3FcA
	s4LXQ5DqH2Hwn6FvnN6003gg8Xq4t3GCewohd7+DFwVmn/HSJum6QPT2ypQ==
X-Received: by 2002:a05:693c:839a:20b0:35a:e354:643f with SMTP id 5a478bee46e88-35ae35465e1mr4121574eec.4.1791824041812;
        Mon, 12 Oct 2026 09:54:01 -0700 (PDT)
X-Received: by 2002:a05:693c:839a:20b0:35a:e354:643f with SMTP id 5a478bee46e88-35ae35465e1mr4121519eec.4.1791824041002;
        Mon, 12 Oct 2026 09:54:01 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb68e56sm32044009eec.29.2026.10.12.09.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 09:54:00 -0700 (PDT)
Message-ID: <ef08eb14-0732-4c75-9f69-2173cba91b65@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 09:53:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] dt-bindings: wireless: ieee80211: Add
 disable-rfkill property
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
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
        ath12k@lists.infradead.org, Dale Whinham <daleyo@gmail.com>
References: <20251220-surface-sp11-for-next-v5-0-16065bef8ef3@gmail.com>
 <M7kfFb5fz-WB43U_xCUwgxpmBJ4TNdp4jE6yFu6HmemIcDx5tXO6H4xnW_pEQz6DMkKm-3POdB9hIdB092zhGQ==@protonmail.internalid>
 <20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com>
 <e0e9e690-c56e-4b56-90f9-2af46a7feaf3@nxsw.ie>
 <20251220-fervent-mamba-of-sunshine-f680a8@quoll>
 <571681d6-67f3-47fe-9a42-dce5aca13c99@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <571681d6-67f3-47fe-9a42-dce5aca13c99@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NyBTYWx0ZWRfX+oHJgm1ly8zQ
 WtD81IS4XXFevnJGh4AGcknmZSc8l5mGtXHvWo+4vb2RVKh4Wj0Lu4egA+JwSJTawkVO6bNJi4R
 mvht6rwdOtxwls8/JSAxPRGyopy+9fDXX/BekVg5rCqxsxuYF9kw1/ckdlxtrnOzBsCziDy4C7g
 n+3d5s6JFAJOuBRKXEcLhP8paOrv0J8ZnjPq92rTSaHn1VW+bS5RWDox8mIPIAZEWutxx01q1P0
 fsj/dXxQP1TALkCv8Kx0qEHeIi9Wq6rHLE6R1hRm0BBqR93Xx5mxzzRn07Wn7z2TmsSSWTIpLvW
 UpsnTk+v76PCiTW4Li+SR+ptsfD4a3vLTqsSQU9bFSa325YW5h42GAjYHYZZjYxDXS7HBf87xo+
 9Ip0N+/OYwHCDCbSzEO7gDFPT5OmQ0HvlSMPZeBXoMMzxGf3ashopNNrqeBPik55heNe8zATxtI
 mZ2kHVaOAz7WuWsTxyg==
X-Proofpoint-GUID: u_AfWUj55nc-ft6jXOfRadziHFT4tJRW
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NyBTYWx0ZWRfX/C38WXGs8WVs
 nC0gxbPRk9M9qzXTDeWU4FXrBXzfGavFlT9+1XLNRuP3T7huOIgUMC8Jl4wBXIKR8mcH2WyjNaN
 qdt4EKsD9bcS3DIbEI9sUzQET8dI7OM=
X-Authority-Analysis: v=2.4 cv=ZcWIpcVA c=1 sm=1 tr=0 ts=6acd10ab cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=pGLkceISAAAA:8 a=IdRum9UsuwhjULrUfLMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: u_AfWUj55nc-ft6jXOfRadziHFT4tJRW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_05,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120067

On 10/12/2026 9:38 AM, Konrad Dybcio wrote:
> On 12/20/25 10:12 AM, Krzysztof Kozlowski wrote:
>> On Sat, Dec 20, 2025 at 06:04:00AM +0000, Bryan O'Donoghue wrote:
>>> On 20/12/2025 00:21, Jérôme de Bretagne via B4 Relay wrote:
>>>> From: Jérôme de Bretagne <jerome.debretagne@gmail.com>
>>>>
>>>> For some devices, Wi-Fi is entirely hard blocked by default making
>>>> the Wi-Fi radio unusable, except if rfkill is disabled as expected
>>>> on those models.
> 
> [...]
> 
>>> Is this really a hardware description though ?
>>>
>>> Its really more of a logical/functional description. It tells the runtime
>>> what todo, not what the hardware is.
>>>
>>> You could also have a list of quirks in ath12k for this or have a user-space
>>> utility look for the appropriate platform device string name and disable
>>> rfkill.
>>>
>>> I think this logic belongs in drivers/net/wireless/ath/ath12k/ triggering on
>>> a compat string.
>>
>> This is good point. Either this could be deducible from the compatible
>> or this should actually describe the hardware and whatever is there
>> wired/configured, not what OS should do.
> 
> Sorry for digging up an old thread. The board-compatible change is now
> I think merged into ath12k, but I'm not sure I like that, as now every
> OS consuming this DT has to carry a table of board compatibles (hence
> needing updates _every single time_ we want to support a new device),
> instead of being able to convey the quirk through the property
> 
> Perhaps we could revisit this approach?
> 
> Konrad

I share this concern although I hope the number of platforms is minimal.
It does seem strange that something supported by ACPI is not directly
supported by DT.

/jeff

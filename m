Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC03F2690EC
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784250602; cv=none; b=GNSj3IPSa36SDRwQwjz6Dn/b4C6HCnzewb+0WT7QX16cFNDPqki6tSssBuWk+RXbW6Kd7uxmWdH2Cg7uBOxlDIlZvUqzKCZNIAHLQtfTo1Ya0NTBfEh4cOmjnimbzXH0HEvtxcIIQLJOxzlcyleFgny2If313trdV4gfjQyR7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784250602; c=relaxed/simple;
	bh=MHFELH/BNeKhAiqUootYQcmY4DkNuX1UUcGOtFbkW4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgVKq5f/FS9SxBEx4HJNf/CFF7C4Uooca4DzsVs3mbqiVhhSYzrgD/BsFseAfw4vbM6ij9GeUyMvNw4RzQ600pOgQ2yt8nabWK3gVjcNRWz5pN167W3dgDTvZunby/ONDHaHThjhW2khcpV2GgxPHywDlfjLC9zWEPrA6XG/bKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=efma3f/I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gVGPcLY4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="efma3f/I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gVGPcLY4"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNJ0AK4026103
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ipbk0KyZAgxVfKwT0bLjaf/pXu6NEEirmBQGmu9UsNw=; b=efma3f/IUsU7Ztog
	HN54YeIVpD//RLsxD60yD7wqvKq8w8N6x5bMhsUs79n9Uz/wgg7D+YNM7S/RHHCW
	HyOh4B4CQqRLTHZdYWVZtY62za4RJ9YmE2tcYHk6cCTMntTfpsiZ8F3YTRvTMz4a
	w84oWI6Kmdrvp7GVElN4u8qY0mFcc1kAKMStrwfwqr/04iSPheI+LEiAj/u2gdDx
	L+AiKkOwi6zRzjYYEGGvvyJm+7UeK4qrLOTH07hHBv8ff1sLGNfArSuQm2aYyPSz
	NhQyVrCnDYxO57d+A4OXGNxyzY9C6DKdCicFPiYuX46NJLDBzyE9aQURlrirjtkH
	kzuCUA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff3u8hegn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:09:59 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso3940062a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784250599; x=1784855399; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ipbk0KyZAgxVfKwT0bLjaf/pXu6NEEirmBQGmu9UsNw=;
        b=gVGPcLY42Xnkk8Dq1Jqh23l5NbeYGvpHzaEECuB3s3GGk0hU7wx68Wh54Nn95xuEEk
         0lgvXS1DIq8aUib0Sk7Vth6DX+kmwbtM/PiOCIhIkOvH6T70LWAc1RI/t9YiCDoHkTih
         1G9wDhG0CQSk37i32lcIiTzgMdg9K7R/qLBzVZ527X0g7BP8mTXT2nsBVf+340kF6EoA
         gIyUAsfAb604vJANRukEruhini+mvppiIqO4w27nDw8AMYaZdF/bHLDS5egft+fubn82
         hlzn/WSYRpgrZe1uH6H5pir31lRBx4viP0ZuwtW24cEZ2NHnthi3Z9tSJCpiBvyJjnX+
         baeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784250599; x=1784855399;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ipbk0KyZAgxVfKwT0bLjaf/pXu6NEEirmBQGmu9UsNw=;
        b=MtvcQqZ2oqOPTTIj0eBdW9mQkcaqmikHfB9vaRUAiTzJ0hZDyZkNpHwa9PRkHRw0ui
         s5dyg1cDwjyKS5a4M8m/wZZ2uLcQf5KS5F7TrMswMBmgkt3p0GotNBbyE0s4K/SfZBnH
         UztR2OaKkDkb8SXjjGvlnugzYBfpr9yxYWBZwg4rNPxZPX1/hI2A5ervB50yGINTfqYH
         IaINJ4daEVRQ2SMFnXvw9P7RN58l0cuD9Z818WSc9KhKsFtkwDYqzz2daS0Ue0t6T8/r
         5pnJaU58aRLrDMCt4bhtOETP5yaNCN0PQaAJFwF5zP0akNid7BuqIaFHGSWkehnDGjev
         T3gQ==
X-Gm-Message-State: AOJu0YxT6S74lu8AR/tgVnS3maRQ9iBrHjN4U/AcGaJVn99gMP9CV1Jq
	rYSCHdq/mKoaLJhWBVhtRb7kOx7Gl35P7aBDXk+d7FsZG63A6p6I1a7ajSOdpYUCJ9TCYqaEWL3
	rfBBmFD4jITMYvBKB19YOKb34aW1u7yXZLN0q0ClQ7RwZea7tdLhRCZlZkulXuF7gJUsDUL8PS+
	IqiQ==
X-Gm-Gg: AfdE7cle2jZ//3kvJsSstaAdZHqcNzp7KdpYeukZ4Hz1DDJuTHSS2aoF7j7s4Zk9arO
	gi0dxFgR4Yfj5SCbddHliAhcBih/FSDPXUt8kfdbPS3y35uMSdEHEqeAYDYf/86w4+e2HQmIQqQ
	gHEo2RhrXpdYR1SqbrHRcTLBM6EENvTKX6bNO/XP4p7FU8p1he3ouLOITKkP+FJoNhFA4drKNYE
	o4ZjVdleI1ikjT69Z6geDgcIZRhhxEz6lEJQAiHuIUkId6cEMoQeJGcUf/dsV7ib4p2WGC9LZ71
	zDjZ7bTL2c/BvNt1wTJmBY7x9wmKrOe5qLhiTScUg4XtICcepN6dX6rLc2Cu7vmFTjh3A+dC41U
	oHG9OG98butrSl9xnLRn1jepxuQ50hx4rtL9fzBWjSeaZvlJHCvkn2QEYDg==
X-Received: by 2002:a17:90b:2e46:b0:38e:2a4:cffc with SMTP id 98e67ed59e1d1-38e4b507f42mr403707a91.25.1784250599015;
        Thu, 16 Jul 2026 18:09:59 -0700 (PDT)
X-Received: by 2002:a17:90b:2e46:b0:38e:2a4:cffc with SMTP id 98e67ed59e1d1-38e4b507f42mr403676a91.25.1784250598398;
        Thu, 16 Jul 2026 18:09:58 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm1034921eec.21.2026.07.16.18.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 18:09:57 -0700 (PDT)
Message-ID: <22af4340-5014-47df-9c8f-17ebcb834e64@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 18:09:56 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] carl9170: 802.11n compliance and driver
 improvements
To: Masi Osmani <mas-i@hotmail.de>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <AM7PPF5613FA0B6D188CBDBAFC0CE13247A9444A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <AM7PPF5613FA0B6D188CBDBAFC0CE13247A9444A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: TUV6jHeujX-fQKve40Z0wSMf7vI-DRPS
X-Proofpoint-ORIG-GUID: TUV6jHeujX-fQKve40Z0wSMf7vI-DRPS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAwOCBTYWx0ZWRfX7Y08xUcXBeOX
 /17SOXeZEmHRPTgAodkYFqeQ0pN8CSJl2aJsa/UOKci47BD83RfJ1WxrwHO+AIW777yqMpmyrM7
 //uMUcClBcsl1faX265nIZ4iSK2qPuY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAwOCBTYWx0ZWRfX84/t6to0lqx0
 Y2lXhW8/F5BYkORnC6vjqVHTlj/cYdvSVgZ5p111wyS7y+VfWm2/YF5e/w+QK35ykgMq9TW05mQ
 kFZmzAfLjQOL1m60cYnCCMLjkgVxC3Jy6xrwfjmRDyYOXvs/xKEYycQcidpwKtuYn6wmCkIIE9U
 Dgyh/dADckOPDRtXdXrC/2Kj5DK3OQFk7hBp/AO4719ERpZhD4GQPAWi779lrb9rlsLNSc0WZik
 0UoV6htU45ki+7wxxIFrhy/GUb38RedvC781R9T56SQ/PaTOoyy/OIVQ8/YxnM572Vo1P5qrIUb
 zbj1ISc5BmF1MY+7HoRVRNAXem7ge3xiLhmcB6vqEp/HKHFTld3yDnLclYU1Up934dLBrR2KjgM
 ZcK0eJ1WjKSDH35IGn6lQ1J896dKl62P2YIJeqkT2efPwWBB9d1cUEYhEUYmvtXDMBr93t9yuw0
 YCiW+o7+CpGgSJfX/gQ==
X-Authority-Analysis: v=2.4 cv=TL11jVla c=1 sm=1 tr=0 ts=6a5980e7 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=stkexhm8AAAA:8 a=R1apqIA2do3W_8G80JkA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=pIW3pCRaVxJDc-hWtpF8:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170008

On 3/12/2026 3:37 AM, Masi Osmani wrote:
> The carl9170 driver for Atheros AR9170-based USB WiFi adapters has been
> effectively unmaintained since 2016.  While the hardware shipped as
> Draft-N certified, several 802.11n capabilities were never advertised
> to mac80211, diagnostic counters were left as TODO stubs, and some
> hardware features were never wired up.
> 
> This series addresses these gaps in 10 independent patches, ordered
> from simple HT capability flags to more involved PHY programming:
> 
> Patches 1-3: HT capability corrections
>   - Enable SGI_20 (was only SGI_40)
>   - Advertise RX STBC (1 spatial stream)
>   - Document the SMPS handler (replacing bare TODO)
> 
> Patches 4-5: Diagnostic counters
>   - Wire up the RX dropped frame counter
>   - Track PHY errors via debugfs
> 
> Patch 6: TX power calibration
>   - Replace hardcoded 18 dBm with per-channel EEPROM values
> 
> Patch 7: Recovery hardening
>   - Add exponential backoff to prevent restart storms
> 
> Patch 8: Antenna diversity
>   - Enable fast antenna diversity for 2-chain devices
> 
> Patch 9: DFS radar detection
>   - Program radar registers, call ieee80211_radar_detected()
> 
> Patch 10: Runtime IQ calibration
>   - Periodic I/Q recalibration via existing stat_work timer
> 
> All patches are individually compile-tested and have been verified
> on real hardware (AVM Fritz!WLAN USB Stick N, AR9001U) running
> kernel 6.18.12.  Each patch applies and compiles independently on
> top of the previous ones.
> 
> The ath9k PCI driver for the same chipset family serves as the
> primary reference for register programming and capability flags.
> 
> Masi Osmani (10):
>   carl9170: mac80211: enable Short Guard Interval for 20 MHz
>   carl9170: mac80211: advertise RX STBC capability
>   carl9170: mac80211: document spatial multiplexing power save handler
>   carl9170: rx: wire up dropped frame counter
>   carl9170: rx: track PHY errors via debugfs
>   carl9170: phy: populate per-channel TX power from EEPROM
>   carl9170: main: add exponential restart backoff
>   carl9170: phy: enable antenna diversity for 2-chain devices
>   carl9170: fw: enable DFS radar detection
>   carl9170: phy: add periodic runtime IQ calibration
> 
>  drivers/net/wireless/ath/carl9170/carl9170.h |   5 +
>  drivers/net/wireless/ath/carl9170/debug.c    |   2 +
>  drivers/net/wireless/ath/carl9170/fw.c       |   3 +
>  drivers/net/wireless/ath/carl9170/main.c     |  45 ++++-
>  drivers/net/wireless/ath/carl9170/phy.c      | 194 +++++++++++++++++++
>  drivers/net/wireless/ath/carl9170/rx.c       |  23 ++-
>  6 files changed, 261 insertions(+), 11 deletions(-)
> 
> --
> 2.51.0
> 
> 

In addition to the 10 patches in this series you then posted an additional set
of 2 patches (labeled 11/12 and 12/12) and then another set of patches
(labeled 13/16..16/16). This disjoint labeling makes it hard to track the
patches in patchwork since they aren't all associated to the same series:
https://patchwork.kernel.org/project/linux-wireless/list/?submitter=220736

In addition, the 3 separated disjoint series aren't threaded together in my
e-mail client.

Likewise, posting an update to one patch is not handled well either:
[PATCH v2 07/16] carl9170: main: add exponential restart backoff

When adding to a series or updating one or more patches in a series it is a
best practice to send a new version of the entire series so that the current
state of all patches in the series is captured.

That said, 3 of 16 the patches were ACKed by Christian so I've picked up those
three patches into my 'pending' branch:
carl9170: mac80211: document spatial multiplexing power save handler
carl9170: rx: track PHY errors via debugfs
carl9170: cmd: downgrade transient register I/O errors to wiphy_dbg

Note that I added a wifi: prefix to all to align with the wireless patch style
as previously reminded by Johannes:
<https://lore.kernel.org/linux-wireless/9d093d8a8df188c99b9b652bb56a5c1faecef6c7.camel@sipsolutions.net/>

See:
https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/log/?h=pending

Once you see those have been accepted I suggest you rebase your work on the
ath.git main branch and then post a v3 series containing all of the remaining
patches, incorporating any feedback and experience gained since they were
originally posted.

/jeff

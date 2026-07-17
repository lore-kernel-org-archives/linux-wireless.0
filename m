Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175013C1403
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 07:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274306; cv=none; b=DOXAF7BvQAXGPVAu9Nq/fywbDbFfKoCHyJ7WwumGiEnKn1H2DJWO3eshxA9ZyYppmFdgBwYD31rDK39oFpxvL3a1g6gGqInhDJuIEqlnM3oJqrBSlQpdCf02ObThGmyZ4CcFcf0bTniU3Q/p7l9tHyZKrRVopWDS3Oy3/GHkWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274306; c=relaxed/simple;
	bh=nV6PwD5p2w+n20ZeQg4Zm5WubRkKiNpU4lsFdd0dXuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSPMFsBP3phODPrIV2HFLp9CrqnmDVzJJQRvs4m7VyaTd83wquAzViOk4GiutAwlg79CQtnsrA+tScFksG+z3cKP6Y6ih1jGoKi1KttMN/4LhWFP8mGI4qNOXNHnWl5qdbWSqlf5qZ8oZhRRkZZjYG1cqru6jphIfTxTIrYGSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AWwz2P7k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SHaRtPoq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AWwz2P7k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SHaRtPoq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6crqn1079322
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 07:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gv8jlUmjaJRUZYYxeNzZvFoNCdmvWcDQlPQfu3CXgjA=; b=AWwz2P7kkJfuOybl
	b0WIzyL1mam766eYMDWU9EqulLP8ez+xXNp2HBIraMZjIHbdZg0hQQQ32hUpaJS5
	lvr3B0i2ksH91FkHm0Chn7DfpuAbmMQl64AeWzl5UfIPejbq2y0KWfiBRXSheFbN
	KTbY1GNSV9zjm6GFRFQDnQvWQSKrFMeL5huBU+egW1hcRkAYX5PK3KogOY2EAPH4
	qOijl5vUgsrrILAcCJaotdktHrvKQXmVLG8mqwovDRP8yjGmZWPEOKmV2XRnI7sm
	KY0HT95ZskIdqdViJL4/Em7ICCHPMQ+1sVuBZjgB5U/CTMWzBcajuoCtpv2ZH+u9
	uKmy3Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feym1c15a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 07:45:03 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cce870a060so135481415ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 00:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784274302; x=1784879102; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gv8jlUmjaJRUZYYxeNzZvFoNCdmvWcDQlPQfu3CXgjA=;
        b=SHaRtPoqkVoHE6mt12l8jChrb/uNAf5a5B6HueffwCIjuJny4JPsc3bA6x4frzR7/i
         kVk6jjGFS7xOMi0+XROYD2xfiALaVowidSvCrd4jNDBMmXptoBjn7NrApufGydGKgLxD
         Z+XHdW8sSLsxekoZNIjIy2b8XpxQTNZ0BRLsjGvrWp+JvTqU585yKehBBT1OtW4QB6PT
         bmV3HKlkB+DyYhkNj1zzX1LF7fZgFrtVq+UyifVgbWhWZ4XTILjkInAINoPSLv4y+KBE
         k9ImqGkNolm/Tr4UxsEYf1pOyCbTlCqA9WvLIa24+azfrAnHsXsyoHnfWUa2HVRsoMK1
         CX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784274302; x=1784879102;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gv8jlUmjaJRUZYYxeNzZvFoNCdmvWcDQlPQfu3CXgjA=;
        b=FAxVQ50xFWVlguJdG711apo6fb7HOTyhlCfluw/UC2jg76oHpp+exZdCOkvoIN9FEu
         VtJBLZRaY7xmyZkR4SVJtE6ZoblaP4C1NLKzM1JPd0EJPTYppfLB2cmcxi8qXySq0NXS
         l6Ug7Ve21W0e5DQTdbp3acCt8UyOwSo8owbGx9zW6yPm9yjIHuvVYb2JcboyFO7jQrlD
         c3uqpoReBhm8kbvY9zDEKYIGpXarjFkErpWzrMAWSTb6G2cDmQorkdwHHDYh997P+VDF
         qqzth3DrUnrSdZoylrxwzwjLLAiPS3Xz65jdwto4RVCBQcpWfgrkXoUuvNSuJGiKAfau
         cOWw==
X-Gm-Message-State: AOJu0YzfTr7rxmzrhbdcZKK4yCgBGhBO2CltzXaThT80hKgNyzGCJHb5
	edRmp70neL4XU8yq/xrkul7cCSvW/cGEvXWcQ8Dmbhlg3XNqSUfKriER+dUn625uySuKQY0VOhs
	FYgyVMH0IU9h1Lme2AVGZ70IO65Sivxh17r8hSdWLJWkc7jSgYqOi6147axMN67HO0rhHGQ==
X-Gm-Gg: AfdE7cklIGbIZAedpX60suInHcRCkPV6FFtoMec96wUfhOCUxpY+OQW6xBdznN5oTTv
	tCX6TuwYKmKXuDVRgxIfm87KAXYVzjSs9FAzhPw0v2f+FicjtJIc+Cu07vwJXFHpjOwumClbiql
	3+sMnNv9somrVhjfVnF5tfkz6lWyuvtLNyZZ1CAwlwUkcl1oa7sLRqoZiP3NqiXjMcOkFCsprgS
	ZLjzrzveLD9MJAHh6ypw5hPZYqzytSlMl4aFDFrj4kJ3muhrY3EGlLHUotSCLH3HYtXym1QXc1r
	oMbBkGy66rtmS1DzKLcZY8snCMpn/EG7Enr5naP4UPR4u7ivYgpiVfVnPkD7t0fpQBYkQGXC27W
	C4s13xIf47OO5PE9I6cMrm2WYpRaitWuqWy+pS4sL+9m9wmpK7JPHax7DSppoddQ+MYWbjts6
X-Received: by 2002:a17:902:cf12:b0:2c9:97a7:71af with SMTP id d9443c01a7336-2cf349ed678mr15082805ad.42.1784274302519;
        Fri, 17 Jul 2026 00:45:02 -0700 (PDT)
X-Received: by 2002:a17:902:cf12:b0:2c9:97a7:71af with SMTP id d9443c01a7336-2cf349ed678mr15082435ad.42.1784274302047;
        Fri, 17 Jul 2026 00:45:02 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448ee77sm6140005ad.4.2026.07.17.00.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 00:45:01 -0700 (PDT)
Message-ID: <1bd4f373-365c-481c-83ee-94a304747cc3@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 15:44:57 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: WCN785x firmware resets regulatory domain on resume
 causing ~7s reconnect delay
To: Stian Knudsen <stian@pokerfj.es>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <-_iDJ_M5RrqACWB0qmtleg@pokerfj.es>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <-_iDJ_M5RrqACWB0qmtleg@pokerfj.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KPRqylFo c=1 sm=1 tr=0 ts=6a59dd7f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=FhP73pfYAAAA:8 a=VwQbUJbxAAAA:8 a=6fZViXMljCPv9DoXK40A:9 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10 a=GvdueXVYPmCkWapjIL-Q:22 a=KIQ-tT4kkC4jZbePahcr:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA3NSBTYWx0ZWRfX5r2sxNGu/t9c
 947B9KW9dt8eGK6lk5Q1a9TfiVa5317NzJZXU6j6LkKsoSt5fi0GqHkyXRJb829smt7sRbp9usb
 iZjWkHeZd/4PMNfm/KyR/DeBdpqGsffpNkz0yDzfwcZN+ghliisFsiFwOys7kOXL3lFaBh4utl+
 ElryeBp3AuP9RVCNj5zIeM1x9TwEMI+wkqDPvVKEkcAuuvnndaELN6iIo1myY074Cp3Rb7TtLOM
 vbIZXC2tq0CgtYYUhzYbH3Uc1ye2duAtaQmc2G9sjvGvjbH2BiC7TlnxgNlTsSR6MOWrgRbW2F7
 4TqXzhC7Ymbh5tpqgyX0yDbYTOSZJFq1hQoXOmWPUgE+9EBKtk9rMFbg5I59/bNYrBuXoGz0TNw
 opBVnePMm3FCGHH8o9QlwDU6Ht0lIjNTbLCHNteJEELJV4qdDkh46wx7EwoFq2HMBW6uec0w3pQ
 lwZaYPpsvgfKkuDtwaA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA3NSBTYWx0ZWRfXw79HoshI5y7j
 /e4jo4l/GAXjBrkMvDBIIQEONJJiMvBWtbqppYGhnuMqQEpq5W/BkUxeCxlwCneggWbua47lOek
 Qy6ZmAMBzSIlX30KQgWa+6p7k0ci9GE=
X-Proofpoint-GUID: CTVXempmIUyvg0rL9G-NepTxHxVa5L-t
X-Proofpoint-ORIG-GUID: CTVXempmIUyvg0rL9G-NepTxHxVa5L-t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170075



On 7/17/2026 6:35 AM, Stian Knudsen wrote:
> After resume from suspend, the WCN785x firmware resets its regulatory state to
> WORLD and takes approximately 7 seconds to re-discover the country code from AP
> beacons. This causes a consistent ~16 second total delay before wifi reconnects
> after resume.
> 
> This is an improvement request rather than a crash bug: the driver currently
> contains no WMI code for saving or restoring regulatory state across
> suspend/resume, and I would like to ask whether this is feasible.
> 
> Hardware:
> Lenovo ThinkPad T14 Gen 5 (BIOS: R2LET40W 1.21)
> Wifi: Qualcomm WCN785x Wi-Fi 7 FastConnect 7800 [17cb:1107]
> Subsystem: Lenovo [17aa:e0e6]
> Kernel: 7.1.3-arch2-1 (Arch Linux, close to vanilla)
> Firmware: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Kernel taint: 0 (untainted)
> 
> Observed behavior:
> On every resume from suspend, the following sequence is observed in dmesg and wpa_supplicant logs:
> kernel: ath12k_wifi7_pci 0000:02:00.0: chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
> kernel: ath12k_wifi7_pci 0000:02:00.0: fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10 ...
> wpa_supplicant: wlp2s0: CTRL-EVENT-REGDOM-CHANGE init=DRIVER type=WORLD
> [ ~7 seconds pass ]
> wpa_supplicant: wlp2s0: CTRL-EVENT-REGDOM-CHANGE init=DRIVER type=COUNTRY alpha2=DE
> [ ~9 seconds pass ]
> NetworkManager: policy: auto-activating connection 'SSID'
> NetworkManager: device (wlp2s0): Activation: successful, device activated.
> 
> Total delay from resume to connected: ~16 seconds, 100% reproducible on every
> resume.
> 
> The device advertises itself as self-managed (phy#0 (self-managed) in iw reg
> get). All standard userspace methods of setting the regulatory domain are
> ignored by the firmware -- iw reg set, wireless-regdb, cfg80211
> ieee80211_regdom modprobe option -- and i found this blog which documents this:
> https://www.julienturbide.com/blog/wifi-7-linux-ath12k-wcn785x-regulatory-domain
> 
> Grepping the ath12k driver source (7.1.3) reveals no WMI code for saving or
> restoring regulatory state across suspend/resume:
>  $ grep -r "regdom|regulatory|country.*suspend|suspend.*country" drivers/net/wireless/ath/ath12k/
> (no output)
> 
> The firmware resets to WORLD on every resume and must re-discover the country
> code from AP beacons, taking ~7 seconds.
> 
> Is there a WMI command available in the WCN785x firmware to cache and restore
> the last known country code on resume, avoiding the need to re-discover it from AP beacons? If so, would it be feasible to add this to the driver's suspend/resume path to reduce the post-resume reconnect delay?
> Full dmesg output and wpa_supplicant logs are available on request.

ath11k has the same issue and there is a commit fixing it

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7f0343b7b8710436c1e6355c71782d32ada47e0c

in ath12k, the same command/function (ath12k_wmi_send_set_current_country_cmd()) can do
this for you.

> 
> 
> 


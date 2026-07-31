Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69703064B5
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535279; cv=none; b=nNfH+WkGDF2+aLIGuOUl8DfAbEZTIpTn+YMvaEdQA2qJjYYEufZRH+r/UgVrWq1IaOAhaRout3WEyzJLseQbk0KAl1nHySsSPlD6DX+GFxQkfGMTQycp2sc8rzNKQul0DLWaV4+ynz4NbcfaVN7usP9NNUqXcu97zYUvxNn4oK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535279; c=relaxed/simple;
	bh=Vc7CM6QuZjhU4NehpXGOFfxDu71f1JarTVlilkzbmp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P652TWLHs6BnEIWZg3R2I1YZD/hNmImhMxPiPbCDHNsStRi7W8q1PgxZza0S82XiDxFKUuALdRjGrnFlghA9EJ7J/aN4/LhTorHaDl8BXmoMZqk0X1meMDh8uK03GjhmgO4RtZJ2AHF9UWr4yy1eOOhuz2xl3gGqsd1h1ypHPLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IlCe+Lmi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XbaCKEeB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IlCe+Lmi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XbaCKEeB"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VM0S7K956443
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p0mWUyHqc0EQqqbAM64vWyRe88nhS5dv2sTdNNCjQmg=; b=IlCe+LmiEFlk+px6
	JKvC4TadJ0Ti5WA9fBQpGmXIYOhHvkb7H1AV5/thLYGv2OlDl9rnkKRmN/N0EHKC
	BiiOTQvBjlbeGxd2rVvvPu/Erd74EDc/+I3UhOXwhZW7nE6fBuTmTJDVZVdGJi9b
	L/hGFVCDG5dfWl9iGFI/qD002mve7vEbxyXa3QAkRlMAhwiW26xLKjIsYHUnWaMT
	912J9MsogF9pL6gdtgZED2ySUSyujGZWGcRCbxbpjD3hjhtUkw6mGU93sJAiprKe
	BxI8p255EZZwGQBrwt6+fUwCLqGruu2k/XDop3svFEqszyx8TOG6WVdcGumi0NiC
	RkDqQg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frtyqjqgq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:01:16 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f0fe57470so2398341a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785535275; x=1786140075; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p0mWUyHqc0EQqqbAM64vWyRe88nhS5dv2sTdNNCjQmg=;
        b=XbaCKEeB/noOUli8Sk0OoymH9BCiHKwLfNQE5u4/TnQxhb4FIUChM4ZlHsPRzWmOO4
         MQuNn+JVZq0RC6vVHgEu+764yDoE5cWcIiwindWANcHGvrCaD+fa6IktBWhbDcEnl3pX
         XavRcFrYR0IXr+BCc8mgvLH66KtIUZ0ABossvX0BfgPn74teEjWtjTqtRsuHz5E3eTJY
         CuQp2k7cTcCokIA5pf7Qg+Z2ARwvTniKYCHaGtbHwcTVVqaVdyxbzYyZXuef18p8MjHM
         VX8W8/IMaU6HvjEjphPYHg4qfS9T0ALXLTNeMIz66ui/71V8rETn7fTUfdkQL6ntwYcj
         ZwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785535275; x=1786140075;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p0mWUyHqc0EQqqbAM64vWyRe88nhS5dv2sTdNNCjQmg=;
        b=qyGn31ztR/01X8caT1h3oAQH0vrDRb9aMYUtm4cqZOJfvzw+XM8P0iIQxeRWX7FRHr
         59k75SknjR4M6lU95qesiH3AQE+fZYL1UFHUYBiEnWB0yCSTga6O0PkAnpOCiiuS1wnG
         yw1Z9QPCAUIAtqiJwbZVQHqJUd830OPtAGsl5MKbyyZKesbDtmfVy/1tYmE/x4gDzW2B
         CqE/cy7NlMfW/8IxP8flqzkQ1HW7+/m4rS1/kJTNfxMwGJ7MU2QfzcNoCWM7TrVpbNYg
         Mw1+RWRYnqY91C8W9RDA7ppmTCatBlsH/mx+072BNjZjaF8StKdwb08hs/+vpIujbiq2
         6Ycg==
X-Gm-Message-State: AOJu0YzL2a9n2tkLukgJ4i2I6RWouWrQJS+XUrBhXz2b95j3M6fSZZTa
	SNOq6ojuaisoNluiiHi2C1xN+TskuS0mti04BFwDmjeefT9K+JGjCBpeq+2+tVQAbXw99rPX1xX
	ghTIpBW3JAeENd7xO0ZHzC5CALL+mBS7ElCPqlpulG7EswqNOk3hB4xH5MxF7Zt6E2NZR4g==
X-Gm-Gg: AR+sD11F1vzb1xpmhfLOHXy9Tyhx9paVD+boB4hrOzqz8QeeQndGlVHk+tmTD1umegg
	+il2Os1XSbud/wUIKXCERrs9B8PGSaPjI42TSi1QJ2EgUA6FNWR1o1dCtSM6H3V6l7jEKeWEdgz
	Cw3MmIZwMHS2bJOFJ/MkFh036gBtXJOXXAiGS0ZRXt3jXqFm714wsEzZkD3ftZ2qFazOnnk7xGb
	bVeb3MthRIELUFByxMlU/xhZg78tWl6YfWuqq8PW2sG2shRLVubF4YufeIOwaCP25xUennn4oMO
	muouA2/gk7wJbK3nk/anwxGYaoByEXPo7cY27LKlFcI0pPKqQtwlWT+AgorCcQCyweKMAcjJsVy
	4yTKuT1XYdaBzWO87w9YECph7rSGXveDStori1L75QeUdor8OfHANlfnFiQc=
X-Received: by 2002:a17:90b:1c04:b0:38f:a81:15b1 with SMTP id 98e67ed59e1d1-38fb263edeamr3599104a91.19.1785535275267;
        Fri, 31 Jul 2026 15:01:15 -0700 (PDT)
X-Received: by 2002:a17:90b:1c04:b0:38f:a81:15b1 with SMTP id 98e67ed59e1d1-38fb263edeamr3599054a91.19.1785535274638;
        Fri, 31 Jul 2026 15:01:14 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4e44bcsm9049012c88.12.2026.07.31.15.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 15:01:13 -0700 (PDT)
Message-ID: <04460a2c-bac7-4d93-b230-9db6fb55761d@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 15:01:11 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: advertise AP_VLAN interface mode for
 IPQ5332
To: Kamil Bienkiewicz <perceivalpercy@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260728193105.1064227-1-perceivalpercy@gmail.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260728193105.1064227-1-perceivalpercy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE2NiBTYWx0ZWRfX8/eoPS6b2+xv
 avo2kybubr02kh8Cl2oZcMD8sy3EBM6kX4JRwo7AM1f4S2XFijT/cRqkkHVy5oIMjGPUUHqxu9r
 bVRaiDi2nioULBEjBTo3uOqMPkflTTMeBP0HLuMpbsizcReAi7m23gXVfaju/d9Czg4WX1X5WFf
 DqF2IuizPPBSMrKCb6H3CvIQ1SOWKpHT6kocTu+UDGke8VpUhb3Y9yeNY09HaN27BSVIFQR4lf9
 axtZxp6Lgkkoi/vDU6u4SIdb5Fr3f+NpNBFYnY1YcZlOVajgroJ6B736s2n/L69i8lCqV30o2j3
 ooT+KiA3dw6RYs69f2t/rXGmpv02GlMijGuo0BSIWPG18IL2o+Z19cJHKWI3iwpUxDkt+Lxz6pH
 mXZwJc5/4qQ+WiReIrj/I7HcJzuT7WwKVNOovgQLGDh9/TYYZ6Z86El6KY4B1mCqLGZ0FsOs6Cp
 W/4IihXAYmbzjN/j33g==
X-Proofpoint-ORIG-GUID: h2mbTptcZwn61jdZczNw30HU7Teq_E3p
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE2NiBTYWx0ZWRfX3bA0Z5cHSozp
 mUw1k4aUGRc9UfcveGYOY8i3E+3UcrvR4Fja/FCxSB2DlY2LFLX3EvyXUQ/GeQ7lOhurPNpO7s2
 znxzqEjMboad+T04BdFBDTvG+IWvzS0=
X-Authority-Analysis: v=2.4 cv=YaGNIQRf c=1 sm=1 tr=0 ts=6a6d1b2c cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=pGLkceISAAAA:8 a=sYObSRI1YwdLi3bfAOMA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: h2mbTptcZwn61jdZczNw30HU7Teq_E3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310166

On 7/28/2026 12:31 PM, Kamil Bienkiewicz wrote:
> Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
> IPQ5332 entry does not. As ath12k sets SW_CRYPTO_CONTROL, mac80211 does
> not add the mode on the driver's behalf, so AP/VLAN is absent from the
> wiphy and hostapd cannot create WDS station interfaces:
> 
>   nl80211: Failed to create interface <name>: -95 (Operation not supported)
> 
> The 4-address datapath itself (sta_set_4addr, per-station TCL metadata,
> WMI_PEER_USE_4ADDR/WMI_VDEV_PARAM_WDS, 4-address frame and NULL/EAPOL
> handling) is shared Wi-Fi 7 code with no per-chip or per-bus gating, so
> IPQ5332 can already deliver it. AP_VLAN is a software interface type, so
> no interface combination changes are needed.
> 
> On a mixed-bus single-wiphy group the effect is wider still, since
> ath12k_mac_get_ifmodes() intersects interface_modes across all radios:
> one IPQ5332 masks AP_VLAN for the QCN9274 radios too.
> 
> Advertise AP_VLAN on IPQ5332 as QCN9274 does. Tested with 4-address WDS
> stations on IPQ5332 + 2x QCN9274; RADIUS dynamic VLAN was not tested.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Kamil Bienkiewicz <perceivalpercy@gmail.com>
> ---
> IPQ5424 (and possibly QCC2072/WCN7850) appear to need the same change,
> but I have no such hardware, so I have limited this to IPQ5332 which I
> could test.
> 
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -655,7 +655,8 @@
>  
>  		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
>  				   BIT(NL80211_IFTYPE_AP) |
> -				   BIT(NL80211_IFTYPE_MESH_POINT),
> +				   BIT(NL80211_IFTYPE_MESH_POINT) |
> +				   BIT(NL80211_IFTYPE_AP_VLAN),
>  		.supports_monitor = true,
>  
>  		.idle_ps = false,

I can't even run my review agent on this since this patch does not apply to
the current ath/main branch:

Applying: wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
Patch failed at 0001 wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332

Please rebase.

/jeff

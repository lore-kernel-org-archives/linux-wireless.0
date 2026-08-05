Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267FC3C2D
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785953933; cv=none; b=gK+uQZMuhBT1VdmJgw2EzIH3xHe4oY+9A+DofthRrOYvQyxsTb5t0mrrO4itxshNjfqxnOOAm0ObJ7iOhaziNmpjjxuqyS2+AOOqeTp7BhJ8uC5eTt6EK6gKIdASVmnRTdHgM6HBGuSmEbVQrODVtTqz79O7M3Ludq/eI4DnKtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785953933; c=relaxed/simple;
	bh=gcPvbkMcWE9n7mKQ0smt9T2nj5M8XUlWzskKqunBr2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bZnM1QMOZ0w+1H5EUzfF8KYy2UWksO+10ZC+CcuQ10ov637Zqb+Oj8oZxxO9zCRYmsRJp8SZRt47LEXXkceJzjVQcXb/JQxPqI5LExxFSOLHszfH76agwbl/b/p55Wwy2Vl6QCM6H5O6DuNH5fMswKL0xQio/RSKz8Cua1YZedQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SG+yj9N6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LfX29W1x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SG+yj9N6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LfX29W1x"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675HS5cu3326546
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 18:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0qidgGtEGnfNFaIkMmYU9lKnfIZdIzRyOH1QZsIQZlo=; b=SG+yj9N6JKJAmz1v
	WJ4g43EoO9PbvdFmtplU4TXqlq1Qb4fjX+l0hHF3J4GG5K7m8n+waxOuV86biLlY
	CfknEbOKgQFLfEw8XDECmZcYBuK6MszuXqJleqSvQf5/620QcOPbRNHszsnVGmy1
	GifcVXsyIGOkPWXfcEQ2SGjG9mgnoIsHBYrQgxwbwnMqy3kN0Vb43+amzpdhEjbo
	2VeBoSz57iZVucVkkwRk06geZLIX/638tisGJpHK/67cV5kxBIl19u2ZvoIwhs4w
	h7i4PmjLv7MXGMuQBhyNMHCKq+SP6y8K5ExpY74vx7fQ0x0V9cp5b87EfC0so0y4
	/TGMug==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv1qgamy6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 18:18:50 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso900459a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 11:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785953930; x=1786558730; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0qidgGtEGnfNFaIkMmYU9lKnfIZdIzRyOH1QZsIQZlo=;
        b=LfX29W1xtcWoZLSUmb78MgvAAIdvHXD+rytAnyV7ss+2jOehkPT2AkqeIs+lv0wbIa
         0UtWj417sLl+p1dEwLu+AGYpXFLRz9cwL0dTk8B7JzMnkiJQhxyZuWaaSVxSyJ+aE5FY
         XRDtQo5VFel9PQeDiMA6LS6rZDiC25pb92QypWmvAr6ivcE5YdiHQ7KZhQQQXX3i+aiX
         8vkwMmKA5mcTxp5lrOmaFz1zdhhItFEVbQParyDP8x85DiHFNDFAGfj4p4Jxr6vq3M0q
         D4Gqw1Zq4G37giTTOpSTIvAxYFaHXqlZaFfvTYaWvQZRnOomzv2ovPcQQ2KMqjciKMH0
         wDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785953930; x=1786558730;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0qidgGtEGnfNFaIkMmYU9lKnfIZdIzRyOH1QZsIQZlo=;
        b=lO/tCu41Srs6ekV6yPYmYTpM94uDuf6qsZRPNsbfC/iN6oYiZ+5NT3JsIc293N83oc
         CIDCLCbWQD1SxILGrtpEMAsyBpQrwKau3RWOwwKL5eefVmICTM6e0AdKpHr9pqE5t/Yh
         TdaAGO31ChXyoPz0WRMdXujEGBYnjytU8KILpvQMDr7lCa2Zwdp0CYfHgEbPHbQkZujr
         C/IGsRlOl+5Ut0CAiuO8II7VXYw0czVAHq+uWQjilyiyqy8avnbm+4D70+AhRkuBift6
         Jlv4YR8JocvpLz+6xXcsJJgrnsnl8nn6QLOSO4c36eGlOnTwalWDCSShefEOqxTosPCx
         fp8A==
X-Gm-Message-State: AOJu0Yzv7jCnOq7jvm+J5ixUGvwuSDtqAvsK9T2f7mgIemp7n0DNOyUc
	MK0Q0huwcw4Y1v9h1zfLcrkYxDYvVI9u8skCwKT5HMEMvV93qqqdE4JEAGmtYtsG7p1vv1QGMJz
	xC2lbdl6n584KAKPIdglO5wx5UN8PNDcnXcVfD0vD3/oT16TXmLrItW6zbt9METUi0n3IXQ==
X-Gm-Gg: AR+sD13xeHaLEfzdFuq+SRSznKD18JQn9EBLKuEEtdaTLJxUDqg3AppHlGRsvJ/rcVG
	D5AzFJr3PygdLjIOF+8e/Gff7W2WP9I2+sGI/N9d3NHok8Fo4d3ML1BMYSoruGv23R54S0DZExW
	dHB3HKCHWqB2OyGz+ewIaOo878G9wTsDyLHfw19LrIRtZFd4GxFv/9p0+xzKyuwsPtUh9k9JsVo
	VK4o0OAWfshh3QZUMNdBtLnWa1gHeWMQ9lwPEn2dgAQ9c9C95xpRgWHeppyzcIVlnbJf+rc8S1m
	Zj/X7WeDljuOUq692HUNFB+l6BHDymwInvywhOoY5zVpAAIjcvQouOS2zMQ0dCl23wv/Wky/e2Y
	G+FN3eiCqXAYlznAmIMwlzqIubQ4C0HKTe4tEO8oycgKX
X-Received: by 2002:a05:6a20:6a08:b0:3c3:859b:9178 with SMTP id adf61e73a8af0-3cb85f508cemr10192560637.34.1785953930348;
        Wed, 05 Aug 2026 11:18:50 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a08:b0:3c3:859b:9178 with SMTP id adf61e73a8af0-3cb85f508cemr10192488637.34.1785953929676;
        Wed, 05 Aug 2026 11:18:49 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867c6a29sm18478135eec.29.2026.08.05.11.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 11:18:48 -0700 (PDT)
Message-ID: <88d5042e-21e2-497c-b86d-3cdf8c0642dc@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 23:48:43 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: advertise AP_VLAN interface mode for
 IPQ5332
To: Kamil Bienkiewicz <perceivalpercy@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260801004243.489010-1-perceivalpercy@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260801004243.489010-1-perceivalpercy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=I+hVgtgg c=1 sm=1 tr=0 ts=6a737e8b cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=qQ61QLhWeJcE6JJgFHMA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: EvD6CS7PytOYmlYCNIXeOyQkBCFGTVhy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE1MCBTYWx0ZWRfXxjsYqanip9Cm
 /j//A+nTWcY122eM03XYI3XCu/A4Zgc11abEXbb7sWawwq3ApnuG38y1+7zkNVPEaqHfwWCNFTy
 FCV4Q9ZwOG8V9xAtuj2TB5cXjVkimxlxkF/Sr55eaPpIUYKi5ehS1RfdZd++gIqpU+9fKKnstCI
 +H29/r4RkkcbsxRzsHkdfegoYZ1Gipu4jgO593VqIyedW9lTNTc7zfbmK5GVfU6RatLjWqibqLR
 NhpSPLCiPM5fXbJ9xExYRnbb/7BddE8gtITyN6y+5UishZRXKWpdri8eDo52+ik+0IMov9kOSi1
 s1EdDnNGBn9Wip4qDSiX86EVWmdGAMOj1CGmfJPrb+WGzJjbjKB9V1EFbQAZUK7NNNF95nrRY6s
 4E8LhHu+05BbUSGZhXJE5LTC+Z+vs+z4Vku0YJC+CrGkDlzFyEhvEl7u5Dxb7P3OHOSzW56XGF+
 XU6ebk5mUhzlQS+dh5Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE1MCBTYWx0ZWRfXxU417J9+AaZS
 mRUTpZ4K8eg1KXuawGM7SZ9nYSYsymafIcGMmbqHXCE5RP6pz+UFwfkkWKQ/LeQnPOgZYU8V0KA
 hlo+HU56TK3nX3jXAxjtAkpEY47+KIs=
X-Proofpoint-GUID: EvD6CS7PytOYmlYCNIXeOyQkBCFGTVhy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050150

On 8/1/2026 6:12 AM, Kamil Bienkiewicz wrote:
> Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
> IPQ5332 entry does not. As ath12k sets SW_CRYPTO_CONTROL, mac80211 does
> not add the mode on the driver's behalf, so AP/VLAN is absent from the
> wiphy and hostapd cannot create WDS station interfaces:

Small clarification: for WDS station interfaces, hostapd creates the
AP_VLAN interface with NL80211_ATTR_4ADDR set. That path is allowed by
cfg80211_iftype_allowed() via WIPHY_FLAG_4ADDR_AP even when
NL80211_IFTYPE_AP_VLAN is not set in wiphy->interface_modes.

So the missing interface_modes bit seems to affect the non-4addr
AP_VLAN case instead, e.g. dynamic/per-station VLAN interfaces created
via hostapd_vlan_if_add(). Is that the failure path you hit?

> 
>    nl80211: Failed to create interface <name>: -95 (Operation not supported)
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
> v2: rebased onto ath/main (8150c22bc). No functional change; v1 was
> generated against a backports tree and its trailing context no longer
> matched after .supports_cong_ctrl_max_msdus was added to the IPQ5332
> hw_params entry.
> 
> IPQ5424 (line ~845, and possibly QCC2072/WCN7850) appears to need the
> same change, but I have no such hardware, so I have limited this to
> IPQ5332 which I could test.
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> index 7b86f324b..a20c21807 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -664,7 +664,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   
>   		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
>   				   BIT(NL80211_IFTYPE_AP) |
> -				   BIT(NL80211_IFTYPE_MESH_POINT),
> +				   BIT(NL80211_IFTYPE_MESH_POINT) |
> +				   BIT(NL80211_IFTYPE_AP_VLAN),
>   		.supports_monitor = true,
>   		.supports_cong_ctrl_max_msdus = true,
>   

Actual change looks good to me so,

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

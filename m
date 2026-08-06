Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BE22DC357
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 03:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785986099; cv=none; b=J7Dxmvg8pQSZsxbo11WKbqTO1loC/+FksVOdkgJySoKhYdIu4D83rtRzNO48iCWJbShZfNlJDLMxgfnE+SO1sTteq3cqylNBn5MfnN3zL5U0qEityRgpnDDwRhHYYQizmt5S07IYMEUqCiO/TB9SVCUNIl+zvw1CgEGuAe8uUdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785986099; c=relaxed/simple;
	bh=D3iCvfNKx/idSoPifsf0+ocoO2Z7+rC+IQ7yXao0pPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LyPnVtLU2zBw7r07F7lePGG4CzxiJCADRpjdRaJYlU5Fe05Li8262NAIdASOSKMvJGZxGS0DUs8c24yhP6sG3uR3QmFP/3h0lcaQZQQUoxzgfYd6aV0UwF1X572YZBimQQYG3oeJjXsL6PKDYsdlo0MQI+pBIEIGBA3hi0WSIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RL5WLkuL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KyKm88C8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RL5WLkuL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KyKm88C8"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NatDB731377
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 03:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1DabwC7oH9KDSlKyVafMlD/TxVCzk/z4oNfeI2MxI6g=; b=RL5WLkuL/NC5HNlQ
	6ozTcumM58gOCD91Tn/IEwto+HVEWB4CKJcVnYTNAoCt/fi1wgUwJVSlVZoTnzB0
	/9q1rftTjobLrraHjYWlaS5fG/ceDGumQ6LdeGqWwEvW7xMCwtKaxHSYtp7FRdbg
	2ByYVL3aiQVp/6tOvP5vcc4BWWk1K0a+MG++oTwQHm/fpFUkI/wMwN8H4dTdQWdr
	guLN12C34TbwpW/A/i6D0rBBZeJJKJGEXAaU39jcVFspjB1qcDgIlJMVkqSmnwcc
	srTYS0jBCJhnrrJWBkhNsypBkVgg+K9VBHhVNstCnlIU/LuOjXITilNKDCvyFn2C
	bPBUiQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv5dk3awu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:14:57 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb48f41343aso384134a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 20:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785986097; x=1786590897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1DabwC7oH9KDSlKyVafMlD/TxVCzk/z4oNfeI2MxI6g=;
        b=KyKm88C8xs2fmOTJrFFHAxIEDd7BtXhLxJJv5K7k78YQeN+Qw0cdr9clTazXc869N9
         R8miLZi6RWkMvjfJ09sjJhHlDDo8qtB/IOXnmGDNh8vcYwjdbMZAJzY1wbjgNPsBbSDd
         h6t0R6h3ceg4h8nz7G8KEg4mMDLARPBquTzYxzulaRB5wJzTiZS22OEYI+3LKdR7TPuC
         d3FI5KejylvjX3SnLIcTpBX3tYn4mfZEgXtbF0bT2hlMXkEPGQEknN+5ak/3fdzfZ/XH
         tmouabr/PyDzso3C+7AbXP18rDrhmaYCWHupOXRF0nZkpUidNTlffqd5ojLqiUFSL4q9
         SJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785986097; x=1786590897;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DabwC7oH9KDSlKyVafMlD/TxVCzk/z4oNfeI2MxI6g=;
        b=hb/A5NOXl5Eusvyarx08NRvDLLb8Pc2Oh5X3v0SgLd1/zK1jobi0m8Y6RWz8xOAxcq
         YdSme8HjOAMe0ag4aSGb+pBt7btHvI615J6Ix326bizvWo/VY+im/LA4e1MAUHxNhTxK
         kMykTZc3E+owTnQ/QYANvGZGpSwc8C05Xb/twu2Ta2oh5f18qHwPdENO07nzDdEQXKGU
         y0HodGPyoKgkdBGvtzSd0C2FlSgrbX63aTIzJciB4P1SB9dJwaMdTROxHi50hKYWCf8W
         Pl0pmvMCoVmojXFtNEg2NPKxHjYBwCuaiVxl1sjDFIA6xKLs8qtHb7ft18RQtOvDhUY/
         f/8Q==
X-Gm-Message-State: AOJu0Yw3BDcb66chXdtSXvrdAKn9BMWiAIsQViVcdmGBQ90I35cH5qmt
	gWw1wBurxSPI6l+1vwzKJ4pFb4IyAwQ2ETv0Sl783pKhtbR6aajJDaTOkSl7K4/lbuCPrLFH0zY
	BVyHkbApocWYUGmutPNmaU+geK8Gn0TxKYkQcYyPAVJniBs9uAw+Xu7tacwDE+T8x8GBkqA==
X-Gm-Gg: AR+sD13CH9dQS8dWnjuqz0CH9xJefO0qtbalHLNsKlaC4/ZI9/jFdS883HeBUUvw367
	ivoq239/Ih95zmC1O+yeY5ZgtpFJvELtPoOMw9ze2cZjPyjgtirU/r0jyLpDsfvp90slvKluk+p
	w1tiZPgRhnd9MiBayiv1dcmDvQI+KCillhxntQkP/wUt7hVc6L3vY0tLlHRdg2EoBIkvvmxO3pS
	9wHIEhKFkT7cgwEFBOsi+VSSNxGiVYEraTYrrKQVEkS3LX1m3CFf1Mewcs3G/7AiUAApeygSvKO
	JY/doEDJi0xvblyLpxF19Yrs6terUTGw3paAxY9AhBjKeFdVBqY0pzh9kRET20hgzLV8Sxf7CI6
	O5XnKtzijrZyj/XFBa2Rt/yvasQsK
X-Received: by 2002:a05:6a21:600b:b0:3bf:8a0e:dd99 with SMTP id adf61e73a8af0-3cb9c25865emr4555684637.17.1785986096647;
        Wed, 05 Aug 2026 20:14:56 -0700 (PDT)
X-Received: by 2002:a05:6a21:600b:b0:3bf:8a0e:dd99 with SMTP id adf61e73a8af0-3cb9c25865emr4555634637.17.1785986096130;
        Wed, 05 Aug 2026 20:14:56 -0700 (PDT)
Received: from [10.152.196.97] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca9111b6sm19025832c88.13.2026.08.05.20.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 20:14:55 -0700 (PDT)
Message-ID: <d9cde078-ad54-4938-8bb2-51193ecddaa2@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 08:44:51 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: nl80211: add support to configure 6
 GHz non-HT duplicate transmission
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20260805-dup-beacon-v1-1-68574869c896@oss.qualcomm.com>
From: Mahendran P <mahendran.p@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260805-dup-beacon-v1-1-68574869c896@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: OU2FtjfrpeusfhLwGTIGBFNI336vcTkX
X-Authority-Analysis: v=2.4 cv=Or9/DS/t c=1 sm=1 tr=0 ts=6a73fc31 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=HgweAf5VjdDSSt7PCqIA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDAyMSBTYWx0ZWRfX6jkyj3z+opM6
 0XLY9lGu5JI3U720CH1Ns5Xw4hFiFjkzqdPUKnog0hcLx0nyrtxYZtRzXrdcGdljCwwzGeF1CRU
 dVvQpNe6TtYO6CuaXJncl7c5B95JtuKabhUtqQN5lZOUg8YfylFmAaeiofgpgq7a/02NcekcQx0
 73TkZJRxSzye9W9mmnhpCWeJYL+Vc6Anl633SBvjBHYycaSNfIT5gTZpicFopqSodlN/zkNbVB+
 1suSeCbh1Fiu8ObvHtwQUnS+TUWNcAfrykSTMIvwqcwwRQWb5EJ/W2spQUTopTOPBk1bbC/BWkv
 DFk6OzpRZ0R52pM7EJYGhFrBwGgUd/LSQLVxMDJpho+3T2Z2eMQ25kpUdHjniviMO64fyzUyYex
 NoMTsjcT9PyPGxGNxYIAiu3C7jv4JLtotM0xvwoVngEkKgbdpIv9rt8LAn6GWcaLZkNmSFLgxve
 Aen/DXdzDG6E+wkOaeA==
X-Proofpoint-GUID: OU2FtjfrpeusfhLwGTIGBFNI336vcTkX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDAyMSBTYWx0ZWRfX0xnlw4J14V+P
 MOP+Apfc0d65Rg2flfkb2GijOpP6kvHXux3lYIe9VSkleBaV9Mr2HctK2igEp8trDT5u4nCXnNW
 nccefT8FoyjMp+mBKMufQLGcgygUpSg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060021


On 8/5/2026 2:56 PM, Manish Dharanenthiran wrote:
> As per IEEE Std 802.11-2024, subclause 26.17.2.2, a 6 GHz AP can transmit
> a Beacon frame using a non-HT duplicate PPDU, so that stations scanning
> only PSC channels can discover it. Currently, there is no mechanism
> to request the driver to transmit non-HT duplicate Beacon frames.
>
> In [1], changes were made to parse the Beacon from user-space to set
> the non-HT duplicate flag in the kernel. However, it was suggested that
> non-HT transmission be part of the Beacon TX rate settings. Hence, add
> NL80211_TXRATE_6GHZ_NON_HT_DUP as a flag attribute under
> NL80211_ATTR_TX_RATES to let user-space request the driver to transmit
> non-HT duplicate Beacons.
>
> Also add validation to reject the Beacon if non-HT duplicate Beacon
> transmission is enabled when legacy rates are not configured.
>
> [1]  https://lore.kernel.org/all/1644914581-21682-1-git-send-email-quic_ramess@quicinc.com/
>
> Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
> ---
> Note: Users(ath11k&ath12k) of this new NL attribute will be posted later
> once this gets approved.
> ---
>   include/net/cfg80211.h       |  1 +
>   include/uapi/linux/nl80211.h |  4 ++++
>   net/wireless/nl80211.c       | 13 +++++++++++++
>   3 files changed, 18 insertions(+)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 97c16d4ff127..6bc490108303 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -901,6 +901,7 @@ struct cfg80211_bitrate_mask {
>   		enum nl80211_eht_gi eht_gi;
>   		enum nl80211_he_ltf he_ltf;
>   		enum nl80211_eht_ltf eht_ltf;
> +		bool nonht_dup_6ghz;
>   	} control[NUM_NL80211_BANDS];
>   };
>   
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 020387d76412..d8fefefc11a9 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -5900,6 +5900,9 @@ enum nl80211_key_attributes {
>    *	see &struct nl80211_txrate_eht
>    * @NL80211_TXRATE_EHT_GI: configure EHT GI, (u8, see &enum nl80211_eht_gi)
>    * @NL80211_TXRATE_EHT_LTF: configure EHT LTF, (u8, see &enum nl80211_eht_ltf)
> + * @NL80211_TXRATE_6GHZ_NON_HT_DUP: configure 6 GHz non-HT duplicate Beacon
> + *	transmission. This flag is applicable only in Beacon TX rate setting
> + *	and must be accompanied by a non-HT (legacy) Beacon rate.
>    * @__NL80211_TXRATE_AFTER_LAST: internal
>    * @NL80211_TXRATE_MAX: highest TX rate attribute
>    */
> @@ -5915,6 +5918,7 @@ enum nl80211_tx_rate_attributes {
>   	NL80211_TXRATE_EHT,
>   	NL80211_TXRATE_EHT_GI,
>   	NL80211_TXRATE_EHT_LTF,
> +	NL80211_TXRATE_6GHZ_NON_HT_DUP,
>   
>   	/* keep last */
>   	__NL80211_TXRATE_AFTER_LAST,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 44f2bad08670..cb4752fc38a0 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -569,6 +569,7 @@ static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
>   	[NL80211_TXRATE_EHT_LTF] = NLA_POLICY_RANGE(NLA_U8,
>   						   NL80211_RATE_INFO_EHT_1XLTF,
>   						   NL80211_RATE_INFO_EHT_8XLTF),
> +	[NL80211_TXRATE_6GHZ_NON_HT_DUP] = { .type = NLA_FLAG },
>   
>   };
>   
> @@ -6303,6 +6304,14 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
>   			mask->control[band].eht_ltf =
>   				nla_get_u8(tb[NL80211_TXRATE_EHT_LTF]);
>   
> +		if (tb[NL80211_TXRATE_6GHZ_NON_HT_DUP]) {
> +			if (band != NL80211_BAND_6GHZ ||
> +			    (wdev->iftype != NL80211_IFTYPE_AP &&
> +			     wdev->iftype != NL80211_IFTYPE_P2P_GO))
> +				return -EINVAL;
> +			mask->control[band].nonht_dup_6ghz = true;
> +		}
> +
>   		if (mask->control[band].legacy == 0) {
>   			/* don't allow empty legacy rates if HT, VHT, HE or EHT
>   			 * are not even supported.
> @@ -6344,6 +6353,7 @@ static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
>   {
>   	u32 count_ht, count_vht, count_he, count_eht, i;
>   	u32 rate = beacon_rate->control[band].legacy;
> +	bool nonht_dup = beacon_rate->control[band].nonht_dup_6ghz;
>   
>   	/* Allow only one rate */
>   	if (hweight32(rate) > 1)
> @@ -6405,6 +6415,9 @@ static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
>   	    (!rate && !count_ht && !count_vht && !count_he && !count_eht))
>   		return -EINVAL;
>   
> +	if (nonht_dup && !rate)
> +		return -EINVAL;


Since the changes introduce NL80211_TXRATE_6GHZ_NON_HT_DUP as a separate 
configuration parameter,
should cfg80211 verify consistency with the Beacon template's HE 
operation duplicate beacon subfield?


> +
>   	if (rate &&
>   	    !wiphy_ext_feature_isset(&rdev->wiphy,
>   				     NL80211_EXT_FEATURE_BEACON_RATE_LEGACY))
>
> ---
> base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
> change-id: 20260805-dup-beacon-0d074e15ecf7
>
>

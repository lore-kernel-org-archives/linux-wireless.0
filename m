Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEF6391E66
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529074; cv=none; b=GqA4egT8qLD4EOvcFfLTBb0EJA2VGBZByUoiOGr2S/hdyb7V2obRvDL1n4GMZmp/5bL0KD9U6exBsWoJ5imveuk+ABQPJs8CpJXOamUJ19hbNrHthAgVSWiQQgSvCd4mIWeeLXtXdnsoNAHXfk+EbyBBx0zGJUUziWGwSYqJYQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529074; c=relaxed/simple;
	bh=aLRgbYqXimOqMDc9Q59czHSvnUagSLPu0GjAYiQbpak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jBXe0YKpgMm9aroQaeoqjBHyOHvh9ibedA2XfJb7kw0FaPREj/S9vT+aXE1foX6MMT5pSt8Uo3zp7wZBueDvnBxrCYpylCPLlA/9C0YHD7iPzF+JLWFaQyP6owb4zxNF9u4JiKQmxpH9/U0BigNl3bA/p/7mdX8PEeR2Nijqhc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T21+3Lvn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=giOKkZLK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T21+3Lvn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="giOKkZLK"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6RUK01520082
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zAxsj4WkF7EoB1I8FK7kcVdIqxSr5L8sLd8lHsuMIkU=; b=T21+3LvnuDY4qgdo
	Ipz1Qt73p/u05pLLMnqdmJod7erdT7C8DANYuhie8WcT8k9MMQ6YnZitPtaI+AT0
	aGXc82I0Kk0V16zJu3UXOmP+tbzYTCXNselfcxIyLpb3M9oIaDL9h9cCa/QkGZm3
	WUPw+BB8oJTOFaVWXKsk+U9yvdsfgANjhIKslP1Hr369TEiqeIy/wvVTaO4Il1/o
	TAQVRKpZJ2wePvP2KQcfur7ow5z0OoddkRKIMH9bEnSKaIrJvdxM4gByfokyDSfa
	lkdeSXfH9wPjowHaFa0YR9zmTi1sEwoPSKBszL2luoHqQegbUbAvE88XYLE5z7q4
	tc94kg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2chmq1b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:31:09 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38827cee19eso10561598a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529068; x=1785133868; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zAxsj4WkF7EoB1I8FK7kcVdIqxSr5L8sLd8lHsuMIkU=;
        b=giOKkZLKSuaHrqrbyj1dpEZX6GmjzQsPdY6u0MLL2tyVrJ0Xpwhw6V0SqTBF9GpG5Q
         NWdTSQ962G6Xs1QwZ4hXVizgrYEBa4Eu3apkQWzmJf3xxQrIPgwOiXfj8m95ABaJhL46
         x0dWKdwW8znvjN4dBmRj+ErWWL1wvKZiZ81zXPk+XCT6WHXDqFTo+sd9CAiZSzpd8EKd
         5d/9Afw3DViBbLYK6or+pNxojnVVQY+PtxpzKTgBTyYWj+nsnC8GKIkSP8vmMBpzbhdB
         ycrCIh94xo3zjSht9vVqZceWlLZaSLsWKDnAQLGJNW1pjd6c0fTM4fgs4DjrhBSNtZCy
         AQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529068; x=1785133868;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zAxsj4WkF7EoB1I8FK7kcVdIqxSr5L8sLd8lHsuMIkU=;
        b=kxt/nDOB3ZzgWoiJfLceH+6ar+RoqY076f+aVLwwCVXURLs6TYT0jiSDXvhtlVR/B+
         WxzC4771s0/3T7N4M4dMPoNazgKU1ObPS9Z5eJLRxgs/DBf6lltMkyGywvQ5OBPcwFVD
         NL2TC/Ym+JHfIpFY6q8z3Fzp9vp9QKGCf5AJ9o/cLnz1kRhbqfXRNIMjvtT65QSSdIoL
         PqzrDCAK8oj2xXTJigihIIriJVPD71qA8e86ZEqr+/erwFF4eh87/+6biA27dcgyFVYb
         IwYx0hui/kWm0MIVcJFKs4dbiZfUFSKCliZf6BYYb/2TzzpRdBn+D/3r6mhqYK9W3yua
         3sWA==
X-Gm-Message-State: AOJu0YxyLPW8AboAFwaCTwnN4uiTQZMa1cNeFpsHl8OFGhQNfdzdXwmH
	g6+uFjww5DShRm2fLE09P901aYMTHC3SIl374U4A8+i9kwcNhCN42N4/onoM8HHTMIKcsRHjZa8
	Jqyn2fiyMTELieOZL9S4Usd5G2gYHxqi3DCKZNEuRT9cUVdbqp5ClYpP2z6epcnufwMXjIQ==
X-Gm-Gg: AfdE7clilfOTU9RIUm6pIQtVygbWVHdi+mjYPsHbBnW4X98K7LjPLwSjCij2et6ZS+F
	Mu+Q5I5x5VrjQvCw5hODjfOCtb8+SYWtUd5XPfuxpGt04so+zHIfTNekYxSaCAv4xH8v36o3yFe
	HKfsrWIHCvaQipX/M4hXtBcrvmpXdzQoJagRo21bjGbqghgLa5/fwGyt3DeaeqwbBNxFPBBS/tH
	nYFLl+u9b9I263TGu9h1mRwXC8OYFHVWJBwCGL+Bk9KS9DI7BFsbCfCkC2lnakVGW60v29RdXQn
	Un8V2tXzKQOSE0pmNY9VyOzZd3jsnpOgCPTnUoqnCfIp4Quh8ZeMW41TeHSpOyZ7t4CGLCJAmUv
	oFzCeLnKnDGJFhk/8Z+ULFl3YhRPHEnRb8r4jezervP9Xzy43Uxygyfiqz7a4xeUHgdy8WMVK
X-Received: by 2002:a17:90b:5808:b0:37f:9ce3:ca97 with SMTP id 98e67ed59e1d1-38e4b5419e7mr13896214a91.32.1784529068310;
        Sun, 19 Jul 2026 23:31:08 -0700 (PDT)
X-Received: by 2002:a17:90b:5808:b0:37f:9ce3:ca97 with SMTP id 98e67ed59e1d1-38e4b5419e7mr13896173a91.32.1784529067700;
        Sun, 19 Jul 2026 23:31:07 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e656e5686sm3251253a91.14.2026.07.19.23.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 23:31:07 -0700 (PDT)
Message-ID: <2c56c58d-4e04-427b-9309-8895ccddc03a@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:31:04 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath11k: fix txpower in ap mode for 6 Ghz
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260514202750.3040404-1-s.gottschall@dd-wrt.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260514202750.3040404-1-s.gottschall@dd-wrt.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MCBTYWx0ZWRfXwRdDPFAVKuas
 PCV7zrTeb8VLxz3x5ey5tYCBi9Yl75Hqwvc2uSvYUDcQi+8iSD20ax2+iRv3DeKP6ILFrCHkqMf
 1/NJ/LUoTq3IQteJeilmzHxLD6tuvAA=
X-Proofpoint-GUID: upUBuU2KgzEIulyz2AAj6QcklXp8AZBC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MCBTYWx0ZWRfXwS1iqznWfNem
 vOT80mgyUNqmcAFOZkotNfV8brX0xaI2cBvX0wSJICElimQfc9+FWB8H0/rdC7tMZ9YvWy5GIg6
 o0cYoyb0VddA6Wb5X6Yio696lw//xfH1LIP6TPOjKY5l2yopRpQUFw77kA6K4BOtOa6BjgbUh4f
 D9uj6mly2puZqmMXGqhKGG2It2HOibArJ708aN717ssaZ8WuQYMyM+8yXNg9k9L3VgFqfi8fsqT
 wzf3MpP8PTa3vBSux84IANH3soJ131wFIQguSeyShZ3cDgGLRemjc2lNGkq0+k561U8umZJFLRd
 YAeKMs4ZSr5e1teXpJFfqAbCmneHIKr2IiTrgMhmIj6+8IuBIrzRejPb+j8JNfhWdMkJ2Kzpm6b
 DAuUw2/1BIJRLZRw2cOalqSNCH3jPqrlYqgVKbEPW3UT7M8uYYlZyhOcOvUKBgCrux3/aCd+0+4
 NI3xXb0wYKD2kxWVUQA==
X-Authority-Analysis: v=2.4 cv=T5K8ifKQ c=1 sm=1 tr=0 ts=6a5dc0ad cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Y5XITzagAAAA:8 a=N9EDWGr9MySOorLMXccA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=dfzBCs9aBJshU-flp7fy:22
X-Proofpoint-ORIG-GUID: upUBuU2KgzEIulyz2AAj6QcklXp8AZBC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200070



On 5/15/2026 4:27 AM, Sebastian Gottschall wrote:
> there is an issue which has been discovered a while ago while testing
> which killed txpower to 0 dBm once scanning is triggered in AP mode
> on QCN9074 based chipsets if 6 GHz is in use.
> ath11k_wmi_send_vdev_set_tpc_power must be set in AP mode in the same
> way is it is for STA as it is implemented in ath12k and in the
> qsdk version for ath11k.
> this patch must be considered to be backported (i discovered that issue
> already 2 years ago)
> 
> fixes: 74ef2d05ede63fd6416aa635aa8972dff901325f
> (wifi: ath11k: use WMI_VDEV_SET_TPC_POWER_CMDID when EXT_TPC_REG_SUPPORT for 6 GHz)

checkpatch errors on this. Three problems: (1) it must be Fixes: (capital F), not fixes:;
(2) the SHA should be truncated to 12 chars with the title in parentheses on the same
line, not split across two lines with the full 40-char SHA; (3) the tag belongs in the
trailer block just above Signed-off-by, not buried in the body separated by a blank line.
Correct form:

Fixes: 74ef2d05ede6 ("wifi: ath11k: use WMI_VDEV_SET_TPC_POWER_CMDID when
EXT_TPC_REG_SUPPORT for 6 GHz")


> 
> changes:
> v2: code formating fixes, take care about LPI setting in AP mode
> v3: fix typo in email annotation

The changes: / v2: / v3: block sits above the --- line, so git am would commit it into git
history. It should go below the --- scissors (after Signed-off-by, before the diff), so it
stays in the mail and is stripped from the final commit.

> 
> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index a48b6bf1f29a..0984c3981ee4 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -3497,13 +3497,13 @@ static int ath11k_mac_config_obss_pd(struct ath11k *ar,
>  	return 0;
>  }
>  
> -static bool ath11k_mac_supports_station_tpc(struct ath11k *ar,
> -					    struct ath11k_vif *arvif,
> -					    const struct cfg80211_chan_def *chandef)
> +static bool ath11k_mac_supports_tpc(struct ath11k *ar, struct ath11k_vif *arvif,
> +				    const struct cfg80211_chan_def *chandef)
>  {
>  	return ath11k_wmi_supports_6ghz_cc_ext(ar) &&
>  		test_bit(WMI_TLV_SERVICE_EXT_TPC_REG_SUPPORT, ar->ab->wmi_ab.svc_map) &&
> -		arvif->vdev_type == WMI_VDEV_TYPE_STA &&
> +		(arvif->vdev_type == WMI_VDEV_TYPE_STA ||
> +		arvif->vdev_type == WMI_VDEV_TYPE_AP) &&

The continuation arvif->vdev_type == WMI_VDEV_TYPE_AP should align to the char after the
open paren.

>  		arvif->vdev_subtype == WMI_VDEV_SUBTYPE_NONE &&
>  		chandef->chan &&
>  		chandef->chan->band == NL80211_BAND_6GHZ;
> @@ -7647,8 +7647,8 @@ ath11k_mac_vdev_start_restart(struct ath11k_vif *arvif,
>  	/* TODO: For now we only set TPC power here. However when
>  	 * channel changes, say CSA, it should be updated again.
>  	 */
> -	if (ath11k_mac_supports_station_tpc(ar, arvif, chandef)) {
> -		ath11k_mac_fill_reg_tpc_info(ar, arvif->vif, &arvif->chanctx);
> +	if (ath11k_mac_supports_tpc(ar, arvif, chandef)) {
> +		ath11k_mac_fill_reg_tpc_info(ar, arvif->vif, ctx);
>  		ath11k_wmi_send_vdev_set_tpc_power(ar, arvif->vdev_id,
>  						   &arvif->reg_tpc_info);
>  	}
> @@ -8155,6 +8155,7 @@ void ath11k_mac_fill_reg_tpc_info(struct ath11k *ar,
>  		psd_power, tx_power;
>  	s8 eirp_power = 0;
>  	u16 start_freq, center_freq;
> +	u8 reg_6ghz_power_mode;
>  
>  	chan = ctx->def.chan;
>  	start_freq = ath11k_mac_get_6ghz_start_frequency(&ctx->def);
> @@ -8311,8 +8312,14 @@ void ath11k_mac_fill_reg_tpc_info(struct ath11k *ar,
>  	reg_tpc_info->num_pwr_levels = num_pwr_levels;
>  	reg_tpc_info->is_psd_power = is_psd_power;
>  	reg_tpc_info->eirp_power = eirp_power;
> +	if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
> +		reg_6ghz_power_mode = vif->bss_conf.power_type;

The function already has struct ieee80211_bss_conf *bss_conf = &vif->bss_conf; use it.

> +	else
> +		/* For now, LPI is the only supported AP power mode */
> +		reg_6ghz_power_mode = IEEE80211_REG_LPI_AP;
> +
>  	reg_tpc_info->ap_power_type =
> -		ath11k_reg_ap_pwr_convert(vif->bss_conf.power_type);
> +		ath11k_reg_ap_pwr_convert(reg_6ghz_power_mode);
>  }
>  
>  static void ath11k_mac_parse_tx_pwr_env(struct ath11k *ar,


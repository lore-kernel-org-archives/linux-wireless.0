Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579915;
	b=zbS+UtQQ/RLeXWDavCOeOzP8k/0oIHDDl0kunyZ6qGg8vvvoQrGI0ptdUrTxddQqtmwX
	 XQuFlcBOwbBHKCqlUz88Xn8Du4Mhhw69XlX8hUiQMo4dlVmJx6cKajOxPYDx+b8lNnSmX
	 HcT2cmYy1Y/XklKJhuBOTm96l8tQHpAVDMKui68bsdYhGRMqx+2aUbjPaKq8qdwBBqTgU
	 GvFjJo45+q6aCf0uwOVFnmYeDLrZ9slmu2rqh1a/wQ7dFxLTTCpO6oTc73v/ylGgC2xkO
	 v5Mh98Bb7B+TcqyJDfFj0waqS6PCLEqw6SDKKnWc37w2MBjno8GLaLauPM/oZYwyQRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579915;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=U8sTz8ypwYRszYEXhOMC86ERxreYQ5qPpp33bSNuyec=;
	b=EtWZj5HnNNvgoxZLhSutjh/TaJgXTRqgbAPxOQOUP7aBCQGbspYbR4DvgcwztxRXYmL3
	 U/UPl8G6Fj+hyO2DEWAziJNJotOds7ZIUism/5svgX1VqJCdl/URRpr9+X8KGOESU3cIL
	 CuiIBxD2hvCdPkDzt1TQwJSCBpu5J9Dm9P9YVxE4yliSzZFYAcuXw7haSRrOLHGDefRGn
	 jTJhFQZK/5hkpbNBzyAOtTfGbD7H+l0R7kzOKH9xoTej69ht6vq83bN+2+Oom+ATqHdxg
	 FBj6+a2INgbDaGrJydCMsfRyggKszvjLwpriZioE61gM10AQTUV458jLG3GRWaKLGCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Iv7YLnqi;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="KAWy0XT/";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73409606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:51:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73409606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Iv7YLnqi;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KAWy0XT/
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA6Mx33621183
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U8sTz8ypwYRszYEXhOMC86ERxreYQ5qPpp33bSNuyec=; b=Iv7YLnqiBwxEFUId
	Awqtb3JfxOY/lFXPR0NvJ3eOCnMGVkKAtewej7eI8WKyEKEt4C6Omq+FE0C9yp/h
	m+0QQrR+k+Hpyvngu6w4dR1ef+mvzKGh0jqLqafRFCpwYJnSKMLOlYr7LEo85SSe
	jU7nDaw/e+N6dpG1ntYtVeSvXSmV+xOr/aabyQvur55OgbEKMj8MxEQN9cNfzsGl
	kijzG32IVJADhOK3+oP7l+rxsn3Liv3OMflXjwXhWijmqxJMC66aNtNLktyCVDoI
	YY4ZJ+YneqCZ+Me+uqxubkV6Wczhj8oniUj4IfgwMxYkeYprHu5vM6IqFc5aahsr
	9hellg==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hebyd3xt4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:51:54 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1663fb7e005so884637c88.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792579914; x=1793184714; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U8sTz8ypwYRszYEXhOMC86ERxreYQ5qPpp33bSNuyec=;
        b=KAWy0XT/eSYqzYHWqLdl9fxGFH2qO2q/Mrqk7peiKlQuQSd4NhEiS1N5sUpmB+3EEM
         rLgtSnWDmOb++e/p5FOw0b1Y0/A3yTX0hnUAHR52rNyp5gFQre3Oo4aGi9OrpmQTIX2R
         lDaZrjgJXM6u960ZbhGhaBeYhA+CrrUWoN/mz9t6P51z2TEaaswuBGAFu78H+wJQAyMG
         Hc188n3x55R2YAWYKTlI4xanexWKWefRHoYFC0T6qcDuyzqxRfdSRZG3iIv1JHaS4pRb
         XnopvW8+hdaW0AqJpWQep2bvNiQJDv5BOU/pDCQ/4kENFkTC0UFvoJd2s2ufBBlLDerm
         GQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792579914; x=1793184714;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U8sTz8ypwYRszYEXhOMC86ERxreYQ5qPpp33bSNuyec=;
        b=X1JlNJDr+Gft/4f5/GMnKXe5+oYcmUBkdXBx5titTY7MmcT3bs0vGWFSqG75GFDdT/
         ggeUfINMU1fCxyaCZWlCnQod+7kwbJX3okoD2auyQc/2cPTijKbGUwnPgBjpXd0UF+zg
         jWbtsEl9l3AliCiWFVVrfLMzxF1B5pqYpFkLn7RNm3XzGM7fpblcQEDHjuOIen91qrVe
         HnNkfGzXE/S1VcoEsfWsbSojVJtNuceHF1axfrSwDl/yZGPgJ8jCrn3uXSHdjKeoGgcE
         0HQybX1iKFCXI8yGoWijnIMXU/mivt1nLvCJ1GcIFa2jmpJgJCO8gV+lB2u4IbTgqOpn
         KR3g==
X-Forwarded-Encrypted: i=1; AKwUvBzgmVle8B8rLcfk8RNdlrtsMFywSqthsP0l0HcChsaVyjz8LoWveu9kt5yuzmjnTABPefUSMUcF+fHIcHNXHA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJK4ad0gJmP6laL8nM2RId8U/euIDAcr/Wo4ic3/JCtoJu5Kawa
	O46mbl8GXSBfASFUeMdAd3ciO0Wnv4zdEUyelXH/vtuAjUI1u7+7Wa21kzZVDLvcACBZ27dw+NE
	ss+NXSek1vlKWDQyiQepIJ3pvr3TsbLHQ3Q8+USeWkiPp+Zk4jbnhO9cOUE+fhe9sNgTlE7QIuG
	NHIA==
X-Gm-Gg: AYBFou3rSpgG/vlNkeUJXsu61riL8IMA48LSFkH+Bvs2E7kkiuMg5lmpX4CH5eSvAUB
	S36GRpUgLJcVjdGV/fG5qimkEAcqwO9njS7HtHibJov71QvLewgMMtV656U9C4yqhmtiD8rZZT2
	e9UxqghnHuDvfzML6Lyf09OOJgH2jNQk66TW8n+rziqxG9HgLSBQ+z/QuVE5CTXYcoY9/kxJIr0
	QhkYkFoq1OfENETDVgPyKa2eyDhMuOwVcRc9S/5G553sIhqIQ2JwDV74HlwRNR13hiWpbj88J1+
	04IXk6LWghf3tyHDj/nD8qZgKiT0/4iszca3zyxMjU/WVpL+Ie/cB4G1XO56e+6iLi4t7kdSuwF
	kloLt4+lzEE1CnP4/doxh9p9Z2qPtqCn4IUo8pGTG
X-Received: by 2002:a05:701b:4189:20b0:144:fa58:95d8 with SMTP id a92af1059eb24-190a599a3b9mr2307167c88.27.1792579913623;
        Wed, 21 Oct 2026 03:51:53 -0700 (PDT)
X-Received: by 2002:a05:701b:4189:20b0:144:fa58:95d8 with SMTP id a92af1059eb24-190a599a3b9mr2307151c88.27.1792579913031;
        Wed, 21 Oct 2026 03:51:53 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm8216367c88.5.2026.10.21.03.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 03:51:52 -0700 (PDT)
Message-ID: <b5fc72a1-71c9-418c-95b1-897a62f0c6c0@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 16:21:48 +0530
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: apply the 160 MHz NSS ratio to the radio
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20261011123631.1664734-1-julius@bairaktaris.de>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261011123631.1664734-1-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MyBTYWx0ZWRfX3mB2zlO9APvZ
 yBSkncjZI0eLQzQjINLoJjZR9noA/koRzPYPpOZEOAfwfMb1FU7tch7d/eLy8iz2Jg50ZpODWFk
 YP3gQn4vIwTgV9q/3EvERM4Ja3CF4CcWXHgn35RzhJMtHw9pD/Fi3sX/5C33a+rnSA8JDRYx+vs
 ylZoP2O5rpGx3GzR7xeMbJ1o6COawX+cRYUQzgDuhh2/ggV+eSWBzM1bqn7L5SF6MiOF1WKNUkZ
 eUQqrjsBmDUH1wgQDLD/6T/+lqWl+lKiSjrLotzjb4ohb7QXRuSTdBy2O5dwvoVkVi3HInHJkVu
 qh7SLRc6SoyeCt36qRV/M7hGABmpO1EyzjN204SdGTmmplaefXbAf4flfc9up5QXo6PF9B1UtkG
 BvCtjjp+TyzHubkef4JfeoA0wNCDKxLGeRoTnsmCJ8fSLPn8zcwQSaHLq2RC9mu+XJOql/LEx/o
 fRSDWg30uqSLLiMk17Q==
X-Authority-Analysis: v=2.4 cv=TdsDJhQh c=1 sm=1 tr=0 ts=6ad8994a cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=WNuFRqQ0kxZQpcAD2SsA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-ORIG-GUID: c91s70BF5F7Sje8g0qEa7yKMraR8K4Yh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MyBTYWx0ZWRfX93vdFHWjY/F3
 GeCUjEyb+kt/HDFLKVnL80gTyW/EDMGQv/RDh9FKDLXwY2DXX+Kk4poySZHtnTQeZm+a3gTPwiz
 daAv151YOf2oyZ1LjzTXHSboS/rrcsw=
X-Proofpoint-GUID: c91s70BF5F7Sje8g0qEa7yKMraR8K4Yh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210043

On 10/11/2026 6:06 PM, Julius Bairaktaris wrote:
> The firmware reports the NSS a radio supports at 160 MHz as a ratio of
> its 80 MHz NSS. Peer assoc applies that ratio to the peer's NSS instead,
> so on a radio with a 1:2 ratio a two-stream peer is sent one stream at
> 160 MHz. The HE 160 and 80+80 MCS maps copy the 80 MHz map, so a
> 4-chain radio with that ratio offers 4 streams at 160 MHz where it
> supports 2.
> 
> Take the 160 MHz NSS from the radio's TX chains, as ath12k does since
> commit a82ce08775bc ("wifi: ath12k: add extended NSS bandwidth support
> for 160 MHz"), and limit the 160 and 80+80 MCS maps to the ratio when
> the firmware reports one.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
> 

Fixes: ??

> Assisted-by: Claude:claude-opus-5-5

The model-specific "Claude:claude-opus-5-5" attribution may no longer be 
required according to the newer guidance - 
https://www.kernel.org/doc/html/latest/process/coding-assistants.html#attribution

> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
> On a Xiaomi AX3600 (IPQ8071A, 4-chain 5 GHz radio, firmware reports
> WMI_NSS_RATIO_1BY2_NSS), `iw phy` lists 4 streams in the HE 160 MHz
> MCS sets without this patch and 2 with it.
> 
>   drivers/net/wireless/ath/ath11k/mac.c | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index c1fa42edd3630..6cd163cab9bd7 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -2278,7 +2278,7 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
>   
>   	if (arg->peer_phymode == MODE_11AC_VHT160 ||
>   	    arg->peer_phymode == MODE_11AC_VHT80_80) {
> -		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
> +		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);

seems ath12k has same issue for VHT care to fix it ?

>   		rx_nss = min(arg->peer_nss, tx_nss);
>   		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
>   
> @@ -2588,7 +2588,7 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
>   
>   	if (arg->peer_phymode == MODE_11AX_HE160 ||
>   	    arg->peer_phymode == MODE_11AX_HE80_80) {
> -		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
> +		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
>   		rx_nss = min(arg->peer_nss, tx_nss);
>   		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
>   
> @@ -5940,7 +5940,7 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
>   				    struct ieee80211_sta_he_cap *he_cap,
>   				    int band)
>   {
> -	u16 txmcs_map, rxmcs_map;
> +	u16 txmcs_map, rxmcs_map, txmcs_map_160, rxmcs_map_160;
>   	u32 i;
>   
>   	rxmcs_map = 0;
> @@ -5958,18 +5958,28 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
>   		else
>   			rxmcs_map |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
>   	}
> +
> +	txmcs_map_160 = txmcs_map;
> +	rxmcs_map_160 = rxmcs_map;
> +	if (cap->nss_ratio_enabled) {
> +		for (i = ath11k_get_nss_160mhz(ar, ar->num_tx_chains); i < 8; i++)
> +			txmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
> +		for (i = ath11k_get_nss_160mhz(ar, ar->num_rx_chains); i < 8; i++)
> +			rxmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
> +	}
> +
>   	he_cap->he_mcs_nss_supp.rx_mcs_80 =
>   		cpu_to_le16(rxmcs_map & 0xffff);
>   	he_cap->he_mcs_nss_supp.tx_mcs_80 =
>   		cpu_to_le16(txmcs_map & 0xffff);
>   	he_cap->he_mcs_nss_supp.rx_mcs_160 =
> -		cpu_to_le16(rxmcs_map & 0xffff);
> +		cpu_to_le16(rxmcs_map_160);
>   	he_cap->he_mcs_nss_supp.tx_mcs_160 =
> -		cpu_to_le16(txmcs_map & 0xffff);
> +		cpu_to_le16(txmcs_map_160);
>   	he_cap->he_mcs_nss_supp.rx_mcs_80p80 =
> -		cpu_to_le16(rxmcs_map & 0xffff);
> +		cpu_to_le16(rxmcs_map_160);
>   	he_cap->he_mcs_nss_supp.tx_mcs_80p80 =
> -		cpu_to_le16(txmcs_map & 0xffff);
> +		cpu_to_le16(txmcs_map_160);
>   }
>   
>   static int ath11k_mac_copy_he_cap(struct ath11k *ar,

Actual changes looks fine to me
-- 
Ramesh

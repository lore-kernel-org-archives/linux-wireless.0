Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CDE309EF9
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354646; cv=none; b=meYsGfcrSD/eXxqRUUTkPQZjJA1KZ2uPCQ1MhLILHMQS+hO2ppZRcEwfbGZOoX4ldreALYp6tfSuD+BA45+MYdzl0pKpdBzryy+P8sId/kgM8FIfcdPUGj7ALJZi7/h2Tg4xQLyhxZ06/MG4eD7Yx6s/OtBxak+q85Qho61cTg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354646; c=relaxed/simple;
	bh=eiTiybaGSljMIosr/1jpdKcCiVMQjswADkPpQUGix+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XcolKpX+iFMQTEF1/O7BS1uOKfBYVqhE4KSqBxMujNbnEzDA++fDekv1FcflkjycMRdgRcwSC6BJQzlOV7nW3vd9LFu06SG1EDqrW7SiPuf1BoBGXLwacdDVR5Rc/DjwjzXr3fIXaCjlnmSUBGA0b19di+DqAOcG8HUtAAtQn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Fojhgnzf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DdUyZjSb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Fojhgnzf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DdUyZjSb"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A9S1jX1189336
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 09:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z5/9h6TwDFEnLhuVtmJol2cvjCYtLCULJ7w8r4LoK4M=; b=Fojhgnzfc2Cb7AbR
	NB0mRi6OjW4ePezuAGbnc4C0mv9B4p/dKHa6TdCRdplgSN13BjBn40bakQyH/Xr1
	FycpwyV1BQbBNd+EUexLDQZjVzQ1ka35uomny6MF6IBZn2yNHyq4dZeSQsCr+n4V
	M+G3eZoVjtNWTQLU3x4U4ls3FXdM8hAfiInNjJiljxSIg8r57ETW077H5ettMKoc
	UaVD2j0Ekq6scA+Ne8Yhn7VWAVGKa0MG8O/p+X+ps0BR3qydCd6Vcr1bGqdHU38I
	tMF8ErBXNgTIMSnmQ3FxAZXxKeN49i4fpqa2q6kqwO1KCtI1b2izoExxCaKifORM
	GkR/6w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v28sdv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 09:37:21 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e2f61c09dso2653901a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786354641; x=1786959441; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z5/9h6TwDFEnLhuVtmJol2cvjCYtLCULJ7w8r4LoK4M=;
        b=DdUyZjSba0/gYUpOiTO5v2r5F/LNkVL6SsnRZBFcs7Rlc4iOlS27+ORyqIkVrAx0Wg
         MfXSrl54/uSmZBVowL5uFiQzW/vh4sSpE+QdsEAQVLV1qBUIVDkXhLIT/TKVTYQ12rYP
         FHArsv751Cq4Sy4trB6a0WRQhxIsLmuPE8rkufZhdLeA5xirLHOlv9WhpkYIh3YVrk0r
         mdCOoJQLZJ9vTBbOFpQKafrROywAkzzJLYD+abbC5SUnnhKr8Py+2689OFRkHpLiBHsP
         DCZcIkpA2EXYDIp4hnQt0BRlEyQrKuOFJiayjX7lsEbS0JKU7QndR4KqJXmcobDsyJJS
         rtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786354641; x=1786959441;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z5/9h6TwDFEnLhuVtmJol2cvjCYtLCULJ7w8r4LoK4M=;
        b=pE3tsdXaubxilKfJ/gVnIoY8XNFx2ReznZ4kuduDQQ9VM5rm7kRnIB8S5yHBRwrpmg
         7qaW9maYyd5Pk6N8cGlbDecIP6KI383CAi/tgchV1xXUxOwDvPYjM7W0A8B2ciAMLzlI
         4nghjwnibwlzUiuJ3lrbxnxjrV0KOGmCL5aswL2pbroLtwukHlZq5jb50LgA6suBZqxc
         RK3wtoyKpX4bMo8UHZ/t6LZJ8nRZRAvYTksFNDUGqhK1e+jbI6czJjlWTZXXUQXMg2JQ
         oiH3Wgg4E5WDfavunVp5S6rHALaGSu7S59VP+FNI7dqX3eh+W8/FRHqYC2AhvDHCYAw6
         5CcQ==
X-Forwarded-Encrypted: i=1; AHgh+RovYieXAwcOj/e0OVrbHckIjWqdKgpHj5efQudgTBKr4fefzWsTCTN3suvZZt8zWbfVsmr4w11b879SDJkDaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykUZk87H4Kd2/e/FrnP7U+uSKSA9yEubDWt/MucFymvrcHrvaX
	9IblJBCtJd6r9naaAmVuBCI1AVzaVe/OK8AhARY8R0SuLn6XHFnqmTNyS2Bi31V223dn4pApz9d
	RZRw+N4yHUsb3hZN67g/XRynd+eHa/PdSdT91y2wuPt42Qj14K46PlhrFTE0tWzePP9i2rw==
X-Gm-Gg: AR+sD10bWTkN7ewFbmUnG3rVptc6W26f/KzrAbP6rLMGovkANHLGhyE8iWkmuOZzgoU
	ceOcx6Pn6r1pK3rCl5XpVr0NHOjFtcN3mDF3iFoTdkzz+1zn9rC99sIu4NMAibidQrA4IaQxNPY
	PZqPJcR7uAF3BRLx6Vb4oElYJ/drzxDKaKO3TnuZcF5+5L+HoDV+/AIUtDoPJQMiwTOtquA6pyp
	2UAwjWVsThnH/TXRTGoHXYFODGz1rjHgzyc81qZu87Rpj48+Re+7NQD3UMAnZkv3TS2OU4OLVpg
	6AkhHMlNFv3bensPbqebt5MXcy1MuGIIvz7j/xGbnL23Lnvp0RuiqUvgHpV8KgUS9HNcSEMZU0+
	z2xVsHMRfeBMTM+vftArGLeOlAr5EnH9/sbWY24csw3O0tt1NUUC9AHmX0CIT7doh23AWoCSr
X-Received: by 2002:a17:90b:528c:b0:380:9f17:6df3 with SMTP id 98e67ed59e1d1-3903c5448dcmr43326189a91.4.1786354640892;
        Mon, 10 Aug 2026 02:37:20 -0700 (PDT)
X-Received: by 2002:a17:90b:528c:b0:380:9f17:6df3 with SMTP id 98e67ed59e1d1-3903c5448dcmr43326144a91.4.1786354640404;
        Mon, 10 Aug 2026 02:37:20 -0700 (PDT)
Received: from [10.133.33.20] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925fc6dab4sm12066088a91.3.2026.08.10.02.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 02:37:19 -0700 (PDT)
Message-ID: <bd5db1a2-90f3-4cc9-8cd8-c18499c56a2b@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 17:37:16 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
To: Linkai Gong <gonglinkai@kylinos.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=S9PpBosP c=1 sm=1 tr=0 ts=6a799bd1 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=UmHtXT4VRqcp-Ls_mGYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: bO3ik-s4urZejxB29QX1t6GpKLbmeTHP
X-Proofpoint-GUID: bO3ik-s4urZejxB29QX1t6GpKLbmeTHP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA4MyBTYWx0ZWRfX4TamB/rM7Xkk
 X9pXsuA5t93Gy25fYzkVmrKj2puRpID+eiJTcDjnuM30Tr4ucjbwwU/IBWf146Msc3udvYT3FvQ
 FEtyTx2x/FJlGbhGm/NQBdiUk3ZRxfIwh9NMQ5bpeuhyt67kPYjwmnGd3b6JZNIqU8bG7slZWO5
 wNbjnG909E6++bkjWrqOvKbuRwzwVEhS0CAVnGsVoN1STYuf7jeERBZW1gzjaQ5aFyH6yZ3fqZu
 hj9Ff6FhtBzCIVPyAy+E0R2fMLVq5+IAELgqqmsySxSJ7sjI5GMw1Ip9/nyWYDSvADd7iuQdwVN
 WOU5QHZXLS5ZFqg+/9Ggjr50pRXsUIAHuz9cW9FHrnUl8uWj3oDGPmBmbRLtAKNwoS72jkr3ejz
 9mQjTCW/vkdkTrZpLKRsCGeXfpB675LShp22fFb4/LmsqAi/q/3LCoPKSm5AKrxGSQa3U7QGkND
 5NRv28R39QS6QRh4mEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA4MyBTYWx0ZWRfX0xI8+xRb9/Yi
 wLa/Di06BfGOaeAw6AS7k8SS2VGHAsf931X7EvitPngN8ynCsProb6qzJRB04ELVbhLB9Gm9oVO
 pehPU5xFdjzL4bniv5O9CacggSJP+Co=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100083



On 7/31/2026 5:38 PM, Linkai Gong wrote:
> ath12k_mac_setup_channels_rates() frees band channel arrays on failure
> but either leaves the pointers non-NULL or clears the wrong band. Later
> ath12k_mac_cleanup_unregister() frees the same pointers again.

The radio that frees its sbands[].channels inside setup_channels_rates() is precisely the
one excluded from cleanup_unregister() — the loop is for (j = 0; j < i; j++) and the
failing radio is index i. The earlier radios (0..i-1) all fully succeeded, so their
channel arrays are valid and freed exactly once. So this is actually a dangling pointer
issue, not a reachable double-free — nothing frees the failing radio's pointers a second
time. Please reword the message to something like "error paths leave dangling pointers + a
copy-paste typo; harden by consistently nulling after kfree()."

> 
> Clear the correct sbands[].channels pointers after kfree(), including
> a copy-paste bug that nulled 2 GHz after freeing 6 GHz channels.
> 
> Fixes: acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in single-wiphy")
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index a0928890671a..5468a8d2d5d5 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14275,6 +14275,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					   sizeof(ath12k_6ghz_channels), GFP_KERNEL);
>  			if (!channels) {
>  				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  				return -ENOMEM;
>  			}
>  
> @@ -14325,7 +14326,9 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					   GFP_KERNEL);
>  			if (!channels) {
>  				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  				kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>  				return -ENOMEM;
>  			}
>  
> @@ -14365,7 +14368,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>  					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  					kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> -					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
> +					ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>  					kfree(channels);
>  					band->channels = NULL;
>  					return ret;

actual code change looks good


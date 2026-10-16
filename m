Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C71339375
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138551; cv=none; b=SbpNl6YoxVJTTGtjL0CtzaZK3lbzdVV2NlDcaosfXXIxC9OyX4JCEDs55b6rqypc5SFbfIpqEF9lDpmEd9eYHwEDbdwOK1/PNCs8trVGGy4fvPorTodhWUm7eE1KlSuDudbvlBDT65/lXM/xxbFR5kHfAleC3FEzo8SuWW1kztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138551; c=relaxed/simple;
	bh=NpCFBXlsllLwxYtV+smWMZZBwE6llQoNc/VJexRBEQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ccSHD7vhB18ePE/HaypnL9XmWJm1XpHalOUwVVkSLWmS6f0BckAHXRSso2P49378FoS/BAdZKFDTC6GNySt7oJJ8FceSxAZZlqLEDsf0MdYelUm892Y5lnRRppKxEQV808mvcT+4rnGH+Bq2fj/tPMS91BKiCzcvIGpjoDtBsiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hov+2geu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bc77WnN5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hov+2geu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bc77WnN5"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G6BR5O4126406
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TfBEOOFg191OMsndyNa58lw23vjInq1gbAbNsF9qyQc=; b=hov+2geuWD+xPnYo
	aLzRLMRYZ/QAVymtFl5SIZG3Nl0WnjrGQ41yI+HrdNdg0qRC/swa1Bs48VRKbeI0
	rclDPZg04BQKtUjxenMV8OdCBqlKEUZflj8NaAJNlwUX8rcUx5z6x/KKSVT3HCTh
	njOqtQHPVljI/NFYdRNpfINTqO4wi6cc6DSznvIa25corCC9Nhb86Bs6M4p1g6Jq
	Ip4WhfG3gpgeXVClJIRIp1mmeHdYaXTwEZPhEkqrruuFW6APeAABd5RQj7xSAjT+
	5g2e3v/Hair1NMpkuzeItyGedBiFrZqmmFBh5GJtpb2jqm/ZmGBt30o1RNqcSA66
	ccBlxQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb19m3ffu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:15:49 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35a4d2e39acso7036460eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792138548; x=1792743348; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TfBEOOFg191OMsndyNa58lw23vjInq1gbAbNsF9qyQc=;
        b=Bc77WnN56jWhLXm0b/MXHoI5J9XL/3SSfauKSj3b836NuGqpj3nJ/CihaKRNr5i4aQ
         77Jdbeg5GQx7Ylkw2IybzdvDYdeYUPKrRmCNDns2UONFRL3bq3QWwwyZPWj4jYyb7oCk
         JXdwcfzDM7JsCk42vPmY/7IyA89reywyc4+VeUkz/V10/lzC4MQ9RzT50YK3Cz9MmdXX
         P46eq6TrSK8M8RDW1h16B9qvOv3Oey5J23ld8VrwoOqoinQxv7ZH1BLDSZenp2Tn5fmR
         h6d+gaXYdbCTKiaRJxzIWUnBVSSuzu+kpXHhKV0gRmF6dlTl9q0ZDqfsoN1DR45Ay6Oy
         BaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792138548; x=1792743348;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TfBEOOFg191OMsndyNa58lw23vjInq1gbAbNsF9qyQc=;
        b=lgf5AKWwGYuoESTQblZRAW03oZdwiZR5BZBlhUK3tOaisk/syo8tuTaZaAi+vAo5Ab
         i1bRcZTBvaytMANv7HrJfStmDWsn+G4ISCAVSzONiZdLbCeYVNEdr4N++nqfqt2inywL
         JJxRCHGKor5msY5tZK9b3U9uZRyvWh8tgPH6cJgM7cOcpRLb7fhP5Z9JX63s+kvmi8+v
         lp8SwXV8fpNsX4MwdZLq9kVTxMbFbN/DH+OCU1MkUBqpbm27qC8bJ0sQzp2PrhK1twee
         emiiDSxis9QZY0CK7sEKM3MU8g8H+jtjavcMoeKMbuKuoojk+NoQMKwvhqgc01WABBd2
         r5yQ==
X-Gm-Message-State: AFq9FYJ0kGNr1t2IBTRZ4OT0bWxBbMMuUA5VQEhyocRl5/W8Uu8HwRgo
	YIou4i+hDQxSgQRvpTOZJJtroTXcWqULoDEYrRHCmYYoeAOhKY2LnWGuYXWFkSo22i+o+pa514/
	InhiWKZEZOw5BwlOSWiHxYWtk3ny/geIGkPFhdjckMSwVcFNYKqxwbRbQ9b/M/ZxZjZMqR7T8Gm
	rjPA==
X-Gm-Gg: AYBFou38zeFVbVxR5XktWWEIjPudLJeH5cB3vBaB4zpSXkGZTBLagFHlvMekDLqfZb0
	ybJyKPgH8M0e1cw1c3gF7L1YFO3pqcDZgw0kY1UPZV21EwctpIwKZjZ67hJyogQyhy7dxW5QAYF
	XYaR3uq/MTPoilvRU5o3lX9M0FoEp7Q5aBxP21ckAT3Wqq6qeAAFJvpgEl9P0r5BINbLpbm0ROL
	DlHXV2aSah7MnNqGWn5aD9vRZCn2ohvVR8cvyj141vVCsy7ldn/5ru2S8dvF+IyMB1jv9D8uGRS
	4jisnhUt+m2OFYtqgqWF0KN1VafAYkRmVaO9hmv3hfwIbzyOvnSSPlvHMZRlXPVP97bTK12HNEi
	CRzV9lXDDrzGrpjH4lcDKZENSOIDITdzvKF6OPscjhcyfLwYKrw==
X-Received: by 2002:a05:693c:88c8:20b0:359:9302:a526 with SMTP id 5a478bee46e88-3599302a70cmr23138213eec.7.1792138548094;
        Fri, 16 Oct 2026 01:15:48 -0700 (PDT)
X-Received: by 2002:a05:693c:88c8:20b0:359:9302:a526 with SMTP id 5a478bee46e88-3599302a70cmr23138171eec.7.1792138547309;
        Fri, 16 Oct 2026 01:15:47 -0700 (PDT)
Received: from [10.235.81.133] ([223.181.200.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3607ee0cab0sm5780124eec.3.2026.10.16.01.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 01:15:46 -0700 (PDT)
Message-ID: <cd1e5824-18da-42f3-acc1-512372237abf@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 13:45:42 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 3/8] wifi: ath10k: also wake peer_delete_done and
 target_suspend waiters
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-3-14baf913df94@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-3-14baf913df94@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aLdlOr9m c=1 sm=1 tr=0 ts=6ad1dd35 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=mU9158tKupmGQ1871ypv3Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=6JssVo0HlxIPen7dyesA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: NvaGqid5xEhm0tdhTc6Bqf07la1w2p9Y
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAzMiBTYWx0ZWRfXxmWQXMhsWwu1
 NPuT50GmtuIeJBbPFE01v1YdSwpejqboG0X1fWNJfHDiBEdi6vbeSkkoZ/bGhhi1XDhQo0S8u8G
 yT2mShyk7tOhEgiTBsuNig4WQ736IKE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAzMiBTYWx0ZWRfX2Bmped+6ERtH
 Aq0+7cC2Y3zlhJ+Yuka3feFn3K81+UUDyfKzmdhP5RCOE7V8Nx3Qceo/onap++H5GOPw5dBHw3q
 6/YXE6F17MrVP/umGGvmOHNK+QleZI0rMZs3wVOMQbBAmJKFyRTeg93WmothQAF7l2Ff4geP7SI
 9ejA6qcQA5zUEWy67+FDVy2vhXyPu2MnWj9xbseL8TcpmKMzj9RM8Dm3o9Xj7atFKgzGU0lFW1Y
 LdzdXaFYrHzKXyvPnZLMv1sAgvrhY6XemBnDJB/nq+Codn+WoXxdns5rWEjcfXlFHrSYFQ4gj5C
 B10XW6wtvtfI8BJM+6SnFfz4qJ2Aa5ehi68wRfUiZ7ulf2SDrRS3nfOH+6fJ0dtnUgi3HbWonIU
 J7kl52KB9K5DVHKqxbYCRE7kYfKROzdLycm3LFyzGyV2rlwBnr49qSSpFj8Hw3q2jCmbQ8DLEzx
 FdeeQh50IS1+W6IdKqg==
X-Proofpoint-GUID: NvaGqid5xEhm0tdhTc6Bqf07la1w2p9Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160032


On 25-09-2026 17:56, Kang Yang wrote:
> ath10k_core_wake_all_waiters() releases callers that would
> otherwise remain blocked after the driver has given up on the
> device.
>
> However, peer_delete_done and target_suspend are not included
> in that list. Callers waiting on either completion therefore
> continue sleeping until their individual timeouts expire,
> even though no further progress can be made.
>
> Add both completions to ath10k_core_wake_all_waiters() so
> blocked callers are released immediately instead of waiting
> for unnecessary timeout delays.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
>
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index be516dc32c1d..f2e457a0fcbe 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2500,6 +2500,8 @@ static void ath10k_core_wake_all_waiters(struct ath10k *ar)
>   	complete(&ar->install_key_done);
>   	complete(&ar->vdev_setup_done);
>   	complete(&ar->vdev_delete_done);
> +	complete(&ar->peer_delete_done);
> +	complete(&ar->target_suspend);
>   	complete(&ar->thermal.wmi_sync);
>   	complete(&ar->bss_survey_done);
>   	wake_up(&ar->htt.empty_tx_wq);

How about other waiters such as radar confirmation (radar_confirm) and  
peer_stats (peer_stats_info_complete)?


Vasanth


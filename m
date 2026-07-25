Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5928336492A
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785011968; cv=none; b=anSL9kocKSSFX+AjhcM2oxzIHIBiUa9AMHRpbVDh7rCfbAu46REXuJRTVAk0SaRFOPUCOKoPoG52znUQ6BbEeMxR5E1tszWCVj5b0kjQmNufzorVYqkiFaRvchARQjpFMODHu4MvQUMNXuTKQbaZaGVWk+JRz5PUQ+2vu6qMQHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785011968; c=relaxed/simple;
	bh=uSfQE0IN+VaXx8DOqN1Ancm8QGOgFDuNlzc+CdQejpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWLANIlDeTlXxBwxDRFgD7MSsrhv+cu0aJBq4Dij2DuYLuuOJs7iNxb9/CpL1UfJanqNtVLTGiquYCTIQUjkhwQfLTyZ96gqBJFhlTPVW4QITnkbnUxX1mz+XnaH1+BETprBnrM1+CUQ35qkPEhEeIjCanncl3AOjGPWaK8LwCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ih6KXaif; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L0epEZd9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ih6KXaif";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L0epEZd9"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PK6VMa2589370
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 20:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B/WVbQl48ga9rURAlLr2HMcjvrNmD1SzG2vYjkcEp9c=; b=Ih6KXaifJjrmE6FG
	r7YuMaBy35lH/WmIe1rR6UtVQ+l+/4Kc5O7jlgg4qL/YwPayKkUomAuAdQKgSkm6
	KgFIUjq7iIHcNXOwuRmL3Btkh7oc5gD14GQd2HugIwtdJEOeeej81A2TrCt/Eain
	/e7xZ4pgcGXrzNXadjvXv2zonD//FujAcVFh8GgBMG7cn5g24sfyfSj1TDyYriSV
	5beBTH2xjjP/n3JmFC1OVR9pUESdidVuF8TkqpuYBMuVLHPvbYufiZ8H984C8UQ+
	i7z5wuTqu5Eal3U8Bt/4trxsSgTgnfbm5QLxRmRUJ6R9+UseYygGmzhK5YPHB1Cb
	g8bHBg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmpee9f6n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 20:39:25 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848860def2cso1591135b3a.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 13:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785011965; x=1785616765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B/WVbQl48ga9rURAlLr2HMcjvrNmD1SzG2vYjkcEp9c=;
        b=L0epEZd9k7ybNVzzDoSkg+2pbjU0xjFAYsYQxOs4Gq8Ocfs+p4y9vr9DvXIoby2ufJ
         seAAKYHYF1JB5tDeYYW7Ayzi3U21ABgWAhNOTRuwRwHzyk4cD2qGR0ih8Onaek/fn5sm
         HN+jkDQ44WYKssJ9pD08MJbpWWkBpTesIh5FDnA0n6qMMU1ncUB3tj9ru1rucNLyJiIe
         wlAbbI0XjsOLBLBgE7o6orhVj1ZmT6y9oJ+dr18K+Vl1JPZhHnFVa/owt5WQpDYkH2qf
         9QsNdcnk/ytPf2Yrr/uBXg66MiqRdlbE1vpo2s5zSwYYhQh+YjcFWywK8uxCYVdadiBL
         KsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785011965; x=1785616765;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B/WVbQl48ga9rURAlLr2HMcjvrNmD1SzG2vYjkcEp9c=;
        b=iRg9bEBGc5iUp3OfT40GXNFSfsVmrsYlR9U0BxLBuRvNjWOUgKSRriVmM+AVxmuIR6
         OsbjxZr2UgdXtl1YemLZJUFh7uIiJyFs57pSwLQxL1+jqdDYOHvcigJolvwpHxEzFHNr
         JA/bnGgJTej/i7ixs19RR92qkON/OqYmD75WPJh8plltk1mS25XhIU6VrGX4R0gOykLD
         jt5cPSuHxnHkKCqOiMrCAjTZv0B5lAG3hUnZmlgTwTmZmCZ3e9JEbLdZr5lU1oOewjyd
         gI4zTnq9NRfstSHcH1xzqDM956EJd7Tu2XyRmHoCb5e97UTX/12fWkMt+Rj6y5gBsGPq
         EleA==
X-Forwarded-Encrypted: i=1; AHgh+Rq9FGr1ubVfIexbtIP4dwAqkF0VAbPdPseLOEztWldI8PXujQ+R31hkxCw+sKVOyReObZs12SrnLWZ6cE8S5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4EjDVArHOf419OjsCDMOzelz5mxrYfpG5XAJNJLk9ftTJYlhN
	0bx9rKsdLAebl86ZnUzmbr8QTPsNh4FAPHefjXAoo6TopMxRN7pDEoHa9ML+ur/dRayviBymsJe
	v+saQUHYItdB37xqs5wvTzXeYx91dpqN4+doFs78ptcNYEZ9BWs8SnQo5EdVbadEea3UfVg==
X-Gm-Gg: AR+sD11zhWY6QKMiXRp4PMFwoFXnVQvwVuH0dukl0vnBm4TBLmdyt7WK1fFfyfP9fID
	r8E2zhUUwloI9x4VMbVmXHcC9bsTNKy9HVpBStanJliIBkGaLcERbr1k9i+aCaZ58FzE0v2V3Fs
	dvzVP+nc79oiAL05+FlrbY+c+NbnCYIbA6Q5tTP5rUVR8jOrGne6ce5OFs/xYnlECLaG767ukV9
	MoINIVQIOAPGiBWPsbZt2rqpGeKEtX5BNX6uokwNCkVq3/QOjmvbmJ8pFMRWbe8CxYl/AiILxc7
	qvYckm2iCpkv9+Twx990z2vgEKljZyS8oVi5r1HDrrKW/+tUpuJkhRyrs+ouXZ20MY68DR/dLaG
	FCNEyscRPMty86XgAIAxZDunT3Xy7P5BKzV48gtPoIxk19q7YY52cab8uhg==
X-Received: by 2002:a05:6a21:918c:b0:3c3:90e6:48b9 with SMTP id adf61e73a8af0-3c67dfc11a0mr3052545637.66.1785011964610;
        Sat, 25 Jul 2026 13:39:24 -0700 (PDT)
X-Received: by 2002:a05:6a21:918c:b0:3c3:90e6:48b9 with SMTP id adf61e73a8af0-3c67dfc11a0mr3052524637.66.1785011964137;
        Sat, 25 Jul 2026 13:39:24 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548f5dsm15979142eec.17.2026.07.25.13.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 13:39:23 -0700 (PDT)
Message-ID: <b9a219c4-c1bc-46db-b88c-4028ac9e186a@oss.qualcomm.com>
Date: Sat, 25 Jul 2026 13:39:21 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: wcn36xx: fix OOB read from short firmware
 HAL message
To: Shitalkumar Gandhi <shital.gandhi45@gmail.com>,
        loic.poulain@oss.qualcomm.com
Cc: jjohnson@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
References: <20260725185740.56658-1-shitalkumar.gandhi@cambiumnetworks.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260725185740.56658-1-shitalkumar.gandhi@cambiumnetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Jr3Bas4C c=1 sm=1 tr=0 ts=6a651efd cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=II-OE9h1AAAA:8 a=pGLkceISAAAA:8 a=g_wSJ8AlVJuxHZqMWoQA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=nd5eHX0RB9Rs0Bh-HiGA:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE5NiBTYWx0ZWRfX0NewrFYiUwPZ
 yu7ZWKhZzcdBcqdCVR4ATgrC14e3xLvJpw8qWOsziHDTxsFUaJzDQCR0As/B//zM7QV8Uf5fEhd
 CdGj4+jO1kG0wGZV0OTBL/ZDAE0x5yM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE5NiBTYWx0ZWRfX9wt2DKFvn3Xc
 S0SGwyS0+x6G0UUTFq4ptxkmff9VZgCsd4wCiCj1Pcrva6qZtzynb+eBemha/snqB4eAmaNtkPh
 P4x7x9qaGosN5Z19FHhXiKVFt6FAU4mtGQiEEd5pglsIglfnbPC5m5MqPr7P0Qfmh3nlYnv+Bna
 vD2csVLvDKD180MVs/jgbpHlY0C0qQKv4YOGn21McQY0/f//0wy6PeB+4ERyXG3UmioDFDcbsyB
 jbjEeOGve5p9E4CccPU0P1iEVev5j1wj+PF/uyJNDGhIEfqGejEwjVpd9LF7NMynCaVv3wkgpz9
 jmMYeZgb9HKaUyt1HBhMRZKu3ouTiLSzXFL+n2S3RVojDBI+0rvxxJb9B6GC4F8I2808nEVKgCv
 Hks+wuMWmiuNcN2CgjYOUk9yYjDISBK7I2DtRu85a34bqOC0QaonLOMhf2F+nQ9Ceg3zUUK4k2g
 61+yB18pHgGYA6oam2g==
X-Proofpoint-ORIG-GUID: nnm0Jujl7MotWlG4o7CV5EyOwHO3ipbX
X-Proofpoint-GUID: nnm0Jujl7MotWlG4o7CV5EyOwHO3ipbX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250196

On 7/25/2026 11:57 AM, Shitalkumar Gandhi wrote:
> wcn36xx_smd_rsp_process() is the rpmsg callback for the WLAN_CTRL
> channel. It dereferences msg_header->msg_type to dispatch the incoming
> message before validating that the payload is actually large enough to
> contain a struct wcn36xx_hal_msg_header.
> 
> The payload length is fully controlled by the remote processor: the SMD
> transport takes it from the packet header written by WCNSS
> (qcom_smd_channel_intr() stores le32_to_cpu(pktlen) into pkt_size) and
> hands it to the callback unchecked. A message shorter than the 8-byte
> header therefore causes an out-of-bounds read. For the indication
> message types the header is read a second time in wcn36xx_ind_smd_work(),
> there from a kmalloc_flex() allocation sized to the short length, which
> is a slab out-of-bounds read that also violates the
> __counted_by(msg_len) annotation on struct wcn36xx_hal_ind_msg.
> 
> The individual response and indication handlers do validate their own
> lengths, but they only run after this dispatch has already happened.

this is not actually true, see my comment at the very end

> 
> Add the missing header length check. Drop the message and return 0 so
> the SMD transport still advances its receive FIFO tail; returning an
> error would leave the malformed packet unconsumed and stall the channel,
> which is why the oversized-response case in the same function also
> consumes the message.

this is a very lengthy commit description that looks LLM generated, and yet
there is no Assisted-by tag. See current guidance at:
https://docs.kernel.org/process/coding-assistants.html

Note that a simple 4-line patch that matches the logic in a lot of drivers
doesn't need this level of detail

> 
> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
> Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>

checkpatch warns:
WARNING:FROM_SIGN_OFF_MISMATCH: From:/Signed-off-by: email address mismatch:
'From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>' != 'Signed-off-by:
Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>'

It looks like gmail may have mangled your From address based upon other tags
in the e-mail (X-Google-Original-From:) so you need to work around this.

I can't take a patch where SOB != From (although I see in lore that some
maintainers have incorrectly taken some of your patches!)

> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index c0b477345832..32dec45dbb50 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -3254,6 +3254,11 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
>  	struct wcn36xx_hal_ind_msg *msg_ind;
>  	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
>  
> +	if (len < sizeof(*msg_header)) {
> +		wcn36xx_warn("Corrupted HAL message: length %d\n", len);
> +		return 0;
> +	}
> +
>  	switch (msg_header->msg_type) {
>  	case WCN36XX_HAL_START_RSP:
>  	case WCN36XX_HAL_CONFIG_STA_RSP:
> 

> base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
As noted earlier there are other buffer over-reads in the wcn36xx SMD rx
processing? My code review bot is flagging:
wcn36xx_smd_join_rsp()
wcn36xx_smd_switch_channel_rsp()
wcn36xx_smd_get_stats()
wcn36xx_smd_gtk_offload_get_info_rsp()
wcn36xx_smd_process_ptt_msg_rsp()

if you decide to address these please do each as a separate patch

/jeff


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793256008;
	b=jd6RlWXuwn6STdBJ1ZyAL2GQrw5kHpqydy9K/RcycIEW3Y2yxsQIWkZj6tzhprtf16B5
	 RAJ3Yehw2Kv60ZDMZck+eN7QtKolONKK2Jp4DqY7/3LbDf1sD+lyWG8/EYpph0oEtdwdE
	 WIdYD/EnvW9GEHpE+4FnmrN84MSa+Szyvg5nQQhh5PS9b3o50sfJdnFsjiPdf5v7SnOgM
	 sizAxECoJTTzx4HQrUXSgGji8AuKntynsFDX6paECsquWHtYy32IfXKmIc3fmjy5G4vH+
	 bKXeLVmSjJ3tpbk5h/tj0YaTbRVXdbIp7ciQXoVnqAHCBmmQFunnw1vM/ea90sfMxoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793256008;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Gv3BQaHlQOepHLlWrIvVRssNi+en5MSyyRdZDeBrNY0=;
	b=yajGs41k4xapQHrCvl//kVCFOdOG7KfUVEskdDCNwe+S86TiAtX78unhPzXe4KCnLZNU
	 eK3zv+0oKx4Betq+cWk2gcW9/tgp+8uuni9orj5SgRhPvYX3A0Fm04TLjxU7MkopzzhP4
	 QmwS8rGRzc74gyi4O1obaZ/s12aGfrMFkPLYcOaruS0qABGH3dfwgmYKJnyoBA1CHD9sF
	 ibfsJMFnm8XvdpBOn9+uFaxlqZ+zOfyMibD9gMOdWVGqSOkWHUdm+GfMHpo03aCLx/9Ni
	 JSupXb6WZ1t4H3iixwN1ewqYVNHQnOXZqkvGK0B9Mh26DvlePBioC2L8RyrpSyJEBGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pLOjDDAO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DL9WSOuf;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BF2606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:40:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66BF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pLOjDDAO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DL9WSOuf
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T5HIY32793488
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Gv3BQaHlQOepHLlWrIvVRssNi+en5MSyyRdZDeBrNY0=; b=pLOjDDAORyjr8kQV
	alcBDL2ofgW33nUMpNZhqwMSo625Jpr17pjhUxbBvsLEOS9rNCZGQ6Sw0Xb24aLW
	v688y4IvEGV0mhd8Tetn0WSSCEf3oQhOo65U2yXPrIjGMXmHj/VSJPtregj6sp8Z
	MnyfkbCUqXSIk986u2Ye2vkMpNuSG4Z8jYiW8PwctclBXKjokYz2EqYdKYmk4UyQ
	QOymclUA4ghsPfx+lNXPtnrMGOEmYN1fReRNxbYMiMVGcbOlgw2p48OsqAL7Zuab
	p+livXOEb9xPK8hgSCl+x/AfeDsROe9SRfbwb2qTm+wInHnefVuHN8K8iZWTlDo+
	PeEJ0g==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hks3n9nq0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:40:07 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30bcb065bfdso2934923eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793256007; x=1793860807; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gv3BQaHlQOepHLlWrIvVRssNi+en5MSyyRdZDeBrNY0=;
        b=DL9WSOufmDaOQS0xwLVdGk8TLtmpzlvF3pS6SLheb7XmJim9YQvC5r+ylWoZw+Ikf1
         QX1vAUB3ZUPPMdS/ymKUg8rlvjyJayEgGwpCgiYUn2nfgru53BqxLiVZH5i6dfWZpaUo
         03OE8r1BUCFj9tMH/Sl2La7KO1ifYf7iyDhgSg3WhTIPvEChT2TIFnjd8MbNb/MWNVvJ
         bJ3YtLUF0SJ9il917xHDz4JaaOfcfVvB4jyZQZflCs1EL4BRvf6LN4OtyYyIbDMAWVot
         rb7jS29LD1PUYI/kq2esuOjrInCxZzhMGQGLL4l9ytqaIrXrGZ2W19hYcYhXvac6QM94
         CqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793256007; x=1793860807;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gv3BQaHlQOepHLlWrIvVRssNi+en5MSyyRdZDeBrNY0=;
        b=a0Q7N/ZRhRX9NehF7oazAXM3qCCy5s/IzBraS1usjbUI6Tv6dCOqkw+Mnn/AbKP+eb
         dK35jhZhIuUg9qhxRDpHPkrMSqpLhhKrE9e5ypy4AmLSm7gBO3cxjYCXuwdenNwgTpMF
         Xgyi9Js46Ataenw0HivbLWU0wdEDRsVDQJcHf75RiqZ3WRYnSNL+KsRFxMeiNHi1Wyqk
         +/UkLrOq8B9Yut/KdMAJVWSX4Gpw+AuurkHS7EvxpnuP+d9Wdx1Nfi2jeiBfeCM+Hojq
         ePS9KZX4q2HhA+WP0Ptv/D2GY/8BHPvSnGxX8HPKWQMVzEH2Xu1hLcNr4A71mL2XPvxE
         ta4Q==
X-Forwarded-Encrypted: i=1; AKwUvBwgCV2XePSQipcjMd7OUMaqI2ntm2tJe0D4Q0BoJ7EuS3g6oD4WJ595d/lU5/NAPafAMWq9Zi9WPPSZlr1iow==@vger.kernel.org
X-Gm-Message-State: AFq9FYLOxymV6886X4jmi15p0Hu08L/eHe6Z2sKcR5ybqOVYGvlA9Z70
	mOIAauM27PSICsgSDmn6v3T5WngzS4hX+SV1yVnUsQV3vo0+pr+/Bo4Krdvl22LUT2ozRERlyAa
	OSNMU6GNYdPJiaUcB1JMmzQBq/VwFNfV2F0k8dUmGH0mUKD4+Le7GUd+BbQ70G7jwTRZxfw==
X-Gm-Gg: AYBFou0oWNYmH4z8BocPkkrbiW3O9WF8xz5nQiqMS/vrRu/tXPwINbdumhv+4mSJhv2
	Xe+ykySmQwC0hfsFeML/llVpk3knw7xkIJLBcc5NZatRjVK2D77ekAEjJd1WGNLHmcpOLkSA9jd
	uQggKaOV6k6PJ2WQ4kF8qRA87VyxeOv8tyGS1I/dsMJP04yxfVjq+By8aOlBe+9iaw4zRWyolAg
	v6zi59qwzO93q8HZ2WxlRNlUbVHUZqXjT7djjMR27LMOKJQZ2f9f5cAusVRsLyjVgRsshni3lqx
	vXs2bPJKQiJjg3bA07zDdW5iL9WVPjumGAcb3+uTorK5WZHLmcImMgOsiOfSWtWk/TnGdTTDZt/
	i55xfDhPAhe7++pm6N7t0TEz0FwCENB0V23Gumb8a0FwqRsSpe7N6rMXMMVPeViURtzRlyCZeU9
	iHSxkJR7HqGHxQb+Lta8lJ3A==
X-Received: by 2002:a05:7301:e10f:b0:369:f4d7:19fc with SMTP id 5a478bee46e88-36a201fb427mr6379467eec.41.1793256006504;
        Wed, 28 Oct 2026 23:40:06 -0700 (PDT)
X-Received: by 2002:a05:7301:e10f:b0:369:f4d7:19fc with SMTP id 5a478bee46e88-36a201fb427mr6379421eec.41.1793256005900;
        Wed, 28 Oct 2026 23:40:05 -0700 (PDT)
Received: from [10.152.202.164] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2398fa4csm16676903eec.24.2026.10.28.23.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 23:40:05 -0700 (PDT)
Message-ID: <e1f00156-fa37-44e7-9d30-177d5fe63240@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 12:10:00 +0530
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
Subject: Re: [PATCH] wifi: ath11k: Reject short management RX frames
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260926114037.3231795-1-yaojiale02@163.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260926114037.3231795-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: u1qROD0TFOQX15WBdiYI_i54jLAc8RMg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAyNSBTYWx0ZWRfXzXlKVOg3ICdi
 uWf33nvY2TTodk7/rva1mDbmQA/BK65t4em8+dB90dYAUgbqWXSB6z36ZPg+dpd/R43eCyuu8tI
 95bJM83mk0iMJq3h53v3f1qdUGENc0jfqysjoe0awoN7tByNcH5YBnlZfAIaKcv+oUVC90lGQ91
 /VAEodQd946DrTEoYlVgoe57g/0/2FHcvoDVGfLYFunlpmMCpNxY3Sa5mgSbwaP0UIFicJqAHm1
 ve5bNhaamCvWWBoH4d1PfLBMDNhVI8tDGip8oHT5c4VwFUXuqZ+4/tfk6UpiYMTkw6Zsvs00kdC
 StFxdXVoxlb0lOCQowAc8dsMhrqQFsDasI/6naADtYayLq9G/GPeX2oG7ZtvXk02cbanvM7jlon
 JLju8hSH3IbE735gWzGrJYDBHsy/ywzu6O7FrzwYKiyOqcPZ6YVaTidGcHzI+fcTN6knQI2YpKG
 1ceyWWfzoXgnS5nQNPw==
X-Proofpoint-GUID: u1qROD0TFOQX15WBdiYI_i54jLAc8RMg
X-Authority-Analysis: v=2.4 cv=XZEcX455 c=1 sm=1 tr=0 ts=6ae2ea47 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=9NHMLYiaqCzydb3n8i0A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAyNSBTYWx0ZWRfX0RBFY4TgnZcV
 sH7+ncV6UinDuDX04K48ED0MfQqNQlkp+C/nljnxHf6f+J1gjkil9ceVDudN1+r7MKu6AJY5ucW
 DbPBRupppVSSQATAkgggOOeEsPIrTD8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290025



On 26-09-2026 17:10, Jiale Yao wrote:
> ath11k_pull_mgmt_rx_params_tlv() verifies that the firmware-reported frame
> length fits in the WMI event, but does not ensure that it can hold an IEEE
> 802.11 management header. It then sets skb->len to that reported length.
> 
> ath11k_mgmt_rx_event() subsequently reads frame_control and other header
> fields without another length check. A firmware event with a short buf_len
> can therefore cause an out-of-bounds read.
> 
> Reject frames shorter than a three-address IEEE 802.11 header before
> adjusting the skb to expose the frame.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>   drivers/net/wireless/ath/ath11k/wmi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
> index bbca275a8289..02cd9764b6fc 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.c
> +++ b/drivers/net/wireless/ath/ath11k/wmi.c
> @@ -5995,7 +5995,8 @@ static int ath11k_pull_mgmt_rx_params_tlv(struct ath11k_base *ab,
>   	hdr->tsf_delta =  ev->tsf_delta;
>   	memcpy(hdr->rssi_ctl, ev->rssi_ctl, sizeof(hdr->rssi_ctl));
>   
> -	if (skb->len < (frame - skb->data) + hdr->buf_len) {
> +	if (hdr->buf_len < sizeof(struct ieee80211_hdr_3addr) ||
> +	    skb->len < (frame - skb->data) + hdr->buf_len) {
>   		ath11k_warn(ab, "invalid length in mgmt rx hdr ev");
>   		return -EPROTO;
>   	}

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>

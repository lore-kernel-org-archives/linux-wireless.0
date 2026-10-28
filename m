Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214208;
	b=3Xgf7ayAUGvg/6VdIyCCISE7sBOaEz3+QnocB9drtbHjzO8PPPZFFesFFUYASTHbQ9/p
	 uEV3whzydZQJ6mhA0r/hz3dKFZtrpv2s2ClIw6o6zUIB2QHBsedvSrGfLxPGha9MSoywu
	 NFjIYdSzKMs+U7ngTXB3fXNPb2KSad2rRjZnnqfBeoOXr3mjCekAhIUGg+tJOqxs+kcDy
	 KRLXj+D5Ic924MdZVgz6VbsqGpy5qdDR5o4Q+1y++8O3dhUBmr8bRPXFNkdnSbT9q9L/o
	 L+EQDkVsPp5alJ0liY74ZzY+XetT90f2lc/L7LiHbyhNxpSctRg2Bmm9a8YcQtYd0Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214208;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=RSOo6LMP9jDtTdJ5hdBRPvj8aB4n0MA265Z5u2qq3RE=;
	b=NuygURCb8p1Vm1XCQ7j4rtuYo1wm/MMd9oBIgOllZsOXEVK8143UUdiE9pVpaBfwyii8
	 yYcbANblOCbgwOvZDjRhCHpIUmnSZdDO0umiyGZx3L9O9/gFmWAwwVLsg9UAvKeHLzKNm
	 oPAk7Ygk4UXwgQ/k0NoRoUxByY9s2V5i7h8ugU7CTxPYEusygxY9qjq5pr/Y9XCC4w/ev
	 X3Gr7Cy6uKrxIdNzWqDHqx/rNzVIjP6mkLE7xkSMKA832kDtZRvPX9CSH6Kj05Ij+kimQ
	 a4Bb2rD9A3X0Atza8Ag0uI2APhwsQLt167VUvGn9HCaUfUJG3qQe1XpN41G0SMzcLJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=YGsur7X5;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eAI3CLC0;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C71C606BFB2
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C71C606BFB2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=YGsur7X5;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eAI3CLC0
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SIPfeb2431679
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RSOo6LMP9jDtTdJ5hdBRPvj8aB4n0MA265Z5u2qq3RE=; b=YGsur7X5LasPkQwJ
	mAdLe+vSNO8OTd9ob+3LiQLsw1S62uw5lOPc+VszgumKjGmHuZrFC0dgdKWowhLr
	xaKbD2MpWYvNY6c/nHwuwICSXjjAqat77NRNB3G0hl0C4SCEE1Hd+D3Yo8RlYp92
	rErNH6rEjT1du9HtHVkxu/YMZkSC0r03d+qv9vtGMyAjNqyERhTAjDp5fIfH8604
	Evbexh4XzAv3fz2aPT4YhCncO53WMzvuCuj0NPCC9xIRJGy9Sr3dMkYVxgs9VQkC
	t9SYxk3heV51tiyj6I6DRSEFyKC7aGQa/6GX6ovL0Dtt1hC/gn9g4jJ74Wou2IVr
	60Ibag==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkdf7tmnu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:03:26 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso2325647eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793214205; x=1793819005; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RSOo6LMP9jDtTdJ5hdBRPvj8aB4n0MA265Z5u2qq3RE=;
        b=eAI3CLC0r0viy8qIFnTBpgQTvpxKQxvBNE5zA7F+PD0mE5G2wJf9Vk84t8nCQT75X2
         EDPz/EFkAocsqO+LKZrlwhypU3BeLY86my1nQA9DoDhJeaAgLPCxrZaMicCiBy0P4Rz2
         Q7m7yzaTqh+n4OBipFTWNSMPtE6JMv+gREzOPvu+B9qH7COerIyd3xmIbmnejsV88Q1z
         pmIcMm0ejHlbsjoqyF5y5aUnhObs+t7BlxLxpfvm9XNitUwGyikxIztJLJdffwKoRtDB
         ztLD5hr9umNX7cuNTaNNfGBO5VTgoFHBVd7jjqAbge+IumztHH+ZpjYmCPDQLKX1Fnp3
         sz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214205; x=1793819005;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RSOo6LMP9jDtTdJ5hdBRPvj8aB4n0MA265Z5u2qq3RE=;
        b=PTnvAgTa5FhUXPQdfiLaxQF1dleK2WEbn93+VEHW7cFoflrkTWWrPxRXR2IPpLwhli
         3ieSuq2DyfSD49O2PoLsjGQ5o4qd/6ABxrNP/MjVMPbS+z4bBFCSuLj3rDBrVnBZE5hq
         I+qBibatUTdYc1nNOqsetbykYoLWsu8COTQ0425b0L4PbDwOVVD+igYwX6DStxqaD2oV
         ChT9Dd0ffYkPF8x3AeiR+57wzJnplv9Z6+t0q3UwgsFUDwPZlmj7UDfGIixbn3nARMih
         6gssk0uOZk+NZHXHwOVzakqeTvdMOnvcRGr7ZNtUNtZSLBXUBF2G4oKi6vLATslxW8Yn
         kH7Q==
X-Forwarded-Encrypted: i=1; AKwUvBw4Zvv4DOlF6m9MKCImcOacmo0vGEC+529Mzl8TbZJy2PoXdL7D+4lsiMdGEwWLefyO7shHFRajLW8rMdwStg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL5PmKmAm7xiDC6F24V3djhC5vgGG7BM6v+V8Fcf7fwt01mn/jv
	yXhoswlNcysMXmaGzd2GVDoWUKFH8D9TzITm+pVTlNIVDjmJRMCQjVBAQmz35fv7eK9ZLn3NmTo
	72m/MwFj9BcoXSBvQ3AYAhU4KAwu3Kg3v/uImcfqav2dXeLiSlS5wyOImut6XuUXecuQtJg==
X-Gm-Gg: AYBFou35zw+5domP/XaBsnXbsA2ZfcY1oRn+H2l5NQY64UIbaoXs7mHfS3wr2DbbSTw
	BO/ucyNj6A2SCiDzMUIb51n4ifL5tvXVttU/gNchPs31wAZbNRjgk063NqcZdzZYFVVloOTB/Xe
	QbA0je1BHIHmK6Q5D9eLA/dFYOKWT0dpa/Qra1nYLsfjZTeXJESBNis3wAybeMTMV1GGzwi3Usr
	upg0zCTU0ZOuqXGZhLcCMvi6HjlF5OkTk5Rqi6JB95SFUPtI1zv8IYle8FQAY3J3qELdD0dCtMm
	p2OoeW3/lMnbOjFpIR5NtCk6ue00lcdgBsuS/uvv0QwanGP+WcpTZQETPHX2hUUNXMmIC21VckP
	KfUEbcKZ6f22BUBRsE/lOWr1CGFU6CeP2KnHNr+asfbCNvf+Iz9ezv7fLp7zODmzPVTH7gGOF5O
	2ayyHUQ8NuANSEiez6tAxLvO12LHP95TY=
X-Received: by 2002:a05:7300:d508:b0:369:7c:bfce with SMTP id 5a478bee46e88-36a2014adcfmr6673864eec.14.1793214204854;
        Wed, 28 Oct 2026 12:03:24 -0700 (PDT)
X-Received: by 2002:a05:7300:d508:b0:369:7c:bfce with SMTP id 5a478bee46e88-36a2014adcfmr6673777eec.14.1793214203994;
        Wed, 28 Oct 2026 12:03:23 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a237be80csm19055196eec.2.2026.10.28.12.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 12:03:23 -0700 (PDT)
Message-ID: <7ecbb748-85fd-4a5b-b673-3f29b683e8af@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 12:03:21 -0700
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
Subject: Re: [PATCH ath-next 3/3] wifi: ath11k: add a module parameter to
 select the hardware mode
To: Julius Bairaktaris <julius@bairaktaris.de>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Baochen Qiang
 <baochen.qiang@oss.qualcomm.com>,
        Semih Baskan <strst.gs@gmail.com>
References: <20261027075544.19144-1-julius@bairaktaris.de>
 <20261027075544.19144-4-julius@bairaktaris.de>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261027075544.19144-4-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=M4bYuCws c=1 sm=1 tr=0 ts=6ae246fe cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=bC-a23v3AAAA:8 a=stkexhm8AAAA:8 a=pGLkceISAAAA:8 a=ssmgTYQ7C2hsjJ5zoukA:9
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22 a=FO4_E8m0qiDe52t0p3_H:22
 a=pIW3pCRaVxJDc-hWtpF8:22
X-Proofpoint-GUID: _Pi0zVCjKpndf43woWL058fc_FSZoZ62
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA3NSBTYWx0ZWRfX/6ywX/5KNHoH
 ARoIs1Rdfo5AkhIfFV9SsAhFTQkg8bg8IBxvNGOISzW72daL7YKOwFR6KEo/rWZ1LRD8QTmfKCS
 +bwBU7ChQA5bsFWzcJXJoN+cMSBXUd0=
X-Proofpoint-ORIG-GUID: _Pi0zVCjKpndf43woWL058fc_FSZoZ62
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA3NSBTYWx0ZWRfX/wnCgLJtdEAD
 KUcR8/lgISqKuUnDhi+lSMGe2YsG0pPOOJ1xi2Qu3f4k2J4HgSE98zhd9GtWi8TIjSCII1SAZ7R
 7V6buByUMKLUftpBI6EwPHGUr84GWkr+SzHLbXM9sKY+ya1o51raU7USlp01M27sXk6TW3WluYL
 3wBEl4TrR7cPxXmUVKZVHm5tIW8bfAOXEajg93gfD2TvJD1Jdb+HkqtHuDa8weujvOAGpsQiXgk
 VpXEi68ObQhfT3GvxGgpS7k9x2JHnpu+AY87XIexApUkaA6rR3mhJAeqota9hy49yS3XyidC06o
 yro4zURfFVJU1gtOlDO9WxGyMFLKv+y3xoxTeIAuunY9xQ+SNyfneZ0ztCWbZCPCS77hgXaqRE7
 sZYKOqcUadaos09LaRKNkvAj2D5XITmcwrbabhZmjy042/XgOJA0ZVz9BApeZydNi0BX0avBoa9
 pAiZC93ZLQDw67G6JoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280075

On 10/27/2026 12:55 AM, Julius Bairaktaris wrote:
> ath11k always uses the highest priority hardware mode the firmware
> advertises. On the Zyxel NBG7815 that is DBS+SBS, which splits the
> eight 5 GHz chains between two radios, neither with a 160 MHz channel
> width. The firmware also advertises DBS, which gives one 5 GHz radio
> with all eight chains and 160 MHz. Add a hw_mode parameter that selects
> any mode the firmware advertises; for a mode it does not advertise, warn
> with the modes it does advertise and keep the default.
> 
> On the NBG7815, hw_mode=1 brings up the 8-chain 5 GHz radio. iperf3
> from the router to a 2x2 HE client with 4 streams gave 1.22 and
> 1.20 Gbit/s at 160 MHz (two 20 s runs), against 886 Mbit/s at 80 MHz
> with the unpatched driver (one run).
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
> 
> Tested-by: Semih Baskan <strst.gs@gmail.com>
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/core.c |  6 ++++++
>  drivers/net/wireless/ath/ath11k/core.h |  1 +
>  drivers/net/wireless/ath/ath11k/wmi.c  | 17 +++++++++++++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index 766ae27306f43..e1a6085a065a6 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -38,6 +38,12 @@ bool ath11k_ftm_mode;
>  module_param_named(ftm_mode, ath11k_ftm_mode, bool, 0444);
>  MODULE_PARM_DESC(ftm_mode, "Boots up in factory test mode");
>  
> +/* hw mode values are mapped as per enum wmi_host_hw_mode_config_type */
> +unsigned int ath11k_hw_mode = WMI_HOST_HW_MODE_MAX;
> +module_param_named(hw_mode, ath11k_hw_mode, uint, 0444);
> +MODULE_PARM_DESC(hw_mode,
> +		 "Hardware mode (0: single, 1: DBS, 2: SBS passive, 3: SBS, 4: DBS+SBS, 5: DBS or SBS, default: preferred mode the firmware supports)");
> +

Is there a different way?
Adding new module params is frowned upon.
https://msgid.link/6d553cffcb0ae84e141006ae1430f6f37909ad2b.camel@sipsolutions.net


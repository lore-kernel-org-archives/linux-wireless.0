Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CF837CD5A
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786392778; cv=none; b=MR1xIPKhTkV23xPqc+klJSjkgsPjjFqT4u5/u4wJxm6XopKX1OuYxhVzzkvwhKgWJZ4PaLexToyB0taG+14gOdf7Plh3YeKrGEwhqu6WOUboIEJu4YdLbnux05NqYnTNBxd2f9yW/MfamTlcC79VLRy38s2NWpUvvGcl5DaopOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786392778; c=relaxed/simple;
	bh=Roc4K3epHkh5JnaF0kTbUObje1U9PZCAsD6UaGILGR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWSuaH5ozrTEyQ3a7d/PHFN6l03fHMZ5QtfEt6Xvg2swjHKp0WVd5cEjv7PUsWTKyCUST86K8cAappe8k/sD34IF3hgFayXw/pmieajgUCAxq2lr183ovCVP2hzsGfMHYBArafS49kEaUsXfu+josf+3Y/jyCjL7DCITz+ePPpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B9G890gP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WRQyKLlr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B9G890gP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WRQyKLlr"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AJlSE62617717
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	toBUUDgSdBywAEmMdTmfJJb0x6y3q4edP6m+xebqlBA=; b=B9G890gPk8ih2zrv
	GTQPrM9AIj/TjgCeHgWtwGogYej5sRnjsxHMGnahICBZJ1OFLw+mMuhU1RHb/Zes
	qWoNGMS1WzyiNI9kEfXwVya3Ass9osgOcjDuW4ajzOV2tSV/nBgDV7SMrltm5iCd
	1zg2DGXfZ/Vu/7Jw7HHHSrWq39XqODPl9jvAinmonAqZcY34i0zEqvs4yPwnaS+F
	oZz9Km14UbkaYcoCUCcrazaN/JRE6YIMG45c13b6sY4fIDum1YW0cB4FayvI0kwl
	i+jwcovu9MOa+qfQtkditB2BkSLvZJPQcODjlIkLV/WmxvNE32NTLFNZ6KRxIcZ8
	mMebfw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyjjtgsxn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:12:55 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca124bf0189so229575a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 13:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786392774; x=1786997574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=toBUUDgSdBywAEmMdTmfJJb0x6y3q4edP6m+xebqlBA=;
        b=WRQyKLlrb4SCbApGnHXysQqFDySCDeWs9recdpbnF31ax19YltF9nKzj+ndAUhtbF1
         M5L1cFTN7YQCfYwqLtUVZ6n7DbSC86YcXHdNoznN4gq3XLZsQESqAYPUfdTs/sR6K6WI
         kXwd54gn5suLICFL+UzaJAPYMxnDa19D5V3z1F7M2HFwh0LgTp5gIu0EHW0C9yyFoOA8
         TvFuu1kkCDg5Lg4Lpfi1Zf8VHq6wFowkA0vTuk9h5hxHi/M/4VFSQFAI+I4vGTklxjny
         YVe0NoYMBt5FL0HCrJMs+97HyNGZWuh4GFR+qmJ+VdUTvgqoXrqQyolMjhpFNVtffmG1
         rKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786392774; x=1786997574;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=toBUUDgSdBywAEmMdTmfJJb0x6y3q4edP6m+xebqlBA=;
        b=VYnna3fLd82Gv2EXxs6phOKvWu0sobTSKsGGAQR0T3FN9tXwuv7ZyMteYBuV+felmb
         wA8Bv3BP61Q1UJ+lAoyelLbq8xFuuUwFADVDXK7L8/qA0jz3xxku24EknZnte4oOcjl1
         KuBaJc3gcYFhh2NxueUgJPPX5auaAKhd+rND5HpKi9O37sC6ExuOiaCjIT2bZWya/fM8
         2Q+MXM3xSNHVQygJcS/0OwYeg+Oq68x07rnPOh5ZYMc6BZbJpJ2zlbXin/zjWFMv8Rq3
         wTj4lnSknbkPMb5YDhVlqvqnySri8+PNUGP6Z1Be/9OgaBxcipOhx/y4PuuDVtoUb9MQ
         6GUA==
X-Gm-Message-State: AOJu0Yz3b9nobvGAix1mD8UCGsSSC4gaGinTR6bhto4pbaD3IkkUfAIh
	DtdV4KHMTY2Td1nR6Gcw4H+IHWof/Ak3PwCsqq2e87kj9uPH4yAhi8uh5DZZ9uTochTc6P291dl
	xvjeJ1w+WjkHzypuvNzGjV2NBW3uSEgfiMItggSEfIL1H/X7CTw92K1cmDPAm/tsgT72yRA==
X-Gm-Gg: AR+sD138X4yaxGBUifnhu52NGo1BuILIGZprKkThvodNn2qb2mjrOlYQZDzbzPo/Hpk
	z8ZTJ31z5gUYLCD1HeTmLTeEbLZdt4+c/9OCG7VMvir5Zdl+wXyE9oYc4kVvMAR2pnR1OcemlUW
	LHL/PbJAbJactqscIWYCVjDhUEbSl0D/23pnaMOacN8xEk+cgtrNzIf8zX6qUONCpekvrt3kuX5
	HuXkfyFVNb2ayQeJB8csMvK0eSZy6zXf9RYPpgZPCR8mwrzXjmLpxPVYbymBVRIGs61btaH908L
	MdJ9bTpepAHMzUu3ZNQ6sh864kqcCV0zugGONlN/5N8o8HtgAR/8DIKxEGr7hRCJFp7+asy11NP
	jxgFgOF8UshwIiJ2//uT0ZIAL8jWmPG4zUVdsopNE+Qy1buDiVXYLT924kZk+
X-Received: by 2002:a05:6a20:2589:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3cc22de56d4mr901233637.5.1786392774043;
        Mon, 10 Aug 2026 13:12:54 -0700 (PDT)
X-Received: by 2002:a05:6a20:2589:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3cc22de56d4mr901191637.5.1786392773514;
        Mon, 10 Aug 2026 13:12:53 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86d3fcsm46495518eec.4.2026.08.10.13.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 13:12:52 -0700 (PDT)
Message-ID: <98e79919-7463-4033-9396-315d09de771d@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 13:12:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
 <20260810144444.2033607-5-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260810144444.2033607-5-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDE3MSBTYWx0ZWRfX4DuONVjVBvEu
 oCoaYGrFSFSg9+rPc/nYRoIM65CmBYe7FMOAAfXoKKSyGoz4o4CYudEDVgkoTU7z0puHv6gR5xX
 pQaAdq7akB5GokalXPlV1/oFx5j+Y3McioNf90pA7ChqdpdnrNZlKfjJzAEBGY+vqfAlrFswyPx
 xVWs1Mk+JJFpQviFD7cHUSonPpaUV+NDSWQ7wEP3xIpPS/sSyOrjZsB8EpiEKfFLh4aifABKiS0
 kZT3lvEWy/wqbkZzfdhMNffuSjVtu2tTTDCzb2J63vXilcaciUKOsGgEzk1ZSbG4HhVc7AwV4J9
 MDZu9bvF5kjESDZXcRnYwtVYuVuQYQ37LPmvLT350h7HvNoJXNh7eggLNjoLqwNvlHhcjsr8/Oq
 gyBZYzf66tYrizWeG1ECSKxEtG3leOgsONeycubTv94njlzmhIpXv87ltLcDaT/L6cc+9l/cslu
 D93h1Mp2NxMu/3fUMFw==
X-Proofpoint-ORIG-GUID: YuGs6CRapqiln5HGQO1WxNrMiQyMBL_M
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDE3MSBTYWx0ZWRfX+75BpzoFrtpo
 DV0bO9coKNeHtPl0MNO/N0JOO5CVG2lCtSCVYLWNF7I3brl9yu7qVjyEB3k3bj2gYUqniA4BP0z
 fYGUArCAbk5lbE+jskkneY407h0sEUo=
X-Proofpoint-GUID: YuGs6CRapqiln5HGQO1WxNrMiQyMBL_M
X-Authority-Analysis: v=2.4 cv=JsHBas4C c=1 sm=1 tr=0 ts=6a7a30c7 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=fraSdVAxK4OO7KLyYRQA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_05,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100171

On 8/10/2026 7:44 AM, Pardeep Kaur wrote:
> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> 
> There is no way to reset device DP stats counters without reloading
> the driver, making it difficult to isolate issues to a specific time
> window during debugging.
> 
> Add a write handler to the device_dp_stats debugfs file so that
> writing 'reset' clears all device DP stats counters. Change the file
> mode from 0400 to 0600 to allow write access. Use
> simple_write_to_buffer() to correctly handle partial writes and
> non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in
> the same file. Return -EINVAL on unrecognised input.
> 
> No lock is taken around the memset since the counters are updated
> locklessly in the datapath; taking dp_lock would be misleading as it
> does not protect device_stats updates.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/debugfs.c | 36 ++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index ec49692107a8..cbda754d8656 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1220,8 +1220,42 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>  	return ret;
>  }
>  
> +static ssize_t
> +ath12k_debugfs_write_device_dp_stats(struct file *file,
> +				     const char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct ath12k_base *ab = file->private_data;
> +	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
> +	struct ath12k_device_dp_stats *device_stats = &dp->device_stats;
> +	char buf[20] = {};
> +	int ret;
> +
> +	/* filter partial writes and invalid commands */
> +	if (*ppos != 0 || count >= sizeof(buf) || count == 0)
> +		return -EINVAL;
> +
> +	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* drop the possible '\n' from the end */
> +	if (buf[*ppos - 1] == '\n')
> +		buf[*ppos - 1] = '\0';
> +
> +	if (!strcmp(buf, "reset")) {
> +		memset(device_stats, 0, sizeof(*device_stats));
> +		return count;
> +	}
> +
> +	ath12k_warn(ab, "unsupported command: %s\n", buf);

drop this.

ath12k_warn() is used to warn about inconsistent state, not user input.
The -EINVAL return is already the correct user-facing mechanism for returning
status. Note all the other .write() functions silently return -EINVAL on an
invalid argument.
> +
> +	return -EINVAL;
> +}
> +
>  static const struct file_operations fops_device_dp_stats = {
>  	.read = ath12k_debugfs_dump_device_dp_stats,
> +	.write = ath12k_debugfs_write_device_dp_stats,
>  	.open = simple_open,
>  	.owner = THIS_MODULE,
>  	.llseek = default_llseek,
> @@ -1232,7 +1266,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
>  	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
>  			    &fops_simulate_fw_crash);
>  
> -	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
> +	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
>  			    &fops_device_dp_stats);
>  }
>  


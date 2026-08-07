Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F3233943
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 02:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068885; cv=none; b=L+XiKaxBmcvrREaI7eYegFx0299mxtaOtrKsKJjWupsHLTobJTSprPAoFDJ3VuO4yKlqdDT9CLUz5/G1Lt5mbO3F3Dq+++BykdwX/Qz6LC302x7eqLgGbvtUPDY4BoUXaUlMijOHPqS34XoW7Mr2PFPSbjiCVWeIBO9h2NeoDt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068885; c=relaxed/simple;
	bh=JYwyDzGJVBBRe2YeBH8CH3pMoKy0zYxHiOS1RV8m0gE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M69WMonP9wLyxHCNW/6xd21OYUKid03MGnUmaDacpz7YsCQ29agJW1z4KaiWfJXP2Nz/GbjxfO9aiO4hVzlHuglwg8cifmq4PPlrE844ZDZbgITAtF6vLz1Arra5yvMquvTCl82uIUcuCnj6GKoO8XqOeiSa6TpuTm15w/Pxjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IemFt93B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=de+H1JXC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IemFt93B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="de+H1JXC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770Gl7C3251830
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 02:14:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Mz00fYtOpYKyQvarXkn0NFY+QnXh7H87jp8eyuTRQGA=; b=IemFt93BQHdj5y8L
	NMoKbGZJkHVy2l5XqAaQ41/oq/uWtZmnZNSMFS/+AwzAm7/TrlmmxEgHrBV5geBI
	A9xC78Zs80JswAnJDjafb5z4zxeNKykZaA6NTa4BNqLrXgDNkbLkFGrPjnbytjxC
	QaF3le4QaAyflf/I2yWezZddO3MHzULITWWX3HJ2ns9vzZeISYhj8BHiDZkxO3X1
	DkUb9pwTv1mKB8juku9dn3FMAyJM6z+vrePV4QHq5C9pzbWJXLQiKKzeWD85Zci9
	tXkrKxnNxc3xJNq1VwzcA4/kiDt+XF+ctGwhL7zzzZ4b2M6dlmZqM60XGUgjqzfK
	bzkV5w==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6k1tg3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 02:14:42 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso3484896a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 19:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786068881; x=1786673681; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mz00fYtOpYKyQvarXkn0NFY+QnXh7H87jp8eyuTRQGA=;
        b=de+H1JXCYaVcfBWaun3+b4+Y0Cnsk6Ytf+jzDXCSpXOcY4x4TvUjdU/eLTRXMwiOMi
         GUknFQ8wEhQryrCHYy764RIvtB5YHU/O82KPIVePVTgwXYuUs5oSb7Ca+8+bwzSUDGUr
         IsvXwpKr+HCcJHhgQBewrdWx3YJPHbT0a1QjTfQgn7i8oPtqEX4IugVe0K6n91cxa4rB
         IESq1y9KN4NK3+ce4ObdHYGgJukbEnDTUD/bzDaI7G391CWFt9sSTFEgBqznhDE8OZUB
         D/41HAzJwyx9bWb0lcRSs+dlOlFIfZsAsRt+ODjvBgX/AURnexUhAgFesOuIXNo6xpli
         zpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786068881; x=1786673681;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mz00fYtOpYKyQvarXkn0NFY+QnXh7H87jp8eyuTRQGA=;
        b=lm/ZcNNCIQmzKoWGPlLuIwxV6ASAK7nRg2NFn6ddQrIfJJIjVVJ9Ns3oob+2JhGz8r
         JGsfnD+VYIKm5Vl0Awy28owVPYv0bFN3zkzmyb5x6kc8D583qJwQeKZ3io0PBrpMyAZ1
         JnHRLcTdoyCynz1mo3rQDeewEr2IvXajXJebjbM2UcXTxGHOflnLSpY4T/3/CP31JJZY
         5Lr4ehR8R6arLJp7lBtizWXJhqZ1/WQYkd6yXm7+7j5wdeyDQ0xpbHDagZ05AJoBCYcn
         L3vkptpzjU7vbwCxhzJsO4lrIZj2VMdafIZfPAabYB9C+GegYq17aYflgZ5HSTGOCKrf
         70aw==
X-Gm-Message-State: AOJu0YyBTxQknc8DxxwbvUSsgl0hkcFI9lNEuDKWar6GPS6OiekqhYeK
	fA3ppZmUfegukj6OxGYvLvLBlZk17W5Kxmeb6XAxmj1rPwEngTw0bVcEA7jfgrsrR04xmZ8iOh5
	Zh4/qhVuiP6UQJfvxezMZzLP/RBFNqlEnfFp1R/U9lwzBnxSJo1JqQAtpJCBUxffl6XEszQ==
X-Gm-Gg: AR+sD12z31q74b2ty36GCnKzqyUomtFkk4d6J+V+26pB5o2Pwl3cZwg7TZISRG8EFkD
	z1+MIRime7ZCUplny8Xzvoms29WriqdUme+17tEXG06d6VSBjSBylr1ujHgK9c3MIYTwlvgZLuI
	K6eUXsRWlXf/oAHSZ7cCk/1XQzfpCCvs6TSPkKze/yCtgBdJEVIAK/1H7INUTmmnqhckKms43iJ
	7rnbogt5waYANKV/aX198tKr5MmJu+Zx1Gj4DLuZUyweszP/zv78G7TTeR+2PXo7tbYiJfI8Myt
	AD4J5IXekrLrxW3XcRUGNdoedbzTicrl7NfTIyOyaBJhh0BdbtcweG5H73IWUUkp3rZ/QMx2Vps
	3D+oKJvq/LmD5tywsLn+/TuwEwGmBJSCJRVS+mPH6hzfCkEufGjyPM3r3S1eN
X-Received: by 2002:a17:90a:d443:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-3903c594637mr21790176a91.10.1786068881326;
        Thu, 06 Aug 2026 19:14:41 -0700 (PDT)
X-Received: by 2002:a17:90a:d443:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-3903c594637mr21790135a91.10.1786068880803;
        Thu, 06 Aug 2026 19:14:40 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101a60867sm1838672c88.9.2026.08.06.19.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 19:14:40 -0700 (PDT)
Message-ID: <9dd4f651-3437-467f-9994-93b92a83270f@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 19:14:39 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-5-pardeep.kaur@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260806132427.3704828-5-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=RpX16imK c=1 sm=1 tr=0 ts=6a753f92 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=Ckv83GLBvhiTrphEyGAA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: iPggphOoIS_B4OSQlkllMpmZRaPXF8y8
X-Proofpoint-GUID: iPggphOoIS_B4OSQlkllMpmZRaPXF8y8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDAxMiBTYWx0ZWRfX9F+m8QA4luzC
 el0O8FwqIc4dLN3xpoY6fihKD5UNTOYv1CFbGvfuxCHW95VZ8NhkQ0SjWVHJqE4KMygTSZXN013
 HNHNlyJktmgJKrLnSznjBTEMb+RgC0FZnwFCYQPjsbgPhWmLUy6xegi98/NCBJiQuR1KKHIsXWb
 YPf+jZ49JdZDeJDyo0yURM6VLYP9yACiWNjyxmQd2+3IXqkD61Rxk27OvhNWVcwine9zBtPrf1i
 cvFPcpQXy0g6ueVuHHDrhEEt5iyV105yzwkJaMUiXg9dayKDdvfSYEqgkmY//xZPVu4DnIaKT70
 xTSBuBAFqUl0uHUaDg4ez8bbvw1x+dPdhBfGRhp4bTInznhCQ7HSQ5QNJF1ApTCra4a5kimtZF1
 0+vnD4WgCzQ7sXiImXIYUA7whdr7oFI/6s3shp7+tEsIgLf0NFuexMoIrQkmmSlrKiECkCNPhd4
 y3HZx6lIwgDZa6OyiVA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDAxMiBTYWx0ZWRfX1PPv5zMfi9Ct
 oZLSmCw0ISCzw3yddmCyNJe1B8fGB8fUgvLTOwkPHCkZzYhNfDB5DcXta3uSgRnsUbTDj9kMvnI
 3Weg+ewDfmMbgRIJKWYo5DAilFylrDs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070012

On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
> 
> There is no way to reset device DP stats counters without reloading
> the driver, making it difficult to isolate issues to a specific time
> window during debugging.
> 
> Add a write handler to the device_dp_stats debugfs file so that
> writing 'reset' clears all device DP stats counters. Change the file
> mode from 0400 to 0600 to allow write access. Use strcmp() with
> newline stripping to match the input, consistent with the existing
> pattern in debugfs.c. Return -EINVAL on unrecognised input.
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
>  drivers/net/wireless/ath/ath12k/debugfs.c | 35 ++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index ec49692107a8..0e446a666f4c 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1220,8 +1220,41 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
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
> +	if (count >= sizeof(buf))
> +		return -EINVAL;
> +
> +	ret = copy_from_user(buf, user_buf, count);
> +	if (ret)
> +		return -EFAULT;
> +
> +	/* drop the possible '\n' from the end */
> +	if (count > 0 && buf[count - 1] == '\n')
> +		buf[count - 1] = '\0';
> +

my review agent says:
The new ath12k_debugfs_write_device_dp_stats uses raw copy_from_user(buf,
user_buf, count) and never checks or advances *ppos. A write split across two
write(2) calls (non-zero ppos on the second) will copy the second chunk into
buf[0] instead of buf[ppos], silently failing to match "reset". The existing
ath12k_write_simulate_fw_crash in the same file (line 63) uses
simple_write_to_buffer(), which is the idiomatic kernel pattern here. Replace
with:
ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
if (ret <= 0)
    return ret;


> +	if (!strcmp(buf, "reset")) {
> +		memset(device_stats, 0, sizeof(*device_stats));
> +		return count;
> +	}
> +
> +	ath12k_warn(ab, "unsupported command: %s\n", buf);
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
> @@ -1232,7 +1265,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
>  	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
>  			    &fops_simulate_fw_crash);
>  
> -	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
> +	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
>  			    &fops_device_dp_stats);
>  }
>  


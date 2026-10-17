Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AC86DCE1
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253046; cv=none; b=hpIDyfBusXwjD0veGPacPbr2TZQjrAZm4ztZ4QEK81lxLfg5ol9i85cp8h2YxIgz8kb0Qyoc4KT9n9kg97GAhMJ5myHXFpuZ4FT6grnZ/BFrFHEXtVIEKe+rX+ozSRZtwmON0mcggAQHZXkvF7KaWP/hM78PEZXuDa0wS0SEhp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253046; c=relaxed/simple;
	bh=jMK4hh+Q6fWIReGITSwdHKw8dJzLunnPFmG3uc5QBZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1vOIXQeyEG+Yllotvbmr6Ils9JR46+y9CgosoIscNVXRhkt0ctqslguYO9Qu60pFtxIStS5mNLDvny89qNt3pIGWlAFvjbPmgBKzBkLKULWhlL/QN4xD7KGnrfvERD7DUohkIIlWKW1X6Y8mG8nGUTCMDbsZ7uB8Bz/RvnDp0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g+XVdKBo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bh/PQ658; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g+XVdKBo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bh/PQ658"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69HDEnLW2244480
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 16:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HwC6Ct+0V7OkpdYkmhRn98kTfyIg9bZcmVNgWSBRMQc=; b=g+XVdKBoE4+1Z9E9
	7yG81V6MItxQzcJS3e5R2TStMxum4Dpj1WdHHkxqkD2DpmT6Ut/FcNeX34IZCKXF
	ia73hMmSxm6E+sYJY9aWdmLrDHg9ZV3WNDkVO4KQ4geJW1fgiZxhjKZvGNqdkUCo
	GCAPUcBbjhnkdvthvmhZ5kMIA85GjdyI0tYu1Hgjxj4/vMmMIG6A2OWxxb4nWJ68
	mBkNG5Lssw6eztBOP4cHPyJ9I1BiRDSJqRjXM5t5ZtYyujYnpW2Yhv5RQQEWVhd7
	Zh3m4l1qWr8GSu5YDp35oWQloRWo1N2NG0KiHiv2/N3dN/vlHuVUY1RIdPGjC5OA
	wlj6Zw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbxqfsk3u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 16:04:04 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35cbea41088so1322847eec.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792253044; x=1792857844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HwC6Ct+0V7OkpdYkmhRn98kTfyIg9bZcmVNgWSBRMQc=;
        b=bh/PQ658zU0mmzLIwOOcKBVbGnoLQFA8M6ooV26N8ZHzqS80dKaBvpG9m1Nb1JCz9K
         WxR7kyeSVNVjT9v7qvc/Xhoxb2ByYqwyhjZzHxwlYGIxdcdV5kcJoGyS6CZucYes1oZQ
         izRNEH36lDQI3bwSZYN35xXOLpT5yBGHsr7jj2dxnzV9ht13GTBM/Qai/cbCTA7Fk1g2
         R+wDfKmqtt4A8f1ganWb+MqOj3WevTCMfVmUea1B/iqkz0sAMT/8uoa4w0GJ2BU25Ecn
         xrXy9p/hHOYLrRcAKr7YVPJh4WFtmZ8mrMh44Tlo+jAWsYCMcklfOfrfVIkBkXX3xjJn
         R/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792253044; x=1792857844;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HwC6Ct+0V7OkpdYkmhRn98kTfyIg9bZcmVNgWSBRMQc=;
        b=ydZzXFhzyqKZ6vBLTCo7yZfwSGs6VAL/68aYn6MgRYc3KIvcf2zy17vqUH8le48Jul
         DzcFT2Oofyju9vQdRUP94qGg1Qa/UmZaHbZCoIWPgQNyqPTWmfi3WtoM5bFpq6/0Ez03
         ETOAlGVZH39yah8zLwmYmV/qwaUgn0eSLwAe3A5D9Tm8ookP21kDBNTKq5ekUaYT9Uz2
         T5FG1cDOfsY0f9ASDnFlkj2fF5YpypCyTZEY2HNY+5NCjjPlGq+kDZMYfrUe7bEb1UZY
         5sQmQo/if/hxqAS0ENvYirdI+9Z7ekE1ry8TZB6YLi3AM7OGogV+gEzeuo4uZnNvpvit
         Kt1w==
X-Gm-Message-State: AFq9FYJAF9UaMh/9m4hsAps4dIgtB0YkafYZNmNTuJXudt+PKqFP/AN6
	meHJhKniePZpGisv5Q3xdUwS/WBDVCZZUKZz9fS0qiKoRrDKh7zfm8WqnPDyFSE06yBg1BWPh5Y
	cqjE5TGmbVtrS7po9Cz+kPr6DLvT/cp78trCOdkc5iIL3CufxB8zNMYoig6VwuC6N8547gA==
X-Gm-Gg: AYBFou361zjAsCSYj3AE7J9NSwNPCqY1uVIMZLfGTiAmpEzyJvTbW760bhrv8uaHYh3
	Fc08MfY8W4SsSay06pCgHJLxyn69ws6aTWN97TGJ8r96Qy7WZeGmgxfKtRrxrZexo7TuLfduF3m
	MjlPuHFq9GDxqW80Rb1Mz8FKTk6SZ/u2hfgIOB8i16BeY1unlMoKTDy6UKXMJJwj77B9wE1S3tF
	pkf9U9vgkojPPkYxKTluI2eo8lUw0hBAGHcoDoiz5AvoPXH57lAOScdMEv8JdBC33rymO0M2r6h
	JnWTwH1xp/zj7/EgsJvOGYu3vC2nYrhpEJEqe2+BVBrqnc1zRFw0JlfhmpF6pYMIw1Il7NYrtD9
	GK/QhJaaUYJW5yeutBku7tiNiODU7J0A+fDFA00ieI4+cfoPNtvVtk8iYTg==
X-Received: by 2002:a05:7301:4615:b0:35c:8ce0:63dc with SMTP id 5a478bee46e88-361a1f522b5mr3727360eec.20.1792253043369;
        Sat, 17 Oct 2026 09:04:03 -0700 (PDT)
X-Received: by 2002:a05:7301:4615:b0:35c:8ce0:63dc with SMTP id 5a478bee46e88-361a1f522b5mr3727326eec.20.1792253042551;
        Sat, 17 Oct 2026 09:04:02 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081ea7e5csm16144290eec.15.2026.10.17.09.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 09:04:01 -0700 (PDT)
Message-ID: <8444a9b6-b197-4b64-9afa-d3741c2a85e2@oss.qualcomm.com>
Date: Sat, 17 Oct 2026 09:04:00 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wil6210: Replace %pK with %p
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org
References: <20260918105632.pDhc9gIB@linutronix.de>
 <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>
 <20260918201145.kQDy1UrD@linutronix.de>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260918201145.kQDy1UrD@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE3MDA2MyBTYWx0ZWRfX7My5iqiVM+qw
 xCS5EbIAADCdIkXRJklo07miULMWBaau6r5IcpzbyNe1M5y9FJb6GVs1j8n5ElooMiib7Kp7Syl
 aqcoLknUmaqBaZdIMrg3fEna08D0da0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE3MDA2MyBTYWx0ZWRfX90vg6eGI3qRZ
 z9TdvfCmmkB0wBydunNUrUWuDDOEhxkJATRsUhC9UoQNaGPpDEGChh/n0SnixaiJPQFCkDI0DHW
 clzjRWIWaWs+6NvlDs6fCZxx0I9FIevWSERBgj04oBqjFFq5R297M7+DO6cN604J4zMFVNUrzyb
 FItxg4magoARuQlUMBgnxHQJVlnQyW+DG1GkZ1WAmjbU40CjkBhnazBVUYyTZFqeaoJ5IlV+uzM
 24DaBk2tW3RHZtawJZEiy+ODCAz44peUQNTfG6b3COp6J+W4aKxRhMVFA7Ns/GWKRPsX5dre9ik
 XfbRCIvfZhj2zcboGIiFw15oA/+Mjp0Ws4f16xkghRXkbmUnPY7dAfY1O+MA1tfqYFniF5tmeoC
 UDoIdrIrCeZ/gPuUvsZpGuL3Ygn6XaEBg7YPuecVnAlFV3hI18Sy1sJ5EH/7Bp7zY1/Ga9MKST0
 UitkJza0du0oil2Y0DA==
X-Proofpoint-ORIG-GUID: 5eObua32JLWdgFL_o7-UiFyqHzwETCKe
X-Proofpoint-GUID: 5eObua32JLWdgFL_o7-UiFyqHzwETCKe
X-Authority-Analysis: v=2.4 cv=RYMFmFtv c=1 sm=1 tr=0 ts=6ad39c74 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=S5I1zsiCXtg5FouQ3_AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-17_04,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610170063

On 9/18/2026 1:11 PM, Sebastian Andrzej Siewior wrote:

commit subject is missing "wifi: " prefix

> Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
> 2011 and changed the %p annotation for pointer to %pK. Back then the
> default behaviour for %p was to print the pointer. The %pK modifier was
> introduced to able to control the behaviour of specific pointer values
> without changing the behaviour of %p for everyone. It was dedicated to
> avoid leaking pointers via /proc.
> 
> Things changed over time. The default behaviour for %p is now to print a
> hash pointer which does not leak the address but allows to correlate if
> two pointers are equal. I intend to remove %pK from the library.
> 
> Replace %pK with %pK in order to retain the pointer output for

s/with %pK/with %p/

> debugging.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1…v2: https://lore.kernel.org/all/20260918105632.pDhc9gIB@linutronix.de/
>   - Keep existing %p, just replace %pK.
> 
>  drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index e06e45323272c..79f5785697081 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -200,7 +200,7 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
>  	seq_printf(s, "Status Ring %s [ %d ] = {\n",
>  		   sring->is_rx ? "RX" : "TX", sring_idx);
>  	seq_printf(s, "  pa     = %pad\n", &sring->pa);
> -	seq_printf(s, "  va     = 0x%pK\n", sring->va);
> +	seq_printf(s, "  va     = 0x%p\n", sring->va);
>  	seq_printf(s, "  size   = %d\n", sring->size);
>  	seq_printf(s, "  elem_size   = %zu\n", sring->elem_size);
>  	seq_printf(s, "  swhead = %d\n", sring->swhead);

No need to repost to address the nits -- I'll fix them in 'pending'

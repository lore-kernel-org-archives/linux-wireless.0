Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A569631D366
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 23:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791068420; cv=none; b=Vsw3ijtRvVwepWahTB+9uPRJ8EcqzFTqDaoT+8xEpwlmMb09gWvS9HQO6W3rWVBCNDQZGB4QoGEj6gXoMIPgQECHsusqDTXqWjYqcoMDSCmOw4lrWhXC3OmWzBPrpAgvaHHfJL4wQ+b+62/FJCIHrJS/krvMfVG0CT5ze1qnV8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791068420; c=relaxed/simple;
	bh=pMi/GbpIcB9dhvmEpmplerT1p9kVJ0FPcCAxiGXuCD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZ/mcF3ZkO8pLDDWsgfZFO9qUBI2SnW4s2DqdWFtTiQcPo6QYUUwy/0ByoBClmH72m/ieLwU8nleMW/30noWzHdIzSOrHyc2DUir35kAmYTn974/l8/z1CI4F4BbdipPP4DA13WtXsRZzdgTvZrUi+OMiBF/iHERIl+QadFlq9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E2jyHK4i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PGGxSw+5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E2jyHK4i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PGGxSw+5"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 693KpawY1307223
	for <linux-wireless@vger.kernel.org>; Sat, 3 Oct 2026 23:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6bZnp1l5Sf0+DvNXCbo/mmmPSmEpfl+U8dXwsWmNIH8=; b=E2jyHK4ieCgZoZ0I
	rz2YiPk9LkphLR+JYFMGvd51prs42UANmr9ZOHmfgJS8j/8uYz2L6Xp/cYd/UyLk
	wJNGbYcQDAuVjur880WRmiM4oU0ddOdrABR2FlSTWqXnMYZVldsAfpIMO9nStCmV
	rVMNoMLr9CtUI1gfvG3pSC9+q2IdcoMtN2ecCqkx0EDHzFRlWRmjCn0yDzrcNgIE
	dQQFAp5tcFvXpxcT//w0Knwkl3vAQlot8AJ6v2pfsDrSERQXVJhtWYP0UmxULZ6g
	CPwjs6Y2zrvzTJdon6Lxb4m1mOqYtZGVB39s9ly+BUCe58bZrsMzqI64Pj1e82aV
	b3M/Ng==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h2sx31xxu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 23:00:18 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3510d0baf63so1340162eec.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791068418; x=1791673218; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6bZnp1l5Sf0+DvNXCbo/mmmPSmEpfl+U8dXwsWmNIH8=;
        b=PGGxSw+5znZGcFWM0x7LmxXElwK2SoTij2KwRJV9rXnSeLW6KtadZ6hbC4OuYhL3/6
         S9/Y0wTJiQOXBlO42S67irM3TeQF+TfDGnxj7otVwiZHoIpb8Gb9ItdgJgmrK2Ixp9dF
         iMgxHuUTeH3line8cDFfIgtlCfGQThVl8/Ubws3JLhsjHpmsdhi1VBtYONptfQbP8fq9
         1YkTgRWXjTv+RrY4L30ZBZ2GbZfrczek9ROKfi7x42+ovWwjNZPkRJtaEdsTvk9TOgyl
         wvae1TeI7R0cYdp7sYCIP05HCeet/+ht3Qv1U8Qlbe325JZxr4rwXz8AYcnUpz6sJaqv
         ctkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791068418; x=1791673218;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6bZnp1l5Sf0+DvNXCbo/mmmPSmEpfl+U8dXwsWmNIH8=;
        b=xnrFITr78+xhcjck/N9Ozru2Ep8kN2Udvz/ftO5SLIx9GQeGfwWQLVD51I87IObzcn
         Bbv4jNhAsL1afj1PJxl7VB/J7BypkjgbQio8xjNTW+JXp9ozAhR4OxPfV4gp1MBJQn9w
         y78rQ/0IaQC49T3wYfb9CxjVHSHmlx+12L9XTmpqOCF69RYc+JSPzTz2UpdRb7BLHGrE
         llQTPeuyNC7HrEkZy56uuTV7fVoAX4cadfjQhvHlbdjSI/4H9XZjptlCyJJTAVaVfXGB
         uongJ3rxQNFBC8Ge1YZYWm9EPQ8E3HXUtJGu3/bfJI1lJBXdTGgQKAt8C5joHiOPY1fw
         OUfw==
X-Forwarded-Encrypted: i=1; AKwUvBw6rWM6NHpoYAIrHMvQFE1DBy8fLP/IiEIcdxzCN77JozGS67iXtyffClp58frWWWQgeL4tIiVDx1pXac2yRw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI1rBs7cj6WWy9PnrmUyJpg0zfLXIF8LMIJskomlIpdgvNKmfmP
	/WW1hYM9cZhhXccYqk9jqbRfevpHfDJseYg+QDDIL3Yt1TuuvkdwYvYG8Ve7thfI595zisdjLUl
	gchx8kipDQb/yamHCMm6h1uJiZ8U15+6ldv2EtoNZDoBEjWeE87Gs167yGu+xuRzlc/t+xQ==
X-Gm-Gg: AYBFou0pJW2OMwxzV/P/0KicEU3QER8iWxwWMnjeyLBi8aZVxalxmLz1GRDH+6Z2hjB
	3pTAzX5LHUKs0z1e97Qg+8eHHNW0wh4DhwqsMVUNt1wt2cFFaZcEQhoXMBcDsTW/mNiJUWxy1xo
	aSx8E6tVqX4zw7suIOFlIiDW8wsVVRKt22TQMAD0uxrXZTaIoGO/svxWIPo7OlKO4fB0Qvn+ZQM
	d5sEjlh01fjIAwsPcJD/B05lCo0zDXx2EUfBl06WaNEC5vIR3mIUEeXux9Hx6uUy5KkuV0RvR3b
	hnNard5ruzTixv2ZROevWS1Jx1LqP96bfUZ3Whnhz/e0B+6ftHdbWaFkzaxfRZ9h0r7AOW/15ae
	fp1jPYwajSMuPw1ZGsiXAxiPE9B8E06jc1E7Qf7YiaIu5yIwP8r9YxTaO8Q==
X-Received: by 2002:a05:7300:ea08:b0:34c:e77c:f928 with SMTP id 5a478bee46e88-35111519db8mr4820867eec.35.1791068417813;
        Sat, 03 Oct 2026 16:00:17 -0700 (PDT)
X-Received: by 2002:a05:7300:ea08:b0:34c:e77c:f928 with SMTP id 5a478bee46e88-35111519db8mr4820753eec.35.1791068416453;
        Sat, 03 Oct 2026 16:00:16 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f1500b59bsm18150132eec.28.2026.10.03.16.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 16:00:15 -0700 (PDT)
Message-ID: <5c764600-4e22-4827-bf4f-1ba4ea4fdd50@oss.qualcomm.com>
Date: Sat, 3 Oct 2026 16:00:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: Reserve space for a string terminator
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Dan Carpenter <error27@gmail.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <20261003095913.575108-1-yaojiale02@163.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20261003095913.575108-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JY0pPkKV c=1 sm=1 tr=0 ts=6ac18902 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bC-a23v3AAAA:8 a=Byx-y9mGAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=JhsGp5YEgYEiw4z---oA:9 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: rz6RqVwNLmOys17Z-MamXWYtlB8Q_lHX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAzMDA5MSBTYWx0ZWRfX+pNGOCPXvJOu
 Fxx7yIU8rkZC6bFtXZxPgNSljqbtwURMvoKrSzCvC1XhIzZMX3lyCzNoLrBWwQE4wNq26Edv+pE
 bT+jSbH69O9m1q+6/ZEatlM2vA1Bb9I=
X-Proofpoint-GUID: rz6RqVwNLmOys17Z-MamXWYtlB8Q_lHX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAzMDA5MSBTYWx0ZWRfXyD9Sgi/CmJ+6
 rnxjczG5E6XicDiHqgEPPCw623tfYptve9Ksl6G7y84Z8uNmOxPv/N2l+tqcp9KYW0QFtgv+niY
 NetAKuv9O6ON3bPk7u6d23dLTHtFcxG2hT0Tz8DVYlugsebaOX7pb+IBm8l8HicIjSAMAia1/s7
 3Rgkt2coLBCx8UlrsmYTHwqBGL+XX//HWiI4cHXMK7Ad89LkhOuUHKiMy17J6YabvkDZoWqOoWA
 zsFkqYoIcJVROdUCCindiBfCPSf8nrKFoOzRxvnhzboesdh7oFOqxzMG1bJx27yupA9bB8jWCFx
 eNE3+f4EI6Tk5cNrdBqgCGy8bPyeu+7pzpLgFyp0NuItKt7iXVaimBxTH5YOKjpHgNOpN7Rn29x
 NSi0y4tgciWakdHdYsJY+4uCS/RnVS4geipUJLZHA3YKgUB5LimSlhhIU4yuR1GH3wWEGwIkqgT
 +OpL0VZG+We6JhdGKoA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-03_04,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610030091

On 10/3/2026 2:59 AM, Jiale Yao wrote:
> ath12k_write_htt_stats_type() accepts count == size, which fills the
> zero-initialized buffer without a terminating NUL. sscanf() then reads
> beyond the buffer.
> 
> Reject input that leaves no room for the trailing NUL.
> 
> Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
> Reviewed-by: Dan Carpenter <error27@gmail.com>
> Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
> Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Documenting that this is actually a REPOST.
The original v1 was part of a 3-patch series:
https://msgid.link/20260926121250.3258285-1-yaojiale02@163.com

The Reviewed-by tags came from replies to the original posting.

/jeff

> ---
>  drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> index b772181a496e..f84f1828275a 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> @@ -6190,7 +6190,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
>  	const int size = 32;
>  	int num_args;
>  
> -	if (count > size)
> +	if (count >= size)
>  		return -EINVAL;
>  
>  	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589C52E8DEB
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 02:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649365; cv=none; b=RqCbt1KWWsx7T5tSF25H4eQ/N9eb+CZYv0no4W8BWs/ZmDGbsLoKsTMKIlfz0T0/VANyVayPPNmv4GGvWGHtp/QLfYR2WiRrY2/V1F8VcQzibXyEorc3iq1XE1YQ3QsrcRRdnnQemLFpPkJ6lVOVczhmtY3KwsbslilqEGtBW8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649365; c=relaxed/simple;
	bh=FphuLZ/UhsPZ7xGO6NhBIs8kkcdXJvtCZJUuTCiwKjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nFa9BrtUF5gQzNR360aUi/l1NHFAL87sWCHNjNMGCVTpgoSgTE5QkddGukEiuONtobry2eI88mn4T1+Urlj6eG523DoVoWsCRDvBGFaX0tENGnySkvA8X1B5ljo1a0Jj5CfevBW38ExujcvUYANK2hn5HkzwxBewdWZihDLVarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c0bOJ0r8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OjE92lFu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c0bOJ0r8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OjE92lFu"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68T0ip4w2809226
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 02:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OU2a1AVipIhoZQb6GLRTapvpusNfuh9B13CGCk9KrWY=; b=c0bOJ0r88lZFhPWv
	MLiRK3z2GoqJWK3Po+4zFzM9an5A4j2W6zbNzgKVqngI/TfDvjjX4A9GOii6ybcv
	/wbRXZvAU5PHhhPoPqc8K7V8zDRYl9I5IrK7RuzjIe54KHRwZjnA0vdcdSgJgiE+
	ykWvgHmUYOXZnyfHsK+puRpgBCVErWOFH1uVa/50RxZIXpTl+Q3Ge6AujszeG+qC
	ZjDo/4dEMz699kq1aXYLp8cvk1f1zeU5ZqCVlEk2ATyWcZUo9qW3hb8Vlz3840Id
	Vn1f5a/KhwSlyfoV1NZ4daAyl5KSSTcAsFWd2KDbbv8vYXu1WHnPpoy9rUKB+Zhv
	HIVLUg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0144rnya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 02:36:03 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so6177685a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 19:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790649362; x=1791254162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OU2a1AVipIhoZQb6GLRTapvpusNfuh9B13CGCk9KrWY=;
        b=OjE92lFuz2fuBAathOjCBME4aKLOv9FK/57GCyktqkdjif52gO2ek/gOHG8Xro5/ll
         CYptRlPItZcjzheCHqIEkozgLvcQCkAseDuUB8wDpaxJ041N5NoMOOhQZHoyKGdyA/ct
         3Kt3c/Wi7j74zYiKsSL6eSXNufamg7ENng+hsjdiqAJ9RFC4OtQYeV9IIEjDsrCcblGI
         owDgfQnAZICPoe7UfEIzvfpZLOdlv+PYgufUflWkpahmfbjP5wNL3H7lIEId6Hhmopva
         Xu9bfWCGIGi7g67CPJttLxbVJO1Z9BLskuTMN5Oz5IYk1W4y3qFdJN4q5bqy5BPo002q
         WQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790649362; x=1791254162;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OU2a1AVipIhoZQb6GLRTapvpusNfuh9B13CGCk9KrWY=;
        b=EXcbhXMq89dHW/Q41cOIM/SKNpRTcI3AyNXwQcc/KNgnKlh6E4fIm9PihH5Ow/kVDI
         ReCOOe83YcKRvwh/0gkvpEm2qUghpTGQUPqPLgZ3WDaiyQxcI1y1+ftg5exO0iGHvvuT
         GrPT25x1gGcdnf949v07EjQnzvK6Hu7Oi7z4B4YfedZm5BD318V2r2Z46WWwfU6CWNJd
         cJ4STif3yXbNa1n7GZlOhkxCbZ8hTaC+FluKFuaIOpb8ehCM5R4UcYWLTr+Sgco6a1V+
         IkQSAwILKH3+9F5YfA05BTRfBNarEIno9mCAP7S9u1itROXgMm7dAe8SqbXrd36n7zOi
         6JCg==
X-Forwarded-Encrypted: i=1; AKwUvBw3E58yN61WJ5rybsoDY3wcYJuHQpdRDYhxdUBHMcXmPWbh3f6C4TFlG5WOVdXQxyVko9HO0OoIZ2aAFMdmww==@vger.kernel.org
X-Gm-Message-State: AFq9FYLC4EZGw9MeuegsuYyGAD+2UK+xhJH6SSpehNoZbNMtB+c/k4RL
	+49h4r7SMFH/SIN+G/UwWDI3LJbxhy1GpVJZUNvbf2BUJxt6CdfaKCFpX+PbcG9266XFntKPEzJ
	4lrBFlUAbgGRPJo0W/HEIot3/2GBi2+FvFrOs17IqXg3D1KCai5RJPW+9naSoxOXXkRm2Sw==
X-Gm-Gg: AYBFou3kve9X0oZ/hYIQ8+IIMFLGLuMMY3HNDFaOH61WXX8nR70b7CCI2dS8siNKtvA
	/VsveA7qTay8KyYAcLEcVo1JcoHGdt0PxyaSaaWFQhQ22pm5h7ORzQBidk8OOAXlLohfBgKDyCw
	RVjFH/0wBOVprL1vltgdqOYHAZvl74EeDRCV36fXu0Vfg8KMDaYyHymKm0W8l3GGQzwWoGX+4pV
	uZbNV9kIOWNx25AvM/hNBDEo9xDZkDG9fUJQMfeOjt+JP46j7tDom22lMqP3/s/mpIMLEPaQtya
	TWKyO99PC//NbVOLgCQAL6sTKdE5LTQ+cnAe2X74C2rn9yXz/otME5qDfyuQFOzTY4YsEvKC7Hw
	Ih73GZO9EWZs4ICJSw4LNoFelO4uUsJFJlJrt/WDm9AxlSjG6pThti4zJdsg6Ay66TGW/wok=
X-Received: by 2002:a17:90b:2645:b0:39e:6c68:c77a with SMTP id 98e67ed59e1d1-3a098e05151mr12783751a91.48.1790649362146;
        Mon, 28 Sep 2026 19:36:02 -0700 (PDT)
X-Received: by 2002:a17:90b:2645:b0:39e:6c68:c77a with SMTP id 98e67ed59e1d1-3a098e05151mr12783739a91.48.1790649361707;
        Mon, 28 Sep 2026 19:36:01 -0700 (PDT)
Received: from [10.133.33.76] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a492da42a3sm1456652a91.2.2026.09.28.19.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 19:36:01 -0700 (PDT)
Message-ID: <0f66a04f-18e0-488e-b6d5-aedead2f82eb@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 10:35:59 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] wifi: ath12k: Reserve space for a string terminator
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Dan Carpenter <error27@gmail.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260926121250.3258285-1-yaojiale02@163.com>
 <20260926121250.3258285-3-yaojiale02@163.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260926121250.3258285-3-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAxMCBTYWx0ZWRfXzCvP1jJDi5kO
 n58Vq8BsvIGrCzKLIQTQwVTZ5gxBPzKvDG1isdd6P5ka4VP89177QLiPddsEZYlPc3AvWosQXQ2
 FioAtbKQvjI7UnS1xwa2BvGi0bAfbYlfcM1WIXqCbVofb/RIisImJxbqNd4xXquLZoITHYU1yov
 Bnb6raDvJYPJysYe1dQQ9D7p+kgYXVerSdqqtzY82AKC6AShBawpWNLJu3xGArJu/POPzDtm4IY
 PQNacU+YVJe2jLuzd6nVKWXGdNAX8mtE8OjSsRBnHxMD5So8Gzx/wkngWqSEqu2CkcwKBguqcLO
 Uo/OYHzzqNRytQMfUQ0O6CxQlIgIEZMNjeYym7iYKRb7zplfENrTCLzLTK+Co69sf75Je7X3wGY
 DAxrOvkXueXZG3QM3KpnC8hLR6Jn2w+I5Uh6N5PMTTsy7dXyXSbzbegkSwJ/uN9jgoVjRiDJ8Ym
 xgaKS8TADm4gWCitK7w==
X-Authority-Analysis: v=2.4 cv=FJSOVOos c=1 sm=1 tr=0 ts=6abb2413 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=JhsGp5YEgYEiw4z---oA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: 5kkddXpOxolebI8AOl1PhohQ83IpJCMU
X-Proofpoint-GUID: 5kkddXpOxolebI8AOl1PhohQ83IpJCMU
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAxMCBTYWx0ZWRfX5ID+1RaWjumg
 87xgSyNrewKnHrtyBRa+2vSAKP5oRfr27pam7B7vVmYPStfEOTNCGqyloXg53mauyzpPAKi6hRd
 Eg0k58tDLbQJMyCQMfFMwNlbNUCLFH8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290010



On 9/26/2026 8:12 PM, Jiale Yao wrote:
> ath12k_write_htt_stats_type() accepts count == size, which fills the
> zero-initialized buffer without a terminating NUL. sscanf() then reads
> beyond the buffer.
> 
> Reject input that leaves no room for the trailing NUL.
> 
> Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
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

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


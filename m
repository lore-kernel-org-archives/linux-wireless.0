Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57CD343885
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696733; cv=none; b=a98f0KCveuIDgJN0GRumGVYk0td+O2WwYG4ZIjzhv7fb1OhcnE+SHQ77+uruNx+8twcy/CuLKTZXP7I9ICwuRvRrsGlRrZr9EiWyuAngxbZ5Ep31IigJdE3T+BNL2k76ejumnmwWGarxL3/7Yvu2qC05LyYgupdELXhkmfooAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696733; c=relaxed/simple;
	bh=NnXIVyan7Hjll07WuAj/3zRitjtS2pawXKmbL3yFBvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D6o79tsi+h2OJBjEjy45CkB/Qt/p7ZBhbb/8wZfrS5UO7EVh87qv/khhW1PJFeX0oOhDwdJSVAF7GgBYxcBgd3FX6YyvYnI5AE0hzCu8WPsV0R6CRBYkHnq8TgArC3R4IllqLezjN0MWEL9b1XVja4o8nNE5x4E+N5Pzs4ae2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c5p1Xxt8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OPdvSY+Y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c5p1Xxt8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OPdvSY+Y"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqei91577194
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OHr/jcEphmriEM1fgwgN6zyuVkI+B+vhIwk8cRw5UGQ=; b=c5p1Xxt8KVBYsUB3
	xYluUR9MR5BVI493p1dU7/qRA7p3Uab0QfpbuGPl4N7oKSR8l/nO6hA2fqIjGBCf
	lvewgeoehd5GZNJK/lICVdtyuyjkIpE4jzq3RvlpAkpahR//80oo7pR5g/ksFoCi
	UGreQx3HnzzIuscV34pdjmOX8gTk6s/0fB2XZQDTg7C4EfXkk4pV0Oo8j5wKQfQg
	576fzBwEUJ3HAeozSCxYT80VGGTz6FzSq81y+kgVCC30AL6SALJ3fNuLVIOXL3ie
	cj3O4c06VkMJUqBJBWT/FSuT1/DbOWAhYasaT3O+s7pFUalgy2oCl180yEf085uH
	FR9wTg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h09x4sv9j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:45:31 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a0f55a3941so3535278a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790696730; x=1791301530; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OHr/jcEphmriEM1fgwgN6zyuVkI+B+vhIwk8cRw5UGQ=;
        b=OPdvSY+Y57yyXcIInrQcGVRm0iJ5L+wyAquTmi7LpaadZdriHiKCQcGejLFghfrjxS
         0XreWaSa7/FDP4YCYO4tzquQiT+5icgPJ43FSokwXKGmL5xGuX3E1fNeHn92e/5+YId+
         SfGh3Z+QUhZrfAziB89lVXma/q43XEjptFFqplwytvzKzQQk4AFuuf29q9rKjYsrOiDU
         zoxo9dMrb5ycrIT4amwgbIpzk3Pq1yT5M3C30/UOTgdfFty2JNO2Q2Tgd0pYK62LbYy+
         VRlDsmjBmYWSB2B60ISC8esKBnWUNHiVElnNAQsMQlU3icQi5jwNhfe19pNNPPmPiy48
         DJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790696730; x=1791301530;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OHr/jcEphmriEM1fgwgN6zyuVkI+B+vhIwk8cRw5UGQ=;
        b=akHjD6Mc6yl3oWu+HlrUFWlrCKI3AMXm30H5avYW3JM9jkpW5MUILY+72Nw0pKs8td
         YdtmZLIq2/t83pQ5vW/OopeI6gGviWxyzhkkUMFwPwLsPWWs8aS3+fKfv5+J7ZmgdNNl
         CYGHi6/EHeEaflHszfOC0Ab9qYKIxJEdTsBvoyjPoLziP5piEV37jSRmeGMlPd6htRe7
         ExRsBXXaz7dp0NNL4gFVp2+cskp2vlXrbcpukO9Q5hqdTfjMaFoS5El8SFpm6AQMU0v2
         CA+PrOUgYfs9ySvbRyUaV6fM+L/kUsGjitsbBFe/EnJ7BcNIYweghuDQCMqVYJCIWz0D
         AVcA==
X-Gm-Message-State: AFq9FYLHdqixVJfOkAfeuWQx6TEWwiOEImQzMrswPKQMizr+woaM8/y2
	vU1do0dWDxRG794YUKBANzWlYJ3zro2497HagGH+TglYzqAE/mKTyvXDaOvZUL7mQCAaaYM4oT0
	npbldYuIGSeDllrsCXb5BNW+vIUZCs5Ax7bo2WiSmz+7WZYjYYhrNjk2ZozgbFKKnPJbHYLWptA
	lYbQ==
X-Gm-Gg: AYBFou0rfCQFLLCf1g0ry808MUVOthVlNoEBisALgcC2j1X7yg3OtE897MvsbjIXkXD
	40vfy2IlV13XiCx3+Vw8rApkPRaOUD4KKIfn4Buuiog6C1gx7QOb3P+PeK1ZiSGIw6dwbG8BUxk
	DNK3TTxVCosFsDk7VLzgQ4q5ZGYUT4HIzeH8Tl2vavjvmq13MX6RxuqLmwJ0p+7xudCnRNbLYCo
	k6svlBVJ9G5JVBWL2UDRsXUxdXU0cDRX2O3PGX9pPxyDDJkhxJLBmiILtrkl1WVSB520dlSD5Rh
	7cLYdM1rHxS/8F+1QiIOKHGZ6X+wK8soxrwFVrbhJw6xLuHFKidUqaOcpi/j+Taz/TRnhZGtHGR
	YHRPvn4qKonr+saxqDO845Xg7GO64YtUY9T1qH9TWg3V/QS78WCBY4A0ET97Z
X-Received: by 2002:a17:90b:1e47:b0:3a0:c72e:46d2 with SMTP id 98e67ed59e1d1-3a0c72e521fmr11145149a91.6.1790696730280;
        Tue, 29 Sep 2026 08:45:30 -0700 (PDT)
X-Received: by 2002:a17:90b:1e47:b0:3a0:c72e:46d2 with SMTP id 98e67ed59e1d1-3a0c72e521fmr11145110a91.6.1790696729652;
        Tue, 29 Sep 2026 08:45:29 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91458e3bsm59366315ad.68.2026.09.29.08.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:45:28 -0700 (PDT)
Message-ID: <fd24a99d-e8f6-492e-a71f-d35188cf41d3@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 08:45:27 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: pull-request: ath-current-20260929
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
References: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfXzMcfZfNY4gZT
 sB9qJfbhotKuyUrUjVMMDA0TTNHFh5/ZkvMDxoHtarSLIAyKq4WMWPL7+KM3hxPLO/Y+yXdq6zL
 RglRWTESZJXZ9eONNi0Vqlm9/q8/ybg=
X-Proofpoint-GUID: uQYwi_nXPK_0U4xqBgkFkZ4KPeb6AMAX
X-Authority-Analysis: v=2.4 cv=I5Hw19gg c=1 sm=1 tr=0 ts=6abbdd1b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=m8tp9wjG45yvVgdVl1oA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: uQYwi_nXPK_0U4xqBgkFkZ4KPeb6AMAX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfX6wx19nTA6p9K
 NG+FPtx6Zei/0V81RA+lrWJuQHGPaDNxw59/S4kt9li5OKSv7oIgHHMigzRaMKTA+wQZ+e4kwbp
 tNttMaxp7wH/lw6ObFfezm83VLJEbGMI/HN5VuI4RBjjvB8tu9R63d0511adbosd8wI/wAk0VRG
 sdpwS3Mst/lBWZjJ0dvgDXSK8OMJrUDcvArH3xirRBZiWGDYyQkAzZZA6x8KJi2HMds2naXct2g
 1hIsiJgC0YjzN3w2GOj02D2I10ba8QyUYXpfNCnEtOCeYkutWJFPgLRjsuR3fE7zpW2jwC3LhSd
 4OoQjAWUnhFa/cIfdTCCc+7n0HB4QsnxNanBn3Rs/R4A01l84lLskpmTa4rUklOpiapUO+Ih4+N
 cTCCNfOIJnT7KXxcmW4w0PpNG276e0Cl4GsI30ss3C16SFvz5TCF1Rs8e6owgATx1Y7HMc7NM4c
 v1kShj7IuHBJP7jZUVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290062

On 9/29/2026 7:58 AM, Jeff Johnson wrote:
> The following changes since commit 6f63e919fe1e335b8abcb3a28bfd4804a98d875a:
> 
>   wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue() (2026-09-28 11:11:19 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20260929
> 
> for you to fetch changes up to d52302171b61dbba6c9c15e80e9a5f02f1e9f95c:
> 
>   wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume (2026-09-29 07:03:58 -0700)
> 
> ----------------------------------------------------------------
> ath.git update for v7.3-rc6
> 
> In ath11k, fix an IRQ imbalance during suspend/resume.
> 
> ----------------------------------------------------------------
> Baochen Qiang (1):
>       wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume
> 
>  drivers/net/wireless/ath/ath11k/core.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Please drop this. As you pointed out this fixes a patch that is only in the
next tree and hence the fix must go through the next tree as well.

/jeff

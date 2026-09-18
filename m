Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079ED339366
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745141; cv=none; b=ennH/qZ1DmowdYsbqlm79bzn1w5yhWqRwU9WBTR6hTUvLSdrCjDQZo+PeAJo2z1gq4Ww8k3b2N1uQMgBRI3n8ZhpihnUH/3JW3tATp7lq2Y9juD7cxj+LYYx5Ub/rtDxExSMYSdv8NRaSQrwg/jR92gfdagRt/iFR8jnPZ2XS9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745141; c=relaxed/simple;
	bh=IGeEkqV/bRxMcJXz3gB71Lgr6drx7WEjN/ZNB68F+4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QzDUpcutr3u0bT/ktTfaPBUQUX8s+iVyGZPBA75FZr4KF1yV7bnfMM66+NCmPx+Mn2KJ4zsiYfqIXSrXyVlxIibynidd2EQ0mmBhn15ZtLsmeFRpsqzwZVBtRnnY1dofuk+7k+TMBXeqeRVkm76bi3l+BvsW5DSyBlBg+HHQ+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jekXM1Pj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jk6TevFq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jekXM1Pj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jk6TevFq"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDOesA1201885
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 15:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	e2X14ijPvU7hbZLqb/jEpzJ7qqwECLW7uzM9cKLErUw=; b=jekXM1PjmQKGFqoV
	qQRFfHe72i1FGSeSO2ChZNG6wnpeJbrd+rER+FvQO1I9hl2JUx+TZ+QMjzSpu5D+
	Os+on8fANqLYkdt4apRShB6x5158iy8oWwoVR8VRTh3EPJ3/gGE/RxJZkP5kS34v
	SM1Hv+TISq3EkTDdNMfgrey5eDYOfYo+EDZ2pQJQsvx9yX/hqKJZJWOm/2xH+7to
	1F7GbaM/KOnEt/gQOPTGWe2ppgTK+vZeVcclbQ31aF4F9Fwa0tJQt7MN3JRhwxUW
	JFMT5k9s1GAA0nzIeppJw7YIoTk5m90UDG49akiYBVqeu+blYFWiokgApBUTt7ca
	3TQBJQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grxp2teh3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 15:25:38 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90ce8ad8002so18245486d6.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789745138; x=1790349938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e2X14ijPvU7hbZLqb/jEpzJ7qqwECLW7uzM9cKLErUw=;
        b=jk6TevFqZfRGVH1ORWh08qKOM71tgYf5cQ3NTuTmtJtD2tzeTFd//Gpf3xxcpO+Rhk
         l+cckJyL8CdDBH2fOX+bnVMn+51NWNWeleb6xtRhMJdt8IgngG0FBjUYBM+jh+xCLs0u
         vM1Dv3+++n27UoHCPYqgt3kBm3pOjH6bYRs+3+DcsWRN8vKVaRfXGB8rI3K6S6Ogsp8p
         1QG7FLvL0tbO+tFfdl8chVitOFe+PaBAR5ACp4d667zRcQDPnt+SYU8jLJaazq+yZfwY
         bqENcPPdeW/ZbhC6VT8Wr+2IOtyULzq22UNSSpLn9VqpM3lFgaeeSRJKL3iBTPRNGPJ8
         V+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745138; x=1790349938;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e2X14ijPvU7hbZLqb/jEpzJ7qqwECLW7uzM9cKLErUw=;
        b=DWUdKu37bCUr7xRqnekYVKQIyg7Jahyt39WUn/22DzoCW5pBBKAqLPIWdaOsBtFm/a
         6unQSPN2/ujZNF00GFFCelM5LupkxhDm2AJLJLphjdHEXBu1r++NVZrM3+oBk6FsDGEk
         0/WU8XmkyRMgZk2n3EFb9QBRzP0ZZN27t7jBBdwasdYY5L9n44AHp8DlNpWayybohgwd
         zHFyJAnTXGr/za85dqHY0sGSRhuMi/GXExyo0tVdFbJ0YU6bY1I2Xc+aZbLe2Ri7VoUp
         B1gSLtdUUGD7/1kyDaseL8bLCNnHa+pVvBytaVVj51E+HBO+gS1eR0kSkmK7H+4GTlCg
         9PWw==
X-Forwarded-Encrypted: i=1; AKwUvByuMLlagv33EIUu68kSbK2vgPe9sffJuoPxwjm+PqfzfO1nM0u7UveVIOtx1mVxOoouK8VTaMeO+hawsUDjRw==@vger.kernel.org
X-Gm-Message-State: AFuF++nTG+l4bbYwMxXfNP6oz36yztlBd/zNGEDpG/aGT0eoBmuk+WAd
	LQWxLx7KbyVAm9HC85qSDF/wQRkdi9Ctv7hTKeU9d1IkHgAdFT5wBNOGORl/W7RxgUl9nXdFJPC
	hPunNtEuTsxj/yONN+cv/ERVpZ+TiHhidaseqCCwphxUcHzK/Oq+IQca1qjc6sZdZOQZ7BMr21Y
	nY0Q==
X-Gm-Gg: AYBFou3QUpUDyAA+R2bMziilnHFNH4UI+CqCowROnUPZ+1U1aMIj0HGU7++mrrDpK9C
	8J3RafJX+cAXaFx+zdHAldR6WkBOLIeUAAMNbNO10tEf8yERGILH4W3M4i1S/RRVDoEKCKJIw5Y
	GspmlhCI+CeIfaislL3Zu1lkVZnVHAKlUVddc6zZH3QJ1KUToCYIaO4x9PGDy/eOElna72YP0W8
	Q9gWaIYFjMYa9o6BU4fEs1oRgiirG/hccg9lHQIAKAneEPVRp2vv4VDLJMuDwkaqtKFrAdxnT6O
	0VN7W3XP1x2sALh49MyyouxXcJYUiN61BSz1JNy4r/RTaYlqmIKDIJpPTNPYZiX9ER96mZmLHBs
	jYL6tA9SNFON78D56MfP7f7bzUUGgscPMnr1FqXUo4alYDlkqZB9ssKf5IjLF
X-Received: by 2002:ad4:52c8:0:b0:912:ab5:9e0c with SMTP id 6a1803df08f44-91254b57a72mr35036056d6.21.1789745135312;
        Fri, 18 Sep 2026 08:25:35 -0700 (PDT)
X-Received: by 2002:ad4:52c8:0:b0:912:ab5:9e0c with SMTP id 6a1803df08f44-91254b57a72mr35035506d6.21.1789745134615;
        Fri, 18 Sep 2026 08:25:34 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9125802c8d8sm14881656d6.23.2026.09.18.08.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 08:25:34 -0700 (PDT)
Message-ID: <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 08:25:32 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wil6210: Remove %pK and %p
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-wireless@vger.kernel.org
References: <20260918105632.pDhc9gIB@linutronix.de>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260918105632.pDhc9gIB@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDIyMCBTYWx0ZWRfXzhm5Tg2+50lK
 2ZwhkVtCefdBD2PVeTgI8fTj4+QVCuZFqM3XTmuNhvPP6C8/A5vQVODzGFLPp0Gu7pHMGcin8DL
 DMOWQgZCoapHNeZCQsO0MieTyLX7KE8=
X-Proofpoint-GUID: MUGrthOjFBzjJxlSZa2fGPKTaKRKkxXC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDIyMCBTYWx0ZWRfXyErYeLjTXwy+
 gKXCSj+z10rSuTfkcmfiwkEqFE2T0UoVlW9j6um3wBIvOSbuRSyMC8dmQanruyaORujF3WmQR0W
 vzm2QIS5IEcoeajNouTZpnA6FEgP38gB2H/NrKtpfgSob7jQB3WgiOpeHcrqO2taT3aCXHlN95I
 gmGlZOy/G8kGcFKuwVsvPhdLSPUwBayf8QR0SaO69dYlc2f1ORI2bVaPditQFQZCeJbjIoVt2RB
 bfU4NupXcwbQzpCm8wPuPoXwErvpqI9oDVXtwydcWLCBwQEz416iYiYohROAADHs+1Rd07rk6C/
 nF62TK1cf9pdDnUfz+LpbuQsnTgSeri06x7bsk9AMSOfuuuRWKHdCVgmd8omqyaatoRqkk6x3nS
 nlE46exsR5rJO63LbzMqTgWEaYz9wLo4hHdXTVZzYKWA3iOKvIenViuaT7S9YjLp7fgOmcv5Sc/
 pylikRj4UInJQtvPbNg==
X-Proofpoint-ORIG-GUID: MUGrthOjFBzjJxlSZa2fGPKTaKRKkxXC
X-Authority-Analysis: v=2.4 cv=cNF1IVeN c=1 sm=1 tr=0 ts=6aad57f2 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=dUtfJtYXSmSsDSKrwpYA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180220

On 9/18/2026 3:56 AM, Sebastian Andrzej Siewior wrote:
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
> The policy on %p is to not introduce new ones. This is somehow in
> between since it already exists.
> 
> The driver uses %p to print the address of skb, %p for the address of a
> transfer ring and %pK for the address of the status ring.
> For the skb it is probably enough to print if there is one mapped. The
> address of the ring probably not matter given the physical is address is
> shown and it is virtually mapped.
> 
> Remove the %p and %pK line from wil_print_.*() so it does not end in
> debugfs' output (debugfs is not ABI so removing does not break
> anything).
> Replace the skb pointer with yes/ no.

NAK. debugfs may not be ABI, but it is a human interface, and you should not
assume that a human debugger doesn't need the information.

I'm ok with replacing %pK => %p but not ok with removing existing %p[K]

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index e06e45323272c..093ec04e4a052 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -80,7 +80,6 @@ static void wil_print_ring(struct seq_file *s, struct wil6210_priv *wil,
>  
>  	seq_printf(s, "RING %s = {\n", name);
>  	seq_printf(s, "  pa     = %pad\n", &ring->pa);
> -	seq_printf(s, "  va     = 0x%p\n", ring->va);
>  	seq_printf(s, "  size   = %d\n", ring->size);
>  	if (wil->use_enhanced_dma_hw && ring->is_rx)
>  		seq_printf(s, "  swtail = %u\n", *ring->edma_rx_swtail.va);
> @@ -200,7 +199,6 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
>  	seq_printf(s, "Status Ring %s [ %d ] = {\n",
>  		   sring->is_rx ? "RX" : "TX", sring_idx);
>  	seq_printf(s, "  pa     = %pad\n", &sring->pa);
> -	seq_printf(s, "  va     = 0x%pK\n", sring->va);
>  	seq_printf(s, "  size   = %d\n", sring->size);
>  	seq_printf(s, "  elem_size   = %zu\n", sring->elem_size);
>  	seq_printf(s, "  swhead = %d\n", sring->swhead);
> @@ -1140,7 +1138,7 @@ static int txdesc_show(struct seq_file *s, void *data)
>  		   u[0], u[1], u[2], u[3]);
>  	seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
>  		   u[4], u[5], u[6], u[7]);
> -	seq_printf(s, "  SKB = 0x%p\n", skb);
> +	seq_printf(s, "  SKB = %s\n", skb ? "yes" : "no");
>  
>  	if (skb) {
>  		skb_get(skb);


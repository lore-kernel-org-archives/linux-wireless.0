Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7D50256A
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 22:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791583684; cv=none; b=X9rHVGGTr3HfXJnIfjNNvWv8nY7ZxS5TdoGB8/6G0NOsPcLTPZ3pYlwV8HQHATSkWQoOuDxJZblSjggpGI3YNyVe5+msIgPsaL8Hg9MMsOMTx4bJjrCYHFOIzvzkqrmsEtb2S3Boe49f+rpnraHPPpRFF1An8NP/eQoC6eOMs+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791583684; c=relaxed/simple;
	bh=2yDW81GZlx8sHJ+qlyywQjnpRRIPYgvD3dV8GOSohmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iaf97tC9COHMrwKOPHqBxWHv8qPs+oA0XXbIwnpypBeV5zdjvGBXCR4OANTbDSFEEzAzePokEMEI9kWeI+0Bzm43C8UM4XEH+aypnl6GfpPD6KDwHd8mXbnfLm71TvihQzz0HthOw+Z2hq0o2z8i6nIZxXx1pwhfCI2BWHzygxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LrikMMDx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c2iMvJwG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LrikMMDx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c2iMvJwG"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699KhYDY2857808
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 22:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Jot2RFAnsnkeM5kfPFj75St8/mCcz8u7h4DuLJdUQdI=; b=LrikMMDxqlrAhRtJ
	QztnB9LLwVHtvrAZlZq34h0mI910nPUKnbop6irhayiAlj6y7FgUpcFJZpIEvi3A
	oBL9SVqWLyRlgzj3e4HOdajUgTI0Kz1F4Fzgc82S9Vd9Co++SkA6WvAsU8TZTSU5
	yRqN0nEIJIVGmjV+XLuCpZ8WmTyNqT+lvhaAS3zNG8iKq4mk9AXzNqL5I4u55LRx
	E88OM+/gNQqmPsR9A4m7vQVsBXXz+/bTqTIe1o84GPfg4l4iCo5wq8G9YuQfVB//
	K0ujpyfgXiDVXCwRnQovSE1u55vT6/PopMyhZ8XLOpYdWs+K+d4vwMgPGywy4Oui
	dIwwWg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h74t88ur4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 22:08:01 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso309330eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 15:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791583680; x=1792188480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jot2RFAnsnkeM5kfPFj75St8/mCcz8u7h4DuLJdUQdI=;
        b=c2iMvJwGAEQ4Q7RZF0yHRRXIlfC9ZTnOsGT6cLAzj+gMUYClYYtMH7Mbjye+07M6yt
         tONioYTvzLbRhd3H9tKGQNwukj6Vf/NGFxeqlK54Hy3zB7PSJUOypWdVxD+Ic0Mhp8zQ
         qWy+PgDx7Ar/owkMAB3Q0nSPmUmV5okWpmlftQwiIZsa9LmfJoyzp2h4+aRoHcgivu4E
         84KfmgAOe6NMqQOCEaBjjro2HG3i2KgDT1fftt7t6KASnFxnXqrAmpwsOvxrbZtRiV5t
         4IvMCeC5muImxq/WbLJ4so0POR57gH9CMswcrq2yqAOuT7GC5x3eJWxaaALm7x90srxS
         pyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791583680; x=1792188480;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jot2RFAnsnkeM5kfPFj75St8/mCcz8u7h4DuLJdUQdI=;
        b=x1l9PhyO9YyZ6Za2bFmCHo/Kor943tlRvI3wCD5wwy7NgXZ/H/a62gdk+lQWMZYXoG
         DXRE95lvwwV4DTSRbCl1ZwBfzorTN8bA9zYqZyh/shDXL0tvpMY0FO0u8bVx7TcAIhc/
         wcEnEYRETT3erNgFgiM6z5Ah96+N8RH4nruOOS/N/NcIc36VmnsUTegPZOPRnVWMC3zl
         kGFOzsx64RogHOEUJ5IdXEm22LRI4yZJ6chEgV/Cjkh13j4nCyddAtdUn8FNKz5+K5j7
         msW7Jjx7Didb1xu85drzJzVQHUR994T7/zhtUf7UnfAIikcyQMdGPHvLZv0iQraxWvg7
         FHbQ==
X-Gm-Message-State: AFq9FYInjXpQD49TlDVJBeFWJzKHDup2ZYgsIUpbFPB0ZsQd3zlnLqwu
	MECZYy4y22uZZiXYtSRl/g+bbGUMtKRS1IXoitl2gFFnW7T7kjpBKHpqxALRlwNc86J62xAog8F
	HABHaHK0cRtlheBYzq1YSMsFkw/HRbiFgrq9N1lHx2+OC9f/5TGbBvZfsRxMFclub9NeX4g==
X-Gm-Gg: AYBFou3JiDqvvCilwgnhFsyKe1kraER5+G7RRzGGGjcun+G1OJrTxAzYxOVD7UdTG2O
	0IvjMMDxkmWaRAC41cQatBBNIPgPEw8n6Gq5FTAfPpp4y+Q5EJfdqJ3cgiyLJiEfMsLn7HTR4GJ
	3CSGjY6A5uiN4wTLYM629DaU9cKhJ2aFICqPwabO3NbLxNAyGg7o8vFNUno5ozSlg/ZdVndxeCS
	xNN+n2MyS+WR/Aq6ToMxOp9HlRxzOzZPlAYEInhKL6oIrQs8gLuWcYiRRE3YdnM7i3pl4gvxBri
	9WuLJg//pe/fufg7gvZqfvTzsHZrJjX7Fj7B9A9ECy3wB8BZfU6BisB1K7Rtwtm8HirtgsIVQwD
	9QPKs01LNSYJ85TM4GRHtEZcOktr9canny/HP6aXrLjqHNG8KTcwAxXNeRg==
X-Received: by 2002:a05:7300:c7cc:b0:351:7dab:58e4 with SMTP id 5a478bee46e88-3537e134b4dmr4228790eec.32.1791583680279;
        Fri, 09 Oct 2026 15:08:00 -0700 (PDT)
X-Received: by 2002:a05:7300:c7cc:b0:351:7dab:58e4 with SMTP id 5a478bee46e88-3537e134b4dmr4228760eec.32.1791583679655;
        Fri, 09 Oct 2026 15:07:59 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb1d6e6sm8860018eec.24.2026.10.09.15.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 15:07:58 -0700 (PDT)
Message-ID: <b96945e6-bebe-480b-80ed-d3343e94f2db@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 15:07:57 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: initialize CFR locks before capability
 checks
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jianhao Xu <jianhao.xu@seu.edu.cn>
References: <20261009060326.1162818-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20261009060326.1162818-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA4OCBTYWx0ZWRfXxnYbjkhxSdFu
 9Xvuy/wgxlFlI4HxkX+soMOeNz1FAzFcTjqyJZJ3spkfRBBdgRM8gadNWbloQlE9KAmA+o/uZTQ
 hWJn22898cw3E+JOCulpU0DACZ+R8zk=
X-Proofpoint-ORIG-GUID: uQXbgUpJEadFN6F4DX-_7BnJOc_aA0c4
X-Authority-Analysis: v=2.4 cv=D9jSufRj c=1 sm=1 tr=0 ts=6ac965c1 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=MAiKVQkammv_BUypPwIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: uQXbgUpJEadFN6F4DX-_7BnJOc_aA0c4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA4OCBTYWx0ZWRfX6KGVTALOGSoW
 mRPtjYPLC/meL4GNzz5chxyG+3+OSw7tqHqJpX//8Hwrdz2ftmPDRW5+yj5EYHIXyuoghv5VPXs
 585nU7n01X5sywpLgFixoBr8GB4w7ZtXZ8AV75YdVF8ZiJuboBIRqyMHToMGfmCexC7lpT/kMMN
 AAQCn5BcHH9iNUtePfbYnfnSrrPHlH25G7k7JYm8B1g8z365JALAkkyb6Az/jjsZx2ryvIie39A
 j2U4ppP0tjS9jn0O8XV8/zEtWIiRB9BvW8P3RR0BeYckA0Ws/dfsZFAndHZgvCKPKOrOb1nfSKI
 7XW6DbdF826lXbgf7GH7fhTbXcrf4+CnTD8J0PgWF9Ho1KC9OJeZ1jnZfICYoRZke63+lMvaJt6
 Vh+49KTyirpFGUtad4YFxSByKHu818jKCgJdvmssavCby87K7TEMbqjNczBV5weekR6R8ksq6cZ
 uAGWJl9FPMOw6YdOr6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610090088

On 10/8/2026 11:03 PM, Runyu Xiao wrote:
> ath11k_cfr_init() returns before initializing cfr->lock when CFR
> capability is absent.  However, station removal still calls
> ath11k_cfr_decrement_peer_count(), which unconditionally takes this
> lock.  This leaves a production path using an uninitialized spinlock.

If this is really happening...

> 
> Initialize cfr->lock for every radio before the capability check.  Keep
> the CFR ring and lookup-table lock initialization conditional, since
> those objects are only used after CFR capability setup.

...then this is a poor solution.

And my review agent agreed:

- Initializing the locks unconditionally at the top of ath11k_cfr_init()
before the early-exit check would work mechanically, but it's wrong
semantically — callers should not need to reason about which subset of struct
fields is safe to use at any given time.

It also ruled out:
- Guarding the call site in mac.c with a capability check would duplicate the
firmware/hw-support logic outside cfr.c, and there could be other callers in
the future.
- Moving the locks to ath11k_ar_init() would be over-engineering; cfr->lock
only protects CFR state.

And concluded:

The fix: guard ath11k_cfr_decrement_peer_count() with cfr->enabled

In cfr.c, add an early return at the top of ath11k_cfr_decrement_peer_count():

void ath11k_cfr_decrement_peer_count(struct ath11k *ar,
                                     struct ath11k_sta *arsta)
{
      struct ath11k_cfr *cfr = &ar->cfr;

      if (!cfr->enabled)
              return;

      spin_lock_bh(&cfr->lock);

      if (arsta->cfr_capture.cfr_enable)
              cfr->cfr_enabled_peer_cnt--;

      spin_unlock_bh(&cfr->lock);
}

Why this is the right approach:

- cfr->enabled is set to true only after spin_lock_init(&cfr->lock) succeeds
and the ring allocation succeeds (cfr.c:997). It stays false in all early-exit
paths: the firmware/hardware capability check at line 959, the
ath11k_dbring_get_cap() failure continue at line 970, and the ring alloc
failure at line 991.
- The check is already used analogously at line 937 in the relay flush path,
so it's an established pattern in this file.
- This avoids touching ath11k_cfr_init() or the call site in mac.c, keeping
the fix minimal and localized to the function that has the precondition.

/jeff

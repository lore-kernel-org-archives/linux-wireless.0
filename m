Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8C4A99DF
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879904; cv=none; b=YLmGEb9JriF1Vs1BSjQZq7hMP+NScOnySUUmr5hfHt98a4jCxNt/srSQzY8NqI/AuNme1XY8ehpstu2axSNz12Kp5Ozd04Bbgb8tzB5jF0ebKHx+p2HyuVIr66ZUBai9fXEvXe6Aoou1vyPvqsNocbPquRwSt4ICRTHcMbh7EDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879904; c=relaxed/simple;
	bh=/ot3bEfw5n53CkqAonvZddrjr4a61Tw39SIgkb+Vx+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfIiN0wpAqbpWYgm+ntRPIVsJ64z/S1pvseIolbfade2+g8ZkfudGrRMr+ZBgZBTYLD4xLlC4zcKld2+am0zpcQnELXxh/B9MPEHH4+AeiLqf0gPvr+P0IYlM9x6im7MQ4bboSvjwDng8NZfkhpLCHds+/YQcdaZ92l6NXzpxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gpT+GGs1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jkbB5yWi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gpT+GGs1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jkbB5yWi"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688F1KX02684512
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 15:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	y2IJKD/wc07ehSuWDkX+So12eTaGvIek1NA45XQQAOU=; b=gpT+GGs10MCSsy78
	7HmXhE6f4W0TM8Q2WVlz0dLOBmyWITlcXiLSMZMgz6NWBUgK7XgIUfLbjZqRSqe2
	e2+TJzXDyQ9Yujk/BeUbBwqZwfL11Gt2v5SzeeDTaQeBWkGOFjaNngY1k6narjCJ
	MkoRDTGXnyrwFpXFj7XiwJV0mBtD0OOtR3T4KO0Y5fSuKs/BgKH7dD3ciA1O124z
	Qn3CQBB1YwK9r9XEICXmbXLeTZsI4YfxzfHBRDtZHRIMyqD2IacFCun1AxfDtD+Y
	MB4lMmMjB8I8ZY/kx7pxbdrrxWHn/w48b8C3VnJx0Vj+S3oLz02bf+lu1Ucs0deF
	0t3dkA==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjjvugm3b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 15:04:47 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f4e52682f0so6845576a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788879886; x=1789484686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y2IJKD/wc07ehSuWDkX+So12eTaGvIek1NA45XQQAOU=;
        b=jkbB5yWibV4Zv4an2uH2YSHZCH1F8eSTqRbs+R+B4UjXNQM18fp4VIjPXYXZgW9saz
         OaMwmXvQn/jYy4azSeEcmhTyD1UjbRf0JQqL4xbCjwPZsn2GN/abFlAyA+ZIWq5wXWhk
         8WgfZk3dADTTLymkvKq7783Ty7ay9z8fFLI6mO/3n7rn0i2O/83RphSSHlpTYkRcUhU3
         mZrSGo/kTa3FL+BLRtLXk4tuBYhdD/0/FsTcqfEtggG7iwrATerFRxOfBwoA4t/pU0Cz
         lL7b4Y2GMQKeHIfqMaemef9uS6zXjnIWtKP5jyjbTkDyxKDHyzJg/M2/jkB2vNoYN8xB
         kEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788879886; x=1789484686;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y2IJKD/wc07ehSuWDkX+So12eTaGvIek1NA45XQQAOU=;
        b=Hq8OX1gGIYK8AZKkTl83LYqO7FYNOIXkTjxBRrHmmCTSmGiM+RQSmCGQynNpByfou/
         uFfBHV68GfAlLB7H1jrwEAwRelWrmqbs102C2b/wrZvXfK1FOgujR2Ab6Ck887l2L1/N
         dj7tVUa0HUjoOSE7/J+FYmuFazBjfIQuG/1qjAgfiS4osZIoSsFnfesDPKqOuKrS3vQh
         pVwrc7f8xJIiLGEg+vsDZcY06u8z5gHpOAQh0bOE0Oa6/NSJLX/d+bI36EniwB6G6Dlb
         9JDSuKJbnAk7uT0AhiTOWf3R0pDupsJSbim17j8NvMPB+iPHjuca2uRRS5tEZOqoIsxG
         uOSw==
X-Forwarded-Encrypted: i=1; AKwUvBxmvLniSU1fDVKlEhwWKXN3N5VrHpFY+eaPEpaIKyE2fUXsW5Mh4wJIECqGdlebScB+agoV4PNeaOYTEvx7VQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lS4xKNFkWz7A0hLPdEJaaOMMRVqKQ1KQ/Ui9NJD13qcjlFqorL
	hnVL0tBEt35HIRLzPvLoIVIfUf2UKyREMC2ZGk9px0kvxj1/IWsf1BxhtaCM7YcBDA7w4t0HyKL
	DKxje69A3ycdYcmrTi8tyIrelNImY6WFAzoTQvK6wXfqhX0nSQriPGOm7AYS6vhgRt9ybQw==
X-Gm-Gg: AYBFou0eBgYvAv5wzfrp/+j0Z899RwJaV16tnk6tOYV62QMIML1k2dOQXWi7BHRuqjF
	mOcNXkgUWcS3L5vLg+2ktQNqJcxbzGMjMrxoPRFqNC99hKjPNpFBv62B2R/5vvxF4BKwI3N5RCc
	0uTmV+73OPOB0WImM5AeKR6DZ5fN4/E/xNT8qTGc/2SKgBAZOSR55aydkb5ipGXWaehPD0kGbPN
	VDw4wDAUWPsRJI+l0xzM+qx1rn6gTBDNXkL8TxiSt+cPzK5coJo8GDRQXSNzi2OSJSrhOhtBIQk
	n81h98REkxOnTsdr1B2z+9UtzhgK/HUQe5i08Y+C5RY9u25UGTfUNFahKEsFr5W8nE1JmC/W98c
	tb+3OzRBYWbFLRWPVxZg0W5ApTr1ybsNidJFIfoCsv+M4XJCeRhcsqTF/O7CL
X-Received: by 2002:a05:6820:1515:b0:6b7:46fc:1d9 with SMTP id 006d021491bc7-6b746fc02damr16325339eaf.56.1788879885679;
        Tue, 08 Sep 2026 08:04:45 -0700 (PDT)
X-Received: by 2002:a05:6820:1515:b0:6b7:46fc:1d9 with SMTP id 006d021491bc7-6b746fc02damr16325213eaf.56.1788879884446;
        Tue, 08 Sep 2026 08:04:44 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa33e96sm36456508eec.12.2026.09.08.08.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 08:04:43 -0700 (PDT)
Message-ID: <a5534789-351d-402c-b7a0-bdd98b68fcd3@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 08:04:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] ath9k_htc: fix possibly missing barrier in
 ath9k_htc_rxep()
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?=
 <toke@toke.dk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER"
 <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260803104424.25880-1-fourier.thomas@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260803104424.25880-1-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: p0_--DeXhC3Rat_wifnVKVRzCpi6yhNn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2MiBTYWx0ZWRfXxBw43NH0SSAe
 YNPlHAOoOwVnhkc4hYiVsK9ARKH2UhjXE2nug/w72P2JBSzDCVN4GTye9EeHfSuFyc7vG0UsmVL
 GVgYyK+X/I54uSpgqj8Lq0D/q/1T6RaAdEEcmh/sAnsDOdHKwdJ25qdQGGn3/Pp6yyzDHIMCK/R
 VdUrPtPQwOtHIZ0h3ot5FL6KL9G4t7MfJ6MZ5scCdQqMet/JRcisGbuxU0jbewPNckSUw3taC1g
 crjbNdid68W0ifMVpaTY3CjmhmIzJ0wxzYGE55NKptLPnarEeubZaE3ymcPfwNn9nnKZfcPc2vA
 z2kwRZM7OYVo7Dnyx8PxuwkpJiRkn97Ilazgo8KQRh46fCtQR/9Qs0zDfyyCevnOmHIiWG1XIPP
 x9YZ4jV1gYpy1PDj70YctVIDxEx13wcXf6QEP9bDe8Xp3VKhJUWvQlf6hMAnt3Y09mCi7Bkx/V8
 9t6qA/xrhxjFTdsSsPg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2MiBTYWx0ZWRfX/ubUDSnq3qGq
 yABoPPCBEbT9Baz5TRx6i7gtCgyccDyTMY1GBVmbNIFFMV/TzWb/gOKXYHxC2SxzpcxwBUBg5ur
 rWn4HQj07hPeMvJZEs/Ov4ftp1RPISE=
X-Proofpoint-ORIG-GUID: p0_--DeXhC3Rat_wifnVKVRzCpi6yhNn
X-Authority-Analysis: v=2.4 cv=X8hi7mTe c=1 sm=1 tr=0 ts=6aa0240f cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=IsJrftOSqqLFh19Q65YA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080162

On 8/3/2026 3:44 AM, Thomas Fourier wrote:
> ath9k_rx_init() initialises the rx buffer and its lock then calls a
> memory barrier and then sets the priv->rx.initialized flag. However,
> ath9k_htc_rxep() reads that flag and imidiatly takes the lock. This may

s/imidiatly/immediately/

> cause the lock to be taken while not fully initialized.
> 
> Add a barrier to prevent speculative read of the lock before checking
> the initized flag.

s/initized/initialized/ (or initialised)

> 
> Fixes: b0ec7e55fce6 ("ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index bed7ea2425a0..97d61f3f0aad 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -1145,6 +1145,12 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
>  	if (!data_race(priv->rx.initialized))
>  		goto err;
>  
> +	/*
> +	 * Make sure all the ath9k_rx_init() memory writes are visible before
> +	 * proceeding.
> +	 */
> +	smp_rmb();
> +
>  	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
>  	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
>  		if (!tmp_buf->in_process) {

I decided to run this though my review agent, which has the following analysis:

### Overview

The parent commit `b0ec7e55fce6` added an `initialized` flag guarded by
`smp_wmb()` (writer) + `data_race()` (reader) to prevent `ath9k_htc_rxep()`
from operating before `ath9k_rx_init()` completes. This patch argues that the
reader side is missing a corresponding `smp_rmb()` barrier, allowing the CPU
to speculatively read `rxbuflock` (and related structures) before the
`initialized` flag check is confirmed.

### Correctness Analysis — **This is the central question**

The claim is that without `smp_rmb()`, the CPU can read `rxbuflock` before
the flag check. This deserves careful scrutiny.

**The actual memory ordering concern:**

In `ath9k_rx_init()`:
```c
spin_lock_init(&priv->rx.rxbuflock);   // writes to rxbuflock struct
list_add_tail(...);                     // writes to rxbuf list
smp_wmb();                              // store barrier
priv->rx.initialized = true;           // flag store
```

In `ath9k_htc_rxep()` (before this patch):
```c
if (!data_race(priv->rx.initialized))  // flag load (unordered)
    goto err;
spin_lock_irqsave(&priv->rx.rxbuflock, ...);  // acquires lock
```

**Problem with the patch's reasoning:**

The `data_race()` annotation means this read is intentionally not ordered —
it is a deliberate racy read. For the `smp_wmb()`/`smp_rmb()` pairing to
work, the flag load must itself be an acquiring/ordered read. `data_race()`
is not `READ_ONCE()` and does not constitute the load half of a barrier pair.

**The correct fix** would be to replace `data_race(priv->rx.initialized)`
with `smp_load_acquire(&priv->rx.initialized)` and drop the `smp_wmb()` on
the writer side in favor of `smp_store_release()`. That gives a proper
acquire/release pair. Or, simpler: replace both the `smp_wmb()` + plain store
with `smp_store_release()`, and replace the `data_race()` read with
`smp_load_acquire()`.

Adding `smp_rmb()` after `data_race()` is also questionable because on
architectures with weak ordering (e.g., ARM64), the `data_race()` load of
`initialized` can still be observed as `true` via a stale/forwarded value
while the `smp_rmb()` fence only prevents reordering of subsequent loads
relative to *prior* loads — but the load that matters (the flag) was
already done without ordering guarantees.

**In practice on x86:** The `smp_rmb()` compiles to a no-op (x86 TSO provides
load/load ordering). The concern is real only on weakly-ordered architectures
(ARM64, POWER). There `data_race()` + `smp_rmb()` is not a sound barrier pair.

### Specific Issues

1. **Wrong primitives for the problem.** The correct idiom for "publish a
data structure, then set a flag that a reader checks before using the
structure" is:
   - Writer: `smp_store_release(&priv->rx.initialized, true)` (replaces
`smp_wmb()` + plain store)
   - Reader: `if (!smp_load_acquire(&priv->rx.initialized)) goto err;`
(replaces `data_race()` + separate `smp_rmb()`)

This is the standard kernel pattern (see
`Documentation/memory-barriers.txt`, "RELEASE-ACQUIRE" pairing). The
`data_race()` annotation is semantically wrong here — it indicates "I know
this is racy and accept it", not "do an ordered load."

2. **`data_race()` semantics mismatch.** `data_race()` suppresses KCSAN
warnings but is not a substitute for `READ_ONCE()` and provides no ordering.
The comment in `b0ec7e55fce6` used `data_race()` to suppress KCSAN since this
is a benign early-exit check — but that means `smp_rmb()` after it has no
memory ordering contract to stand on.


I ran the above through another LLM instance to check the analysis:

Issue 1 + 2 (barrier primitive mismatch) — Partially valid, but the framing is
overstated.

The reviewer's core claim: data_race() + smp_rmb() is not a sound barrier
pair. This deserves scrutiny.

data_race() is purely a KCSAN annotation — it disables the KCSAN
instrumentation and compiles down to a plain C load. On ARM64, the sequence as
patched is:

ldr    w0, [initialized]     // data_race() → plain load
cbz    w0, goto_err           // branch
dmb    ishld                  // smp_rmb()
ldr    x1, [rxbuflock]       // spin_lock_irqsave

The dmb ishld prevents loads after it from being observed before loads before
it in program order. Since ldr [initialized] is before the dmb ishld and ldr
[rxbuflock] is after it, the ordering holds on ARM64 in practice. The
conditional branch plus smp_rmb() does close the window.

However, the reviewer is correct that the idiom is non-idiomatic and
semantically contradictory:

- data_race() explicitly declares "this is an intentional race / unordered
access" — which contradicts using it as the ordered-flag-read half of a
barrier pair.
- The standard kernel idiom for "publish-then-flag / check-flag-then-use" is
smp_store_release() + smp_load_acquire().

Verdict: Valid, but the stronger "technically unsound" characterization is
debatable. The right fix is to replace both primitives for clarity and idiom
compliance, not because smp_rmb() alone is provably broken with a conditional
branch preceding it.

The reviewer's recommended fix is correct:

/* ath9k_rx_init() — writer side, replaces smp_wmb() + plain store */
smp_store_release(&priv->rx.initialized, true);

/* ath9k_htc_rxep() — reader side, replaces data_race() + smp_rmb() */
if (!smp_load_acquire(&priv->rx.initialized))
    goto err;
/* no separate smp_rmb() needed */

So my question: Are there any flaws with that analysis?

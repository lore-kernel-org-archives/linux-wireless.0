Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C451423794
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116960; cv=none; b=OUTFySRff6NUPdoWAapcV003Ig5esQlHhgL4Fv2vCR7wYrI5IgVrqWa4fHi/ZF7kz5kCsdfkWKGrg6X6yhCtvVUj3n3hN07rHe4/iK8WAEp6oeMWyZVifuy+jB7i/twj0vVoQBInIXiLbzYFF5OmWy4edkgqy7Z1eI11itg1qTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116960; c=relaxed/simple;
	bh=tjCJ1OLd4bESmRn4ltE+OeVIx/6AdbNp7qosZGyVn/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWehOh4EdlTFKISURZjBuhN2ivkDMHB895rfQOT+Tjz4fRoNOUYJjJDje/T5eZ5xH0jojLiR7vuBTI5a4cmb/CcVtOd/Qn70HA2SSmy9QIdTOSWQY03ZUPCohhn1m8ZLqXEKHGgi5ok9KquvGbGL2AlQA00q3pBJ7RQWQYX1cr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hHogZNps; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hHogZNps"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-8520161fdb9so600935b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791116959; x=1791721759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VPmsD6wMbwGyIjjK6id1o7siDpKmgW9pQeTfa7Jr/0s=;
        b=IzWYy+YObaMevpgaOly2vmRSWS5DaMdnVlzz5P+o0ZPrbbPSg7NmbAYblQ4m2Siz88
         JH0KHUJ3nPo7cMI178VRbpbg9fnDQbGXMpb33fIMVbEMbXYvguQHlX4Mzq9Y+Cqk4eBa
         jx3jEseJ0hg/OD9+9pXuPI13BmOP6+wSQToiCxT/x9DYlPzeTXJMEQBesj8+a+1/wzcz
         FQFXfoRmwC7Skwu9YObM+wTZr0/MHo1sOMPRw+slqVflq8Zk7eDROFWSv/05dNtDtR4v
         JXQowPL/UPunoDJ8wpKmqFgZwZeJQWHPErVZENWdXNZ7thsTYOcrfCEd1IwH2y3b6qql
         e4Rw==
X-Forwarded-Encrypted: i=1; AKwUvByWM1itVf/pmgC4kYckWiwCaqkP4cSNXbMzUOIRc8pBcNrf1FVRboqcf/tNCmtoz/u4mYf3YWH3jZaG2E1ffA==@vger.kernel.org
X-Gm-Message-State: AFuF++mz9x7bp8ldAcgocNTCHpCzWquD9SEHlBMLNv3gJivsTqefjJFb
	p28X8AGvA7bxo8SgpTxbEbIT27LlmRIy8iN4qEkl/+0JtHkYmonHpiBagteZEXQbcmefg/r58Jo
	FWUkpoVT0nOyQSzUQaSi0LPDPDvxU0I1O7rNXqqir7SPYwI/Nj0yYv9mn5VGzKZQFmcF7XObXnj
	lOs/yUBc3j9ftI8nzd5HOtOR/GdhzcTAuostxvALabZ151CH3KXKjVO5ei7g0szkaLfS+3iLzJQ
	d2nEbgh5DHV3oXfjylpGgGli5C2
X-Gm-Gg: AYBFou2JddW1ERI9aiL8a6vpgPI6CniKz0ULIVppbNO9vUiGsU+q1Nd8kQE3AfbytP/
	iTR5jr/SPH5B2GmupSbI92LjfGhfcVYafyodK8WC+0kZjX4gongw0SRjxxvn8xM7Q2Rh9Ddvv2r
	RQ0mCRa4F0AwYHcxCMfoPjUrYEt1t4ksJ6wHTZLf6ImyTL5NzpffspyblcgQO/bX8uVRHq9Afp9
	l+nLy1yqe6GIO8A0TGow53zvWQpylqG/ehKDi/6dnyEMaxhE9RYGMQH3FOnejFX9YTLIwBnrQYl
	ku9McVa3FnNbn+hOvsaP+a3LZ5yoLuL0kg3vrqmeuWJzEFruB1vkhRcKoYYBOPdikNLmGTUgfkx
	/ueSgqM//7PZZN1nXwXPBamDzlqAyuj0wrIy5IXcp3rQfqiMKn0BgBuyt2JZHORisPRrmXrHU4B
	p8ATYHaMrSLDn9O6y4wL0BGeVCq0Tag67uvnjn+KWsEQ==
X-Received: by 2002:a05:6a21:4d05:b0:3de:b120:bba0 with SMTP id adf61e73a8af0-3e0d6b04e8dmr4451603637.36.1791116958726;
        Sun, 04 Oct 2026 05:29:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-ccb741a86c6sm1020435a12.7.2026.10.04.05.29.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 05:29:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34d84114044so4648092eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791116957; x=1791721757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VPmsD6wMbwGyIjjK6id1o7siDpKmgW9pQeTfa7Jr/0s=;
        b=hHogZNpskqlnr34YBNtaxLKJ4cuv7qhnkZjmKyeTzaVQAA5uffU69nPrAmMK8I2El0
         ip97LBzb4gQDSBEpEizY9kiaf1QCWgmg3eJ5WbGdhNF3gpfzjrdhpGrVf1wGxh6pb9Fm
         Rn5dHyj9SBe2O/zVEvFtSFtrBMmHTrRmsCkdo=
X-Forwarded-Encrypted: i=1; AKwUvBwkzjDyQFtk+VAuiMlwTQSAvWklEgNStjk8KFTkmdRGZf+fN6pi7cpWnr6vrVOPIDRzpOdVtOL/MYX0Hs0hVw==@vger.kernel.org
X-Received: by 2002:a05:7022:7e8a:b0:143:298f:33b8 with SMTP id a92af1059eb24-151c4c11b5amr10031766c88.44.1791116956809;
        Sun, 04 Oct 2026 05:29:16 -0700 (PDT)
X-Received: by 2002:a05:7022:7e8a:b0:143:298f:33b8 with SMTP id a92af1059eb24-151c4c11b5amr10031715c88.44.1791116956147;
        Sun, 04 Oct 2026 05:29:16 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35126f01924sm4803605eec.0.2026.10.04.05.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 05:29:15 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: avoid sleeping tx locks in netpoll context
Date: Sun,  4 Oct 2026 05:29:10 -0700
Message-ID: <20261004122910.1392318-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930185417.61865-1-kmehltretter@gmail.com>
References: <20260930185417.61865-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 30 Sep 2026 20:54:17 +0200, Karl Mehltretter wrote:
> With the default fcmode=0, netpoll calls ndo_start_xmit() with hard
> interrupts disabled and reaches brcmf_sdio_bus_txdata() directly. The
> function takes txq_lock with spin_lock_bh(), and the queue helper takes
> the embedded sk_buff_head lock. These locks may sleep on PREEMPT_RT.
> On non-RT, spin_unlock_bh() can run pending networking softirqs before
> netpoll releases the transmit lock, causing a recursive transmit
> deadlock.
> 
> Use spin_trylock() for IRQ-disabled calls and enqueue with the unlocked
> skb helper while holding txq_lock. On PREEMPT_RT, reject hard IRQ and NMI
> callers, where rt-spinlocks cannot be acquired. If the lock is busy or
> the queue is full, return through the existing drop path. Do not evict an
> older packet from this context. Suppress the queue-full printk because
> netconsole can recursively enter this path.
> 
> The flow-control callback takes another spinlock, so defer it when an
> IRQ-disabled enqueue reaches TXHI. The data worker rechecks the bus state
> and queue length under txq_lock before stopping the queue. Existing TXLOW
> handling wakes the queue after it drains.
> 
> This fixes the direct SDIO transmit path used by fcmode=0. Modes 1 and 2
> take the FWS lock first and need a separate change.
> 
> Fixes: ac3d9dd034e5 ("netpoll: make ndo_poll_controller() optional")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

[...]

> @@ -2796,8 +2797,53 @@ static bool brcmf_sdio_prec_enq(struct pktq *q, struct sk_buff *pkt, int prec)
>  	return p != NULL;
>  }
>  
> +/*
> + * The caller holds txq_lock with hard IRQs disabled. Avoid the skb queue
> + * lock, which may sleep on PREEMPT_RT.
> + */
> +static bool brcmf_sdio_prec_enq_irqoff(struct pktq *q, struct sk_buff *pkt,
> +				       int prec)
> +{
> +	struct sk_buff_head *list = &q->q[prec].skblist;
> +
> +	if (pktq_pfull(q, prec) || pktq_full(q))
> +		return false;
> +
> +	__skb_queue_tail(list, pkt);
> +	q->len++;
> +	if (q->hi_prec < prec)
> +		q->hi_prec = prec;
> +
> +	return true;
> +}

Looking at brcmf_sdio_prec_enq(), it performs essentially the same check on
its fast path (!pktq_pfull(q, prec) && !pktq_full(q)) before calling
brcmu_pktq_penq(), and only falls back to packet eviction when the queue is
full.

Since bus->txq_lock is always held by the caller, using the unlocked
__skb_queue_tail() is safe in both contexts (the embedded skblist spinlock
in brcmu_pktq_penq() has always been redundant in sdio.c).

Is there an opportunity to reuse/refactor brcmf_sdio_prec_enq() rather than
adding a separate brcmf_sdio_prec_enq_irqoff() helper? For example, passing
a can_evict parameter:

static bool brcmf_sdio_prec_enq(struct pktq *q, struct sk_buff *pkt, int prec,
				bool can_evict)
{
	struct sk_buff_head *list = &q->q[prec].skblist;
	struct sk_buff *p;
	int eprec = -1;

	/* Fast case, precedence queue is not full and we are also not
	 * exceeding total queue length
	 */
	if (!pktq_pfull(q, prec) && !pktq_full(q))
		goto enq;

	if (!can_evict)
		return false;

	/* Determine precedence from which to evict packet, if any */
	if (pktq_pfull(q, prec)) {
		eprec = prec;
	} else if (pktq_full(q)) {
		p = brcmu_pktq_peek_tail(q, &eprec);
		if (eprec > prec)
			return false;
	}

	/* Evict if needed */
	if (eprec >= 0) {
		/* Detect queueing to unconfigured precedence */
		if (eprec == prec)
			return false;	/* refuse newer (incoming) packet */
		/* Evict packet according to discard policy */
		p = brcmu_pktq_pdeq_tail(q, eprec);
		if (p == NULL)
			brcmf_err("brcmu_pktq_pdeq_tail() failed\n");
		brcmu_pkt_buf_free_skb(p);
	}

enq:
	__skb_queue_tail(list, pkt);
	q->len++;
	if (q->hi_prec < prec)
		q->hi_prec = prec;

	return true;
}

Then in brcmf_sdio_bus_txdata():

	if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec, !irq_off)) {
		skb_pull(pkt, bus->tx_hdrlen);
		if (!irq_off)
			brcmf_err("out of bus->txq !!!\n");
		ret = -ENOSR;
	} else {
		ret = 0;
	}

That keeps the queuing logic in one place, eliminates the duplicate helper,
and simplifies the caller.

Regards,
Arend

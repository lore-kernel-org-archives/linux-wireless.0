Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D3495AE1
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 13:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792329577; cv=none; b=DREzEGf1DpLVthpAiwJft7bdI1deqDdjkdPym4UJJJqawXs0yGv64QGzFIRdl0xkXTAe72ln5hKe2jJV4wHBjRuB4UuqbskWrY7Y1a30+xlUiGsSaY2mbKyHhU/vDiVLd/2na0lPeJ3O0fgy/FZW2idBCCDjfrrzXwgIh53C3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792329577; c=relaxed/simple;
	bh=8uBrJgFPuxy+BLTmgpJjVgcQvgOGHRiBjGy3ylfY+m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3vN3fSmG2Sj6x/ypKqqcGWzU/5V0inFqjVsEEan+STxWsrK1t/N0VBhJFeBkXLC3oDb44bJOweRzt1Vv+r1PDWvo8kTjV77N1LhFFOCSJqaEE5zFHvMrMW7hmrv2BX+rg4Rk4whUtns/k47KG5QUfozz/+oPrQA/gUD1xcbrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=t0dy4z5X; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="t0dy4z5X"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c423b145922so81502466b.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 06:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792329574; x=1792934374; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EmlLkQ6dpljXtahKxB7AlkZKnbyW86lxsHxYr9rqtM0=;
        b=t0dy4z5XpfgynbquqXLd8aUy9j+JPfX/vd9PFgPmGBYCE4Gm2Wp8j5QkjBQbj7VF0a
         dWrrTwd+73K7uPdBloq/XTh3WtOkcHMCX2TP8J8FM+QUHrFMeUDvW/647Y4zCbNxgh5N
         2z7l49dN8DM/aYU1Q3r4vpqiTJUPmm1Q+ayqgmXxJOoHmGSYxm0E2F5aTUYvN/o5xNj7
         r3cCanaN0ABR2Wyuc7bnTzYggdD7X91u6G7MUqUOa/vPsPU3toirVMd3DKhhM9KKF6Zd
         OGjlcul0bQUo1TtH9UdvxhZN6q4h5ulH1/u7MWUZstVJgj5cSOIufT1MKkrYBH6KAJps
         Kwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792329574; x=1792934374;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EmlLkQ6dpljXtahKxB7AlkZKnbyW86lxsHxYr9rqtM0=;
        b=cN8giDwKESoFvfjDkPGrEyiCWwsWANv/RX74nTpkvXEZ7KCsGsGA4G/4yEuuTLQ+ng
         yjEKSyrMHjLs3xZ67oypY7TaMFYcv1Z5tLD7Z+BwfA6E1OKa1tu5MtZrfuGDS/1YbqEr
         ALTcHZ9tyoaQ8P9lN5SZ4/32oRF1MtM/Lcf1km2EF3+w8CXYt89n/JR/wcLnaNZKcSRI
         LLVCRBTuUraufvOj5cgquJ9EYslfTVsXA2GEm0YrDOsQ42iKUJQB9nwPe0tOSon+GcRH
         /LyTvDa+NKWXqVwWqG0Xa9HsnafxeH56VNy22Cis4X8W3Bx9mIzv3kwigSaw4Iu4aZvY
         k3ug==
X-Forwarded-Encrypted: i=1; AKwUvBxkH65CgBxxvaZ9aoNMqMkz962/77D1Itt9dfSv81LXRzsCG80LKmHH74xmltzDllOOa7pz7ut968oaiLApwg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIJwZ/xn1AQZdJLX1LIEFJYWpvFNOaMPxadB0cmcjRhu4SVRe68
	9omWDbFOpm70EmjZjmo9yV8plG9k5k60SXWA/pMhuoLPU+Ql/+JxoSYqcO1MTEOFVA==
X-Gm-Gg: AYBFou3Qv66MzEaf4z6Ww/D6SL4xMc7oXIhC23xC26NIHbqNJJtxMRu77fx5U5xhlqI
	7ye8QtXM8ur5bU8Y6gesNqQJI+f80YudyCciwviV+UzrBOdC6Kl55pwEmUl0Wa7ZAWZ8BhFsD1t
	dSCAVdTrGfDfI7yCwn3cmzzPHljV8rPPcAI7zKEuYhm7IQE98Qn6Wz++ldj38PJuxCUwaXoMP5U
	KvqIvLRR6S4MsTvgtv1y1euRGfNGJ8DeST/4eOZrCMUVUtcyOGBt43jmclxIxdzIoztHo/5wjZl
	D5zAVTi7ZlQ5S8NGASlpyarSnxxDQbR/YC1TLFcBv6aikPIrNKuEGW5LzEgvruAxCT/EBB9Jk/N
	Bs+qH6tBqV8jMXLpVXOtSOo2gGxyAN65NoEc0Q3rCLYuzIBrCea7bvynxax8JToN6CHPpZxAcPO
	N8wcSuMFuQ12dVaRYnzMnvgE0ogsRnhnRCgtJqgzJnRxExE9WyE8Oxi/co4Nn+WQuCZTH3rvcxe
	/nASJFUcuIH3GosAuOY2wR+6N+x5oRElJBT+mN63Am4/pyKHSUS6a2PIuZtcBJ+GANvxzNitU4F
	DqTGOHlnJVUrszFIqsn60zj4OVTdWKyqyyqd5nLBLU4O/GSBthGlw5EKUauHiOR+c3bT5+IlcY+
	1qVaDzZdQl7ELEVKyPPERbVtddgEMMsGz/7Qc+VIDHZDobg0q6vHqkjI8ocZEHDPJWvLU22kSuY
	bEYEZEzs+fTC2qNlLbcig=
X-Received: by 2002:a17:907:d643:b0:c2e:7da8:f54f with SMTP id a640c23a62f3a-c419f80267amr348395066b.38.1792329574061;
        Sun, 18 Oct 2026 06:19:34 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4090dd10d4sm264093166b.27.2026.10.18.06.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 06:19:33 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: Tamizh Raja <tamizh.raja@oss.qualcomm.com>,
	jjohnson@kernel.org,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Zhi-Jun You <hujy652@gmail.com>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
Date: Sun, 18 Oct 2026 15:19:30 +0200
Message-ID: <20261018131930.1116724-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017074012.35602-1-jtornosm@redhat.com>
References: <20261017074012.35602-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi José Ignacio,

On Sat, Oct 17, 2026 at 09:40 AM Jose Ignacio Tornos Martinez wrote:
> For ath11k, my series is smaller (4 patches, 7 review cycles) and has
> no external dependencies, so it may be simpler to land first. Julius
> already offered to rebase onto it in his cover letter [1] and move the
> ring check into his scheduling round.

Agreed.

One thing on patch 3, from reading the code:

> +		if (num_free == 0) {
> +			spin_unlock_bh(&tx_ring->wake_tx_lock);
> +			break;
> +		}

When this breaks, the frames stay in the txq and nothing restarts it
until mac80211 queues the next frame for that txq. A sender waiting for
ACKs then stalls until its retransmit timeout. With AQL I measured this
in v4: one download in three stalled, max RTT 347 ms. A restart from
ath11k_dp_tx_completion_handler() fixes it.

For patches 1-3:

Tested-by: Julius Bairaktaris <julius@bairaktaris.de> # IPQ8074 WLAN.HK.2.9.0.1-02146

Julius

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442564;
	b=WLabW95TvzIgNCu9yu27R02spLUcp6FQhityenUa5dOWjlVUX5iwbPJYxChPnrhXbcTs
	 dbOyIk0hicfFfdFC616JI2Ifa0T6OtozeAz7NYjYabXuaRPiXvKvj4QYSyCvZZqTFFM/x
	 JJ6f8XJLUttkSCJVjfCRDnemxfqFxqF12CxZiifd5k1HrImcQ3LWWNBAWNJ/Qobz3JwBj
	 2BBB3zuEVvdpSkQnT7qfCtA4+mVu0mZ2u4fqKnPDm/Ct8Y4tHm5cZ1ISshUp45T5+XM1K
	 pbRb8jEbKUsCJPMHgQZ3YDVOdJED+vryvpsUL/ZwT8WLCinlTFkBmIU2EgsTfxnjcFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442564;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SvXYd0343aBXV7g7oifbdryYhVUFmKu7Adz7aqbowPM=;
	b=lquqaJx9tIJqiwoORdix/rJxzyX7SqhHrb9q6NKn81tzz4O0+STdWJ/5Rl709pOqeP/Z
	 fHzr1E7BymmQaShf5QEGR14ggJWK0nb24RaIDLHIOGrNY7hxhfa6kM5V9mduWG2UoLUiE
	 Cu6gHeYMo2kqqY2JomAuhojTEltsU7ryuFD40Stx9v/BJPxpCsVw6J3yZKdT1xJRz1WeU
	 M1NTuQ+FuxalPGVlmRLGxCszPInVSnaliPMyD4lMuimIqEjHLZU/Gfqui7DWyRlZrzIVY
	 0BWrxZ1X6ZMBpmuhufMcUxH2wUVfchdQ0I7OyrQ//hon/O4JUCmpo/V0oI8glJb4vgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCEB606A320;
	Mon, 19 Oct 2026 20:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DCEB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
Subject: Re: [PATCH ath-current 1/2] wifi: ath9k_htc: do not start ANI
 before the first channel is set
In-Reply-To: <20261005072209.4101009-2-mehmet.fide@gmail.com>
References: <20261005072209.4101009-1-mehmet.fide@gmail.com>
 <20261005072209.4101009-2-mehmet.fide@gmail.com>
Date: Mon, 19 Oct 2026 22:42:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87jyndv2v3.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mehmet Fide <mehmet.fide@gmail.com> writes:

> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>
> ath9k_htc_add_interface() starts ANI for the first AP interface, before
> any channel is configured. The per-channel calibration data only gets
> attached by the first ath9k_htc_set_channel() that is not a fast
> channel change, and that same call cancels the ANI work a few
> milliseconds after add_interface, so normally the work never runs.
>
> When the bring-up stalls for more than the 100 ms ANI poll interval in
> between, it does run, and ar9002_hw_per_calibration() records the IQ
> calibration result in the calibration data that does not exist yet:
>
>   Unable to handle kernel NULL pointer dereference at virtual address
>   00000008
>   PC is at ar9002_hw_calibrate+0x1f8/0x570 [ath9k_hw]
>   Workqueue: phy0 ath9k_htc_ani_work [ath9k_htc]
>
> Seen about once per thousand AP starts with an AR9271 on a Cortex-A5
> board that starts hostapd while still booting; a 500 ms delay after
> add_interface reproduces it on every start. The crashed work never
> completes, so the next cancel_delayed_work_sync() blocks for good.
>
> Drop the start; it has nothing to calibrate against and is cancelled
> anyway. The TSF adjust bit that shared its condition is now set for
> every AP interface, which is harmless: the next reset applies it. The
> next patch starts ANI once the interface beacons.
>
> Fixes: a236254c35f0 ("ath9k_htc: Add ANI for AP mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792437942;
	b=VlyNUtdpWKqSN+Xt/Lr6cEPDqoF8vgKQBcHDWJEitvirPT/87OaZuExdHq63CydI2/iD
	 g1ITeM431xfJwYlQ4P6mQlf951TKfsnRqPR22R1wZEnVq9qi6qje+RWQgmaHQ+MGtdX5A
	 aOtG5vai3I0As29+GokqaDvmlEA6d8Ert7Dn2VuEA0xLGGFEyWl80UAbM9amjYpEcKp1K
	 W77XzhAK90MzE6EjsD9dB6tt2FKEG/+Zblkkr2RYF1hsNvDem5x7ONOdaxHMdwG6+iZWj
	 WYdW9nugMvIqaH+FLIrpod+aPJZKBIy1dSVMjFaoagZLPDPNtXg5+DqjeWj0SJyXPgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437942;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=l+mQb03BfYUQz9sASK6Iqg7KQQN8PUQbGpUb67U98IU=;
	b=rmh4+X2gzWZNDyt7OWUFnH+iU7J8K/Ccg6p0A9M3eG7QJNvM6KmNYbk9QfuEZZNcCEs4
	 r9nDgfklbERQxWS6OON6tTRuFgSa2ZRYUhcvaaTEiE0ZyS3B2tgTNBt/GzBJYEV0vS4Br
	 +I6YVioiqD/nxBmnn610bF9xMYa60l+jFDMNwu1ccOWdOUaemN/8QnCsjgLKdPetTRX+5
	 BH/1iUZoWIii+zqwPVT7fNpOWQfG3xezqahJx+EK9eV8brkKnLbmcul1O1VqjC0gp9cVi
	 y40RtCLKE6zYm+/qzon8q3WOwACeOD+CgPHUXl/n2FUVlyGexGAaN+v5rK/aJu3hLtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C22606A321;
	Mon, 19 Oct 2026 19:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7C22606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Deepanshu Kartikey <kartikey406@gmail.com>, jeff.johnson@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Deepanshu
 Kartikey <kartikey406@gmail.com>,
 syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Subject: Re: [PATCH] wifi: ath9k: stop WMI event tasklet from rescheduling
 itself on probe failure
In-Reply-To: <20261003021147.7461-1-kartikey406@gmail.com>
References: <20261003021147.7461-1-kartikey406@gmail.com>
Date: Mon, 19 Oct 2026 21:25:38 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pkx5v6fh.fsf@toke.dk>
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

Deepanshu Kartikey <kartikey406@gmail.com> writes:

> Since the init guards were consolidated, ath9k_wmi_event_tasklet()
> reschedules itself until priv->initialized is set. If
> ath9k_init_device() fails, initialized is never set, so the tasklet
> keeps rescheduling itself while the probe error path calls
> ath9k_destroy_wmi() and frees struct wmi. tasklet_action_common() then
> touches the freed tasklet, causing a slab-use-after-free.
>
> Make the tasklet drop its queued events and stop rescheduling once
> wmi->stopped is set, and call tasklet_kill() before freeing wmi in
> ath9k_destroy_wmi(). The probe error path already sets stopped and
> kills the RX URBs first, so the tasklet cannot be re-armed afterwards.
>
> Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards")
> Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De91dc13b1b37759b3d9f
> Tested-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

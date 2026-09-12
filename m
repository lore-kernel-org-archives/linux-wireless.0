Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3211F1534;
	Sat, 12 Sep 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201441; cv=none; b=G96mtxtzBj9IB6IY9NnPkP/gk9+iTl/oNCXkHrZh27qABuTchPdwli+L7Ey+VDd1fxx3Jxbar/I0CwJ5/yvlw3MwiARVGhbPwHc6Ce2EAgJqC3Ki4lu2s62KmP+IVl0wfro/c86/j4Iwx1xxuFxq010HoaWe5WJ1xKvzXILIaNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201441; c=relaxed/simple;
	bh=TwZhBuno2BL0lCfU5LNVvIVMY6qRhXLsNT6GyrVHBgg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CsjnCstJshe+ZWbE8ScsZhgmHQ6S9anSU7YoJTBFLhTEu5+1eQILZq9C4UQxJU6tRVEWetKmJl3ROxc+Bd4e29iROvwcLC2mqGQ1isqHdK+ZHkwwxKJ1zoeE6kHcr3TB7nE2MhI/mw9XQuhcZRYaeQbZKnlVHTKTNpKmpyTpGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 ath-next] wifi: ath9k: delete channel-context timers
 on deinit
In-Reply-To: <20260911213144.130192-1-rosenp@gmail.com>
References: <20260911213144.130192-1-rosenp@gmail.com>
Date: Sat, 12 Sep 2026 10:23:48 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87eceydgiz.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> ath9k_deinit_channel_context() cancels chanctx_work but does not delete
> the offchannel and sched timers set up by ath9k_init_channel_context().
> If either timer fires after deinit (e.g. during driver unload or
> suspend), it accesses sc->sc_ah which may already be freed by
> ath9k_hw_deinit(), causing a use-after-free.
>
> Delete both timers with timer_shutdown_sync() before cancelling the work
> item.
>
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

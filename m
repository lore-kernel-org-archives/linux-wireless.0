Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAFA43DEAC;
	Fri, 11 Sep 2026 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123025; cv=none; b=X4hR8lIixs4sVCuY/xDvasfrMfN8TWMLo/b5lycassKwFs2tmCjYGND4Y/11Gl1OwYuWZhoMq4zrITR6Ozk23uJ1JiVF+cIX+bbriMT/YWAGzsQgJp/Qpx5MAvqLt6pL8pJF/9Ol6Bme9GV4RelN1MuBCy5RIVRG92Hu2adG8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123025; c=relaxed/simple;
	bh=3KwfhbiyZxswjDgYi8EhT8OfH+XCcBMU2nF2ZrNajSs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZfFC87HS8u2PY5ix8kAnEsQJ0fdWxktbxEewELrS9rqdfJmC3hLe8nOm8173gwov6FJVsLWHtr0K25hJkHPYGiKAvtf1dkVEySJV/X0baHRzZwAF79MUW+Zaq3Q9sO+Aoe5d5nzwrCIpLQnp+30ior975aFihpTzKJ92YgRk7gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] ath9k: delete channel-context timers on deinit
In-Reply-To: <20260904212225.84813-1-rosenp@gmail.com>
References: <20260904212225.84813-1-rosenp@gmail.com>
Date: Fri, 11 Sep 2026 12:36:55 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pkykcbw8.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> ath9k_deinit_channel_context() cancels chanctx_work but does not delete
> the offchannel and sched timers set up by ath9k_init_channel_context().
> If either timer fires after deinit (e.g. during driver unload or
> suspend), it accesses sc->sc_ah which may already be freed by
> ath9k_hw_deinit(), causing a use-after-free.
>
> Delete both timers with timer_delete_sync() before cancelling the work
> item.

From the documentation of that function:

 * This function cannot guarantee that the timer is not rearmed again by
 * some concurrent or preempting code, right after it dropped the base
 * lock. If there is the possibility of a concurrent rearm then the return
 * value of the function is meaningless.
 *
 * If such a guarantee is needed, e.g. for teardown situations then use
 * timer_shutdown_sync() instead.

AFAICT, the timer callbacks can re-arm the timer, so this should be
using timer_shutdown_sync() instead.

-Toke

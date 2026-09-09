Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D842D4A2064;
	Wed,  9 Sep 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951211; cv=none; b=O/JpVWESdvd3fcI88sG2fso8jtEWNWwtGQicQ4Pm3hHy4KpluVD9hogIapw8StXNK+LCJGaRGOCNJfn19+/uZk7hyhjtAeSLznuCcx+WHyKlTeEPIJC6cXUki0AuWVLbCw1uNzGBzBkfOouvjLQ1rIsIgVLTe0Ou6skd6vSIzaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951211; c=relaxed/simple;
	bh=zlk0UngrBZbFUDryFDHnLcg1xZ74B4mx0o8V1QDPfbo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y4AFipnJEJcwS+vxGkX3zMCjkOEgi0iRfb1cVkLDexn550f0On7yz+1Uwr3NEi2+2nNSMb71p82o1fP75V6qgsg7k1gU176xTDEcPto6wY0GWAlu7lFgpRbl6up9BF6MBWGAd8isCBoerPiz8lmlHE7/0Xz4vEuccish04LlmOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, pengdonglin
 <pengdonglin@xiaomi.com>
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath9k: use rcu_dereference_bh() for
 sta->rates in ath_merge_ratetbl()
In-Reply-To: <20260813-ath9k-rcu-fix-v1-1-424665a1ce60@oss.qualcomm.com>
References: <20260813-ath9k-rcu-fix-v1-1-424665a1ce60@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 12:53:21 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ecf2g0gu.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jeff Johnson <jeff.johnson@oss.qualcomm.com> writes:

> Commit c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock()
> in spin_lock") removed the explicit rcu_read_lock()/rcu_read_unlock() pair
> from ath_txq_schedule(), relying on spin_lock_bh() to provide an implicit
> RCU read-side critical section.
>
> That is correct on kernels without CONFIG_DEBUG_LOCK_ALLOC, where
> rcu_read_lock_any_held() falls back to !preemptible() as a proxy, and
> spin_lock_bh() disables preemption.
>
> However, rcu_dereference() in ath_merge_ratetbl() checks
> rcu_read_lock_held(), which under CONFIG_DEBUG_LOCK_ALLOC only returns
> true when lock_is_held(&rcu_lock_map) =E2=80=94 set exclusively by an exp=
licit
> rcu_read_lock().  A spin_lock_bh() does not set rcu_lock_map, so on a
> CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU kernel, any call path that
> reaches ath_merge_ratetbl() with a non-NULL sta will produce a lockdep
> splat.
>
> The correct fix is to use rcu_dereference_bh(), whose validity check
> calls rcu_read_lock_bh_held(), which returns true whenever BH is disabled
> (in_softirq() || irqs_disabled()).  This matches the actual protection
> at all callers of ath_set_rates() that pass a non-NULL sta: they all hold
> a spin_lock_bh() (either sc->chan_lock or txq->axq_lock).
>
> Fixes: c4f518736472 ("wifi: ath9k: Remove redundant rcu_read_lock/unlock(=
) in spin_lock")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

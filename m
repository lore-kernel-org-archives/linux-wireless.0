Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C3379EC1;
	Mon, 22 Jun 2026 11:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782126470; cv=none; b=R2vXo4oQJRHtrdnmmT27gSh/ofPI/bcUMfHqX1Rkz7MCfJwYp7CUuwTn3+vXw83B4lJxKdAeJa6Av1FYR8JGkMy/Xxre8C7K6kDbf4qCpwUmoWF8maq4vqfcODRFoM+C+srCRHBmE7PkCranq/+TOrzBcQVzeNmT06YiSLqOyvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782126470; c=relaxed/simple;
	bh=+sUs033RCzPqgG4D0WKAQvJtW9ijh/ekE1r3w+eHkus=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YyMKDVowgKx2w04a9V1/puIZyCy2rTeg4AmjZdG3syj2BDUi/NpFYNnVoLQafFdJKlZl+rr8k8IToQPAM/BOAE9g4st4mXXHJ5fj1vDCrk6ghSUZ+ADhfkgpnIA7GvsEVQBkeQm4ZMUk7qYwQsGPGy/k/5jN5YstnSHoCb35LNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+fhj6gv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+fhj6gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324221F000E9;
	Mon, 22 Jun 2026 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782126468;
	bh=wgVMVHa2k0yY+2/n/waYjplt/Z+GwM/2A/ABlT/a+Gk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P+fhj6gv5NDqwQfr40nDoCFoUhpzVIJ9PXgrDr0Orq1OXGvPaifaOJqMs8rMqIv8j
	 4QV0TvJWYvdBGBf/IPIs5ZlLfOpILEiCJSHUSLqYTUeP2EzWffaNTy5jwhT6tUtNym
	 8o9fPL4/1oNiFX/7dcFihCb9TT4I+Odqq/LjLd+AbgXPQcEF4ssL5iOIB9DiQQuW+8
	 34YGR/nHma7q+4yCl1DuYdkr8uRJiLfu0jWeqS0gmB+fQazKMwWsdJeDvxPLn3MmzS
	 CL+/b1kKuTbKR+r38RJ+y6CjShiijqNcnhwcmz5ZCDLZvu2jZmyZqI8LN7wzXQ23Wc
	 iLlcyx1t4IfnA==
From: Thomas Gleixner <tglx@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>,
 thomas.weissschuh@linutronix.de, Arthur Kiyanovski <akiyano@amazon.com>,
 Rodolfo Giometti <giometti@enneenne.com>, Vincent Donnefort
 <vdonnefort@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Oliver Upton
 <oupton@kernel.org>, Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>, Johannes Berg
 <johannes.berg@intel.com>, Jacob Keller <jacob.e.keller@intel.com>, Tony
 Nguyen <anthony.l.nguyen@intel.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org, linux-sound@vger.kernel.org, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [patch V2 18/25] timekeeping: Prepare for cross timestamps on
 arbitrary clock IDs
In-Reply-To: <b296182e2e2c1ed2fe1c4879fd6f12d67a7ad22f.camel@infradead.org>
References: <20260529193435.921555544@kernel.org>
 <20260529195557.846634842@kernel.org>
 <b296182e2e2c1ed2fe1c4879fd6f12d67a7ad22f.camel@infradead.org>
Date: Mon, 22 Jun 2026 13:07:46 +0200
Message-ID: <87se6eltod.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22 2026 at 09:55, David Woodhouse wrote:
> On Fri, 2026-05-29 at 22:01 +0200, Thomas Gleixner wrote:
>> From: Thomas Gleixner <tglx@kernel.org>
>>=20
>> PTP device system crosstime stamps support only CLOCK_REALTIME, which is
>> meaningless for AUX clocks. The PTP core hands in the clock ID already, =
so
>> prepare the core code to honor it.
>>=20
>> =C2=A0- Add a new sys_systime field to struct system_device_crosststamp =
which
>> =C2=A0=C2=A0 aliases the sys_realtime field. Once all users are converted
>> =C2=A0=C2=A0 sys_realtime can be removed.
>>=20
>> =C2=A0- Prepare get_device_system_crosststamp() and the related code for=
 it by
>> =C2=A0=C2=A0 switching to sys_systime and providing the initial changes =
to utilize
>> =C2=A0=C2=A0 different time keepers.
>>=20
>> No functional change intended.
>
> We ended up with ktime_get_snapshot_id() also supporting CLOCK_BOOTTIME
> and CLOCK_MONOTONIC_RAW, but not get_device_system_crosststamp().
> Should we make that consistent?

Maybe. The BOOTTIME support is only there for that ARM64 hyper trace muck,
but has no other relevance.

MONORAW is there for the PTP EXTENDED IOCTL, but with PRECISE the
snapshot already contains the raw value and you'd have to prevent the
historical adjustment part for RAW. So I don't see the actual value, but
I don't have a strong opinion either.

Thanks,

        tglx




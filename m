Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211B3803D9;
	Wed, 27 May 2026 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897751; cv=none; b=CxF9t9+VhOxSxexiIvqW7mnF5/5cjf7lu76nuti91G69Opmpaex7hj9aZWjC9mS9GtEOqk3ltWpSzgp/dREj18UuXbbwz4p1Gdjkm13JuhCtU8smmof+0WpB7yCIC0cknea17uyx7EjLlu1d4cQlu7RBK039YmGESf8257ogXY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897751; c=relaxed/simple;
	bh=StSRKJn8icwOdQYtunCr9S/Hzkzk5f/ZDII2gnQ52Dc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lVYYiglsKY/NRuhgG02EC3cxUxIFeS7dQUXjkm/sJj9yvKTwFRyTLivToiczUyqHohD1UHGVdUDx4Iqi+ajQqYVcHOb+G66vtLlRqiWMwcDp+ZwDhwiYdre53vBaIATf1ZaTg42qTmK/v7v+sBEOYpo9advwFbggYhNx6ZrMacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQC0iN+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQC0iN+D"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4BA611F000E9;
	Wed, 27 May 2026 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779897750;
	bh=0imBknv/pgewMByeR8YgZ6XE6TXEr/GjmohnuFC14K4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=aQC0iN+D6vf7IROpsytSNpQF+mRMbTIGjh1sg8CKEM1uD9Q0UNq6a4+IOkoN+Z/qw
	 zx7cO28vimeYXrc6uitEUYCYaIVsXaKMxoSWOjQFvH751cr88gPR0QJCLqpnveUWB3
	 xzr0iKzRWrauJ2nUhJ8YynmS+Mkq7/DC2jzI2z0r0w4ehsZMGwZXoNg9EgAnd13Ukd
	 avCBn40cLRXTucfHFyH5S6sDWfNK/IsI/8IcgwW1IpjwLTWmW6Pyu1LNeCEj54KsXH
	 tv55WNtlM3+a9A/Wu+vev7lgcXWVeF6QImSUKDSHMn4EyhacPf2o0nT8HRyQh2rMxq
	 w4y0N+acxpExA==
From: Thomas Gleixner <tglx@kernel.org>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse
 <dwmw2@infradead.org>, Miroslav Lichvar <mlichvar@redhat.com>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>,
 Arthur Kiyanovski <akiyano@amazon.com>, Rodolfo Giometti
 <giometti@enneenne.com>, Vincent Donnefort <vdonnefort@google.com>, Marc
 Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, Richard Cochran
 <richardcochran@gmail.com>, netdev@vger.kernel.org, Takashi Iwai
 <tiwai@suse.com>, Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>, Jacob Keller
 <jacob.e.keller@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Peter Hilber
 <peter.hilber@oss.qualcomm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev, linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: Re: [patch 04/24] pps: Convert to ktime_get_snapshot_id()
In-Reply-To: <20260527090114-359e2553-2c63-4ac2-a15a-776ba08b6eec@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171222.995833811@kernel.org>
 <20260527090114-359e2553-2c63-4ac2-a15a-776ba08b6eec@linutronix.de>
Date: Wed, 27 May 2026 18:02:26 +0200
Message-ID: <87ik88lu25.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 27 2026 at 09:02, Thomas Wei=C3=9Fschuh wrote:
> On Tue, May 26, 2026 at 07:13:48PM +0200, Thomas Gleixner wrote:
>>  static inline void pps_get_ts(struct pps_event_time *ts)
>>  {
>> +#ifdef CONFIG_NTP_PPS
>
> IS_ENABLED()?

ts->ts_raw is #ifdeffed out then, which would make the build fail :(


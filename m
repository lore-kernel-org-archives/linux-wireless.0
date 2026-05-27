Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C46937757D;
	Wed, 27 May 2026 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897532; cv=none; b=abM4fMZzBW3Fbgi6Y2K3TD0kpB4TOvVTGYxzG/g9LUXkkXpv6B8PK35NvNsEo+q2phy3p+AzuqYw4mLX4Fc9cf4pPcNw+26yxDeCNGobdSeM+T6HFVk/HuTqOS4uUK2Y4c6F83IdnD+COeXFINSibN+6osPgvdOa4ruNhWe0zCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897532; c=relaxed/simple;
	bh=P/q0FkPCbOqbUkrw+u8nkYD8bm9IFRA3W532/HwIFe8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=senNA22VjHmcauyrG5eyK2oc/GivUlWT0J7AYrLUO8Veh03wIbBzgGq8KnCDzAh7gMV4uWfgZoRo9fGc3WLLwX+15Clw1iu7tqLg21EeKxod1zr9p/lsCGfzv5fe52QJKbMrzXHC4YOWxjr0ijWPicsk0G8HqaMPaqDRWGgc0MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HI52qeAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HI52qeAa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 46A771F000E9;
	Wed, 27 May 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779897528;
	bh=qOiVUORxGHoXQHdIH/CnzYXWd5lz7K5U1INIbRfRKIg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HI52qeAaRyO4Q6E0LSwfS3Av/xt9S4iwpw7+92v2eByeb1/+L10PUigEtdcxRbB2T
	 YamtaviZWmfWO49VVYpBvsZfAQLf4EIQDIuCnYG206Ok8ubXohZhWnl4ooKkdSbZPX
	 nq5OyQE2Cv2aFfDXQrhbVQ2piHDtY7tLnafJ5P/lgg6q3JmI+T2NjGEYRUTE780w8L
	 ANFQ+NC2szcnuVHU9Z+XZSgz5mQX59RNQe0PkzPWiGCzdlNm6frITdN3acntNrp0rQ
	 6ph4g1ryHdSYDHURey1Z734BfqKq7UHQI5R0mMZFypz+G8tSOzLnlTg0XMqsEEfjyX
	 yhgW9ueoXM6yQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Jacob Keller <jacob.e.keller@intel.com>, LKML
 <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Miroslav Lichvar
 <mlichvar@redhat.com>, John Stultz <jstultz@google.com>, Stephen Boyd
 <sboyd@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic
 Weisbecker <frederic@kernel.org>, thomas.weissschuh@linutronix.de, Arthur
 Kiyanovski <akiyano@amazon.com>, Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Oliver
 Upton <oupton@kernel.org>, Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Miri Korenblit
 <miriam.rachel.korenblit@intel.com>, Johannes Berg
 <johannes.berg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Peter Hilber
 <peter.hilber@oss.qualcomm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev, linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: Re: [patch 01/24] timekeeping: Provide ktime_get_snapshot_id()
In-Reply-To: <5b082d25-9a57-4612-a93e-a4591acd0ea6@intel.com>
References: <20260526165826.392227559@kernel.org>
 <20260526171222.769770418@kernel.org>
 <5b082d25-9a57-4612-a93e-a4591acd0ea6@intel.com>
Date: Wed, 27 May 2026 17:58:44 +0200
Message-ID: <87ldd4lu8b.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, May 26 2026 at 14:41, Jacob Keller wrote:
> On 5/26/2026 10:13 AM, Thomas Gleixner wrote:
>> -void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
>> +bool ktime_get_snapshot_id(struct system_time_snapshot *systime_snapshot, clockid_t clock_id)
>>  {
>
> Since this function now returns a bool would it make sense to add a
> "Return:" comment to the kdoc to help explain what the return value means?
>
> I saw that you have a WARN_ON with the ktime_get_snapshot wrapper. I
> guess it returns false if timekeeping_suspended.

...

> This warns here, and the wrapper ktime_get_snapshot also warns. Does
> that make sense? I guess eventually the ktime_get_snapshot will be removed?

No it does not and it's a leftover from an early version. I later
switched to have a valid bit in the struct because otherwise I'd need to
modify a gazillion call sites to propagate the return value through.

Let me remove it.

Thanks,

        tglx

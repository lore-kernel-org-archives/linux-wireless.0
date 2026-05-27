Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CC3390998;
	Wed, 27 May 2026 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779866592; cv=none; b=I/RbcXZzUgf7lcdaKeNdaiAr4fnrcpYqky8yNvaJAzgV96xeHD1zv6HTBL6XlOUeFX6QcsWSBEDyT8dNTUnqMi/4Hh/Kn0dhHnFb0WHHWXueWBmt7GqadyfRpDYiEALEwS5J9ndlXlSodwU5k+5xTjPqtbOCb/AgN1QBcM3RIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779866592; c=relaxed/simple;
	bh=kpTQ7YI4sDj0kaApw8R0TqVKXjDTWrUOtJNoBP81cFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COXPY2s/g9bJ8TFtfwDJbEUgjNBwTzw4X+BoOs1GHqdMW5VBiEl97+pBwfXmjawDLnAR4O7vMY20AUFJbI28efu7ZszWN5Ur81CqZXpuRvL9yiUO1yzhR/J9iZ2q95IfD+bgkf5qmdlpLkjtN4q/9uPnHti93qwXfNflljOzUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nHN/d8tU; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RpQxk7l4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nHN/d8tU";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RpQxk7l4"
Date: Wed, 27 May 2026 09:23:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779866589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGpnwBWnR9Wgvjj1aRML6E3DbNQLjsriYriSyfcJ80A=;
	b=nHN/d8tUjnGSXHfynWIK0cq76Huiktr/HwIIgVtO8If5liXM1MUwe4PY4lJPy3VqlMI5In
	oc3L19KvH4ZMbrBXJEm8qzA8GdKiBKyAvJNt6zRcNVH19340qHYlGn62yG/WwSqOLdCVe2
	mJAQ8jN9aEWLH6L53/KRcnSI6IxfrYpV1BGXHIwlPmrG1DhnK+KRV+ZsmL71wi+5xx8Xz8
	7rogdZUyiYuTs6ux3sghllS2UjRzeDIDxWhV3XIln9eT9MTHiBksnd33r6SslfJQv59uoF
	PhBaviAOYqMGwYLHkI3MOvtsXox0CIB6P1oI4zxWFcmeGWLFRDGEEueotRhPrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779866589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGpnwBWnR9Wgvjj1aRML6E3DbNQLjsriYriSyfcJ80A=;
	b=RpQxk7l4F++LQnx70QxTcdn/QglMVPaHQzdqjB2WOkZgJHprItqdFTpD9eWSkPrl8S3sbP
	ZtBXRys8r3cyjXAw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Miroslav Lichvar <mlichvar@redhat.com>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Arthur Kiyanovski <akiyano@amazon.com>, Rodolfo Giometti <giometti@enneenne.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Peter Hilber <peter.hilber@oss.qualcomm.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, linux-wireless@vger.kernel.org, 
	linux-sound@vger.kernel.org
Subject: Re: [patch 18/24] timekeeping: Prepare for cross timestamps on
 arbitrary clock IDs
Message-ID: <20260527092126-74cc58f7-b0ee-4ab2-9daf-52de42fed4f6@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171224.050496338@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171224.050496338@kernel.org>

On Tue, May 26, 2026 at 07:14:57PM +0200, Thomas Gleixner wrote:
> PTP device system crosstime stamps support only CLOCK_REALTIME, which is
> meaningless for AUX clocks. The PTP core hands in the clock ID already, so
> prepare the core code to honor it.
> 
>  - Add a new sys_systime field to struct system_device_crosststamp which
>    aliases the sys_realtime field. Once all users are converted
>    sys_realtime can be removed.
> 
>  - Prepare get_device_system_crosststamp() and the related code for it by
>    switching to sys_systime and providing the initial changes to utilize
>    different time keepers.
> 
> No functional change intended.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5749A37EFE4;
	Wed, 27 May 2026 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779865141; cv=none; b=nPYutlm+qRDb93ggIKNizuTO6d8S5CP1leaMjrLdtVfcAvYmtFaGpFzFtvhabGQfHh6tjATtyPsq6wcG+A8WMAG33RtzF/FC1bSGBmnyM+XZHHN1Pj0zFzS9Zao6yBPWycZ2kkBCk3CouS/JIcZZfTMMKw02sye9zwA2a9hXxeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779865141; c=relaxed/simple;
	bh=viJNVp178BWiwCodeOsJN+/cqbnck9ZtjEGjL+GgNiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFv1v5tQOtb1tOiLc+mAZxffGO/ON9LEbvQgxgNt7Q/XIt7nImGBZpD9ZCAv2BWeYkxukcXcUma4K7foRul5fUQ74NRXCWX7RyQMCebBw89Abximir8ofOjftkmPjgbPHiH7zLdYAAD/Wn2DnXGXkZ2FyXEVD3POGZ14+JGwp/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=z3AyANOy; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NLSAUXE2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="z3AyANOy";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NLSAUXE2"
Date: Wed, 27 May 2026 08:58:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779865138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVwxPRuSU8phWDoZCD0LOwTMjaZx4+rWIiUwN1pJKYk=;
	b=z3AyANOydMGn6KodTuTXGB93a8C/LNd68IrHsJQtgCeUvS1Ay5ZLhdE+AeGYFDInwMLCKd
	OA//a0RNtsqhlRAMRFwrX8nZsXcv7izJlnjw0wHiKMZQNMPY/wRd6baWMvrfqshOCj4y2O
	KyTy1Htq0UlWck18XEkLMSaKHRfMCyIh9GOZMg104ecX7SvJdyyGI3EpUdYDOCLP3kl702
	OlVllgF8i3iYrGnTBbYt+gOwMwD33FJ9tKVLSSd2BN7EFET3PtkjCeclN0brLeDwANbPmP
	cFekM7qjitpev6rRLZ3RtHPu7NhzP+b31lJwpT3+QqG/n2utI30O5vqMH+RR0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779865138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVwxPRuSU8phWDoZCD0LOwTMjaZx4+rWIiUwN1pJKYk=;
	b=NLSAUXE2T00wxLDWtgdQnBIo0CyluAdTpOByi45v0GAepECrZ+6v+pBZUSNrj2+ie8UQL1
	yS0wBy1HPbtNHFCg==
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
Subject: Re: [patch 02/24] timekeeping: Use system_time_snapshot::sys instead
 of ::real
Message-ID: <20260527085841-1b996b24-3b5f-48b7-8c69-64639260ad81@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171222.846848261@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171222.846848261@kernel.org>

On Tue, May 26, 2026 at 07:13:38PM +0200, Thomas Gleixner wrote:
> system_time_snapshot::sys provides the same information as
> system_time_snapshot::real when the snapshot was taken with
> ktime_get_snapshot_id(CLOCK_REALTIME).
> 
> Convert the history interpolation over to use 'sys' as 'real' is going away
> once all users are converted.
> 
> As a side effect this is the first step to support CLOCK_AUX with
> get_device_crosstime_stamp() and the history interpolation.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

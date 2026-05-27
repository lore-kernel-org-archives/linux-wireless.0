Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5B3B1019;
	Wed, 27 May 2026 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779865435; cv=none; b=KBT+OXZyVY+biq/4tRDcrQx2LfXUahks0ExQkjAyxQ0C3r3v8EZooy1s+52oY6g4j1l8A2fNd3h+KBLsrGbmp+cXkMBJ8Fxa83x3RUu/9YBBJpf3Act4UF2jgITtlP7T5Z8m9iNT8R+4XA/mSqVUo0kHKDhtsatm6E7RvPZnSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779865435; c=relaxed/simple;
	bh=DCZ6C7qF+0dCuvF6/rtBJIHnUs5YW9SR5lLq5LplnZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijKa3RKf25E6vvyUhU2TPcTs7DAcxlBWIKGhIKhvDhjFMUpBPjDsX/6PZvak+C71AStLR3gMp/kFSkTKbBD59wq27AyTY36cBnXKggPOi8235HBBJ3zeto2V9y+rb49Eh9P7/R2gE76dHFY2rD8uXLSYCBzFu4hzlmD57c3G6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xGi5vo5D; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eI0RKJjb; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xGi5vo5D";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eI0RKJjb"
Date: Wed, 27 May 2026 09:03:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779865432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KgTs6G0FhL+F5KBKUBEi9iPfdtbWQuDdQ+5FzH8mImI=;
	b=xGi5vo5DwOQcgTiPQuFCVz1DXOkIelpBx+tkpLcqcoKjPqXoxBzWo4Wqpkm56FbzKN/i8f
	bISk7XxxA88pDP/cQfRyQ11BOdWJ0SabWsOZiUx66Q/zsz34dZr0Kr4uF5nqyCRfbfc6XO
	CzIm4cLN36bprziK/cmMWKkNSvdhDNimTzLtl8MNKA1fI8j7mDu2byE+BgjGiMyg0Tv3Wu
	bZdwRnV2Fx+RAKxQE9MbnkaPA9PNgpCrAwpvDrAMJ8laK9QNQAJPaLtaDjqV5ZRiQcuE/h
	l1H4IijdmCJxXBpLcq9ODivkbx/06SXGIxFh1//4+Gc/MwE/nyOKZ0WFsu1zEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779865432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KgTs6G0FhL+F5KBKUBEi9iPfdtbWQuDdQ+5FzH8mImI=;
	b=eI0RKJjb2sgVi/o5B8b2aiMXIQez4KWVR+VGlYeCeeFN7ZcJ2utqbRmhAH3mxvWRbV5o4V
	DL3JpF2m36h82WDg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Miroslav Lichvar <mlichvar@redhat.com>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Arthur Kiyanovski <akiyano@amazon.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, Rodolfo Giometti <giometti@enneenne.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Peter Hilber <peter.hilber@oss.qualcomm.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, linux-wireless@vger.kernel.org, 
	linux-sound@vger.kernel.org
Subject: Re: [patch 06/24] KVM: arm64: Use ktime_get_snapshot_id() to
 snapshot CLOCK_REALTIME
Message-ID: <20260527090259-47d7928e-ffc0-4529-8258-a8807e0feb33@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.144327185@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171223.144327185@kernel.org>

On Tue, May 26, 2026 at 07:13:58PM +0200, Thomas Gleixner wrote:
> ktime_get_snapshot() is replaced by ktime_get_snapshot_id() which allows to
> request a particular CLOCK ID to be captured along with the clocksource
> counter.
> 
> Convert the usage in kvm_get_ptp_time() over and use the new
> system_time_snapshot::sys field, which holds the system timestamp selected
> by the CLOCK ID argument.
> 
> No functional change intended.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: kvmarm@lists.linux.dev

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381B13B7B7A;
	Wed, 27 May 2026 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779866335; cv=none; b=E/ozaT8bSpNBMbO0HUnCCyFNi/NW9qSqnG7pu6kWCiOClplr3U9Iqt3xgHDiY+RPXPLXbAI+wbS4TEtEzXi+39SQ8q/dpE2ezCX+D3w+cpP+2cOs37xABzUEztBtWS8+nCQ0EupZ0NvymuxXHBceZWxEDjn1CmMN7aG6NQ58qac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779866335; c=relaxed/simple;
	bh=wCHkiYzaEZ2VQJMSZlE0SCDBVwizZU8XwTiUPxbQd6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdZpLaR7toM24SUrbhDnm6vTA2IoQsFknGFV3Qrz2cY9XRYoATLs/db19DpXS/WiNMmDdxqZQvKbILwlaozWQNLL1PVHoBzSShS5We+Rjy0O5BBMRQG75Je5po3SZArsyOhLjsnv/zzFm3jZVuXWffStIHSP9szcWJhUi8Mlhic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mB7P4YGn; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6th0MMuw; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mB7P4YGn";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6th0MMuw"
Date: Wed, 27 May 2026 09:18:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779866332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ovgQx3AFB6saAe6xkInVEM2b4dB/Is3QWdliTwZX6I=;
	b=mB7P4YGnlLJoUJQeRXqbeTC+uZ18fZbm87IGXwh2McxnBynPlakT9gFx++QEAd2raNNNkE
	I5ZBl3NmrL+A1y986pGYZTXto5BH0FGQ9b0oGfySZuEKtzH4TS6XRH+mIxQoY/RDCEgQIS
	6nJ0Ai6b5AePV/IS1MA+C/7egRMMMGNYM+/rPsFUFYMfcAm710VA2OCJ5DzMMX2OkoA84d
	/gjAjoL1BLVCIg6O7WB5SI106/DdE+OE+4uZcHhgzZFhATsTiH11iKOFpnLbuB7lZr6te6
	zQ5JtSkwIRoXSEvaQ2M4GGe9VhOTD2pjaTR4J+vETMsuW7um22BDNjvHLGWM1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779866332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ovgQx3AFB6saAe6xkInVEM2b4dB/Is3QWdliTwZX6I=;
	b=6th0MMuwDyMvHKsIXfWjRM0+4x36ThhPY40eLVcGMu3VP/nlb1jOqC57RP5nxNO9/sxuq7
	l/Ctseig23H+AQAg==
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
Subject: Re: [patch 09/24] timekeeping: Add CLOCK_AUX support for
 ktime_get_snapshot_id()
Message-ID: <20260527091749-dfc12db1-6b39-4aea-82e7-f1c20f35ddbb@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.374814973@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171223.374814973@kernel.org>

On Tue, May 26, 2026 at 07:14:13PM +0200, Thomas Gleixner wrote:
> Now that all users are converted it's possible to enable snapshotting of
> CLOCK_AUX time. The underlying clocksource is the same as for all other
> CLOCK variants.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

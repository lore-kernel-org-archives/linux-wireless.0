Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E12C027C;
	Wed, 27 May 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779866702; cv=none; b=m4Zrkfyas/cW7pe3S4OdU4+cQylWEkyU4cE8yMwbiczyHiW8fuyHU7sCYJcjUj8OcmjnqpxjiyzdkdNHGTMGGz5O5ZR+YmJciR5t6xGWS5Y0CGIecZ1BaL5hY2jxXt5/kUZyCBvyxkB1UA9/BLeSPRrEkVFFG3cIrjGTAZBxEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779866702; c=relaxed/simple;
	bh=H286pH0XEVaTBl11NoF476tTyCrePsNa+hNCO4h58i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwoF5ZVxl5eC2PX6IATc13M798584QJeKsXbba2BnxcLKoWmAsLEVvOZKb7hOz6SXM3HHXRbKu33NJYDT5KPr6wHAUkDb0XeQtnPzvse/Kq9fKoCPUNCW5eg5heLDno2TFAa0zE88iKwUzX5JwcCj6ZkwZJT7+bJLvJZqHmeHKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=yxICJRlV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SWxeWBwT; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yxICJRlV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SWxeWBwT"
Date: Wed, 27 May 2026 09:24:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779866700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wbgh1lph/Cw9cQ2P7yfOnakbfAXz1iVADCAMap9VS2s=;
	b=yxICJRlVnrHFs7DxFJvW+0S+eTDuoFTKh6YKulHGTjwvy/voHWsGUCGCmM2ZhTZG+Ndcor
	RdcmpLsSec38GmQ2YaTGdsz2w5LwBhJb4gMKodn8snCpxniL57+0pJluvJpHzA7MUL7VVo
	kVh4Tyqw6jo4K3JO8WBjyCVePOW/pzxo5MKaIg4/NXj7A5qEOUDHm4V00aqkTeP/ZumqaM
	lFoFI9XJ88pWL8jqoFkCmw4gy5CVZRx7Qi8MnE+tLY8k8lpCCuCXgE+5JtOnmWZaD9YGiy
	JIivgwPtV24GGWDMhY+u5LNb3Nc5U+W95ZW9JGJkX/3jw2G6c2ViiYkNdB0rpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779866700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wbgh1lph/Cw9cQ2P7yfOnakbfAXz1iVADCAMap9VS2s=;
	b=SWxeWBwTBBmK1D3E1cPJ4Sod+C/sOqkqJA4Z5RxQ7r7sOrEyKlkQsh95tLQxrSeGcl1j0y
	an/Z0sm1XLeeUkCg==
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
Subject: Re: [patch 23/24] timekeeping: Add support for AUX clock cross
 timestamping
Message-ID: <20260527092439-18ac09b4-d62f-4215-bb20-fe3ad7b0e77b@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171224.423155175@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171224.423155175@kernel.org>

On Tue, May 26, 2026 at 07:15:22PM +0200, Thomas Gleixner wrote:
> Now that all prerequisites are in place add the final support for AUX
> clocks in get_device_system_crosststamp(), which enables the PTP layer to
> support hardware cross timestamps with a new IOTCL.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

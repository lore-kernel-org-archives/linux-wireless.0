Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149DA3914EB;
	Wed, 27 May 2026 07:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779866461; cv=none; b=CLRVEWAMFCH4Abg0HjlDSF1+vtfW5fq0WLFbmGJ2HOz/LH9yEfteIO8ky9Sxwb2YVX2YhLJqU7XK0Ml2hsTOAV+qtRwQT1FcL/NxcGsB2QeWq+A37yHHuH3aT2ni6RkoA95OLQK2JdZm+bFBWIY/CdY7Dc6j32V/SxjZ/DPaUA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779866461; c=relaxed/simple;
	bh=hgm4jg5E+uP0vo+tWiTQPB96ZAtqreh14eLEU2uzbgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQm3dj+b1OdaVkpKIIHcYszxBIwphdK+jdwwDuOn+UkJMxmdEUWHsEHyue81y6Rs24L77lWqBzyJaVyD3Jo6fSgGjaYNjV5thzSH+oUOICyK4a3ME4ItrxuMQmPV4PifAvQ/wAcXlj5OPy1uUHetApR0LLsSe9nI4KkZH5/NW8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HCsg9f80; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=06wKcfZV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HCsg9f80";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="06wKcfZV"
Date: Wed, 27 May 2026 09:20:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779866458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hK2Whffe8U5/Bmvpd1uw+2U1JQ46A8W6No1g7ttBSc=;
	b=HCsg9f80pLbeYJT8ZOpeTMvyTcUbNUUA7VZPt8rcr6Ly4O+qWF/Y6Qi2F3JGrHWeLQgMfk
	WxCrkoDW0PqYN4CsdRUBCkoo/WjYxDhwPQDMz3esYrLajyIwduebJncuNjdeAuvOsteSZn
	zEvSy8BPifSRFEOI0oL1Hjxge6WE9tWs+MkgO1y2JKLpXLQDYDe1k7lWqQBC5SSxmrtiPk
	k/cp1EPgwYBAh3P3uAesi9QdGk/STnvBe3CNetiHTdr8vnjYgE9/Fn30rEK3lXVh+BilcB
	CS2VRkCq6CK85QMEgM7fSDUU9AOMYXCZLp+4ot67C4/52Zza8l2tvbnMCh7sog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779866458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6hK2Whffe8U5/Bmvpd1uw+2U1JQ46A8W6No1g7ttBSc=;
	b=06wKcfZVXh1DOeAMRiQHzaFEdS+QIBRWlA2zFMyCkvW4fVste2X22Bna1tRdAXc5viGpvg
	hBtbcl3/36lWfoDg==
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
Subject: Re: [patch 17/24] timekeeping: Remove ktime_get_snapshot()
Message-ID: <20260527092044-91c6992a-52f2-45d0-8478-b53c186a5e63@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.974925389@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260526171223.974925389@kernel.org>

On Tue, May 26, 2026 at 07:14:52PM +0200, Thomas Gleixner wrote:
> All users have been converted to ktime_get_snapshot_id().
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

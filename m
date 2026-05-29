Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A301F43E9D1;
	Fri, 29 May 2026 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084860; cv=none; b=sR/HhsLvR+REm44qgt2wvrIsogPQh3Z3IbnxFNJacBaWQfarG3WYNUlvuc8hO1QgJF+W1kZUeDC6+n7ffr/c+B4byctzXQOwiJYqhYGpWDkwJ2QiNXlOij6QimcdZ1m1/Dyp2p9e1gb5pKfvp4Ruk4jKezbRaWU46hNWjCJwg2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084860; c=relaxed/simple;
	bh=TjDxcDLb2J9B/F5VPwHZZwZhUCGD+n1Zxf5w2iisH9g=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=AOiB92V+/wZDBBFiyGXzI9RLMvCZP71RLl7MIbbl9P/81G8ZSLUWyLj+BqbAuW+Xrtorsf2fnLEQ66GnIZXcSexPbEDXO68ScRjYcizXEQ4vSJ7klxTpmA1IdzCcmXtyVG+7+F1auzCrf6oPgxfU5Rq35AoOk9mdhr7CRyLGrn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsTk5hxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsTk5hxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB61D1F00893;
	Fri, 29 May 2026 20:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084859;
	bh=fxF7IUJLmP951C4QzYmMiCV+YlkoHUCPEOW+29GOPe4=;
	h=Date:From:To:Cc:Subject:References;
	b=WsTk5hxhDKEy0peIliPk2CQVgBLsbM7oTIaDRXduLffrLVEy9xKn0/Hg/H5tmBJDD
	 Khj9LV/SV+8Smf4b6v3NUAg+jmpZZS9l+CVpDM2tck5TcNORz/7kSLSscvzvwFOvaz
	 d084nBPnNytVNL3iwhJxE87NBB1sht1OKvx2Fhji75bNDe9QCvz4Gxashbr3/4vFh7
	 2Irw3z9dW8Eye2n81HsBuPJ8OMnGCVU9moS9y8kPmt4ZN8RtY1MIcc2qSPdmFHabsA
	 bh3zvvmLHn4Oq00x3vK5F6vrcpURvg0Hat7kuWIgIgi0PEaLvp+ssFq5gK/yhg1GkD
	 zdjFThQmmS5wA==
Date: Fri, 29 May 2026 22:00:56 +0200
Message-ID: <20260529195557.795510496@kernel.org>
User-Agent: quilt/0.69
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Miroslav Lichvar <mlichvar@redhat.com>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 thomas.weissschuh@linutronix.de,
 Arthur Kiyanovski <akiyano@amazon.com>,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org,
 Takashi Iwai <tiwai@suse.com>,
 Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>,
 Jacob Keller <jacob.e.keller@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org,
 David Woodhouse <dwmw@amazon.co.uk>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [patch V2 17/25] timekeeping: Remove ktime_get_snapshot()
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

All users have been converted to ktime_get_snapshot_id().

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/linux/timekeeping.h |    5 -----
 1 file changed, 5 deletions(-)
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -350,11 +350,6 @@ extern int get_device_system_crosststamp
  */
 extern void ktime_get_snapshot_id(clockid_t clock_id, struct system_time_snapshot *systime_snapshot);
 
-static inline void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
-{
-	ktime_get_snapshot_id(CLOCK_REALTIME, systime_snapshot);
-}
-
 /*
  * Persistent clock related interfaces
  */


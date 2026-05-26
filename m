Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F2D4048A7;
	Tue, 26 May 2026 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815657; cv=none; b=a9wZCAlZmwPO4H6zIYQnSO1JnCsfmY83kVtCvxtfKjs4TvmxEhTHwYMVNt9l03pDX8ajOkifSvcmirqbc2t3/9AfuJwLc4L87GU9ufqrd0vD73WU+ZhSDRMCs1DUKzYR1dFUpFvKipAWyOYgf7rkTDot3xBSwCehwo+0wFHHrSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815657; c=relaxed/simple;
	bh=NARuUrkHmNevlyIPFQFIlrHQGoHA/MiQ41mOIukkYr0=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ciTaaTQDq44LuLx4TkHAKgXlgmhtRkr0p+oebKoWQt1NWVZO21RHYifv5Ezy/s7DxPJBLvF+R2+01Ol+D/OvuZZpv2X6hkCZbjLk5sMRtgJw1J2Hke8Cl3mTIkLzGMrSSrigTkHlR62pcHzAc5uOmZ3FesmyuxeVePKbBC7wzL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrc2F73Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrc2F73Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 685011F000E9;
	Tue, 26 May 2026 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815656;
	bh=Zuslkw/wyLuc6P6SYlU885Bs4PDs+BVXU769LA34MfA=;
	h=Date:From:To:Cc:Subject:References;
	b=jrc2F73Zqf+wrR8aePRalmTTp1CxIywOZfK7+g19mZb6cP/i9FMMelBgNfiV0WioR
	 wSBUZwhGtNXmlyg2ywnHYoOUzbECrYAgoF8anRf6IDr+cdD3tv+lxOXEkcMkkU3TXL
	 zsLYsSdlAJUzxlUhu6WcBYc93NhqoNxGqPJJLIi7L8G5qAq6t9nrzfSntyVNhD/M2f
	 matYf0ZaYZf+xVuh6dom0b3Wxu6ESPiQIRWsmYzmRC2g7/5qgAvNeDUjWwod5xeqWb
	 aoDyzVBk9jzWigFzvAC+1saO6Q+gH4XRHaGgUytnmWo5mcOubBx/Yt/gvHCYRbyPTJ
	 9dZkIsvJZgl6A==
Date: Tue, 26 May 2026 19:14:13 +0200
Message-ID: <20260526171223.374814973@kernel.org>
User-Agent: quilt/0.68
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
 linux-sound@vger.kernel.org
Subject: [patch 09/24] timekeeping: Add CLOCK_AUX support for
 ktime_get_snapshot_id()
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Now that all users are converted it's possible to enable snapshotting of
CLOCK_AUX time. The underlying clocksource is the same as for all other
CLOCK variants.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 kernel/time/timekeeping.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -67,6 +67,7 @@ static inline bool tk_is_aux(const struc
 {
 	return tk->id >= TIMEKEEPER_AUX_FIRST && tk->id <= TIMEKEEPER_AUX_LAST;
 }
+static inline struct tk_data *aux_get_tk_data(clockid_t id);
 #else
 static inline bool tk_get_aux_ts64(unsigned int tkid, struct timespec64 *ts)
 {
@@ -77,6 +78,10 @@ static inline bool tk_is_aux(const struc
 {
 	return false;
 }
+static inline struct tk_data *aux_get_tk_data(clockid_t id)
+{
+	return NULL;
+}
 #endif
 
 static inline void tk_update_aux_offs(struct timekeeper *tk, ktime_t offs)
@@ -1218,6 +1223,12 @@ bool ktime_get_snapshot_id(struct system
 		tkd = &tk_core;
 		offs = &tk_core.timekeeper.offs_boot;
 		break;
+	case CLOCK_AUX ... CLOCK_AUX_LAST:
+		tkd = aux_get_tk_data(clock_id);
+		if (!tkd)
+			return false;
+		offs = &tkd->timekeeper.offs_aux;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
@@ -1228,6 +1239,10 @@ bool ktime_get_snapshot_id(struct system
 	do {
 		seq = read_seqcount_begin(&tkd->seq);
 
+		/* Aux clocks can be invalid */
+		if (!tk->clock_valid)
+			return false;
+
 		now = tk_clock_read(&tk->tkr_mono);
 		systime_snapshot->cs_id = tk->tkr_mono.clock->id;
 		systime_snapshot->cs_was_changed_seq = tk->cs_was_changed_seq;


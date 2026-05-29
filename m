Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B403AFCF6;
	Fri, 29 May 2026 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084828; cv=none; b=ABvnDSMXazpvJw8jMjMO77zlWMp2i9O2hW3B+BmhZdgE6aw733bOUgE0W/2Q/D4gVACyR77JqYe9pLhlGHYShMGsaJ+wmL+kNEtdVdymnWVJMWp3+VHkyokJl4KaJuw2HcyzoSYp3LK+G2FEkTaLyniqayGepE/b53UXYl0+xc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084828; c=relaxed/simple;
	bh=A/5waJp+BmZ+vva6Vr7ea8bVP3AYVgQmus3ZwCqskxA=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=MY/vIRquwTSKhD8I1k2mICv17QlwAeVGOiaZBVJyTdvnCHrwk9t7OqXbEtUW///iY3aNer4qGFFfd3EQ7cjYgBAXQtjqkVRQlX0pYWIN552UeWHQPcSkUM3Ea61QKiOg0NV8toFCrIwsIWQULt1+H4HCSOby0YRO3XWRbTsk+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdNN9lDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdNN9lDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537DF1F00893;
	Fri, 29 May 2026 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084827;
	bh=Peis10VZiN8/DpiwZbUZKE9VvYtDRN4ai22wyx4i9l0=;
	h=Date:From:To:Cc:Subject:References;
	b=UdNN9lDUrY/wnD/o9Iu0KV6r5Gp2otSL5SWTBtBZqLqcuQiZOvMQAflU+A3qRxdXa
	 PraTW2+SEqiFM9JkVn2TcSIHKSo22zjvTVVwWsvwqcmkj32Qu3Mggh55/pV6nuQYgM
	 uph75hz6z0ZqDstWhYQAgd6h9ggrK6MTh4NwMPdzqRnbQ3BHasLSLo2tOdoke5Am3C
	 4EIb7RnGu7kbT+GJPJ9Vf2lvkC62TxLF+eKlXnltRTmnqVmqKn6280iRBmTjn61U5q
	 LC9KhS5etpEKnqGe95R9LyeVKhOR+Mhj6z6q3yRV9aeu/+rEKETeY+dojgHsVwm/wo
	 rch6oFiGV31Aw==
Date: Fri, 29 May 2026 22:00:24 +0200
Message-ID: <20260529195557.380601005@kernel.org>
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
Subject: [patch V2 09/25] timekeeping: Add CLOCK_AUX support for
 ktime_get_snapshot_id()
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

Now that all users are converted it's possible to enable snapshotting of
CLOCK_AUX time. The underlying clocksource is the same as for all other
CLOCK variants.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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
@@ -1218,6 +1223,12 @@ void ktime_get_snapshot_id(clockid_t clo
 		tkd = &tk_core;
 		offs = &tk_core.timekeeper.offs_boot;
 		break;
+	case CLOCK_AUX ... CLOCK_AUX_LAST:
+		tkd = aux_get_tk_data(clock_id);
+		if (!tkd)
+			return;
+		offs = &tkd->timekeeper.offs_aux;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return;
@@ -1228,6 +1239,10 @@ void ktime_get_snapshot_id(clockid_t clo
 	do {
 		seq = read_seqcount_begin(&tkd->seq);
 
+		/* Aux clocks can be invalid */
+		if (!tk->clock_valid)
+			return;
+
 		now = tk_clock_read(&tk->tkr_mono);
 		systime_snapshot->cs_id = tk->tkr_mono.clock->id;
 		systime_snapshot->cs_was_changed_seq = tk->cs_was_changed_seq;


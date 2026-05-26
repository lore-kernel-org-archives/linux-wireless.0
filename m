Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10758405C41;
	Tue, 26 May 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815624; cv=none; b=LEQKrS8J6PxZdCWJA9lGFHFkirFpirOkFh4CNi9gHZ3zMugl0WWQz1454BMXm0OXXHsxwiHlJcbpMa3yVj5eA9mAjGXk4AE4ndoZNcc8z15Q8RSRe2vf4v4uedMFqdSTyMX58VnTTruC4JmUzLUNeRS1TTOXqqEkyg7fnulRmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815624; c=relaxed/simple;
	bh=1gJ39ZBykzUVBWyDS6VHvRoUDWgo7sKerVkC8ZiW740=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=i7Y+3DidpvBiJeIWI7sYGc6ru2QgstQ41LX8OUDhcHCevT/YymcNanjdYUPa9CwIpcK5vF4fKMu3/hT1Q0Ghpnh4CFKmtJRDC+GFuPwHwAkm999/qN3wHjuJNXVvmWvTKEqWrKB83OFTJ/FZVbx+9doLHXE4pG+pUgpl9K7xBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmZbwV0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmZbwV0J"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B20C31F00A3A;
	Tue, 26 May 2026 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815621;
	bh=PbsJ6GKklobOZdFGQ/1Sa//V0DO21BARQCnNN3dl8uA=;
	h=Date:From:To:Cc:Subject:References;
	b=YmZbwV0Jx5+P9OBLnh6BPP6K29uNO7VDiOjP3djaK8Iq12XfIbPQUJ2XFuqbHkeUt
	 WyclmZde0cCdGKJI0+Jp20D6gW62Ik8diU27wGA8eTNdrkgrvgeBGtfCNjdzA3Wcrg
	 B0fV/+SCJMzLzvFQLBygK2as/tI4QC+ISwMysnUCAAHXT9g4mByv5W7uy5u9lRaSjs
	 C9vhRoMzjdG5hfxZbAb2HQk4ycfPCgt2JdhsTKUEJ4/DOhBZd8i4Z2h1vxYyTFoSwQ
	 v4gXkegCGDrMQjYguFpM7NgcdDcVjxMZL+JUFTK7fGaPJus8y5WGj9sWftN6vT8dNJ
	 yXeafV0yJhihg==
Date: Tue, 26 May 2026 19:13:38 +0200
Message-ID: <20260526171222.846848261@kernel.org>
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
Subject: [patch 02/24] timekeeping: Use system_time_snapshot::sys instead of
 ::real
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

system_time_snapshot::sys provides the same information as
system_time_snapshot::real when the snapshot was taken with
ktime_get_snapshot_id(CLOCK_REALTIME).

Convert the history interpolation over to use 'sys' as 'real' is going away
once all users are converted.

As a side effect this is the first step to support CLOCK_AUX with
get_device_crosstime_stamp() and the history interpolation.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1342,7 +1342,7 @@ static int adjust_historical_crosststamp
 			(corr_raw, tk->tkr_mono.mult, tk->tkr_raw.mult);
 	} else {
 		corr_real = (u64)ktime_to_ns(
-			ktime_sub(ts->sys_realtime, history->real));
+			ktime_sub(ts->sys_realtime, history->sys));
 		ret = scale64_check_overflow(partial_history_cycles,
 					     total_history_cycles, &corr_real);
 		if (ret)
@@ -1352,7 +1352,7 @@ static int adjust_historical_crosststamp
 	/* Fixup monotonic raw and real time time values */
 	if (interp_forward) {
 		ts->sys_monoraw = ktime_add_ns(history->raw, corr_raw);
-		ts->sys_realtime = ktime_add_ns(history->real, corr_real);
+		ts->sys_realtime = ktime_add_ns(history->sys, corr_real);
 	} else {
 		ts->sys_monoraw = ktime_sub_ns(ts->sys_monoraw, corr_raw);
 		ts->sys_realtime = ktime_sub_ns(ts->sys_realtime, corr_real);


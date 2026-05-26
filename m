Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB996428494;
	Tue, 26 May 2026 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815647; cv=none; b=c5yIJzG9olSG5UzNXz5vVzvQCU0ZylhDMzRfGZHN6/euYes7DofAL1tD7ZiJS8U2FmJactatThQ1frcmZxz/mVsnBkFnwz+UR4L/8LzqJ8TTXAoKwRB5pS68T5y/Z2sXDpZAjmtPSir8WBRHJRF65p52KjSxRLhPQSYAIp7u9OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815647; c=relaxed/simple;
	bh=C/lMk2GwsVhK7xeNGjqgovxJVEbkd/ih7wBImrOm6no=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=n2MZq9o9oo54ekbfXSwEJspcKKeno+iEo4EtTvI9Ky8RoaczP0oS7Nyvip0lMZhWzX8bh0J/9SF1NKRW1bDQv4cQEtYjMjs8aIPrR4R6rIwUWbf1j+i5aOR+dGdgflrfCOXeI0nR19Zz6CL5KEtVRud+8OkF9sM2h7oBbSBb2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+jXC5EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+jXC5EY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D0DA1F000E9;
	Tue, 26 May 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815646;
	bh=2ympzjAuthBIB8syf+QxMkzZ62mfQrNEou/VCvaS1MU=;
	h=Date:From:To:Cc:Subject:References;
	b=W+jXC5EY7w0lfHOahBCkY0aiK84bLrigeVkZqS28mZeHL4pwSOPqcyj6u14nPVAqe
	 GRC/xUIdM+A67H6udH3kJTgfDK7P9CNeXCJo0Sxzk2NcHG/2aJCMoLE0VAtQk4ZPrz
	 hO0CKUdsNaxx/d/kvOORBbpR6VMwJzJG54DlwhGjWplDbjcL/OklY+v8hezKTRUEe5
	 b1TuNSIkANh8NhVyzPYKcMSldAG9dj2Uf5D7MtAh4+fvT5e1JD73wuV8ifjcGePG7U
	 Wr+mRcXqfynnoW0EziFCm1pS4a/kRBpVbo2A2nzQInpHtFCoccatYEtnlv8F1HLhwi
	 b7KFZ9XWNXA8A==
Date: Tue, 26 May 2026 19:14:03 +0200
Message-ID: <20260526171223.223860692@kernel.org>
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
 Richard Cochran <richardcochran@gmail.com>,
 netdev@vger.kernel.org,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>,
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
Subject: [patch 07/24] ptp: ptp_vmclock: Convert to ktime_get_snapshot_id()
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

ktime_get_snapshot() is replaced by ktime_get_snapshot_id() which allows to
request a particular CLOCK ID to be captured along with the clocksource
counter.

Convert vmclock over and use the new system_time_snapshot::sys field, which
holds the system timestamp selected by the CLOCK ID argument.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/ptp/ptp_vmclock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -132,7 +132,7 @@ static int vmclock_get_crosststamp(struc
 		 * will be derived from the *same* counter value.
 		 *
 		 * If the system isn't using the same counter, then the value
-		 * from ktime_get_snapshot() will still be used as pre_ts, and
+		 * from ktime_get_snapshot_id() will still be used as pre_ts, and
 		 * ptp_read_system_postts() is called to populate postts after
 		 * calling get_cycles().
 		 *
@@ -140,7 +140,7 @@ static int vmclock_get_crosststamp(struc
 		 * the seq_count loop.
 		 */
 		if (sts) {
-			ktime_get_snapshot(&systime_snapshot);
+			ktime_get_snapshot_id(&systime_snapshot, CLOCK_REALTIME);
 			if (systime_snapshot.cs_id == st->cs_id) {
 				cycle = systime_snapshot.cycles;
 			} else {
@@ -181,7 +181,7 @@ static int vmclock_get_crosststamp(struc
 	}
 
 	if (sts) {
-		sts->pre_ts = ktime_to_timespec64(systime_snapshot.real);
+		sts->pre_ts = ktime_to_timespec64(systime_snapshot.sys);
 		if (systime_snapshot.cs_id == st->cs_id)
 			sts->post_ts = sts->pre_ts;
 	}
@@ -272,7 +272,7 @@ static int ptp_vmclock_getcrosststamp(st
 	if (ret == -ENODEV) {
 		struct system_time_snapshot systime_snapshot;
 
-		ktime_get_snapshot(&systime_snapshot);
+		ktime_get_snapshot_id(&systime_snapshot, CLOCK_REALTIME);
 
 		if (systime_snapshot.cs_id == CSID_X86_TSC ||
 		    systime_snapshot.cs_id == CSID_X86_KVM_CLK) {


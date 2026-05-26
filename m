Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A1425CF5;
	Tue, 26 May 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815644; cv=none; b=gIykxaIUOEBZDuIq8IylTe8a8y9H7pcrza+uV3Jl3iSZX5OrEgs8hpFqrrynGAKvTlf1ymKGNxHxnoYk/sFIWIIN0p81N1qC+oMYw9ugpbtyoZYZaMs12Xh7VuHXm7+fxeziJSzSwCEduNwc4+8by9YjIOaTMV7sXGpHsuW3SpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815644; c=relaxed/simple;
	bh=p1bCOvFUnRZdHK9oC4A/qYvklVkRMVW2a1tjKJ7ZXnU=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=j9sa7F2q3TJCbwgeRP3xcdhsUuPp9f4ANs/wivylPwavmXEPXlrinAKkmrEv6Oyfg9zJxLNRIQIqj5ZLE2Yzz1oggWwbxXYM7eTY5K29pelVUIHC3mVvfOKly3zHgGlTpFQ+1rGWO+0uPB1+vdz+5E+0xs+iYT0sKG/4WJNGbBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flRS5F69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flRS5F69"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BB5A21F00A3E;
	Tue, 26 May 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815641;
	bh=4U2mbuq0xtl7gCbi5xEqZvtSRzRMupEXV/dl04k7LQs=;
	h=Date:From:To:Cc:Subject:References;
	b=flRS5F69yAU28B6rRvNeU/k3gPOzTuv2+Nwc3ZPccKO0kXtBRESu6Tq0JqEuUZlXJ
	 6QofuY2O19vJqMJjhtoctyQ5wmgw2fiQAp0bkkEOiWwImF/zVrVR1ejY/YcIJriy4a
	 ika8Yf2siWBDQ0j90LSV+l1y8w3t3sl6NkzRApMji0TY9wNuAkAtgBkFwDiIJ5nEoi
	 KccjmbHgOplcMUBvoj+XiBKn+uz9H1Pzd0tX4dqV64VWjwh/CamYK0QjGJH+z7zwpp
	 S6QPXJP0lph2ho6kDT8U50uwr3HKu7M24fQ5VtTIo0+17NQahXxAq9HW15HCvUANxm
	 XPRyetaM0ZqcA==
Date: Tue, 26 May 2026 19:13:58 +0200
Message-ID: <20260526171223.144327185@kernel.org>
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
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev,
 Rodolfo Giometti <giometti@enneenne.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Oliver Upton <oliver.upton@linux.dev>,
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
Subject: [patch 06/24] KVM: arm64: Use ktime_get_snapshot_id() to snapshot
 CLOCK_REALTIME
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

Convert the usage in kvm_get_ptp_time() over and use the new
system_time_snapshot::sys field, which holds the system timestamp selected
by the CLOCK ID argument.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev
---
 arch/arm64/kvm/hypercalls.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -28,7 +28,7 @@ static void kvm_ptp_get_time(struct kvm_
 	 * system time and counter value must captured at the same
 	 * time to keep consistency and precision.
 	 */
-	ktime_get_snapshot(&systime_snapshot);
+	ktime_get_snapshot_id(&systime_snapshot, CLOCK_REALTIME);
 
 	/*
 	 * This is only valid if the current clocksource is the
@@ -61,8 +61,8 @@ static void kvm_ptp_get_time(struct kvm_
 	 * in the future (about 292 years from 1970, and at that stage
 	 * nobody will give a damn about it).
 	 */
-	val[0] = upper_32_bits(systime_snapshot.real);
-	val[1] = lower_32_bits(systime_snapshot.real);
+	val[0] = upper_32_bits(systime_snapshot.sys);
+	val[1] = lower_32_bits(systime_snapshot.sys);
 	val[2] = upper_32_bits(cycles);
 	val[3] = lower_32_bits(cycles);
 }


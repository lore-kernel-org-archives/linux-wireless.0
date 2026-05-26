Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD4238C42F;
	Tue, 26 May 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815677; cv=none; b=fOh4PX/tVslmuPXNu1hSDcoaGfUo/xRp9QcSq+fc0fPaiC8Pd6VhVu+dlfSIBpcEwecpKbCEXCXMHDSxYfQoEWjpPd5LVxwblZmXnjXSCbNt0LodNduuOjKn46IrLzI+FJTiPrJN/kp1HpTlsInLZOR02zpMkK7A+rYqva8jCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815677; c=relaxed/simple;
	bh=DArheUVO61XUzBgNB85AXjNmnIHLUI6Q0bxHpApsjVk=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=der1Ax1U2X87uSCpp6KZL4GPHVpElzc6Rc2o+kcxBYFvHKECD/brwceTBeO3TLxYQ2e3Ka6iCZdtlZ5p5o2B8r7Qo2JwKgv2HO3hBdMBvZKmajqTM8zpQXtblWlu8AfrOY/jIbavhwBJ8MNrlGriCDGGkAh0Av7bojgarsIOMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gh61Pf2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gh61Pf2b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45BC01F00A3A;
	Tue, 26 May 2026 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815676;
	bh=tIfdsxtLHEHKv/HG7wFZVqMYMQjPHg6WbV6XiYCEtAA=;
	h=Date:From:To:Cc:Subject:References;
	b=gh61Pf2bwkkQRe4nF/oglZC6S3bL38FPLNua214+hjlq7CLs3e+8TQ1kVFMIMGbWp
	 cDFlwvHmqEJ5YgC6SsOIsg+0ONZvyC7a1yZdPj0vCwmWJKpSfYu8wuaEk0Xa4R66AI
	 yT919lxYqGEh2p6izz2Q6StZgUlljlLBfvWbPgIRLHgsLrnFq9Lhogi5p/721sfYBF
	 WdMq2SsGbt7YFS5iVzhR5088g8zXNn3ecoN1tjcZEHVmwUn+ILdBXtxxlHTOEttoHN
	 DDPdy6vQzBUcak7rWUxxkLSDuIDrSps7DUK/yhzv07lyBXob07ZWx9HNjSP6qHXtpK
	 grztSygWBlwtQ==
Date: Tue, 26 May 2026 19:14:33 +0200
Message-ID: <20260526171223.670955218@kernel.org>
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
 Jacob Keller <jacob.e.keller@intel.com>,
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
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
 linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: [patch 13/24] ice/ptp: Use provided clock ID for history snapshot
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The PTP core indicates in system_device_crosststamp::clock_id the clock ID
for which then system time stamp should be taken. That allows to utilize
hardware timestamps with e.g. AUX clocks.

Save the provided clock ID and use it in ice_capture_crosststamp() for
taking the history snapshot.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2065,11 +2065,13 @@ static const struct ice_crosststamp_cfg
 /**
  * struct ice_crosststamp_ctx - Device cross timestamp context
  * @snapshot: snapshot of system clocks for historic interpolation
+ * @snapshot_clock_id: System clock ID for @snapshot
  * @pf: pointer to the PF private structure
  * @cfg: pointer to hardware configuration for cross timestamp
  */
 struct ice_crosststamp_ctx {
 	struct system_time_snapshot snapshot;
+	clockid_t snapshot_clock_id;
 	struct ice_pf *pf;
 	const struct ice_crosststamp_cfg *cfg;
 };
@@ -2115,7 +2117,7 @@ static int ice_capture_crosststamp(ktime
 	}
 
 	/* Snapshot system time for historic interpolation */
-	ktime_get_snapshot(&ctx->snapshot);
+	ktime_get_snapshot_id(&ctx->snapshot, ctx->snapshot_clock_id);
 
 	/* Program cmd to master timer */
 	ice_ptp_src_cmd(hw, ICE_PTP_READ_TIME);
@@ -2176,6 +2178,7 @@ static int ice_ptp_getcrosststamp(struct
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
 	struct ice_crosststamp_ctx ctx = {
+		.snapshot_clock_id = cts->clock_id,
 		.pf = pf,
 	};
 


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E0340963C;
	Fri, 29 May 2026 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084844; cv=none; b=mIEuaovSF4Be0r6CH5E5haPvLxHuz8uBjqu2fYgqGgq5uAxP4Ao4Q7pA2mWkcTlR14LeZ4VepTOr70KdglMDdEcv+cezIJZLSHEEsL4l2hEtugUIUFhpipw8qYZfTWv0M0TvKhhOtXomTAn9QVa5HVLrtmaUvUFxYO7Ifr8wUQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084844; c=relaxed/simple;
	bh=u9Yr4OTXUEgvnkILoxrqeGDalc0zSQDZnCWqI3ARSMg=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ESyyW2WEYtTq8BpGj1kfgCB54f1Cao3fBMv8apOt4iMOPaIWOlFdyYPMRlDGGPA8FkipQf0Zb6vuYbHwDE2v5vQCOEgwjjJ4h3s94noMToTKpfYmNE3af2RViL/4QYHsUbOm3SMLS2PI4vD80DssA0oHYtjlSewg31vFuxai7Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHL7W3iY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHL7W3iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE01F00893;
	Fri, 29 May 2026 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084843;
	bh=iMKm0Qio5sZVWtxF7eOS+y+2+SjEMRnOEgT1VIjfp/E=;
	h=Date:From:To:Cc:Subject:References;
	b=bHL7W3iYV3PzOHb+vrO8CnX4LGqhP5PuObbNbQXsfV5OfaZNNSM8RkEUdsr76f/x3
	 HZ9Pe2rcMgJ+VyKQt/4FtWPleIG8lEonBQwxwPoe08xDzReR0INTaGecahaqpm5nt0
	 FVKSi5iTF06EtRAVOd+A3b8S9XUC7vGZ3p0Xfm06srBrqeZHhAPbQqd8zFjBg9l38D
	 piiTd0TIxaHL0krPcR7ffccO0XbBFBo1K8rwm+nUc1qWPk2wxp7XIkbvKd2evTsa2P
	 j7pK+QuGPmAG3plDlRLzP5xPQgb7J1KF+ZKB3NdaPDQqEgDWQGX3w8YCy9sJaJa1t5
	 ax2Z/jWC3YbCQ==
Date: Fri, 29 May 2026 22:00:40 +0200
Message-ID: <20260529195557.587226681@kernel.org>
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
Subject: [patch V2 13/25] ice/ptp: Use provided clock ID for history snapshot
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

The PTP core indicates in system_device_crosststamp::clock_id the clock ID
for which then system time stamp should be taken. That allows to utilize
hardware timestamps with e.g. AUX clocks.

Save the provided clock ID and use it in ice_capture_crosststamp() for
taking the history snapshot.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
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
+	ktime_get_snapshot_id(ctx->snapshot_clock_id, &ctx->snapshot);
 
 	/* Program cmd to master timer */
 	ice_ptp_src_cmd(hw, ICE_PTP_READ_TIME);
@@ -2176,6 +2178,7 @@ static int ice_ptp_getcrosststamp(struct
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
 	struct ice_crosststamp_ctx ctx = {
+		.snapshot_clock_id = cts->clock_id,
 		.pf = pf,
 	};
 


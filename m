Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482B13AD51C;
	Fri, 29 May 2026 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084812; cv=none; b=dTtJh546ZKiCihy+Flz2x27f+6BE5GGvK5OnkBhQQWvbopDpoVIuZraBEdYCOa7hCHa00uJIFF3Id3sNVqLcHFOYxcl8Z0PUCroQoNVAhMHXC5w0r8+qFbvj9pLx1qKmCo3FosvEnBDD6JkXhgFgVkkUnHtbcBQY2GtaQ9kbHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084812; c=relaxed/simple;
	bh=Ex1XQFbZNFKU6Xzfmk5of25W7XKdOWloO7UTZAd8MHE=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=NCegV3L9WP1+tOeds8c3YGS8s3iuPWDlNU8JUeBPrJ+IEyVI6kAWYs6C6EC4wsJQ2L8Zyxrwh1zVqxbJDrW1f4BkuHHKPl28lU6ZgBABvFv88/ukBQR6Jzpo2NHM8valpy8FwiqloOVQbqfbligccDRdvTLTK+hzXFFNd/YcTdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9qS2kmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9qS2kmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265DB1F00898;
	Fri, 29 May 2026 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084810;
	bh=zOPiszdYJq77106tNJH6ojssvXhvas5wabWXLdkaJzY=;
	h=Date:From:To:Cc:Subject:References;
	b=h9qS2kmQPZrAogp4T/OlxkJivZEwJDQE/rH2E2uErnV2gtDzboyrV+916JED18FkV
	 FyAS/O/mAgccp4AYWGuC1P6/3WnGp0MX643ewe7axJO+6o5CZ8c9GXS9R+jVJM64qR
	 zS8smnYhFnP44BQiISF+z6vfks+p02nqW0KSdJ3MsR1CkRjDtxABj7Da7gI3qPSwiV
	 qkBsVOwGzR623BYo4h+GtYVmJFldJUbXeNBMaTRJ0yDP1NTitcUdbd7afTJ+TAgvIh
	 m2ZrEOVW7EhZtKJK8SO45MJWuehEXb3a6s/fl5YKtuWQNrT0S2jIlt3F/EHVmWcYZt
	 7az/58u9WVNbw==
Date: Fri, 29 May 2026 22:00:08 +0200
Message-ID: <20260529195557.174373054@kernel.org>
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
Subject: [patch V2 05/25] KVM: arm64: Use ktime_get_snapshot_id() to retrieve
 CLOCK_BOOTTIME
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

ktime_get_snapshot() is replaced by ktime_get_snapshot_id() which allows to
request a particular CLOCK ID to be captured along with the clocksource
counter.

Convert the tracing mechanism over and use the new
system_time_snapshot::systime field, which holds the system timestamp
selected by the CLOCK ID argument.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp_trace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -51,8 +51,8 @@ static void __hyp_clock_work(struct work
 
 	hyp_clock = container_of(dwork, struct hyp_trace_clock, work);
 
-	ktime_get_snapshot(&snap);
-	boot = ktime_to_ns(snap.boot);
+	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
+	boot = ktime_to_ns(snap.systime);
 
 	delta_boot = boot - hyp_clock->boot;
 	delta_cycles = snap.cycles - hyp_clock->cycles;
@@ -118,9 +118,9 @@ static void hyp_trace_clock_enable(struc
 		hyp_clock->running = false;
 	}
 
-	ktime_get_snapshot(&snap);
+	ktime_get_snapshot_id(&snap, CLOCK_BOOTTIME);
 
-	hyp_clock->boot = ktime_to_ns(snap.boot);
+	hyp_clock->boot = ktime_to_ns(snap.systime);
 	hyp_clock->cycles = snap.cycles;
 	hyp_clock->mult = 0;
 


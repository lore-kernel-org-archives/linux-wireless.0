Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216B13D53C;
	Fri, 29 May 2026 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084808; cv=none; b=OVu/d9U5s+dCfkeBS8juBq4pj0vs7VME5caOpAwM2uQPuD/IQ5nqMByZGeOYCZsTpNEsxwDLFzDNeUkLy4XE0RpX7YixBJgi3Csi6+s6aSO3HZjErToyBfWkCAeYF/nOITHZHk1ONLrgOhIGmWS0e2b9MZp/w7RdbxBpLey1Qwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084808; c=relaxed/simple;
	bh=XJUX+tjEQtHwQCzntIRA6mkrzAvneAW5LZZBYjXvEMM=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=GL9VXROkfP1z3ab9Ai95K3gws1yOCUk4lY+3jBbWLvHdGti0O4kfVDFwvoqJuPyO9BAauHK2jssH2eNoka/tqnWY0KfSeaVH6H6Br5R4CRFA3X+BmmzYuh1u8ZUStNs+m8LjYPTUFeXim9Z81mP84rhgBPrrTkVXwVV22NllnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEKjNpTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEKjNpTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D09D1F00893;
	Fri, 29 May 2026 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084806;
	bh=FZkyrSLm2T1xfbhjteZd4JlHM91F9x6V2go1S71X7K4=;
	h=Date:From:To:Cc:Subject:References;
	b=FEKjNpTFCsreN3iUN3UZ5kAGgqsqGfjw007m6Sb6Cv4IE5+XKsDMIsVuGdDltvWn1
	 zDG3IGek8g/P+U+DXmK0WxT6TTPBbXjmOjEzi5jNDmpdM9/e/lJ60s9l5GoXsa76Qr
	 Rpo1J0smny+ZqlTTRnmay6OCEncWY45zD/q+bVzX4wuVI/aK2aPhP5hw6TSRtxfG8n
	 0gXkA+qmxeMc6KOYTeYHGl/0KDz9zw7QmQBu7/rUHeG22uEhTcnqsKV2VtG4Z8eu5n
	 3+RiHBODxXlza9CTXigCCyXeoh7jpWoAWENC1ULzUyFpT5CVr8wa+7z3xAKFcDojoU
	 7RCrpE3lUh0xQ==
Date: Fri, 29 May 2026 22:00:04 +0200
Message-ID: <20260529195557.123410250@kernel.org>
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
Subject: [patch V2 04/25] pps: Convert to ktime_get_snapshot_id()
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

ktime_get_snapshot() resolves to ktime_get_snapshot_id(CLOCK_REALTIME).

Make it obvious in the code and convert the readout to use the
snapshot::systime and monoraw fields instead of snapshot::real and raw,
which aregoing away.

Similar to the PPS generators, avoid the more expensive snapshot when
CONFIG_NTP_PPS is disabled.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/linux/pps_kernel.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -99,12 +99,14 @@ static inline void timespec_to_pps_ktime
 
 static inline void pps_get_ts(struct pps_event_time *ts)
 {
+#ifdef CONFIG_NTP_PPS
 	struct system_time_snapshot snap;
 
-	ktime_get_snapshot(&snap);
-	ts->ts_real = ktime_to_timespec64(snap.real);
-#ifdef CONFIG_NTP_PPS
-	ts->ts_raw = ktime_to_timespec64(snap.raw);
+	ktime_get_snapshot_id(CLOCK_REALTIME, &snap);
+	ts->ts_real = ktime_to_timespec64(snap.systime);
+	ts->ts_raw = ktime_to_timespec64(snap.monoraw);
+#else
+	ktime_get_real_ts64(&ts->ts_real);
 #endif
 }
 


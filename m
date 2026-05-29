Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1980408007;
	Fri, 29 May 2026 20:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084803; cv=none; b=A9hgsV+g7zDoRuuLqMGz7pgr9diN2dW4dITl2hOXtIs1wuoY458h4OfMBiDI7+/t4CSCZ5F07twch+qwXMHVEVBLV0QdNCRa37if0LXhaL7KkpV34O2oD0cUb7oPx+QfGaT7HGhPbbpP7sTpyj5/LigM5M+XSiAgqZcQHf881Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084803; c=relaxed/simple;
	bh=5C7JwKG7kjwJuwdCXdvjxylr8WdCNnDRKLp6xdeCcTo=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=W4lW9VAwiZpckJKRVung0QNGwGGiEjzffadVu4BAFP3vkgabwQLq7KN0fk2GAuncgDvhZmx03MSx17CtUqOaLP/pqK9V81t7rFAwPjgXh742xOaJlfAE9+9V4EL+aDi+qw3c8Djtu6kAWhyd1Q9JmG926zTsC67AK6QwzIZSvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBkSZyRS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBkSZyRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F121F00893;
	Fri, 29 May 2026 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084802;
	bh=CCz9vCDQiGdUd064CtcsBTxQEA+gPKTgfhLTy+v7giw=;
	h=Date:From:To:Cc:Subject:References;
	b=CBkSZyRSECHyHhutRERBNQEPid1w1N5/ovCC/uRsJ9jpCNfHk22JuqW5oiVyezDd5
	 +xShcRXbqwV50ImT2CAWtZKmZNTbqZF7/S+4iym89JBKdz6P8eJu+q47zf2Wcp4fWM
	 KTWKLFpZRHS9jLRZPDHixQorVanyfo2uXC6Mllt41DEbevTiu+9tfaz5OAdv8bsaSI
	 XzHEODUnYZLlxmfmNjbQSHpU4c/Jxs48gQlBZ4N4yTXgxDtzSVZt//5SLoCHU8XdIh
	 ZpU8vKW9FMX2hul1U4izHQayY9qiXACl3D8pRvL54Na0uE8b8mQUNNHBUtepzqFFYz
	 anbqirMSoHmyQ==
Date: Fri, 29 May 2026 21:59:59 +0200
Message-ID: <20260529195557.074439049@kernel.org>
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
Subject: [patch V2 03/25] pps: generators: Use ktime_get_real_ts64() instead
 of ktime_get_snapshot()
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

There is no reason to use the more complex ktime_get_snapshot() for
retrieving CLOCK_REALTIME.

Just use ktime_get_real_ts64(), which avoids the extra timespec64
conversion as a bonus.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/pps/generators/pps_gen-dummy.c |    6 +-----
 drivers/pps/generators/pps_gen_tio.c   |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)
--- a/drivers/pps/generators/pps_gen-dummy.c
+++ b/drivers/pps/generators/pps_gen-dummy.c
@@ -39,11 +39,7 @@ static void pps_gen_ktimer_event(struct
 static int pps_gen_dummy_get_time(struct pps_gen_device *pps_gen,
 					struct timespec64 *time)
 {
-	struct system_time_snapshot snap;
-
-	ktime_get_snapshot(&snap);
-	*time = ktime_to_timespec64(snap.real);
-
+	ktime_get_real_ts64(time);
 	return 0;
 }
 
--- a/drivers/pps/generators/pps_gen_tio.c
+++ b/drivers/pps/generators/pps_gen_tio.c
@@ -189,11 +189,7 @@ static int pps_tio_gen_enable(struct pps
 static int pps_tio_get_time(struct pps_gen_device *pps_gen,
 			    struct timespec64 *time)
 {
-	struct system_time_snapshot snap;
-
-	ktime_get_snapshot(&snap);
-	*time = ktime_to_timespec64(snap.real);
-
+	ktime_get_real_ts64(time);
 	return 0;
 }
 


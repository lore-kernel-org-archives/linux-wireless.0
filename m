Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A15A403E99;
	Tue, 26 May 2026 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815692; cv=none; b=leRuXjcTM88QClggEVx3mcrGFelppFXN8tru5UnnIukmtoxOyk4APgGNAsfva62Ib8WcsCJnCQj/MWDyXos9K97cA/wF9rwxq0094tCeaMpWoPwYP/OxFQZAspgGK0UEzNft0bTRRLTu4sq9oYNjW4u9Q8mku8hY9VQGv7QwfX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815692; c=relaxed/simple;
	bh=Y8IXzMUomtrlwK38Q7O+Uaj3T9uEUrs8xtbBKTUcZUk=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=bL9RMPZrVOdOLwqu3vlgTeDV7UkUwU6OSKLFDOzllqheStVaaCeruCAcfrLDgYnn33EfBWBEfz+LzYqUH+pE1disrEdpHAnbUJl8ve53EmGV6kKkwrRp+RHujQq3+9bBtuGAeOXwFfParbZCs5G0S9IHj7lAQwKd9T3qsK+c4ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkDfevTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkDfevTY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F0FC1F000E9;
	Tue, 26 May 2026 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779815691;
	bh=51tug6a6FaLaxd2I+xCk3mWFTQm5O63L+L59ZG+fII0=;
	h=Date:From:To:Cc:Subject:References;
	b=gkDfevTY41dsIoa9JxJ2MLOX8gXyCV3hS3Ud9hg+NxybSAIIJRaaUXs45noG50E7f
	 IzjbiWKMlvzkFZB2pXRDon0qCbSM0FYd2d1GP7aner0ZQ7wr60YlQw9NOyyxPMn4Q5
	 +M7NMep/nG+YO7NH04T4LmsQRwI2ixuhMo29LcyrEjkc480aGZkezQ2P9ieElq4Oa2
	 TCOs/Sz9nqziL+8EZh359uUSyUkKYO6EO08u7SwXmFAG+zTnmInTJD9fGDX47S+lUv
	 CI8juvZtxqAYEgg+EnAhcY60uosYehO1USDSt8/iamAW9+aKECAn6wqt4bVFIiGl35
	 5uqolx94e+NWg==
Date: Tue, 26 May 2026 19:14:47 +0200
Message-ID: <20260526171223.901103717@kernel.org>
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
 Peter Hilber <peter.hilber@oss.qualcomm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev,
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
 linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: [patch 16/24] virtio_rtc: Use provided clock ID for history snapshot
References: <20260526165826.392227559@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The PTP core indicates in system_device_crosststamp::clock_id the clock ID
for which the system time stamp should be taken. That allows to utilize
hardware timestamps with e.g. AUX clocks.

Use ktime_get_snapshot_id() and hand the provided clock ID in.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Hilber <peter.hilber@oss.qualcomm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev
---
 drivers/virtio/virtio_rtc_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_rtc_ptp.c
+++ b/drivers/virtio/virtio_rtc_ptp.c
@@ -139,7 +139,7 @@ static int viortc_ptp_getcrosststamp(str
 	if (ret)
 		return ret;
 
-	ktime_get_snapshot(&history_begin);
+	ktime_get_snapshot_id(&history_begin, xtstamp->clock_id);
 	if (history_begin.cs_id != cs_id)
 		return -EOPNOTSUPP;
 


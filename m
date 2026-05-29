Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7BC3A3E91;
	Fri, 29 May 2026 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084880; cv=none; b=GlrWMomIBBIPbI4Ost3ez53hgHi2vhEqSjl/JTebDVh9W+ZhxCUduqX3A4pMolEy+l9Alv0gZBMIHgWaM12bDunZxvOfblyg+iHx2BlrZUX95dwnJuEZ2jKzTeBM7mZaeN966Uisn8qReyeRk3Cnbz/z72AzaIxjAoQ8Oj6EpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084880; c=relaxed/simple;
	bh=wHAlmEXN0ywt5Hmh7D9uzXwqV7j+pKDkHzo7btXLNtk=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=UG8SOS5J3NGAm337xOaMdh3f/mls8R5rkVBOWAHIE0XvmsomvI28/Gs3RnKX8kQXBjdVmjaPXE06/pu6wLj3h2ugi3wnWxD9JaNygJJshoWmUx75nDz0B7E4KAD1o0zyIk4344ZELxEEs9zy/ESnPTl77j/963AgabPdt0w0Ujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+dS5X32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+dS5X32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAD71F00893;
	Fri, 29 May 2026 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780084879;
	bh=sSsi+8YGKOmRj+8oQCNXvfFYdFW+lcIqMKaVUJeLWKE=;
	h=Date:From:To:Cc:Subject:References;
	b=Z+dS5X32cEj67uOjjn6FExCB6tfShFzWNGLLFJ2W9aExAqOdQesA4AeSqtjf5hf9A
	 pY39pAv3cCWWeDWda/uKPxxk1b0qUjk5S+EREeilC7N2gpJaohRCNnrZX1KHil/Zgq
	 ZmDCurDxZbySnzlCqU4ARX12aDyZ/C6F3hOJ8OvvxMD8bc2qw09mUO8lp6lq8U0p1+
	 5m1A4qsUADAQLva/C0Xn6lYCKEz+SQPpq8yKEvyISKo7HvoTszi2gfIeyZcM3siCMY
	 MfyC8q4u1cRXLW8FImaUwc6GJTbvepeSnHiIqkllOUcPz4o3iJfS7PWKYrVz0w4EiZ
	 Kl3i7Opfvt2Lg==
Date: Fri, 29 May 2026 22:01:17 +0200
Message-ID: <20260529195558.046694580@kernel.org>
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
Subject: [patch V2 22/25] timekeeping: Remove
 system_device_crosststamp::sys_realtime
References: <20260529193435.921555544@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

All users are converted to sys_systime.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/linux/timekeeping.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -318,7 +318,6 @@ struct system_counterval_t {
  * @clock_id:		System time Clock ID to capture
  * @device:		Device time
  * @sys_counter:	Clocksource counter value simultaneous with device time
- * @sys_realtime:	Realtime simultaneous with device time
  * @sys_systime:	System time for @clock_id
  * @sys_monoraw:	Monotonic raw simultaneous with device time
  */
@@ -326,11 +325,7 @@ struct system_device_crosststamp {
 	clockid_t			clock_id;
 	ktime_t				device;
 	struct system_counterval_t	sys_counter;
-	union {
-		/* realtime goes away once all users are converted */
-		ktime_t			sys_realtime;
-		ktime_t			sys_systime;
-	};
+	ktime_t				sys_systime;
 	ktime_t				sys_monoraw;
 };
 




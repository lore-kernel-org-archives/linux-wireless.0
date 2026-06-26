Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338537B020;
	Fri, 26 Jun 2026 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487076; cv=none; b=kbKu3HXbMD7tJDgkFOy4Z/sZ9n47wm41RJ0GA75mSqJpsL3ackf4ju99qsbwrZxU5GMK4LLvZh9HL7xaEY7DmU5qTILIJBAmo8hznuujBHVJC2BSnDsO/aoAPgePXj+gDWoVJq6ZP4wTIc+A+bLi7DezcMcFu8m8FlaeSxX7ges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487076; c=relaxed/simple;
	bh=+2WMSpeYQauY3ayqAWmihAgxFm5GiuL3JVnsZFr/NDM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f+w5t6OSNUV4w9D96tZ169AzQSTcg+5ehML59ansUStTHIlAPlwi0w9nnqvWdP3lTCsV7sriFremSc4dmkVL9VzbjBBxaEC7n2JUvFUv/+k0Ik5/QsEgkLy1lJX6hcA8CVQRFhuYmiIY/LUHFVguauMVHLygO/QxEFDf9VsLbRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNDxtU8y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNDxtU8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5531F000E9;
	Fri, 26 Jun 2026 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782487075;
	bh=JkUVs+kU43zS2CPMfq3q5ID+5rkKg3CG5Y2R5GSNDYM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=WNDxtU8yHc2NVDKr01ddEY4wTI1nZFABN1wZqtcq8gJ3HLwowFBdSSRf13AvQ6+AK
	 KrUPVgy5zp+5DbFIV9NYl+F1JqOc1G55tLbOPBhnBQzK1R6UFqBIsmqNNwR/2ed+RS
	 93CpYL0hJ5pDCDa3FjX41wu4KnsvHEVo/5vO46UuwWtnOMPlWBvHarRbQAVe0T6seO
	 DAhRi4rEArIi1MX+Dc0gAF3VnI7yDW5mkwDeC0TAdk62Nz+16DO7c4JKLXFjGVlCMX
	 L1sb1Oe8QYroTWv2Bs2Eq20hSysa77IDKHYDXZ0fvWCjzR8uiN7xcVqDE/XcrJE1VV
	 k3ifRTCUaO0Rw==
From: Thomas Gleixner <tglx@kernel.org>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse
 <dwmw2@infradead.org>, Miroslav Lichvar <mlichvar@redhat.com>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>,
 Arthur Kiyanovski <akiyano@amazon.com>, Rodolfo Giometti
 <giometti@enneenne.com>, Vincent Donnefort <vdonnefort@google.com>, Marc
 Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, Richard Cochran
 <richardcochran@gmail.com>, netdev@vger.kernel.org, Takashi Iwai
 <tiwai@suse.com>, Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 Johannes Berg <johannes.berg@intel.com>, Jacob Keller
 <jacob.e.keller@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Peter Hilber
 <peter.hilber@oss.qualcomm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev, linux-wireless@vger.kernel.org,
 linux-sound@vger.kernel.org
Subject: Re: [patch 09/24] timekeeping: Add CLOCK_AUX support for
 ktime_get_snapshot_id()
In-Reply-To: <20260626125819-d8b197fc-7671-4d12-a578-9025affc52d9@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.374814973@kernel.org>
 <20260626103359-66ab2b54-d36f-416b-94a4-3f3708dccced@linutronix.de>
 <87echtk24a.ffs@fw13>
 <20260626125819-d8b197fc-7671-4d12-a578-9025affc52d9@linutronix.de>
Date: Fri, 26 Jun 2026 17:17:52 +0200
Message-ID: <87fr29ib4v.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26 2026 at 13:03, Thomas Wei=C3=9Fschuh wrote:
> On Fri, Jun 26, 2026 at 12:49:41PM +0200, Thomas Gleixner wrote:
>> On Fri, Jun 26 2026 at 10:48, Thomas Wei=C3=9Fschuh wrote:
>> > On Tue, May 26, 2026 at 07:14:13PM +0200, Thomas Gleixner wrote:
>> > (...)
>> >
>> >>  static inline void tk_update_aux_offs(struct timekeeper *tk, ktime_t=
 offs)
>> >> @@ -1218,6 +1223,12 @@ bool ktime_get_snapshot_id(struct system
>> >>  		tkd =3D &tk_core;
>> >>  		offs =3D &tk_core.timekeeper.offs_boot;
>> >>  		break;
>> >> +	case CLOCK_AUX ... CLOCK_AUX_LAST:
>> >> +		tkd =3D aux_get_tk_data(clock_id);
>> >> +		if (!tkd)
>> >> +			return false;
>> >> +		offs =3D &tkd->timekeeper.offs_aux;
>> >> +		break;
>> >
>> > 'tkd' is also used to compute 'monoraw'. However 'tkr_raw' and 'tkr_mo=
no'
>> > are the same for auxilary clocks, so this will compute a wrong 'monora=
w'.
>>=20
>> AUX clocks are independent in the first place and the MONORAW part is
>> the "MONORAW" related to the AUX clock itself.=20
>>=20
>> > Instead 'monoraw' should be computed based on 'tk_core'.
>> > Which then also requires the sequence locking of 'tk_core'.
>>=20
>> No. From a PTP and steering point of view you want the "raw" value which
>> is related to the AUX clock itself and not the global one.
>
> Ack.
>
> However the kdocs call it 'CLOCK_MONOTONIC_RAW'. Can we clean this up?

Yes. Something like the below?

Thanks,

        tglx
---
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1202,10 +1202,21 @@ static inline u64 tk_clock_read_snapshot
=20
 /**
  * ktime_get_snapshot_id -  Simultaneously snapshot a given clock ID with
- *			    CLOCK_MONOTONIC_RAW and the underlying
+ *			    the corresponding monotonic raw the underlying
  *			    clocksource counter value.
  * @clock_id:		The clock ID to snapshot
  * @systime_snapshot:	Pointer to struct receiving the system time snapshot
+ *
+ * For the system time keeping clocks (REALTIME, MONOTONIC and BOOTTIME) t=
he
+ * monotonic raw clock is CLOCK_MONOTONIC_RAW. For AUX clocks this is the
+ * monotonic raw clock related to the AUX clock. These AUX clock related
+ * monotonic raw clocks have a strict linear offset to the system time
+ * CLOCK_MONOTONIC_RAW:
+ *
+ *	MONOTONIC_RAW(AUX$N) =3D CLOCK_MONOTONIC_RAW(system) + offset(AUX$N)
+ *
+ * The offset is established when a AUX clock is initialized, but it is
+ * currently not accessible.
  */
 void ktime_get_snapshot_id(clockid_t clock_id, struct system_time_snapshot=
 *systime_snapshot)
 {
@@ -1512,6 +1523,9 @@ EXPORT_SYMBOL_GPL(ktime_real_to_base_clo
  * @xtstamp:		Receives simultaneously captured system and device time
  *
  * Reads a timestamp from a device and correlates it to system time
+ *
+ * See documentation for ktime_get_snapshot_id() for information about the=
 raw
+ * monotonic time stamp which is used here.
  */
 int get_device_system_crosststamp(int (*get_time_fn)
 				  (ktime_t *device_time,


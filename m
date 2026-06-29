Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D33932F7;
	Mon, 29 Jun 2026 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782722373; cv=none; b=MdLMRKqNfqnW2gzooSgvUOIg2tMftwdc+caUyQb000X9GD5uXT0Hi+RU+EaoKmICYH3RosdbnIpYJPOErG1l3TcjUZVGZaLOnxgbqXuuOL92KA3L7sQkHC7IvabkOhBHclt8qzttOkaTsP7kPzx8sifLr3RvXhuXLYBXRzNn5M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782722373; c=relaxed/simple;
	bh=c4sIW5ycgpKIzndr7OBsugpKjXxHJyhKvNXgVBgHeU4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LFy8mFWRDuEQS6JACV50YjB7neu0+Zbt4F0q2ffy7yPMDLqFFtSvXdWQjB/I2i+Zk4uH8APkb8jfZoCQZOIryD+us4Yni7GAj2RyR1AdELeGZZ3Bw5mV5zXsaunY9rzBOh9Q/Q7dBgzBcX7pPDwgXhq70o4RUrclAEkkvRmuu/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0jrwcN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0jrwcN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D224C1F000E9;
	Mon, 29 Jun 2026 08:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782722372;
	bh=lq5LQ9JJIDNlCaG6JOmQhcLy406DV5gppuzq/19j6u4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=g0jrwcN7FicUiZjmTdmUTBj9Jd6bDziwdyJEXWr9dwXtodAHHfT4gyhX90rCOLzMG
	 LZ/WbKKfW/llBWAnPUID5vrxbWnIsEMzfnmmGlddoEw07yl0+kN0xTCAnYFMAM1lgw
	 VfQZ+UddMWjc14ffDQM+l63bdsgK0VxxksGsknHAOJfI4QtBSUKewhoH7Zg50oam7D
	 BqB5DEpDacVIFF3iKVxhOclY55m87G0cONuxRo9/FtK7dRlsqIymFhcCpQ6mQGksTH
	 q0ZAahQkgb57Le0NwhxkQtp0csuXF43ZGmnQ3v0UfdtZvb8F5+QwwU8dDaVVxRiAnh
	 0/tWhLjmKBD7Q==
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
In-Reply-To: <20260629055344-b74c43de-2a2b-4608-ae4e-ed0ac8e12fd1@linutronix.de>
References: <20260526165826.392227559@kernel.org>
 <20260526171223.374814973@kernel.org>
 <20260626103359-66ab2b54-d36f-416b-94a4-3f3708dccced@linutronix.de>
 <87echtk24a.ffs@fw13>
 <20260626125819-d8b197fc-7671-4d12-a578-9025affc52d9@linutronix.de>
 <87fr29ib4v.ffs@fw13>
 <20260629055344-b74c43de-2a2b-4608-ae4e-ed0ac8e12fd1@linutronix.de>
Date: Mon, 29 Jun 2026 10:39:26 +0200
Message-ID: <87bjctsptt.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29 2026 at 05:55, Thomas Wei=C3=9Fschuh wrote:
> On Fri, Jun 26, 2026 at 05:17:52PM +0200, Thomas Gleixner wrote:
>> On Fri, Jun 26 2026 at 13:03, Thomas Wei=C3=9Fschuh wrote:
>> > On Fri, Jun 26, 2026 at 12:49:41PM +0200, Thomas Gleixner wrote:
>> >> On Fri, Jun 26 2026 at 10:48, Thomas Wei=C3=9Fschuh wrote:
>> >> > On Tue, May 26, 2026 at 07:14:13PM +0200, Thomas Gleixner wrote:
>> >> > (...)
>> >> >
>> >> >>  static inline void tk_update_aux_offs(struct timekeeper *tk, ktim=
e_t offs)
>> >> >> @@ -1218,6 +1223,12 @@ bool ktime_get_snapshot_id(struct system
>> >> >>  		tkd =3D &tk_core;
>> >> >>  		offs =3D &tk_core.timekeeper.offs_boot;
>> >> >>  		break;
>> >> >> +	case CLOCK_AUX ... CLOCK_AUX_LAST:
>> >> >> +		tkd =3D aux_get_tk_data(clock_id);
>> >> >> +		if (!tkd)
>> >> >> +			return false;
>> >> >> +		offs =3D &tkd->timekeeper.offs_aux;
>> >> >> +		break;
>> >> >
>> >> > 'tkd' is also used to compute 'monoraw'. However 'tkr_raw' and 'tkr=
_mono'
>> >> > are the same for auxilary clocks, so this will compute a wrong 'mon=
oraw'.
>> >>=20
>> >> AUX clocks are independent in the first place and the MONORAW part is
>> >> the "MONORAW" related to the AUX clock itself.=20
>> >>=20
>> >> > Instead 'monoraw' should be computed based on 'tk_core'.
>> >> > Which then also requires the sequence locking of 'tk_core'.
>> >>=20
>> >> No. From a PTP and steering point of view you want the "raw" value wh=
ich
>> >> is related to the AUX clock itself and not the global one.
>> >
>> > Ack.
>> >
>> > However the kdocs call it 'CLOCK_MONOTONIC_RAW'. Can we clean this up?
>>=20
>> Yes. Something like the below?
>
> Looks good, thanks.
> The corresponding structure definitions are a also affected, though.

True.

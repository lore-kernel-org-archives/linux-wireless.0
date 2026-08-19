Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5D4028CA
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787130193; cv=none; b=W3IHA4NNJUL59TLa00lpo+ar0T8yWMea9RMSoNva/GrU+0dBap2lfF+bAcRz6GPrDfmL68iZP+yUaN69LAs2ROHxoQmgV6DN57KHf+r/VpaLuBLzuqz9BFyupYKva++BQbLVKNp9WTwxlOW7F0UoRy5mJylTv6eJEZxkA1KYQ0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787130193; c=relaxed/simple;
	bh=V56WzWd2EHf/12E6ECIaHQNoiEpF3J1G/bBOD5bzeTU=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=ESl6+MQ1gb42e2v1Cnu89kYV93SyU9ADoyPofLL9kHZDgDKi7K7NwpQP4Up6zTnXSQqKjlA7AHvnLdBvHY/oShBw0HGAwAnWQtGr/mclP+ASBLHh9UcpIj+ibdIZBMUbn7VdXqbLfvBcppnklzMbo9LMjRWW/9b/jWTdpJ/+pps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=mF4gVczD; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="mF4gVczD"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 8860F240104
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:03:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1787130188;
	bh=V56WzWd2EHf/12E6ECIaHQNoiEpF3J1G/bBOD5bzeTU=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=mF4gVczDmFwyoB6Ak5G9k8Eza7d3mn8ITzzbcuQDDxXegVQI6bxRObsE3TneFQ2ZH
	 hdURX8Cblw9oelo1b7kZnvZ0kA25tlb8Qg++t/hJsFEcUrgf12x06XcpZ9pgmtXXyb
	 jt6fxzZIBMvN3WlfRTeYh8PDMZUs3Ja0jKpW3/9BkXAVXUrjy7ygeuHrpKFFK8pyJP
	 2cThQDOmEFInzlw/XL6dsuKbtNPD1Ta9j/1xgnIc4Us8PnPszVN5NIF/3l50fqv2x3
	 3fXET8hT803bPpfShLW/5T2mmFJdRamyc7I3JuSg4JCDulHe3y2IJojYdAJjEFaaEk
	 JlWSqeNMcjcGg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hQ0wB6xF9z9rxF;
	Wed, 19 Aug 2026 11:03:06 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:03:08 +0000
From: Jonas Hort <jonas.hort@posteo.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, lorenzo.bianconi83@gmail.com
Message-ID: <49643be3-43e5-41f8-9ed7-689269adc7d4@posteo.de>
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <49643be3-43e5-41f8-9ed7-689269adc7d4@posteo.de>

Thanks for the detailed breakdown.

I'll build v7.0 vanilla and test it, as suggested. Fair warning
though: I'm on vacation this week, so I'll pick this up next week.
I've also never compiled a kernel before, so it'll likely take me a
bit of trial and error the first time around - please bear with me
if it takes a little longer than expected.

Will report back once I have results.

Thanks again,
Jonas

19.08.2026 03:18:34 Devin Wittmayer <lucid_duck@justthetip.ca>:

> Thank you very much, that answers both things.
>=20
> The ROC tracing is the more useful of the two even though it came back
> negative. Two of the three freezes have no ROC activity in them at all, s=
o a
> link switch that never finished cannot be what starts this. The middle on=
e
> does have rocabort, mloroc and rocwork in it, but one out of three makes
> that look like the exception rather than the pattern. So the area I sent =
you
> looking at is out, and that is worth knowing before you spend nights on
> builds.
>=20
> One other thing worth saying first. There is a five patch mt76 series on =
the
> list at the moment and two of the patches look like they were written for
> exactly this bug. I do not think they were, and it is your own numbers th=
at
> show it. The failure 4/5 fixes stops mt76_txq_schedule_list from servicin=
g
> the queue, and the one 5/5 fixes stops mt76_txq_send_burst once the non-A=
QL
> count reaches its cap. Both of those keep frames from ever reaching the
> hardware, so if either were your problem head would be sitting still
> alongside tail. Yours does the opposite. Head climbs 390 to 408 while tai=
l
> stays at 260, so the frames are getting into the ring and nothing is
> finishing them, which is the far end of the same path. 2/5 is a use after
> free when an interface goes away, so it does not fit either. I would not
> expect that series to change what you see.
>=20
> On the bisect I would build v7.0 next. There are 32 mt7925 commits betwee=
n
> 7.0 and 7.1 and 19 of them are one run of work from Sean Wang, reworking =
how
> the driver tracks the per link mlink and WCID for an MLO station. That is
> the kind of change that fits a bug only showing up with two links up. If
> v7.0 comes back clean, that series is where I would look. If v7.0 is alre=
ady
> broken then it is off the hook and 6.19 becomes the next split. The mt76
> core and mac80211 both moved in the same window, so mt7925 is where I wou=
ld
> look first rather than the only place worth looking.
>=20
> Devin
>=20
> Am 17.08.26 um 23:34 schrieb Jonas Hort:
>=20
>> Quick follow-up: managed to confirm 6.18 as a clean baseline on my
>> own hardware now (not just secondhand from others in the forum
>> thread) - running Linux 6.18.42-1-cachyos-lts with MLO active
>> (5GHz+6GHz, same FritzBox 5690 Pro) for 3 hours straight, no freeze
>> at all.
>=20
> Am 17.08.26 um 16:25 schrieb Jonas Hort:
>=20
>> One correction to how I described this earlier: the connection does
>> NOT reliably self-heal on its own. I have manually intervened every
>> single time to restore connectivity [...]
>>=20
>> Update on the ROC tracing: three real freezes captured now with the
>> kprobes active (all confirmed via the WFDMA0 tail-frozen signature).
>>=20
>> - Freeze #1 (15:37): no ROC activity in the trace.
>> - Freeze #2 (15:43): [...] The trace shows several ROC events
>> =C2=A0 (rocabort, mloroc, rocwork) clustered together.
>> - Freeze #3 (16:15): no ROC activity again.
>>=20
>> Uploaded all three logs to the bugzilla ticket if useful:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D221884

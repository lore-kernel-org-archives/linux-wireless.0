Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633AB408039
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787130237; cv=none; b=enjRSFtoIsHf98D2FnwWCWoazO/uukjpeBqmSHyEapNKYUGfepnMxCvBS6MzCF3yw0ys67iTOHaSt9f1jvukx00Ao4Tw77opuEieMMD3RfA5d8Q6ZSwOax4Me9Nq6WJ/k3utLaYnYftRrvHLHcIU6lu6WYfVjSNNndNA0pwi4Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787130237; c=relaxed/simple;
	bh=V56WzWd2EHf/12E6ECIaHQNoiEpF3J1G/bBOD5bzeTU=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=LivNN+JIbCVhi1TaXyrn9oF1RggUCfeg5TpnsYPq/QVW9OxBCimGejz3hKU/dmfZlK7PQSK5BWXAfkcKlytFquMQ74Nt4kXppAJFk03LIXuuDo1mKKOnZ/JKk+V7BnITPNsGGc6N7oqkj/r6Q4H9MEcTTOJVUEYXdxne+Jw6hQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=f5cd3Qy4; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="f5cd3Qy4"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 5389A240101
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1787130233;
	bh=V56WzWd2EHf/12E6ECIaHQNoiEpF3J1G/bBOD5bzeTU=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=f5cd3Qy4JAkD4Rn6z7kfMbIDVtFIT9rkcKeixVt1A7e85NV5/I4FnFmkS4+T9wm5d
	 CMpqq+6/XRLtu90eAGRy6uZkgDQQ3/UTZku8c8wc3NYEMmCJsARCcsPzDOhkbEv/tD
	 p/UHdhsqaXOFBdUwFeaC0H+5rRPcbam/0CC71ybTd8kteZcLhut6p2mgJRTugYXsoI
	 Vtt7qzoH2X56ylM0dGDYfpfgcTndQIRZ81CSnY+mSCwHWAIj4sX2FXOfHT+iFrVyny
	 AvU+oeMFcVY4/eQ3yesvXHBpZiePpisLeLxvTcoEcZNS5Uu8skn3esUZWkGRegSdyC
	 zRsKw49zSy2tg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hQ0x40ypQz9rxG;
	Wed, 19 Aug 2026 11:03:52 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:03:53 +0000
From: Jonas Hort <jonas.hort@posteo.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, lorenzo.bianconi83@gmail.com
Message-ID: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de>
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
X-Correlation-ID: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de>

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

Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B7D5427E3
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788872192; cv=none; b=bqN3pxV6bDzobGG/plF5TUh3ufpiQ2CNwncwTNjDwGP6Vd5zS8rMaxofnpdgZwqjh0eYU+LvoSpw34V2+o5juJneUgTydcYlJFfm/+/E3RCF8lLty828nqBYP3aD1eAJVTHxUSRYDtaUJyohUoBP1sgIEXUlH4RBXUhoq9N8uIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788872192; c=relaxed/simple;
	bh=dvxoYrFwANfOfAGdF2meKaNS1goS1wQOzWzhG5OqaTc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=sIYtCz4UKMkcaaw2aogHFVgId/FZT507rVVif4eZfl/tdC1ucuOyQClIrgTVQ9oV3hz2vnlqSYV9jy3aCL/dcilcT1KoHNwUhEq3A4+t+xRHWzFKnsykNImqgL3sfqTW4cHYsf7wDVuTRYEIq407HgDCs0cxG2bd/97ro+JOqto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RJSHWLnv; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RJSHWLnv"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dvxoYrFwANfOfAGdF2meKaNS1goS1wQOzWzhG5OqaTc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788872185; v=1; x=1789476985;
 b=RJSHWLnv9cT87OKsH+d8QbrgTGsOWUaB6QPhJ1Fsdr0l7zyov3kv4iaYZoApmx+b6Wl/8Cqo
 qRGyEJCjPcffNu93DJyg85JgB3NLcbjMylzyXGcqG2hDoF/NBeRfBlwANz8I1gZtGEotgUCU2SZ
 dbomHxBDyfaargbI7s/LIGxQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6758adfd6373cdd;
	Tue, 08 Sep 2026 12:56:25 +0000
X-Mizu-Trace-ID: d6758adfd6373cdd
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 14:56:24 +0200
Message-Id: <DL9Y9KGJKWIT.26GHPWWWG0WFV@linux.dev>
Subject: Re: [PATCH v9 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "luka.gejak@linux.dev"
 <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Bitterblue Smith"
 <rtl8821cerfe2@gmail.com>, "Peter Robinson" <pbrobinson@gmail.com>, "Hans
 de Goede" <johannes.goede@oss.qualcomm.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260831061144.18631-1-luka.gejak@linux.dev>
 <20260831061144.18631-5-luka.gejak@linux.dev>
 <d4a8b1203ee0402483269a31ad4d6dd2@realtek.com>
In-Reply-To: <d4a8b1203ee0402483269a31ad4d6dd2@realtek.com>

On Sun Sep 6, 2026 at 4:22 AM CEST, Ping-Ke Shih wrote:
[...]
> If the __skb_padd() is necessary for original (generic) part, please
> add another patch to fix it. (see below comment)
[...]
> Why doesn't rtw_sdio_write_port_generic() need __skb_pad() as well?
> Is there an existing problem by original?

There is. rtw_sdio_write_port() rounds the transfer up with
sdio_align_size() and passes that length to sdio_memcpy_toio() while the
skb still holds only skb->len bytes, so between one and 511 bytes from
past the end of the frame get transmitted. Whether that stays inside the
skb's allocation depends on how much tailroom it happens to have.

It gets its own patch, no chip condition:

  wifi: rtw88: sdio: zero the padding added to a TX transfer

Which also answers the question the other way round: the RTL8723BS does
not need the padding for its own sake. I tested that rather than assume
it, with a local patch that transfers unpadded exactly as the generic
path does. Uplink is 20.9 to 21.1 Mbit/s unpadded against 19.5 to 19.8
padded, in an interleaved A/B in one session, and scans, reconnection
and a UDP flood are clean either way. So the padding is a correctness
fix that belongs in the shared path, and patch 4 no longer carries it.

There is an ordering point in that, which I would rather raise with you.
The separate fix patches rtw_sdio_write_port(), which after this series
is rtw_sdio_write_port_generic(), so it applies cleanly on top but only
covers the generic path. The RTL8723BS would then be the one part still
transmitting the padding unzeroed, which is not where I want to leave it.

The shared place is rtw_sdio_write_to_port(), which both paths call, but
that only exists once this series is in. So I plan to send it once this
series is applied, against that function, where a single patch covers
every SDIO part including this one and nothing here needs respinning.

There is one more thing. With the padding gone from patch 4, nothing on
that path returns -ENOMEM any more, so retrying it in patch 6 was dead
code and I removed it. If the padding fix is applied then -ENOMEM becomes
reachable again, for every chip, and that retry has to come back with it:
without it a stopped access category has nothing left to kick it.

> As we have sdio_set_block_size(sdio_func, RTW_SDIO_BLOCK_SIZE),
> can here use sdio_align_size() to get the writ_size?

Yes, and v10 does. I checked it is really the same rather than only
looking the same: on this card sdio_align_size() matches the open coded
rounding at the block boundaries, and over a full session it agreed on
every frame, 80000 of them with no difference.

It is equivalent because the card reports multi block support and a 512
byte block size, which puts the byte mode limit at 512. Without those
two properties sdio_align_size() falls into chunked byte transfers that
are not block multiples, so the equivalence is a property of this card
and host rather than something unconditional. It is still the right call:
it is the core helper and it is what the generic path already uses.

> I think write_size must be large or equal to skb->len, right?
> Therefore, declare size_t pad_size at top of function, and then
[...]
> I think this is easier to read.

You are right that it can never be negative. The whole block is gone in
v10 with the padding, so the question does not arise any more, but it
would have been the better shape.

> In this patchset, you add many comments. Please review them across whole
> patchset to see if they actually need. Like this one, do you think the co=
de
> can't explain itself?

I went through the series and removed redundant comments: v10 adds 62 comme=
nt
lines where v9 added 103.

What I kept is the things the code cannot show: which page pool a queue
draws from and how that was measured on hardware, why the counters are
atomic_t, why only the defined interrupt status bits are acknowledged,
and the two places where an skb has already been handed on and must not
be touched. Two more are there because they were asked for in earlier
review: the comment in patch 2 and the mod_delayed_work() one in patch 6.
Say the word if any of those should go too.

Best regards,
Luka Gejak

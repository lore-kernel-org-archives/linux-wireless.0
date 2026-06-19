Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D8372062;
	Fri, 19 Jun 2026 10:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781864621; cv=none; b=sTotAwJ4ZtLvkS8ot0UpxHbDWpn1aLpx7vczpg1QjstsRcaUmM5V2VR2hynj/L8HC1M3FjHhr70cV3unrBpOPIULCH6nOBbuK8EBgNeikB0762hwtj/aoVoN6LCXMfoWK6EIw7AK4uYneYezJF8mUrb1zaCGBijuaNDbqEPct8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781864621; c=relaxed/simple;
	bh=rlU6Fsomk54zDs8xzYXnvQ05msPTbxPCvks7+J7sqN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IAxMGgH8xZdkgnshsM7zlwNmIbvUufwo/OQ3CWLTeThlhQLciIDFwhJeXG3t17UR0tTwXV44HWNln4O2ZG19tjx+8uIX+7RjFgVPp7klu/+Odg7w+kS2481FI35S0To8rEpLT/jArwmQuHzNCP0XkHwpz3VtuvRB1h+tFgFvG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, Rosen Penev <rosenp@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, open list
 <linux-kernel@vger.kernel.org>, "open list:CLANG/LLVM BUILD
 SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Subject: Re: [PATCH ath-next] ath9k: eeprom: alias vpdTableI onto vpdTableL
 to shrink stack frame
In-Reply-To: <DJCF38062Q69.1WQ853JSRMFQ9@gmail.com>
References: <20260617234105.284358-1-rosenp@gmail.com>
 <87pl1ofa6t.fsf@toke.dk> <DJCF38062Q69.1WQ853JSRMFQ9@gmail.com>
Date: Fri, 19 Jun 2026 12:23:26 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878q8ag76p.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Rosen Penev" <rosenp@gmail.com> writes:

> On Thu Jun 18, 2026 at 2:51 AM PDT, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> Rosen Penev <rosenp@gmail.com> writes:
>>
>>> vpdTableL, vpdTableR, and vpdTableI are never live simultaneously.
>>> vpdTableL and vpdTableR are consumed during the frequency-interpolation
>>> step that writes vpdTableI; after the if/else they are never read
>>> again.  Reuse vpdTableL for the interpolated result (what was
>>> vpdTableI), reducing the stack frame by one 256-byte array.
>>>
>>> The read-via-write in the else branch is safe: ath9k_hw_interpolate()
>>> receives vpdTableL[i][j] by value as a function argument before the
>>> return value is written back to vpdTableL[i][j].
>>>
>>> Stack frame size change (x86_64, clang):
>>>   before: 0x440 (1088 B)
>>>   after:  0x330 (816 B)
>>
>> Huh? These are static variables, how is this affecting stack usage?
>> I assume this is against your previous (broken) patch?
> It's only broken on ARM + GCC. GCC + anything else and Clang + anything
> else is fine.

That's still broken, though :)

>> Anyway, adding this kind of aliasing to fix a problem that you
>> introduced by changing working code with no real benefit is not an
>> improvement. I'm OK with fixing actual bugs, but this is just mindless
>> churn...
> Fixing actual bugs is the goal yes. It makes sense to split up into
> multiple parts IMO.

If you're fixing an actual bug, include that in the patch description,
and if it requires multiple patches include them in a series. Sending
these out of context patches that just shuffle code around is just
churn...

-Toke

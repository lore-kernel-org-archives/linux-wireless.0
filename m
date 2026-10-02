Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B8036B93C
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790962319; cv=none; b=fAV1WZmf02FESRBAkhp8YLlkRTZCneANzdzJBihaxbUcbwUAg35BH9ybZKF2UyFKnq3qbs2SIDFXe+qsL1jSAdiqE3RyvwoAWQB40LTvoRAMoJSQgGNnVQZdig7VeYwpc/PuDETYfrcnOcdeLAoei9Umov/NCaOWAnyMzL5idpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790962319; c=relaxed/simple;
	bh=MS4ZDGuvKjfwTzbHy9l4+euwKvvlpobjq9tTX69q7i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4cr7WyxD3SmaxhicRTW8ZJh8FFNLJ+FG58ooaSUsowA94M9QlUtVij0cIGNPbgn1fFUfTAZ5cPvy6NPT5FfZG023bK5Wh/xNu9EEJWpNqb/ezkwqKQb7BAKVKMNEGYyEqdNvbrqECyvOSbd0QmYDpexHxrGEj6IbPzetQPVVkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=Yo7jqArn; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="Yo7jqArn"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id ADB9A240103
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 19:31:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1790962315;
	bh=RVpkGJ1xxwLinZ+PqsTSo9xnvUSVxp77MIy/WKYmLyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:Content-Type:
	 Content-Transfer-Encoding:From;
	b=Yo7jqArnMBYJ7KtXMfzz996WdcYsoeysPeJs8tspFWd7Z4QgtnmOB7rxTjNqZjWWW
	 +g5NMznaMNDRpI61BOkLXhCS4mXLcD1i75i1XU10oVxFmNmTOpnMwuy7Jx97vb+VIf
	 I/VQAcwL+OfQ2PH1TEA6UaDyVM7z0YRs8FGO/xtH7ERtkKqRo0C/o+y/GnezMrQA1U
	 LYnn++DCZVIszMjyMFPRo58YM452mGVo3jyg+HFHvNryKgWPHR3ricww/YFWC7zb96
	 BZ6chLTnujFB5cltQPqbshz9eChz+rfr16etpGjdKrphCYj38B1NmNJfEipn2u72uE
	 3ieS1gKBWUJng==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hxG6x74FMz6txy;
	Fri,  2 Oct 2026 19:31:53 +0200 (CEST)
Message-ID: <d10ae529-968e-4cf8-bf28-b704755f124f@posteo.de>
Date: Fri, 02 Oct 2026 17:31:55 +0000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] mt7925: MLO connectivity silently stalls with 6GHz
 link active
To: Devin Wittmayer <lucid_duck@justthetip.ca>,
 Sean Wang <sean.wang@kernel.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sean Wang <sean.wang@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
 lorenzo.bianconi83@gmail.com, regressions@lists.linux.dev,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de>
 <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de>
 <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de>
 <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info>
 <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de>
 <20260829221319.25334-1-lucid_duck@justthetip.ca>
Content-Language: en-US, de-DE
From: Jonas Hort <jonas.hort@posteo.de>
In-Reply-To: <20260829221319.25334-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Friendly ping on this one - any news on the mt7925 MLO stall?

No pressure, I know everyone's busy. My setup is still in place, so
I'm happy to build and test patches or collect further traces if
that would help. Nothing has changed here: still reproducible with
the 5 GHz + 6 GHz pair.

Thanks for all the help so far.
Jonas

Am 30.08.26 um 00:13 schrieb Devin Wittmayer:
> On Mon, 2026-08-24 at 08:18 +0000, Jonas Hort wrote:
>> Setup is still up and I can build and test whatever is useful.
> Your bisect holds here, on a different machine and a different access
> point, running your June firmware. Three states, each replicated:
>
>    both commits reverted        clean, two runs of six minutes
>    only the later one reverted  stalls, two runs
>    neither reverted             stalls, three runs
>
> Tail welded and head climbing, which is your signature. The tree is
> 7.2-rc5 with one unrelated ACPI patch of mine, nowhere near this path.
>
> db134691924f lands fifteen commits after ff643b81bc38, and reverting it
> alone still stalls, so the builder rewrite is the one that matters.
> Reverting the builder on its own is not available either: v7.0's version
> dereferences a link pointer that the later commit leaves unpublished
> until after the firmware call, so it would need a check neither version
> has.
>
> A correction to my last message. I pointed you at the link count, since
> the new code reports one link whenever the update concerns the primary.
> That undercount is real but it's not the cause. Telling firmware one
> link always is clean over two six-minute runs. Skipping the
> undercounting update entirely, so firmware is never told anything wrong,
> stalls on both runs. Writing the entries in v7.0's order stalls on all
> three.
>
> On the August firmware, stock still stalls, twice, the detector firing
> 95 and 141 seconds into the run.
>
> The band pair matters. Same driver, same August firmware, two runs each:
>
>    5 GHz + 6 GHz     stalls
>    2.4 GHz + 5 GHz   clean, full duration
>    2.4 GHz + 6 GHz   clean, full duration
>
> Not the channel width. Narrowing the 5 GHz link to 40 MHz, so that pair
> carries the same narrow-plus-wide mix as the clean ones, still stalls on
> both runs.
>
> The sharpest pair there is the two runs where the iperf3 stream never
> established, leaving only the UDP pressure: 5 plus 6 stalled with the
> queue peaking at 187, and 2.4 plus 6 stayed clean at 186. The other
> three clean runs peaked above 1000.
>
> Sean, the two things I can't see from out here: what firmware does with
> a multi-link record naming one link while a second is associated, and
> why 5 plus 6 should differ from 2.4 plus 6.
>
> Jonas, thank you for the bisect. Five steps, every bad verdict confirmed
> on the queue signature.
>
> Devin

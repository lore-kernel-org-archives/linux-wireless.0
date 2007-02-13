Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:45818 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965447AbXBMBID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 20:08:03 -0500
Received: by py-out-1112.google.com with SMTP id a29so940235pyi
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2007 17:08:03 -0800 (PST)
Message-ID: <1ba2fa240702121708k29634cf0r8d8ab8e02bca8dfc@mail.gmail.com>
Date: Tue, 13 Feb 2007 03:08:03 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Cc: "Michael Buesch" <mb@bu3sch.de>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070213002849.GE16597@instant802.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702041344.19117.mb@bu3sch.de> <200702130023.53271.mb@bu3sch.de>
	 <1ba2fa240702121554v4e5b55b3t4582241f6347b355@mail.gmail.com>
	 <200702130110.02658.mb@bu3sch.de>
	 <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
	 <20070213002849.GE16597@instant802.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Jouni Malinen <jkm@devicescape.com> wrote:
> On Tue, Feb 13, 2007 at 02:19:15AM +0200, Tomas Winkler wrote:
>
> > For past packets you've already computed it so why do  it again? So
> > you keep 2 phas1 keys one old and one current. When sequence numbers
> > advance sufficiently you discard the old one and compute the new one
> > in a spare time. Something like double buffer.
>
> Well, you can, but how likely is this case to really happen? If someone
> can show this happening frequently, I could consider adding support for
> it, but I see not much point in adding the extra complexity without a
> clear case where this would be of benefit. P1K is not really that slow
> after all and figuring out when the kernel code has "spare time" and all
> the extra handling of pre-calculation and storing the values is not
> really something I would like to add into d80211 unless this can really
> be shown to provide noticeable throughput improvement.

There are real cases when this happens. Try to two different AC for
example  VoIP and have FTP in parallel.  Packets for low priority AC
can be stalled encrypted and scheduled in a AP TX queue while high
priority packets are already sent with the new key.
Maybe the new key can be computed on demand but it's good thing to
preserve the old key for while.


>
> > I didn't measured performance but I thought  it can be precomputed by
> > the supplicant rather then by kernel code.    I might be wrong.
>
> P1K is calculated by whoever is using the TKIP TK and in case of all the
> implementations that I'm aware of, this is not done in the supplicant.
> Sure, it could be done there, but I think the current design of doing
> all TKIP encryption/decryption (including phase 1 and 2 key derivation)
> in the kernel is better.
>
You might be correct here.
> --
> Jouni Malinen                                            PGP id EFC895FA
>

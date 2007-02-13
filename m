Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-68.dex002.intermedia.net ([64.78.20.34]:22077 "EHLO
	DHOST002-68.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030582AbXBMA2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 19:28:53 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 12 Feb 2007 16:28:49 -0800
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Message-ID: <20070213002849.GE16597@instant802.com>
References: <200702041344.19117.mb@bu3sch.de> <200702130023.53271.mb@bu3sch.de> <1ba2fa240702121554v4e5b55b3t4582241f6347b355@mail.gmail.com> <200702130110.02658.mb@bu3sch.de> <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 13, 2007 at 02:19:15AM +0200, Tomas Winkler wrote:

> For past packets you've already computed it so why do  it again? So
> you keep 2 phas1 keys one old and one current. When sequence numbers
> advance sufficiently you discard the old one and compute the new one
> in a spare time. Something like double buffer.

Well, you can, but how likely is this case to really happen? If someone
can show this happening frequently, I could consider adding support for
it, but I see not much point in adding the extra complexity without a
clear case where this would be of benefit. P1K is not really that slow
after all and figuring out when the kernel code has "spare time" and all
the extra handling of pre-calculation and storing the values is not
really something I would like to add into d80211 unless this can really
be shown to provide noticeable throughput improvement.

> I didn't measured performance but I thought  it can be precomputed by
> the supplicant rather then by kernel code.    I might be wrong.

P1K is calculated by whoever is using the TKIP TK and in case of all the
implementations that I'm aware of, this is not done in the supplicant.
Sure, it could be done there, but I think the current design of doing
all TKIP encryption/decryption (including phase 1 and 2 key derivation)
in the kernel is better.

-- 
Jouni Malinen                                            PGP id EFC895FA

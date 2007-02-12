Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-97.dex002.intermedia.net ([64.78.19.89]:32558 "EHLO
	DHOST002-97.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030516AbXBLXxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 18:53:47 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 12 Feb 2007 15:53:41 -0800
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Message-ID: <20070212235341.GD16597@instant802.com>
References: <200702041344.19117.mb@bu3sch.de> <20070212183020.GA16597@instant802.com> <200702122239.31778.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702122239.31778.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 12, 2007 at 10:39:31PM +0100, Michael Buesch wrote:

> What happens on RX when the iv32 wraps. Well, it simply won't decrypt
> the frame. What we must do then is upload a new key as fast as possible.
> The undecrypted frame can be either decrypted in SW (which I think d80211
> can do. At least with minor additional changes), or we drop it.

That "iv32 wrap" should have been "iv32 changes" (phase1 key changes
whenever iv16 changes, i.e., when iv32 is incremented by one). d80211
does indeed support software decryption for this case, so it is fine to
just pass the undecrypted frame up and marking it as such. This was
needed for some of the TKIP cases with Atheros.

> I started to implement an API to calculate the phase1 key on demand.
> It doesn't quite work, yet and I'm stuck in more important work
> that should be done before the d80211 merge, so it will take some time
> until I can continue debugging the stuff.

OK.

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-91.dex002.intermedia.net ([64.78.21.115]:33829 "EHLO
	dhost002-91.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965458AbXBMBUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 20:20:45 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 12 Feb 2007 17:20:41 -0800
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Message-ID: <20070213012041.GH16597@instant802.com>
References: <200702041344.19117.mb@bu3sch.de> <200702130023.53271.mb@bu3sch.de> <1ba2fa240702121554v4e5b55b3t4582241f6347b355@mail.gmail.com> <200702130110.02658.mb@bu3sch.de> <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com> <20070213002849.GE16597@instant802.com> <1ba2fa240702121708k29634cf0r8d8ab8e02bca8dfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240702121708k29634cf0r8d8ab8e02bca8dfc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 13, 2007 at 03:08:03AM +0200, Tomas Winkler wrote:

> There are real cases when this happens. Try to two different AC for
> example  VoIP and have FTP in parallel.  Packets for low priority AC
> can be stalled encrypted and scheduled in a AP TX queue while high
> priority packets are already sent with the new key.
> Maybe the new key can be computed on demand but it's good thing to
> preserve the old key for while.

I don't know the particular hardware design well enough to comment on
this, but d80211 software implementation keeps a separate RX P1K for
each AC (actually, each TID). In other words, this kind of issue does
not show up there. If the hardware implementation is limited to only one
P1K for RX, there may be some benefit on storing old keys in some cases,
but I'm not sure how that would work if the key has to be configured
before the frame is actually received.

In other words, in this case, the next frame after an FTP packet could
well be from voice and not background and reconfiguring the old P1K
value could have caused more latency on the higher priority frame at
this point.. In other word, if there is only one RX P1K, the benefits
for throughput may be requiring compromise on latency for higher
priority traffic and that may or may not be acceptable.

-- 
Jouni Malinen                                            PGP id EFC895FA

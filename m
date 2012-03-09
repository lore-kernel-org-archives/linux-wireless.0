Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2CIL2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 06:28:38 -0500
Subject: Re: [PATCH] mac80211: Limit TID buffering during BA session
 setup/teardown
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAJ-Vmomm9NKr6T_PczQ_eOq-so1b-=z1dSEPyjJr35ZNcag2XA@mail.gmail.com> (sfid-20120309_110227_120979_D2EF6FA3)
References: <1331137230-12430-1-git-send-email-helmut.schaa@googlemail.com>
	 <1331139615.3519.18.camel@jlt3.sipsolutions.net>
	 <CAGXE3d_fMnjyHJ7zkz53Dvv0eL+MKC6sDJwpvOQQrK+R=f2iBw@mail.gmail.com>
	 <CAJ-Vmomm9NKr6T_PczQ_eOq-so1b-=z1dSEPyjJr35ZNcag2XA@mail.gmail.com>
	 (sfid-20120309_110227_120979_D2EF6FA3)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 12:28:33 +0100
Message-ID: <1331292513.3491.1.camel@jlt3.sipsolutions.net> (sfid-20120309_122841_665592_D39B9F5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 02:01 -0800, Adrian Chadd wrote:
> I haven't come up with a cleaner solution either for
> FreeBSD/ath/net80211 at the moment.
> 
> Right now, if you try establishing an aggregation session by flooding
> 250+ Mbit of UDP, you can easily allocate all the ath_buf's before the
> driver gets a chance to send the addba. Or, the addba fails but before
> that retransmission occurs, another UDP frame has eaten up another
> mbuf/ath_buf.
> 
> I'm totally open to a better idea/solution. Even if I delay allocating
> ath_buf's until actual packet TX, that doesn't necessarily stop mbuf
> exhaustion from occuring, which is in line with what you see you're
> seeing in Linux.
> 
> My temporarily solution is likely to fail datapath TX at say, 70% of
> ath_buf's being allocated, allowing the other 30% for whatever
> management traffic needs to occur.
> 
> (That said, what may be nice is applying backpressure to the source
> interface of the frame(s), eg by sending PAUSE frames to the ethernet
> port(s), but that's just me..)

That would happen from the bridging code when the interface queues are
stopped & get full, right?

johannes


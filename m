Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59277 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab2CIKB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 05:01:57 -0500
Received: by lahj13 with SMTP id j13so1472030lah.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 02:01:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d_fMnjyHJ7zkz53Dvv0eL+MKC6sDJwpvOQQrK+R=f2iBw@mail.gmail.com>
References: <1331137230-12430-1-git-send-email-helmut.schaa@googlemail.com>
	<1331139615.3519.18.camel@jlt3.sipsolutions.net>
	<CAGXE3d_fMnjyHJ7zkz53Dvv0eL+MKC6sDJwpvOQQrK+R=f2iBw@mail.gmail.com>
Date: Fri, 9 Mar 2012 02:01:55 -0800
Message-ID: <CAJ-Vmomm9NKr6T_PczQ_eOq-so1b-=z1dSEPyjJr35ZNcag2XA@mail.gmail.com> (sfid-20120309_110210_142282_527452F2)
Subject: Re: [PATCH] mac80211: Limit TID buffering during BA session setup/teardown
From: Adrian Chadd <adrian@freebsd.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't come up with a cleaner solution either for
FreeBSD/ath/net80211 at the moment.

Right now, if you try establishing an aggregation session by flooding
250+ Mbit of UDP, you can easily allocate all the ath_buf's before the
driver gets a chance to send the addba. Or, the addba fails but before
that retransmission occurs, another UDP frame has eaten up another
mbuf/ath_buf.

I'm totally open to a better idea/solution. Even if I delay allocating
ath_buf's until actual packet TX, that doesn't necessarily stop mbuf
exhaustion from occuring, which is in line with what you see you're
seeing in Linux.

My temporarily solution is likely to fail datapath TX at say, 70% of
ath_buf's being allocated, allowing the other 30% for whatever
management traffic needs to occur.

(That said, what may be nice is applying backpressure to the source
interface of the frame(s), eg by sending PAUSE frames to the ethernet
port(s), but that's just me..)


Adrian

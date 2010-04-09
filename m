Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:39282 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754572Ab0DIJej convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 05:34:39 -0400
Message-ID: <100384.6603.qm@web51401.mail.re2.yahoo.com>
Date: Fri, 9 Apr 2010 02:34:39 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: Any news regarding multicast rate configuration?
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100409083651.GA3627@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Jouni Malinen <j@w1.fi> wrote:

> 
> At least for now, there is no separate configuration option for
> multicast frames, i.e., the same TX rate mask will apply to rate
> selection for both unicast and multicast frames. Multicast frames are
> subject to rate selection; the current mac80211 rate algorithms may not
> do much in that area, though, apart from letting the lowest available
> rate be selected. By changing which rates are enabled, you can change
> that lowest rate..

I think there is a serious problem. Unicast and multicast have
different characteristics and should have different "rate pools"
to select rates from. 

> 
> Why would the currently available mechanism not work for
> you?

For multicast the situation is the following: the selection of available
data rates affects all stations. If I drop the lower data rates to force 
multicast traffic at 11Mbit/s, then the stations close to the sender will 
be able to receive a video feed. Stations further away won't get it, but 
this is a trade off between data rate (e.g. quality) and coverage.
However, I'd still like to reach them over unicast, even if the data 
rate is only 1Mb/s. The current approach would prevent this, despite
the fact that it would be physically possible.

So, I would really prefer a solution were multicast and unicast data
rates can be selected independently of each other.

Kind regards
  Joerg

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

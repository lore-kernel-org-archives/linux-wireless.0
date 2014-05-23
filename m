Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47470 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbaEWJIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:08:09 -0400
Message-ID: <1400836074.4358.12.camel@jlt4.sipsolutions.net> (sfid-20140523_110847_374022_5F8EB18E)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 23 May 2014 11:07:54 +0200
In-Reply-To: <CA+BoTQnLPEqTnyr98TmDETP_iBOAza_XLZ53Jd+GdG6sRc3=5Q@mail.gmail.com> (sfid-20140523_105832_059803_80C652EC)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	 <1400770484.4174.35.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmdNV3XMmiAmA=bP4ZQ7dRZOwX8=_NYqmZW+orEA=OysA@mail.gmail.com>
	 <1400834656.4358.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnLPEqTnyr98TmDETP_iBOAza_XLZ53Jd+GdG6sRc3=5Q@mail.gmail.com>
	 (sfid-20140523_105832_059803_80C652EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 10:58 +0200, Michal Kazior wrote:

> If you keep on beaconing for too long on a DFS channel after detecting
> a radar you risk breaking local law (ETSI and FCC specify quiescing
> periods).

Yes, this is true.

> > You could technically just return NULL in this period, but I don't know
> > how well drivers would cope with that (though technically they have to
> > cope with it due to memory allocation failures anyway)
> 
> Sounds good to me.
> 
> I guess you'd use ieee80211_csa_is_complete (or
> ieee80211_csa_update_counter) for template-based drivers to stop
> beaconing.

The thing is, I don't see that template based drivers would be able to
stop beaconing :-)

This whole design that requires it seems a bit fishy to start with, so I
can't really imagine anyone writing firmware that supports it. That
said, ours only supports a single beacon at a time anyway, so we'll
switch immediately and don't have to do that anyway.

johannes


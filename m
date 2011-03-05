Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1CEUXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 15:23:37 -0500
Subject: Re: [PATCH 0/4 v2] {mac|nl}80211: Support for SAE mesh
 authentication in userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinKjmy8Py+1+eyfJ6Z72KR_Htq_9Aomdie884Fp@mail.gmail.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1299333960.3826.6.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sP0-cjuDu1XYGB2+UzHjyD_i1854AJQ=A4Bfn@mail.gmail.com>
	 <1299354655.29845.8.camel@jlt3.sipsolutions.net>
	 <AANLkTinKjmy8Py+1+eyfJ6Z72KR_Htq_9Aomdie884Fp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 21:23:32 +0100
Message-ID: <1299356612.29845.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-03-05 at 12:01 -0800, Javier Cardona wrote:
> >> > How does userspace know when to authenticate with a new peer?
> >
> >> Authentication is triggered by the reception of a beacon or presp from
> >> a compatible mesh peer with security enabled.
> >
> > Ok ... so I read from this that it actually parses out the beacon frames
> > from scan results? It seems that it should rather signal beacon frames
> > for unknown peers to userspace somehow, so userspace doesn't have to
> > poll scan results?
> 
> Discovery (and much more) on that prototype can certainly be improved.
>  Not sure what you mean from "signal beacon frames
>  for unknown peers" but yes, the current polled approach is probably
> not what we want.  The mesh stack should trigger an event when a mesh
> beacon is received from a station that has not been created.

Right. But in any case, the secure flag doesn't really need to mean
"secure", it can simply mean "userspace manages stations". I was
thinking first that maybe there's something else that triggers this in a
secure case, but of course that can't be true since it's symmetric.

Therefore, I think we should allow userspace the flexibility to say it
manages stations even when the RSN information isn't there, no?

johannes


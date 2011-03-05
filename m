Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1CETu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 14:50:58 -0500
Subject: Re: [PATCH 0/4 v2] {mac|nl}80211: Support for SAE mesh
 authentication in userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=sP0-cjuDu1XYGB2+UzHjyD_i1854AJQ=A4Bfn@mail.gmail.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1299333960.3826.6.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sP0-cjuDu1XYGB2+UzHjyD_i1854AJQ=A4Bfn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 20:50:55 +0100
Message-ID: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-03-05 at 11:40 -0800, Javier Cardona wrote:
> On Sat, Mar 5, 2011 at 6:06 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > I have a more generic question since I haven't seen the userspace bits:

> There's a working prototype here:
> https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c
> The intent is to merge that functionality into wpa_supplicant at some point.
> 
> > How does userspace know when to authenticate with a new peer?

> Authentication is triggered by the reception of a beacon or presp from
> a compatible mesh peer with security enabled.

Ok ... so I read from this that it actually parses out the beacon frames
from scan results? It seems that it should rather signal beacon frames
for unknown peers to userspace somehow, so userspace doesn't have to
poll scan results?

johannes


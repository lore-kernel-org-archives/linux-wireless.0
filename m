Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab1CXJ2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 05:28:43 -0400
Subject: Re: [PATCH 0/4] Add station BSS parameters to station
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=4QLfpeAKCiAxDYcL8dGNbWdaxE3OVic7obe_B@mail.gmail.com>
References: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
	 <1300800933.3746.5.camel@jlt3.sipsolutions.net>
	 <AANLkTi=4QLfpeAKCiAxDYcL8dGNbWdaxE3OVic7obe_B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 10:28:41 +0100
Message-ID: <1300958921.3807.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-22 at 07:33 -0700, Paul Stewart wrote:

> > Nice set of patches, but I'm wondering if the station info really is the
> > best place to put this information? It's not really strictly information
> > about the station, but rather about the BSS that it created. OTOH, I'm
> > not sure if we need to distinguish?
> 
> I think it makes sense in a way.  This is the station's view of the
> BSS once it is associated.

Yeah but it's tell you the view of the BSS as if it was its view of the
peer station. The BSS and the AP station aren't quite the same.

> In fact, the primary use intended for this
> is to verify that the station's view of the BSS parameters matches
> that of the AP.  

Right, but the station info is the local station's view of the remote
station, not the local station's view on anything else directly.

> After looking a little closer, it looks more for iw,
> it should show up in the output of "iw link", as part of the output of
> the hidden "iw link get_sta" command, but from the kernel perspective,
> the API would be the same.

I think the problem is that we haven't really defined any "view of the
BSS while connected" at all. We have used the scan data, which is a more
generic view of the BSS that anyone could have (almost, think hidden
SSID), and we have the view of the station which contains counters such
as the number of packets which works because that's the only station we
ever communicate with (ignoring things like (T)DLS.)

But frankly I'm not sure what to do. We could introduce a concept of an
associated BSS, but it wouldn't make sense as a separate object because
there can be only one. That reminds me of database normalisation for the
sake of it. Or we could put it in the station, like you did. Another
alternative I could think of would be putting it into the interface
information, since it's really specific to that interface as well. But
then again stations are already per interface too, so there's no
correctness issue either way.

I'm not sure. From a "less confusion" POV I might very slightly prefer
putting it into the interface data (i.e. nl80211_send_iface) but that
will obviously complicate iw and other tools using it, and also you've
already implemented the other approach.

Anyone else want to voice their opinion?

johannes


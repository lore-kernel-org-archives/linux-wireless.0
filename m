Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:13631 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXKXWjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 17:39:17 -0500
Received: by py-out-1112.google.com with SMTP id u77so448726pyb
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2007 14:39:16 -0800 (PST)
Message-ID: <8e6f94720711241439x27c1a48dxe3f3698043fb05a8@mail.gmail.com> (sfid-20071124_223919_730571_F0BAB405)
Date: Sat, 24 Nov 2007 17:39:15 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 regression: doesn't associate automatically
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195940177.4149.203.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <1195821998.4149.113.camel@johannes.berg>
	 <200711231423.23910.hs4233@mail.mn-solutions.de>
	 <1195940177.4149.203.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 24, 2007 4:36 PM, Johannes Berg <johannes@sipsolutions.net> wrote:

> Yeah, I've been bitten by that too. It's pretty tough actually but
> *should* be doable though I would much prefer to set it only after the
> interface is up I can see... Thing is that before the iface is up the
> interface mode isn't set in stone. So things like
>
> iwconfig eth1 blabla
> iwconfig eth1 mode monitor
> iwconfig eth1 mode managed
> ip link set eth1 up
>
> can probably never work properly. In any case, we ought to fix this
> though right now I don't know what the best way would be.

Ugh, yeah.

Would "bringing up a STA interface always triggers a scan" be too
horrible of a kludge to contemplate?

-- 
Will Dyson

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1I0HsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:48:03 -0400
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com> (sfid-20110927_003132_449210_ED324B61)
References: <20110922154726.521122680@sipsolutions.net>
	 <20110922154849.369194760@sipsolutions.net>
	 <CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
	 (sfid-20110927_003132_449210_ED324B61)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 09:47:51 +0200
Message-ID: <1317109671.4082.1.camel@jlt3.sipsolutions.net> (sfid-20110927_094807_203582_0E0556AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 15:30 -0700, Luis R. Rodriguez wrote:

> No particular comments on the code yet but latency issues has got me
> thinking about the filtered frames stuff and if we really need it. How
> much benefit does keeping these frames give us instead of just
> dropping them?

If the station goes to sleep, it'll incur latency by design. The
filtered frames stuff is really just a way to close the race between
giving a packet to the device and the station going to sleep -- as such
I think we should really keep it.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33178 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbcEIQdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 12:33:08 -0400
Message-ID: <1462811585.18382.22.camel@strongswan.org> (sfid-20160509_183314_028009_469D278A)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 09 May 2016 18:33:05 +0200
In-Reply-To: <1462779045.30690.2.camel@sipsolutions.net>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
	 <1462302992.10444.11.camel@sipsolutions.net>
	 <1462350799.2546.31.camel@strongswan.org>
	 <1462779045.30690.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Moving the radio back to the creators namespace would be the most
> > consistent behavior, so I'll check how difficult such a reverse
> > lookup is. We then would delete the radio only if it is in the
> > creators namespace, or if the creators namespace is gone. Does that
> > make sense?

> It does make sense, but it does also feel a bit complicated. 

Yes, and proper locking gets difficult when using cfg80211_set_netns(),
which can sleep. This would probably need larger changes in the locking
code, but that's IMO not worth the effort.

> Perhaps just special-case the init_net case for consistency with the
> existing behaviour, and reserve netgroup 0 for that so we can easily
> check for it?

I'll do that in a v2, following immediately.

> > I suspect you should be defining a structure that currently 
> > contains one integer member. Something (maybe a compile time 
> > assert) needs to check that buffer space you are accessing (where 
> > ever it is) is large enough.
> 
> It does look a bit awkward, but there's no value in having a struct -
> you still have an opaque pointer here and cast it to something whose
> size you assume to be present... it really makes no difference.

I agree there is no added safety when using a struct; Nonetheless have
I added one in v2, and is it just for any future member additions.

Best regards
Martin

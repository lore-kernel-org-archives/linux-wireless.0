Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:43745 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3KLLEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 06:04:35 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [RFC v3 1/4] mac80211: don't transmit beacon with CSA count 0
Date: Tue, 12 Nov 2013 12:04:33 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com> <201311111557.42832.sw@simonwunderlich.de> <1384244496.12583.46.camel@porter.coelho.fi>
In-Reply-To: <1384244496.12583.46.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311121204.33274.sw@simonwunderlich.de> (sfid-20131112_120443_804035_F1934401)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Just to make future bisecting easier, shouldn't this patch go after "only
> > set CSA beacon when at least one beacon must be transmitted" in the
> > series? Otherwise userspace may change the channel with count=0 and hit
> > a warning here, because this is not supported anymore.
> 
> My plan was to squash them, because they really belong together.  What
> do you think?
> 

Good idea, it belongs together anyway. 

> > Apart from that, the series looks fine. I'd like to test the next v4
> > then.
> 
> Great! I'll try to send v4 soon, hopefully the missing mesh part doesn't
> turn out to be too complicated. ;)

OK

> > I guess we still need to do the action frame part - for IBSS mode we
> > already have code but we probably need to make sure that these packets
> > go out before actually changing the channel. Do you plan to work on
> > that?
> 
> Yes, I'll look into it.  I think it should be pretty simple, especially
> now that we already have IBSS and MESH sending it out.

Great, thanks!
    Simon

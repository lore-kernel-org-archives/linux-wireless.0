Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:4753 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbXJJSLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 14:11:37 -0400
Received: by wr-out-0506.google.com with SMTP id 36so170803wra
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 11:11:36 -0700 (PDT)
Message-ID: <43e72e890710101111l10acad42u62eff5c995cfbe47@mail.gmail.com> (sfid-20071010_191140_562411_5C44448A)
Date: Wed, 10 Oct 2007 14:11:35 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/6] ath5k: Add proper support for multicast
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <1191960084.4013.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo>
	 <20071006011949.GD25022@pogo> <1191960084.4013.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/9/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-10-05 at 21:19 -0400, Luis R. Rodriguez wrote:
>
> > +     /* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
> > +      * set we should only pass on control frames for this
> > +      * station. This needs testing. I believe right now this
> > +      * enables *all* control frames */
>
> Which is fine too, but not most efficient. Remember that the docs also
> say you can pass up more frames, so an implementation that passes up
> *all* frames at all times is correct in that it supports all filter
> flags; it is, however, rather inefficient.

Right, well I think we might be able to figure out way to do by th
BSSID, if it doesn't do so already. But I'll clean up the comments to
reflect this is OK then.

  Luis

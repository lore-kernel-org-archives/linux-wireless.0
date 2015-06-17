Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47458 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbbFQLha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 07:37:30 -0400
Message-ID: <1434541047.1884.41.camel@sipsolutions.net> (sfid-20150617_133733_418255_1045B12F)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state
 stuck in ACTIVE caused by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 13:37:27 +0200
In-Reply-To: <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com> (sfid-20150617_133542_383000_26A57581)
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1434530870.1884.12.camel@sipsolutions.net>
	 <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
	 <1434538909.1884.39.camel@sipsolutions.net>
	 <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com>
	 (sfid-20150617_133542_383000_26A57581)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 17:05 +0530, Krishna Chaitanya wrote:

> > Then again, you're talking about WoWLAN, but then ...
> In wowlan, we simply call drv_resume and only if it fails
> then we will go through full resume. And without wowlan
> connection will not be there so this code will not be hit.

Right, but then the important part still is that we're enabling
powersave when going to sleep, no? I mean ... anyway it doesn't matter
much. I'll come up with some better comment/description I guess.

I really hate this whole powersave code btw - we really should refactor
that into its own little library module or so...

johannes


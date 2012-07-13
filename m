Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab2GMMJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 08:09:04 -0400
Message-ID: <1342181342.4983.10.camel@jlt3.sipsolutions.net> (sfid-20120713_140925_746509_D809860D)
Subject: Re: [PATCH 0/3] cfg80211/mac80211 channel fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Jul 2012 14:09:02 +0200
In-Reply-To: <CA+icZUVs-XMjWhuUE8-8+nyVADw-GRrMGp8=VfRj2F_2H42FLw@mail.gmail.com> (sfid-20120713_140158_879950_0FD6CC99)
References: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
	 <CA+icZUVs-XMjWhuUE8-8+nyVADw-GRrMGp8=VfRj2F_2H42FLw@mail.gmail.com>
	 (sfid-20120713_140158_879950_0FD6CC99)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-13 at 14:01 +0200, Sedat Dilek wrote:
> On Fri, Jul 13, 2012 at 1:58 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Ok so the last series worked but wasn't really good. I realized
> > that even for normal multi-channel operation we're going to need
> > get_channel() since otherwise we don't know the channel *type*
> > that the interface is using (e.g. in managed mode) since the AP
> > is no real indication of it as we might decide to not use HT40
> > or whatever...
> >
> > So instead of just reverting the get_channel removal, I'm adding
> > it back now with an interface argument. Nothing much changes for
> > mac80211, but in the future I'll adjust the cfg80211 channel
> > tracking code to make use of it so that it'll be required for
> > multi-channel (or the code will have to assume incompatibility.)
> >
> > This series fixes the monitor mode problems and I've committed
> > them (but haven't pushed, in case somebody finds errors.)
> >
> 
> For what tree is this? -next aka 3.6 material?

Yes.

johannes


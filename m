Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47327 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaJGMFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 08:05:43 -0400
Message-ID: <1412683538.1825.13.camel@jlt4.sipsolutions.net> (sfid-20141007_140550_446892_6E6CF53A)
Subject: Re: [PATCH v2] cfg80211: allow to configure dynamic PS timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Zdenek Kabelac <zkabelac@redhat.com>
Date: Tue, 07 Oct 2014 14:05:38 +0200
In-Reply-To: <20141007110356.GA2902@redhat.com>
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com>
	 <542AB859.5080008@broadcom.com> <542AB893.9090201@broadcom.com>
	 <20141001092710.GB2011@redhat.com>
	 <1412607640.3098.33.camel@jlt4.sipsolutions.net>
	 <20141007110356.GA2902@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 13:03 +0200, Stanislaw Gruszka wrote:
> On Mon, Oct 06, 2014 at 05:00:40PM +0200, Johannes Berg wrote:
> > On Wed, 2014-10-01 at 11:27 +0200, Stanislaw Gruszka wrote:
> > > Dynamic power save timeout value is suppose to be configurable via
> > > wext, but due to iwconfig bug is not possible to set using that tool.
> > 
> > That's interesting, what's that bug?
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=532713
> 
> Parsing problem. After reading bug report more detailed I found out it
> is fixed on pre beta version v30, but it was not released i.e. on Fedora
> we use wireless-tools v29.

Curious. I have version 30 on Debian, but all of this is *years* old.
Hah.

> > > Allow to configure PS timeout via nl80211 - add NL80211_ATTR_PS_TIMEOUT
> > > attribute which become timeout stated in ms.
> > 
> > Why do you want to be able to set it at all though? I remember having
> > this discussion years ago, and we said that it wasn't really useful
> > since the user has no idea when and why this should be changed. I'm not
> > convinced that changed?
> > 
> > We had to keep the wext for compatibility - maybe that can now be
> > removed if you say it's broken - but I'm not sure I see much value in
> > adding it (and you're doing nothing to convince me otherwise, so far)
> 
> Zdenek (CCed) reported to me 40% download performance degradation when
> PS is used. I think this happen because of delay between packets, but
> it is not confirmed yet (I did not provide patches to Zdenek for
> testing), hence perhaps problem lies somewere else. I can not reproduce
> this issue - I have the same download performance with PS on and off,
> I have quite bad performance when set dynamic PS timeout value less
> than 20ms, with default 100ms things are fine.
> 
> I assume we can provide that setting to user space, if it allow to
> fixup performance with PS ?

I'm not convinced - that'll give you a way to have the bug reporter test
it, or whatever, but that can also be achieved with debugfs or similar,
no?

"Regular" users will never even get there, they'll either give up on
Linux, the machine, the wifi NIC, or live with the low speeds. They'll
never manipulate things here, and this isn't anything that a userspace
tool could automatically manipulate either.

johannes


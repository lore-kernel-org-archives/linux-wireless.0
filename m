Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plexity.net ([206.123.115.38]:60203 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0CAUAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 15:00:31 -0500
Date: Mon, 1 Mar 2010 11:59:48 -0800
From: Deepak Saxena <dsaxena@laptop.org>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: add auto auth mode feature
Message-ID: <20100301195948.GA19200@plexity.net>
Reply-To: dsaxena@laptop.org
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com> <201002261355.06127.holgerschurig@gmail.com> <c1545bb51002261210h27ba9868tca0261742b848e51@mail.gmail.com> <1267225266.14995.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1267225266.14995.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 26 2010, at 15:01, Dan Williams was caught saying:
> On Fri, 2010-02-26 at 12:10 -0800, Andrey Yurovsky wrote:
> > On Fri, Feb 26, 2010 at 4:55 AM, Holger Schurig
> > <holgerschurig at googlemail.com> wrote:
> > >> Auto auth mode is enabled by default. If user doesn't specify the
> > >> auth mode, while association driver will first try with open mode
> > >> and then with shared key mode. If user specifies an auth mode,
> > >> auto auth is disabled and driver will not try association with
> > >> another auth mode.
> > >
> > > I'd rather would like if you guys chime in into the cfg80211 port rather
> > > than adding stuff to assoc.c and wext.c, which hopefully get's removed
> > > really soon now.
> > >
> > >
> > > As a side note: I'm now inclined to get rid of Libertas' proprietary mesh
> > > support in the driver. I don't know no one except OLPC that uses it, and
> > > even they don't seem work with upstream. For me, this mesh stuff is the last
> > > obstacle for cfg80211 support in libertas.
<snip>
> > Perhaps the OLPC folks might want to fork the driver or maintain a
> > patch set for the XO-1 mesh features.  Meanwhile we could all move on
> > and use cfg80211 and clean things up accordingly.
<snip>
> It might not be a bad thing to rip out the mesh stuff and add it later,
> but we do want to coordinate with OLPC folks as they are still the
> *largest user by far* of this driver.  As in a million+ units.

As has been pointed out, the next-gen XO wireless FW does not have mesh 
support; however, there are still plenty of end users and developers on 
the existing XO-1 laptops and I don't think completely removing mesh 
support is an option our community would be happy with. However, I also 
don't want to end up with a libertas fork (all our mesh patches are
currently upstream and not forkd off) in the OLPC tree so let's figure 
out a path to make this work for everyone.

It looks like there is already some work in progress towards mesh support
using cfg80211 [1] and if I can get pointers to the latest version, I can 
point the OLPC community to them and see if we can find some testers.

> Is it seriously that large of a block?  I thought we'd discussed a
> fairly viable plan for keeping mesh around while still doing cfg80211.
> Would shipping you a usb8388 dongle or two make it easier to work with?

Or a few XO-1 laptops? :)

~Deepak


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50532 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJGMdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 08:33:10 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so7701661wid.16
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 05:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412683538.1825.13.camel@jlt4.sipsolutions.net>
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com>
 <542AB859.5080008@broadcom.com> <542AB893.9090201@broadcom.com>
 <20141001092710.GB2011@redhat.com> <1412607640.3098.33.camel@jlt4.sipsolutions.net>
 <20141007110356.GA2902@redhat.com> <1412683538.1825.13.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 7 Oct 2014 18:02:49 +0530
Message-ID: <CABPxzYJ2Qghy87XhfSCdY+vB3CiNn-HpH_8BP=LfafLc37yiZQ@mail.gmail.com> (sfid-20141007_143315_113826_F2FA6A0B)
Subject: Re: [PATCH v2] cfg80211: allow to configure dynamic PS timeout
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2014 at 5:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2014-10-07 at 13:03 +0200, Stanislaw Gruszka wrote:
> > On Mon, Oct 06, 2014 at 05:00:40PM +0200, Johannes Berg wrote:
> > > On Wed, 2014-10-01 at 11:27 +0200, Stanislaw Gruszka wrote:
> > > > Dynamic power save timeout value is suppose to be configurable via
> > > > wext, but due to iwconfig bug is not possible to set using that tool.
> > >
> > > That's interesting, what's that bug?
> >
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=532713
> >
> > Parsing problem. After reading bug report more detailed I found out it
> > is fixed on pre beta version v30, but it was not released i.e. on Fedora
> > we use wireless-tools v29.
>
> Curious. I have version 30 on Debian, but all of this is *years* old.
> Hah.
>
> > > > Allow to configure PS timeout via nl80211 - add NL80211_ATTR_PS_TIMEOUT
> > > > attribute which become timeout stated in ms.
> > >
> > > Why do you want to be able to set it at all though? I remember having
> > > this discussion years ago, and we said that it wasn't really useful
> > > since the user has no idea when and why this should be changed. I'm not
> > > convinced that changed?
> > >
> > > We had to keep the wext for compatibility - maybe that can now be
> > > removed if you say it's broken - but I'm not sure I see much value in
> > > adding it (and you're doing nothing to convince me otherwise, so far)
> >
> > Zdenek (CCed) reported to me 40% download performance degradation when
> > PS is used. I think this happen because of delay between packets, but
> > it is not confirmed yet (I did not provide patches to Zdenek for
> > testing), hence perhaps problem lies somewere else. I can not reproduce
> > this issue - I have the same download performance with PS on and off,
> > I have quite bad performance when set dynamic PS timeout value less
> > than 20ms, with default 100ms things are fine.
> >
> > I assume we can provide that setting to user space, if it allow to
> > fixup performance with PS ?
>
> I'm not convinced - that'll give you a way to have the bug reporter test
> it, or whatever, but that can also be achieved with debugfs or similar,
> no?
>
> "Regular" users will never even get there, they'll either give up on
> Linux, the machine, the wifi NIC, or live with the low speeds. They'll
> never manipulate things here, and this isn't anything that a userspace
> tool could automatically manipulate either.

iw/iwconfig tools are not only used by regular users but also used by
developers/
engineers. We use it heavily for all our wifi testing, and when
debugging performance
related issue having a configurable ps timeout is of value. We had to
hack the kernel
to change that value (did not had enough time to work on iw/iwconfig).

So IMHO we need to have this configurable either through iw/mac80211 debugfs.

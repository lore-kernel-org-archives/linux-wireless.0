Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:7589 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXHEJYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 05:24:38 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1145274fkz
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2007 02:24:37 -0700 (PDT)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: further plan wrt. monitor interfaces
Date: Sun, 5 Aug 2007 11:29:23 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1186178959.13315.30.camel@johannes.berg> <200708041322.14876.IvDoorn@gmail.com> <1ba2fa240708042358x6b206c4bla6f10589fd2cf97f@mail.gmail.com>
In-Reply-To: <1ba2fa240708042358x6b206c4bla6f10589fd2cf97f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708051129.23301.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 August 2007, Tomas Winkler wrote:
> On 8/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Hi,
> >
> > >  * FIF_PROMISC_IN_BSS (BSS filters still on, but otherwise promisc)
> > >  * FIF_ALLMULTI               (all multicast frames are allowed through)
> > >  * FIF_BROADCAST      (broadcast frames are allowed through)
> > >  * FIF_FCSFAIL                (frames with bad FCS are allowed through)
> > >  * FIF_PLCPFAIL               (frames with bad PLCP checksum are allowed through)
> > >  * FIF_CONTROL                (control frames are shown)
> > >  * FIF_OTHER_BSS      (frames from other BSSes are shown, subject to the
> > >                        other filters)
> > > [missing anything?]
> >
> > rt2x00 registers have the 2 following entries as well:
> >
> >         Physical error
> >         Version error
> >
> >
> > The rest of the idea looks pretty good, si I will be happy to implement it for rt2x00. :)
> >
> > Ivo
> >
> >
> What about decryption error ?

those could be send to the mac80211 stack without the DECRYPTED flag set.
It will be up to mac80211 to take another shot at decrypting, send it further upstream as-is
or just simply drop it.

Ivo

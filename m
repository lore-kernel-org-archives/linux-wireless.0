Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47619 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab2KTML4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:56 -0500
Message-ID: <1353413478.10872.170.camel@cumari.coelho.fi> (sfid-20121120_131438_295157_5CA2F8AA)
Subject: Re: [PATCH v2 01/11] wlcore: start sta role on CHANGED_BSSID
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 14:11:18 +0200
In-Reply-To: <CAB3XZEfDz9B1h7AzLr92SjmE+pBqP3d_o+bXQdzz3dzhTe8HqA@mail.gmail.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
	 <1353410411-18833-2-git-send-email-eliad@wizery.com>
	 <1353411725.10872.159.camel@cumari.coelho.fi>
	 <CAB3XZEfDz9B1h7AzLr92SjmE+pBqP3d_o+bXQdzz3dzhTe8HqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 13:57 +0200, Eliad Peller wrote:
> On Tue, Nov 20, 2012 at 1:42 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2012-11-20 at 13:20 +0200, Eliad Peller wrote:
> >>       if (ret < 0)
> >> -             goto out;
> >> +             return ret;
> >>
> >> -out:
> >>       return ret;
> >>  }
> >
> > This is, of course, functionally okay, but seems like an unrelated
> > change.  Also, this is different than the general style we use in the
> > driver (ie. use goto out in most error cases).
> >
> > Same thing for the other functions you added.  It would be nice to be
> > consistent with the existing style, at least in error paths.
> >
> AFAICT, a major part of the functions in the driver use the "goto out"
> only when there's cleanup work to do.
> this is also the convention in mac80211.
> 
> but then again, i don't mind changing it if that's your preference.

Nah, never mind.  I noticed this is now different everywhere, no need to
bother.

--
Luca.


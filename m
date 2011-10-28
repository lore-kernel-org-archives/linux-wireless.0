Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1J1ICJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:02:09 -0400
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not
 wait for ACK
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEd1Mg6sYiW4tfaeaoAL8OoRRysKg-U6RU1SucE08hdfJQ@mail.gmail.com> (sfid-20111028_004455_347747_E16D85A4)
References: <20111021142322.229128720@sipsolutions.net>
	 <1319743973.32221.4.camel@jlt3.sipsolutions.net>
	 <CAB3XZEd1Mg6sYiW4tfaeaoAL8OoRRysKg-U6RU1SucE08hdfJQ@mail.gmail.com>
	 (sfid-20111028_004455_347747_E16D85A4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:02:06 +0200
Message-ID: <1319788926.3914.5.camel@jlt3.sipsolutions.net> (sfid-20111028_100213_633270_D84B3B98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 00:44 +0200, Eliad Peller wrote:
> On Thu, Oct 27, 2011 at 9:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > For probe responses it can be useful to not wait for ACK
> > to save airtime, so allow userspace to request not waiting
> > with a new nl80211 flag.
> >
> > Since mac80211 needs to be updated for the new function
> > prototype anyway implement it right away -- it's just a
> > few lines of code.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>

> [RFC v2 13/12] ? :)

Too lazy to send a new patchset and it really belonged with this :-)

> > +       if (!dont_wait_for_ack)
> > +               flags = IEEE80211_TX_CTL_NO_ACK;
> > +       else
> > +               flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
> > +                       IEEE80211_TX_CTL_REQ_TX_STATUS;
> > +
> 
> shouldn't it be the other way around? (i.e. set NO_ACK if dont_wait_for_ack)

Doh, of course, thanks. I was editing this code a few times -- guess I
lost track.

johannes


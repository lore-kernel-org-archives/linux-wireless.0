Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2ASMfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 07:35:45 -0500
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEd9F+0oOeSmn4UWPZ2iwWdRZ83KcRYRfD4q8ZrGm7m=4Q@mail.gmail.com> (sfid-20120119_123759_062535_26ECFC35)
References: <20120119082956.486569312@sipsolutions.net>
	 <20120119083102.873553392@sipsolutions.net>
	 <CAB3XZEd9F+0oOeSmn4UWPZ2iwWdRZ83KcRYRfD4q8ZrGm7m=4Q@mail.gmail.com>
	 (sfid-20120119_123759_062535_26ECFC35)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 13:35:40 +0100
Message-ID: <1326976540.3324.3.camel@jlt3.sipsolutions.net> (sfid-20120119_133549_378358_A0826B50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-19 at 13:37 +0200, Eliad Peller wrote:
> On Thu, Jan 19, 2012 at 10:29 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Similar to the previous beacon filtering patch,
> > make CQM RSSI support depend on the flags that
> > the driver set for virtual interfaces.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> [...]
> 
> >
> > -       if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
> > -               if (sdata->vif.type != NL80211_IFTYPE_STATION)
> > -                       return -EOPNOTSUPP;
> > -               return 0;
> > -       }
> > -
> >        /* tell the driver upon association, unless already associated */
> > -       if (sdata->u.mgd.associated)
> > +       if (sdata->u.mgd.associated &&
> > +           sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
> >                ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
> >
> should you return EOPNOTSUPP if the vif doesn't support it?

No. The code above that checks the type is useless as cfg80211 already
checks the type, and we do support this in software in mac80211 if
there's no HW offload for it.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1K2Qr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:47:26 -0500
Subject: Re: Converting ipw2x00 driver to mac80211 framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CA++WF2Op0dScq=coD=qkjqE-Q3ncOVjWVfFsF6sWUi0M5To=7g@mail.gmail.com> (sfid-20111129_173345_176491_131376D3)
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
	 <1322338254.4283.2.camel@jlt3.sipsolutions.net>
	 <1322338337.4283.3.camel@jlt3.sipsolutions.net>
	 <CA++WF2Op0dScq=coD=qkjqE-Q3ncOVjWVfFsF6sWUi0M5To=7g@mail.gmail.com>
	 (sfid-20111129_173345_176491_131376D3)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 17:47:22 +0100
Message-ID: <1322585242.4110.23.camel@jlt3.sipsolutions.net> (sfid-20111129_174729_260744_55F54B20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 08:33 -0800, Stanislav Yakovlev wrote:
> >> It would be much less risky to convert the entire thing to cfg80211, I
> >> think, basically just replacing the configuration layer in libipw_wx.c
> >> with a cfg80211 based one.
> >
> > It might also be a good idea to do some cleanups first -- e.g. I notice,
> > just in a random look at the code, that reset_port isn't used anywhere
> > so all code related to that can be removed...
> 
> Do I understand correctly that you suggest remove reset_port from
> libipw_device struct
> and remove all code like this:
> 
> -          if (ieee->reset_on_keychange &&
> -              ieee->iw_mode != IW_MODE_INFRA &&
> -              ieee->reset_port && ieee->reset_port(dev)) {
> -                 LIBIPW_DEBUG_WX("%s: reset_port failed\n", dev->name);
> -                 return -EINVAL;
> -         }
> 
> from libipw_wx.c ?

Right. There might be more of this too. That'd just help with converting
since you wouldn't have to think about converting this at all.

johannes


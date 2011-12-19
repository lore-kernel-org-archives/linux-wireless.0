Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1LSQGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:06:08 -0500
Subject: Re: [PATCH v2 1/7] wl12xx: implement change_interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEeb1eLMHtqtEMpuswv1NiHExy+y0vVkykrzSWdHMoJxMQ@mail.gmail.com> (sfid-20111219_121736_970824_85C0CDB1)
References: <1324288803-1666-1-git-send-email-eliad@wizery.com>
	 <1324292350.2800.280.camel@cumari>
	 <CAB3XZEeb1eLMHtqtEMpuswv1NiHExy+y0vVkykrzSWdHMoJxMQ@mail.gmail.com>
	 (sfid-20111219_121736_970824_85C0CDB1)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 17:06:03 +0100
Message-ID: <1324310763.3414.7.camel@jlt3.sipsolutions.net> (sfid-20111219_170611_860329_282255F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 13:17 +0200, Eliad Peller wrote:

> >> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> >> index c305841..82fc318 100644
> >> --- a/drivers/net/wireless/wl12xx/main.c
> >> +++ b/drivers/net/wireless/wl12xx/main.c
> >> @@ -2269,6 +2269,17 @@ out:
> >>       cancel_work_sync(&wl->recovery_work);
> >>  }
> >>
> >> +static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
> >> +                                   struct ieee80211_vif *vif,
> >> +                                   enum nl80211_iftype new_type, bool p2p)
> >> +{
> >> +     wl1271_op_remove_interface(hw, vif);
> >> +
> >> +     vif->type = ieee80211_iftype_p2p(new_type, p2p);
> >> +     vif->p2p = p2p;
> >> +     return wl1271_op_add_interface(hw, vif);
> >> +}
> >> +
> >
> > As Arik already commented, this looks a bit weird.  Shouldn't the type
> > and p2p elements be changed in mac80211 itself? What about doing so if
> > the op_change_interface returns success? Currently, the opposite seems
> > to happen (ie. mac80211 changes type back to the original vif.type if
> > the op fails).
> >
> iwlegacy and ath9k are also setting vif->type and vif->p2p in a similar manner.
> add_interface(vif) assumes vif->type and vif->p2p are correct, so it
> makes sense to update the vif before adding it.
> i also think this behavior is a bit ugly, but this is the current
> mac80211 implementation, and i don't see a good enough reason to
> change it :)

The reason I did it this way is because it simplified the code in the
driver (for me at least) -- I could call functions that work on a vif
and look at vif->type/p2p before and after doing my own changes, whereas
if mac80211 was doing the modification I'd have to add extra arguments
everywhere.

johannes


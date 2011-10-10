Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38231 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab1JJTkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:40:07 -0400
Received: by mail-bw0-f48.google.com with SMTP id zu5so12135243bkb.21
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:40:05 -0700 (PDT)
Subject: Re: [PATCH 06/29] wl12xx: add vifs list
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEfA2woetrXDycv3xcBYGBvyYJQoLz969Rp8k8WjaG3FFw@mail.gmail.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-7-git-send-email-eliad@wizery.com>
	 <1318271328.9690.381.camel@cumari>
	 <CAB3XZEfA2woetrXDycv3xcBYGBvyYJQoLz969Rp8k8WjaG3FFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:40:02 +0300
Message-ID: <1318275602.9690.409.camel@cumari> (sfid-20111010_214009_856776_9016A93E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 21:29 +0200, Eliad Peller wrote: 
> On Mon, Oct 10, 2011 at 8:28 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
> >> keep a list of all the vifs associated with our hw.
> >> it will be later used in order to iterate through vifs.
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > [...]
> >
> >> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> >> index 33ccdf8..55561c5 100644
> >> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> >> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> >> @@ -394,6 +394,8 @@ struct wl1271 {
> >>       unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
> >>       unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
> >>
> >> +     struct list_head wlvif_list;
> >> +
> >>       struct wl1271_acx_mem_map *target_mem_map;
> >>
> >>       /* Accounting for allocated / available TX blocks on HW */
> >> @@ -564,6 +566,7 @@ struct wl1271_station {
> >>
> >>  struct wl12xx_vif {
> >>       struct wl1271 *wl;
> >> +     struct list_head list;
> >
> > I know we alredy call this kind of thing "list" struct wl1271 for the
> > ARP stuff, but I prefer "node" so it's easier to follow when calling
> > list_add and friends.  Mind changing?
> >
> i think "list" is the standard convention (e.g. see sta_info,
> ieee80211_key, etc.) and more intuitive.

Yeah, it makes a bit of sense, because each node is actually a head of a
list.  Still, I don't like it because it's annoying to read it a
list_add() with two lists.  It's not intuitive to know which one is
which.  Anyway, it's fine to leave it like this.


> >> @@ -653,6 +656,9 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
> >>       return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
> >>  }
> >>
> >> +#define wl12xx_for_each_wlvif(wl, wlvif) \
> >> +             list_for_each_entry(wlvif, &wl->wlvif_list, list)
> >> +
> >
> > This looks fine, but is it really necessary? I think the call to
> > list_for_each_entry is clear enough already, isn't it?
> >
> i find it easier to understand this way.
> also, future patches will add wl12xx_for_each_wlvif_sta and
> wl12xx_for_each_wlvif_ap, so it even makes more sense to use this
> macro.

Yeah, I now saw the other macros and it now makes a bit more sense for
the other ones.  But I dislike simple macros whose content are almost as
easy to understand as the macro name, because one needs to go dig the
macro out to figure out exactly what it is doing.  With no macro, it
would be much easier to figure out that this is a simple
list_for_each_entry(), because you would simply call that explicitly. ;)
It's as annoying as unnecessary typedefs.

But I'm in a temporary and unusual mood of accepting stuff easier than
usual right now, so it's fine to keep it like this. ;)

-- 
Cheers,
Luca.


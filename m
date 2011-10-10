Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:43423 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab1JJTyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:54:37 -0400
Received: by bkbzv15 with SMTP id zv15so10977943bkb.18
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:54:34 -0700 (PDT)
Subject: Re: [PATCH 08/29] wl12xx: configure sleep_policy according to
 active roles
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEcXGyia5r1jrfjYTwrNvFDpxpckY=jX6qYyWuHg-iBYvg@mail.gmail.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-9-git-send-email-eliad@wizery.com>
	 <1318272712.9690.384.camel@cumari>
	 <CAB3XZEcXGyia5r1jrfjYTwrNvFDpxpckY=jX6qYyWuHg-iBYvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:54:31 +0300
Message-ID: <1318276471.9690.416.camel@cumari> (sfid-20111010_215441_536958_F915E223)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 21:32 +0200, Eliad Peller wrote: 
> On Mon, Oct 10, 2011 at 8:51 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
> >> If there is an active AP role, stay always on.
> >> Otherwise, allow chip to enter elp.
> >>
> >> (Note that this is a global configuration, so if the
> >> device is already configured according to our policy,
> >> we don't have to configure it again)
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > [...]
> >
> >> @@ -573,13 +563,38 @@ static int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
> >>
> >>  int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
> >>  {
> >> -     struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
> >> +     struct wl12xx_vif *iter, *wlvif = wl12xx_vif_to_data(vif);
> >>       struct conf_tx_ac_category *conf_ac;
> >>       struct conf_tx_tid *conf_tid;
> >>       bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
> >> -
> >> +     u8 sta_roles_cnt = 0, ap_roles_cnt = 0;
> >>       int ret, i;
> >>
> >> +     wl12xx_for_each_wlvif(wl, iter) {
> >> +             if (iter->bss_type == BSS_TYPE_AP_BSS)
> >> +                     ap_roles_cnt++;
> >> +             else
> >> +                     sta_roles_cnt++;
> >> +     }
> >> +
> >> +     /*
> >> +      * consider all existing roles before configuring psm.
> >> +      * TODO: reconfigure on interface removal.
> >> +      */
> >> +     if (!ap_roles_cnt) {
> >> +             if (is_ap) {
> >> +                     /* Configure for power always on */
> >> +                     ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
> >> +                     if (ret < 0)
> >> +                             return ret;
> >> +             } else if (!sta_roles_cnt) {
> >> +                     /* Configure for ELP power saving */
> >> +                     ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
> >> +                     if (ret < 0)
> >> +                             return ret;
> >> +             }
> >> +     }
> >> +
> >
> > Wouldn't it be much simpler to have a "have_ap" element in the wl
> > struct?
> >
> >
> have_ap is not enough, because there might be multiple aps, and we
> need to consider it on removal.

Right...


> we can use ap_count, if you prefer it that way.

Yeah, I'd still prefer that.

-- 
Cheers,
Luca.


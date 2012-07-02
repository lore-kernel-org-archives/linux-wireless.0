Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:45165 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2GBIEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 04:04:31 -0400
Date: Mon, 2 Jul 2012 16:54:50 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 11/18] brcmsmac: remove some unnessessacry casts and
 void pointer
Message-ID: <20120702075450.GB18990@nautica> (sfid-20120702_100436_790639_E13CE2A1)
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-12-git-send-email-hauke@hauke-m.de>
 <CAGRGNgU3=WoGBrSBsuiGhTs2tx3iZMt_fjqYaxLk7rSAMw8jHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGRGNgU3=WoGBrSBsuiGhTs2tx3iZMt_fjqYaxLk7rSAMw8jHQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote on Mon, Jul 02, 2012 :
> On Sat, Jun 30, 2012 at 11:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> > diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > index 478b374..8bad8b6 100644
> > --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> > @@ -4241,10 +4240,8 @@ static void brcms_b_watchdog(void *arg)
> >  }
> >
> >  /* common watchdog code */
> > -static void brcms_c_watchdog(void *arg)
> > +static void brcms_c_watchdog(struct brcms_c_info *wlc)
> >  {
> > -       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
> > -
> >         BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
> >
> >         if (!wlc->pub->up)
> > @@ -4284,7 +4281,9 @@ static void brcms_c_watchdog(void *arg)
> >
> >  static void brcms_c_watchdog_by_timer(void *arg)
> >  {
> > -       brcms_c_watchdog(arg);
> > +       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
> > +
> > +       brcms_c_watchdog(wlc);
> 
> You remove 2 cases of this pattern in your patch then add one. Why?

I'm not Hauke :) but as far as I understand, brcms_c_watchdog_by_timer
is used by brcms_init_timer which expects a void (*fn) (void *); and
which is also used with brcms_c_radio_timer
Admitedly, brcms_c_radio_timer also uses a struct brcms_c_info* as
argument, so everything could be change this way, but I think it's not
completely insane to keep callbacks as void* :)

I also see the point of removing this "pattern" since it makes it easier
to understand with the proper type information.

Regards,
-- 
Asmadeus | Dominique Martinet

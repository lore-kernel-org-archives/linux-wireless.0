Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36914 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbbIJQ4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 12:56:11 -0400
Received: by wicfx3 with SMTP id fx3so30433362wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 09:56:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Hiroaki Kawai <hiroaki.kawai@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix bad rssi reading
Date: Thu, 10 Sep 2015 18:56:07 +0200
Message-ID: <1507351.ZjrYSIG4vW@debian64> (sfid-20150910_185614_290383_5E9DD709)
In-Reply-To: <CABD3darfGTc8gVgAo4j7S4M0uymoF2gy8ihLraN2qcXJFO9cWw@mail.gmail.com>
References: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com> <1738409.B3jGDQ6NWL@debian64> <CABD3darfGTc8gVgAo4j7S4M0uymoF2gy8ihLraN2qcXJFO9cWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, September 11, 2015 01:37:48 AM Hiroaki Kawai wrote:
> That field is union and referenced as rssi_combined at two lines below.
Correct

> The status->signal will show up in radiotap
> IEEE80211_RADIOTAP_DBM_ANTSIGNAL
> header field at userland finally.

so, this patch should go to -stable too.

Cc: stable@vger.kernel.org

Thanks
> > > ---
> > >  drivers/net/wireless/ath/carl9170/rx.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/wireless/ath/carl9170/rx.c
> > b/drivers/net/wireless/ath/carl9170/rx.c
> > > index 924135b..d66533c 100644
> > > --- a/drivers/net/wireless/ath/carl9170/rx.c
> > > +++ b/drivers/net/wireless/ath/carl9170/rx.c
> > > @@ -453,7 +453,7 @@ static void carl9170_rx_phy_status(struct ar9170 *ar,
> > >       /* post-process RSSI */
> > >       for (i = 0; i < 7; i++)
> > >               if (phy->rssi[i] & 0x80)
> > > -                     phy->rssi[i] = ((phy->rssi[i] & 0x7f) + 1) & 0x7f;
> > > +                     phy->rssi[i] = ((~phy->rssi[i] & 0x7f) + 1) & 0x7f;
> > >
> > >       /* TODO: we could do something with phy_errors */
> > >       status->signal = ar->noise[0] + phy->rssi_combined;
> > >
> >
> >


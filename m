Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:21272 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbXHGAhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 20:37:21 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1599118wxd
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2007 17:37:20 -0700 (PDT)
Message-ID: <1ba2fa240708061737q66c85ad7s2bde54f083a12266@mail.gmail.com>
Date: Tue, 7 Aug 2007 03:37:19 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC V2] bcm43xx-mac80211: Add TX power set file to debugfs
Cc: bcm43xx-dev@lists.berlios.de,
	"Larry Finger" <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708062335.14693.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46b78ac2.M4X/XQ9LXYHUe/aO%Larry.Finger@lwfinger.net>
	 <200708062307.40590.mb@bu3sch.de> <46B791EF.7000105@lwfinger.net>
	 <200708062335.14693.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 06 August 2007 23:26:07 Larry Finger wrote:
> > Michael Buesch wrote:
> > >
> > > No, why do you poke with this at all.
> > > This completely breaks power adjustment from mac80211.
> > > Simply don't touch bcm43xx_dev_config :)
> > >
> >
> > The problem is that mac80211 never seems to do any power adjustment. The funny 0x1b value for power
> > level that I wondered about earlier is coming from a value of 27 dBm that is set in
> > net/mac80211/regdomain.c, and conf->power_level doesn't get any information from anywhere else that
> > I see.
> >
> > Do you know how to get mac80211 to change what it is sending to us?
>
> I think we have an ioctl.
> But it's probably the task of the rc algorithm to adjust power.
>
11k and 11h have TPC features in as well.
Even though tx power affects link quality it is not usually part of
rate scaling.
> --
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

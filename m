Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:10833 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXL2CpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 21:45:06 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5922409wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2007 18:45:05 -0800 (PST)
Message-ID: <cb0375e10712281845j472b2161vfd9815428b01dd32@mail.gmail.com> (sfid-20071229_024512_012588_1C377DBB)
Date: Fri, 28 Dec 2007 18:45:05 -0800
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: ath5k oops (recent regression, I think)
Cc: "bruno randolf" <bruno@thinktube.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
	 <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 25, 2007 6:23 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/12/25, bruno randolf <bruno@thinktube.com>:
> > seems ath5k likes to write some rate registers before vif is set up. i used
> > the following as a stopgap fix. johannes, do you have any advice how to
> > properly fix that?
> >
> > diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> > index f4478f6..2e9f5c5 100644
> > --- a/drivers/net/wireless/ath5k/hw.c
> > +++ b/drivers/net/wireless/ath5k/hw.c
> > @@ -510,6 +510,11 @@ static inline void ath5k_hw_write_rate_duration(struct
> > ath5k_hw *ah,
> >         const struct ath5k_rate_table *rt;
> >         unsigned int i;
> >
> > +       if (sc->vif == NULL) {
> > +               printk("*** sc->vif NULL\n");
> > +               return;
> > +       }
> > +
> >         /* Get rate table for the current operating mode */
> >         rt = ath5k_hw_get_rate_table(ah,
> >                 driver_mode);
> >

Works for me.  This patch is ugly, but:

Tested-By: Andy Lutomirski <luto@myrealbox.com>

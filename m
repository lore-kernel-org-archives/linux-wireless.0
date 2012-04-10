Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41863 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab2DJMrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:47:08 -0400
Date: Tue, 10 Apr 2012 15:47:44 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120410124742.GA17779@aemeltch-MOBL1> (sfid-20120410_144714_641139_44CC76DA)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <CAGRGNgX+R0CrtF2tBJ1AASBqkhHjmEfcqVnJiTd_1mXFL2rVUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGRGNgX+R0CrtF2tBJ1AASBqkhHjmEfcqVnJiTd_1mXFL2rVUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thanks for review,

On Tue, Apr 10, 2012 at 10:26:11PM +1000, Julian Calaby wrote:
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -898,6 +900,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
> >        case NL80211_IFTYPE_WDS:
> >        case NL80211_IFTYPE_AP_VLAN:
> >                break;
> > +       case NL80211_IFTYPE_VIRTUAL_AMP80211:
> > +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> > +               ieee80211_vamp_setup_sdata(sdata);
> > +               break;
> > +#endif
> >        case NL80211_IFTYPE_UNSPECIFIED:
> >        case NUM_NL80211_IFTYPES:
> >                BUG();
> 
> Should this really BUG() if VAMP is not enabled? Maybe print a warning
> and return an error instead.

I will make it empty inline function.

> > diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
> > new file mode 100644
> > index 0000000..5b7d219
> > --- /dev/null
> > +++ b/net/mac80211/virtual_amp.h
> > @@ -0,0 +1,29 @@
> > +/*
> > + * Virtual / Software AMP 80211 BT Controller header
> > + *
> > + * Copyright 2012 Intel Corp.
> > + *
> > + * Written by andrei.emeltchenko@intel.com
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include "ieee80211_i.h"
> > +
> > +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> > +
> > +void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
> > +void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
> > +
> > +struct vamp_data {
> > +       struct hci_dev *hdev;
> > +
> > +       unsigned long flags;
> > +
> > +       struct work_struct work;
> > +       struct sk_buff_head txq;
> > +};
> > +
> > +#endif /* CONFIG_MAC80211_VIRTUAL_AMP */
> 
> A cleaner way of doing this is to have the function prototypes
> specified as empty inline functions when CONFIG_MAC80211_VIRTUAL_AMP
> is not defined and remove the #ifdefs in the main code. GCC's smart
> enough to compile away all the empty functions.

Will do this way.

Best regards 
Andrei Emeltchenko 


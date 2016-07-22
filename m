Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36440 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbcGVKiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 06:38:16 -0400
Received: by mail-io0-f178.google.com with SMTP id b62so101349458iod.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 03:38:16 -0700 (PDT)
Date: Fri, 22 Jul 2016 06:38:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iw: display 5/10 MHz channel widths
Message-ID: <20160722103807.GA15262@localhost> (sfid-20160722_123819_648756_1FC707DF)
References: <20160721153948.32171-1-me@bobcopeland.com>
 <CAGRGNgWHJEFBnak-MCK2htkaeQcZ6dmZ=w96omC99G5Z2UJWFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgWHJEFBnak-MCK2htkaeQcZ6dmZ=w96omC99G5Z2UJWFg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2016 at 07:53:35PM +1000, Julian Calaby wrote:
> Hi Bob,

Hi!

> > --- a/interface.c
> > +++ b/interface.c
> > @@ -295,6 +295,10 @@ char *channel_width_name(enum nl80211_chan_width width)
> >                 return "80+80 MHz";
> >         case NL80211_CHAN_WIDTH_160:
> >                 return "160 MHz";
> > +       case NL80211_CHAN_WIDTH_5:
> > +               return "5 MHz";
> > +       case NL80211_CHAN_WIDTH_10:
> > +               return "10 MHz";
> >         default:
> >                 return "unknown";
> >         }
> 
> Judging by the previous two entries, it looks like the case statements
> are sorted, so should these ones therefore be at the top of the list?

These are sorted by NL80211_CHAN_WIDTH_* attribute value, which makes
a little more sense to me than sorting by the string or numerically by
width, but sure, I can do it either way.

-- 
Bob Copeland %% http://bobcopeland.com/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41949 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab1HaQov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 12:44:51 -0400
Received: by ewy4 with SMTP id 4so573545ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 09:44:50 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/4] nl80211: Parse channel type attribute in an IBSS join request
Date: Wed, 31 Aug 2011 18:44:47 +0200
Message-ID: <2853752.GZVY6pETLZ@alex-1> (sfid-20110831_184454_725548_22509D91)
In-Reply-To: <201108311751.20806.lindner_marek@yahoo.de>
References: <2053881.ENil2Dy3QM@alex-1> <201108311751.20806.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 31. August 2011, 17:51:20 schrieben Sie:
> On Monday, August 29, 2011 16:15:47 Alexander Simon wrote:
> >         if (!ibss.channel ||
> > 
> > +           ibss.channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
> > 
> >             ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
> > 
> > -           ibss.channel->flags & IEEE80211_CHAN_DISABLED)
> > +           ibss.channel->flags & IEEE80211_CHAN_RADAR)
> > +               return -EINVAL;
> 
> Do you mind elaborating why this patch removes the IEEE80211_CHAN_DISABLED
> check and adds the IEEE80211_CHAN_RADAR check instead ? Copy and paste error
> ?
You're right.

I've adopted this from the check in cfg80211_can_use_ext_chan in 
net/wireless/chan.c and probably missed the DISABLED check.

Thanks.
Will be fixed in v3.

Alex

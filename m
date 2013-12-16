Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:38773 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3LPOxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:53:19 -0500
Received: by mail-vb0-f49.google.com with SMTP id x11so3157662vbb.22
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 06:53:19 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 15:53:18 +0100
Message-ID: <CAD_=uH_pzbobvJGAgQcaPAVV+w9YA9DnFiSV+e4K-k456mmcBQ@mail.gmail.com> (sfid-20131216_155328_556817_E7790C64)
Subject: Re: [PATCH v4] cfg80211: fix dfs channel state after stopping AP
From: Marek Puzyniak <xpumapu@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/12/16 Johannes Berg <johannes@sipsolutions.net>
> If you keep changing your patch without any changelog (after the "---"
> line!) then I have no idea what I should look at?

Right, I will add history of changes.

> > +     if (rdev->num_running_ifaces == 1) {
> > +             /* Last running AP iface*/
>
> missing a space
Yes, right.

> > +             wdev_lock(wdev_iter);
>
> This will almost certainly cause a lockdep warning since you hold the
> wdev lock already.
>
> > +             if (!netif_running(wdev_iter->netdev)) {
> > +                     wdev_unlock(wdev_iter);
> > +                     continue;
> > +             }
> > +
> > +             if (wdev_iter->iftype == NL80211_IFTYPE_AP) {
> > +                     wdev_unlock(wdev_iter);
> > +                     return false;
> > +             }
> > +             wdev_unlock(wdev_iter);
>
> I don't think checking the iftype needs the lock (this lock - maybe
> rtnl) anyway?

I will remove lock here.

> johannes

Marek

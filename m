Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50690 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2KBT5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 15:57:03 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so4107782vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2012 12:57:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com>
References: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com>
Date: Fri, 2 Nov 2012 15:57:02 -0400
Message-ID: <CA+7oygfnsrqAyU4d3n7EgmOntenhp36DEGhSnJ4FsJFdOKCk-w@mail.gmail.com> (sfid-20121102_205717_681122_4529AA56)
Subject: Re: bug in compat-wireless 3.6, rt2x00 iftype is wrong
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The issue seems to be that in all of these drivers, wdev is NULL when
you hit set_channel()  in the older and newer driver.  In the old
driver, cfg8011_set_freq() is called with wdev has NULL and it still
calls rdev->ops->set_channel(....) which succeeds.

However, in the new driver cfg80211_set_monitor_channel() is called
since wdev was NULL, but now instead of still calling
rdev->ops->set_channel() or rdev->ops->set_monitor_channel() it
returns -EBUSY because if(!cfg80211_has_monitors_only(rdev)) returns
true.  Is this really the expected behavior, or is meant to only
return -EBUSY if there are only monitors, rather? (i.e.,
if(cfg80211_has_monitors_only(rdev)) )


On Fri, Nov 2, 2012 at 2:46 PM, George Nychis <gnychis@gmail.com> wrote:
> I'm still trying to track down the cause for this, but starting in
> compat-wireless-3.6 (including early RCs and the most recent 3.6.2),
> rt2x00 devices register with the wrong iftype.  They register as
> NL80211_IFTYPE_MONITOR instead of NL80211_IFTYPE_STATION, for example.
>  I checked cw-3.5, 3.4, 3.2, and 3.1 and none of these versions have
> this bug.
>
> This breaks the ability to set channels, etc.  Hoping to track down
> the bug, but wanted to report it in the meantime and see if anyone
> else has run in to it.
>
> - George

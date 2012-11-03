Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2KCLNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2012 07:13:43 -0400
Message-ID: <1351941260.21705.2.camel@jlt4.sipsolutions.net> (sfid-20121103_121356_532500_815E923F)
Subject: Re: bug in compat-wireless 3.6, rt2x00 iftype is wrong
From: Johannes Berg <johannes@sipsolutions.net>
To: George Nychis <gnychis@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 03 Nov 2012 12:14:20 +0100
In-Reply-To: <CA+7oygfnsrqAyU4d3n7EgmOntenhp36DEGhSnJ4FsJFdOKCk-w@mail.gmail.com> (sfid-20121102_205717_681122_4529AA56)
References: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com>
	 <CA+7oygfnsrqAyU4d3n7EgmOntenhp36DEGhSnJ4FsJFdOKCk-w@mail.gmail.com>
	 (sfid-20121102_205717_681122_4529AA56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-02 at 15:57 -0400, George Nychis wrote:
> The issue seems to be that in all of these drivers, wdev is NULL when
> you hit set_channel()  in the older and newer driver.  In the old
> driver, cfg8011_set_freq() is called with wdev has NULL and it still
> calls rdev->ops->set_channel(....) which succeeds.
> 
> However, in the new driver cfg80211_set_monitor_channel() is called
> since wdev was NULL, but now instead of still calling
> rdev->ops->set_channel() or rdev->ops->set_monitor_channel() it
> returns -EBUSY because if(!cfg80211_has_monitors_only(rdev)) returns
> true.  Is this really the expected behavior, or is meant to only
> return -EBUSY if there are only monitors, rather? (i.e.,
> if(cfg80211_has_monitors_only(rdev)) )

No, this is the correct behaviour, if you have non-monitor interfaces
you can't set the channel since the channel setting would be done with
other actions, e.g. associating a managed mode interface.

I don't really understand your original complaint though, the iftype you
set will be the one the interface is in ...

johannes


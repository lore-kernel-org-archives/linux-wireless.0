Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57850 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2KCWJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2012 18:09:07 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so4832940vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Nov 2012 15:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351941260.21705.2.camel@jlt4.sipsolutions.net>
References: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com>
	<CA+7oygfnsrqAyU4d3n7EgmOntenhp36DEGhSnJ4FsJFdOKCk-w@mail.gmail.com>
	<1351941260.21705.2.camel@jlt4.sipsolutions.net>
Date: Sat, 3 Nov 2012 18:09:06 -0400
Message-ID: <CA+7oygemJMmhEdy8SeE5w9bXmYB6tn4J03ORkLubV1DVO3hwaQ@mail.gmail.com> (sfid-20121103_230920_585471_35957E4D)
Subject: Re: bug in compat-wireless 3.6, rt2x00 iftype is wrong
From: George Nychis <gnychis@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fair enough, this is just behavior that was newly enforced without
comments that I could find.  For the several years that I've been
working with compat-wireless, I've been able to change the channel of
an unassociated Managed interface with a coupled monitoring interface
using iwconfig or iw on either.  Then, that behavior broke.  I see the
logic behind the behavior.

On Sat, Nov 3, 2012 at 7:14 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-11-02 at 15:57 -0400, George Nychis wrote:
>> The issue seems to be that in all of these drivers, wdev is NULL when
>> you hit set_channel()  in the older and newer driver.  In the old
>> driver, cfg8011_set_freq() is called with wdev has NULL and it still
>> calls rdev->ops->set_channel(....) which succeeds.
>>
>> However, in the new driver cfg80211_set_monitor_channel() is called
>> since wdev was NULL, but now instead of still calling
>> rdev->ops->set_channel() or rdev->ops->set_monitor_channel() it
>> returns -EBUSY because if(!cfg80211_has_monitors_only(rdev)) returns
>> true.  Is this really the expected behavior, or is meant to only
>> return -EBUSY if there are only monitors, rather? (i.e.,
>> if(cfg80211_has_monitors_only(rdev)) )
>
> No, this is the correct behaviour, if you have non-monitor interfaces
> you can't set the channel since the channel setting would be done with
> other actions, e.g. associating a managed mode interface.
>
> I don't really understand your original complaint though, the iftype you
> set will be the one the interface is in ...
>
> johannes
>

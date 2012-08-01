Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36107 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2HAXWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 19:22:44 -0400
Received: by obbuo13 with SMTP id uo13so12907721obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 16:22:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343842772.4638.15.camel@jlt3.sipsolutions.net>
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	<1343842772.4638.15.camel@jlt3.sipsolutions.net>
Date: Wed, 1 Aug 2012 17:22:43 -0600
Message-ID: <CAMLZHHQdBHZa4NBQ3ygKJSHmKL11ERUWDAtMx0-Qh4OzSoN-SA@mail.gmail.com> (sfid-20120802_012247_877845_C883381B)
Subject: Re: cfg80211_disconnected memory leak
From: Daniel Drake <dsd@laptop.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 11:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> The strange thing is that we call __cfg80211_disconnect() from the
> netdev notifier with NETDEV_GOING_DOWN. This will allocate and queue the
> work item as you found. The next thing that happens should be
> NETDEV_DOWN, which will cause us to dev_hold() the device and then queue
> the cleanup work. The cleanup work must run for us to dev_put() the
> device, so that it can only be unregistered after that runs. Then,
> finally, we get NETDEV_UNREGISTER which removes it from the list.
>
> Now note that the work item we queue in __cfg80211_disconnect() is
> queued *before* the cleanup work, therefore it should also run before
> the cleanup work since the workqueue is singlethreaded.

Here is what happens:

NETDEV_GOING_DOWN
cfg80211_disconnected() called, disconnect event work queued
NETDEV_DOWN
cleanup work queued
NETDEV_UNREGISTER
*** cfg80211_netdev_notifier_call now calls: list_del_rcu(&wdev->list);
disconnect even work runs, calls cfg80211_process_rdev_events() but
the wdev is already removed from rdev->netdev_list as above
cleanup work runs

The bit I marked with *** is what is causing the difficulties - it
runs before the work items do.

Daniel

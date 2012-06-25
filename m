Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38898 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2FYQGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 12:06:00 -0400
Received: by yenl2 with SMTP id l2so2942439yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 09:05:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340639295.27437.7.camel@jlt3.sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	<1340117456-10154-16-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEcWE46OHiigB24ezaDA3rRUYoKGtYcmvVxVgMizVK+d8w@mail.gmail.com>
	<1340639295.27437.7.camel@jlt3.sipsolutions.net>
Date: Mon, 25 Jun 2012 19:05:59 +0300
Message-ID: <CAB3XZEfpSxd6LC9XnwFDfVHx=EP2aypEuPhrvtAsJM4HxpJ8gg@mail.gmail.com> (sfid-20120625_180603_745178_BDB135D6)
Subject: Re: [RFC 15/17] cfg80211: add P2P Device abstraction
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 25, 2012 at 6:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-25 at 18:20 +0300, Eliad Peller wrote:
>
>> > +void cfg80211_unregister_wdev(struct wireless_dev *wdev)
>
>> > +       case NL80211_IFTYPE_P2P_DEVICE:
>> > +               if (wdev->p2p_started) {
>> > +                       wdev->p2p_started = false;
>> > +                       rdev->opencount--;
>> > +               }
>> any reason not calling stop_p2p_device() here as well?
>
> That would be circular? You're supposed to call this when
> stop_p2p_device() gets called, or when you need to delete it for some
> other reason, usually device unplug or such.
>
hmm... so where stop_p2p_device is being called when userspace doesn't call it?

Eliad.

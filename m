Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49963 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2HBRZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 13:25:54 -0400
Received: by obbuo13 with SMTP id uo13so14112720obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 10:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343924789.4471.26.camel@jlt3.sipsolutions.net>
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	<1343842772.4638.15.camel@jlt3.sipsolutions.net>
	<CAMLZHHQdBHZa4NBQ3ygKJSHmKL11ERUWDAtMx0-Qh4OzSoN-SA@mail.gmail.com>
	<1343894552.4458.4.camel@jlt3.sipsolutions.net>
	<CAMLZHHSVediwHaw3f8s1QYNoc_xV55CEUP7wBQu_on-p8WUQJg@mail.gmail.com>
	<1343924789.4471.26.camel@jlt3.sipsolutions.net>
Date: Thu, 2 Aug 2012 11:25:53 -0600
Message-ID: <CAMLZHHR6xp0qxR4Z-BP195pV2XAKm=Q8quU_2dGz4L1_zrS8LA@mail.gmail.com> (sfid-20120802_192557_982333_20F14426)
Subject: Re: cfg80211_disconnected memory leak
From: Daniel Drake <dsd@laptop.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 10:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hmm. Then again, I think we can call cfg80211_process_wdev_events() from
> case NETDEV_UNREGISTER though, probably after removing from the list.
> Maybe you could try that?

That solves the issue - confirmed that kmemleak now shuts up, and with
some added printks to confirm event creation and freeing.
Patch coming up, titled:    cfg80211: process pending events when
unregistering net device

Even if libertas isn't quite doing the right thing here, I think this
is the right thing to do. I guess there are other situations, perhaps
more legitimate, where we can reach this point with events in the
queue.

> I'm not 100% sure about the API in this area right now though, it's been
> a while and I never worked much with this API (rather than the mac80211
> one with auth/assoc/disassoc/deauth.)

I think we both feel that removing it is correct. I'll test this when
I find some free time, and if things seem OK i'll post a libertas
patch in addition to the cfg80211 fix.

Thanks
Daniel

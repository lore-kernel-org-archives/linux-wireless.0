Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55680 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdJFOHQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 10:07:16 -0400
Message-ID: <1507298832.19300.20.camel@sipsolutions.net> (sfid-20171006_160745_679783_7E6099A3)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 06 Oct 2017 16:07:12 +0200
In-Reply-To: <20171006115232.28688-1-toke@toke.dk> (sfid-20171006_135301_379557_9AE74A5E)
References: <20171006115232.28688-1-toke@toke.dk>
         (sfid-20171006_135301_379557_9AE74A5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-06 at 13:52 +0200, Toke Høiland-Jørgensen wrote:
> This adds accounting of each station's airtime usage to mac80211. On
> the RX side, airtime is calculated from the packet length and
> duration.

I think you should probably try to get something here from the driver?
Doing the calculations is really awkward, because you have to take into
account aggregation, etc.

However, I'm not even sure that you _want_ to use RX airtime at all? I
guess this is a fairly fundamental philosophical question, but there's
no way to feed back "you're sending too much" to a station, so if it
starts consuming a lot of airtime with (what we see as) RX, and we
throttle sending to it, then I'm not sure that will have much effect?
Maybe with TCP, but not really with anything else.

You also can't really know what AC this was on, and it doesn't make all
that much sense?

Then again, I'm not even sure yet why you care about the AC at all?
Should fairness really be something that's within an AC?

johannes

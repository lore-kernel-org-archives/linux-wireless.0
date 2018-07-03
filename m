Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58427 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932209AbeGCObY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 10:31:24 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
In-Reply-To: <20180703124725.30917-1-johannes@sipsolutions.net>
References: <20180703124725.30917-1-johannes@sipsolutions.net>
Date: Tue, 03 Jul 2018 16:31:09 +0200
Message-ID: <87601wfl1u.fsf@toke.dk> (sfid-20180703_163130_551328_FF2F9228)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Since (QoS) NDP frames shouldn't be put into aggregation nor are
> assigned real sequence numbers, etc. it's better to treat them as
> non-data packets and not put them on the normal TXQs, for example
> when building A-MPDUs they need to be treated specially, and they
> are more used for management (e.g. to see if the station is alive)
> anyway.

No objections to this per se; but didn't we want to move towards
everything going through the TXQs? Any progress on that front? :)

-Toke

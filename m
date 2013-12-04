Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3LDIY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:24:27 -0500
Message-ID: <1386145463.4284.7.camel@jlt4.sipsolutions.net> (sfid-20131204_092430_404566_F383CEC6)
Subject: Re: [PATCH 2/4] nl80211: back to default bitrate_mask correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Wed, 04 Dec 2013 09:24:23 +0100
In-Reply-To: <CALhHN=otvEjKAWxRvX4KAC4DY39BSeqm-v8mOfyL+M2XLQezYw@mail.gmail.com> (sfid-20131203_170007_540333_5F65286A)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386060648-6020-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1386080437.4393.26.camel@jlt4.sipsolutions.net>
	 <CALhHN=otvEjKAWxRvX4KAC4DY39BSeqm-v8mOfyL+M2XLQezYw@mail.gmail.com>
	 (sfid-20131203_170007_540333_5F65286A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 17:00 +0100, Janusz Dziedzic wrote:
> On 3 December 2013 15:20, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
> >> In case of empty NL80211_ATTR_TX_RATES attribute
> >> in nl80211_set_tx_bitrate_mask() function back to
> >> default bitrate mask.

> > Why?
> In case we will execute:
> iw wlanX set bitrate
> with this patch we will back to default - defined by capabilities
> (driver) startup values for both legacy and ht (and VHT with last
> patch).

Maybe add something like that to the commit log - just a single line
would be ok (e.g. "back to the default bitrate mask, to be able to reset
the state") or so?

> Without this patch I don't see an option how to do that from iw. Or I
> miss something

You're right - how did I ever take this code into the tree? Ugh. It
seems it should be reset more often, but I guess we're stuck with it.

johannes


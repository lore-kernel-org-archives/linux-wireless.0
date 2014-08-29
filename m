Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:45885 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2KDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 06:03:15 -0400
Received: by mail-we0-f182.google.com with SMTP id w62so1960649wes.13
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 03:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409256330.2505.13.camel@jlt4.sipsolutions.net>
References: <1409225636-23923-1-git-send-email-michal.kazior@tieto.com>
	<1409256330.2505.13.camel@jlt4.sipsolutions.net>
Date: Fri, 29 Aug 2014 12:03:13 +0200
Message-ID: <CA+BoTQ=W7Aokeg3XGTxbr5dRZxu5bNYht_xbSVpaKLfwKcH+0Q@mail.gmail.com> (sfid-20140829_120318_658812_EE474231)
Subject: Re: [PATCH] mac80211: fix offloaded BA session traffic after hw restart
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 22:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-08-28 at 13:33 +0200, Michal Kazior wrote:
>
>> Instead of last_seq pick seqno of a first Rxed
>> frame of a given BA session.
>
> Any way to do this without touching the RX path? It's kinda a hotpath :)

Perhaps we could push this to the driver, i.e. export
ieee80211_set_rx_ba_session_ssn() so a driver can update the
ssn/head_seq_num on its own. It would then first request an offloaded
BA and when it sees first frame for that BA it would update the ssn
before calling ieee80211_rx(). This way other drivers won't be
bothered with cruft on the Rx path. The function would have to be
called within a softirq/tasklet/timer unless reorder_lock locking goes
_bh.

I'm worried how a driver would map Rxed frames to a vifs though. I
could probably do it in ath10k indirectly via peer ids mapping but
that would involve more resources than the current approach does.

Is putting an extra if() in the Rx path really worth the concern? I'd
expect branch prediction to take care of this nicely. I guess I could
add an unlikely() too.


Michał

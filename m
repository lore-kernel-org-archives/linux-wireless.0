Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:37945 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750831AbeBULAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 06:00:18 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
In-Reply-To: <5A8D3445.3040300@broadcom.com>
References: <20180219170224.14816-1-toke@toke.dk> <5A8D3445.3040300@broadcom.com>
Date: Wed, 21 Feb 2018 12:00:16 +0100
Message-ID: <87bmgiboan.fsf@toke.dk> (sfid-20180221_120022_510182_E3F6D9CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 2/19/2018 6:02 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This series adds TXQ parameters and statistics that were previously only
>> available through debugfs to the nl80211 userspace interface and the
>> cfg80211 kernel interface. Patches for iw to print the statistics and
>> change the settings are included.
>
> So what is your motivation for having this exposed through nl80211.
> For the average end-user the stats and parameters are fairly fuzzy.

Two reasons, basically:

1. Visibility and statistics; this is basically the same information
   that is available at the qdisc layer (with `tc -s qdisc`), but which
   has been missing on WiFi interfaces ever sine we switched to the TXQ
   structure. Having this available has been quite valuable for
   debugging qdisc setups on wired links, and it's not always feasible
   to ask users to recompile their kernels with debugfs enabled.

2. Having visibility into the queues from userspace makes it possible to
   make decisions based upon (e.g.) which stations are currently
   backlogged. I'm working on a "policy mode" for the airtime fairness
   scheduler which will use this capability.

> So can we expect some manual in which is described what parameter
> should be tweaked based on the retrieved statistics.

Heh, not sure I'll promise a whole manual, but I am happy to write a
blog post (or wiki page if that's better) explaining what these values
mean and what insight one might gain from them.

> Also do you intend to remove the debugfs method? Seems a bit redundant
> to have two mostly identical interfaces in place.

Yes, I am planning to do that in a separate patch; I also have some
patches pending that changes the airtime scheduler and adds airtime
statistics to nl80211. So I am planning to send a cleanup patch once all
that is in place (and I've had time to change my tools that are
currently parsing debugfs :)).

>> Wasn't sure whether to include the updates to nl80211.h in the iw
>> patchset, so I didn't :)
>
> Updating the nl80211.h in iw should be done with a copy from the
> kernel so it has to wait for the kernel patch to be applied (which
> tree I am unsure).

Gotcha. Sort of guessed that from the commit history, but wasn't sure.
Thanks for confirming my suspicions :)

-Toke

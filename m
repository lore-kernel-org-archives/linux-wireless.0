Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:36668 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbcBHJzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 04:55:08 -0500
Received: by mail-yk0-f181.google.com with SMTP id z7so84692621yka.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 01:55:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
References: <1454920723-48071-1-git-send-email-nbd@openwrt.org> <CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 8 Feb 2016 15:24:48 +0530
Message-ID: <CABPxzY+dgMWDeQ=_c0xyFq0g7HcP459b5Ypy3OoUwjDi+eooMA@mail.gmail.com> (sfid-20160208_105513_616840_65FF7AA2)
Subject: Re: [RFC v4] mac80211: add A-MSDU tx support
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2016 at 2:56 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Feb 8, 2016 at 10:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Requires software tx queueing support. frag_list support (for zero-copy)
>> is optional.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>
>
> Ok - looks fine, but... and here comes the hard stuff.
> The frame size in the PLCP is limited in a way that you can't - from a
> spec POV - enable A-MSDU for low rates. Of course, you don't want to
> do that for low rates at all regardless of the spec.
> Since you build the A-MSDU in the mac80211 Tx queue which is not aware
> of the link quality, how do we prevent A-MSDU if the rate is low /
> dropping.
> I'd even argue that when the rates get lower, you'll  have more
> packets piling up in the software queue and ... even more chance to
> get A-MSDU in the exact case where you really want to avoid it?

Similar to triggering AMPDU setup, we should put this control
in RC (minstrel) to start/stop AMSDU based on link quality/if the rates
drop below a pre-defined MCS (or) only for best-throughput rates.

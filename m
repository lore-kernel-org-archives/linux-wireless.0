Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62903 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KLVwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:52:30 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so4067532qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:52:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352752959.12957.2.camel@jlt4.sipsolutions.net>
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com> <1352752959.12957.2.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 13:52:09 -0800
Message-ID: <CAG6hwVPwYX5Uw+_Y9enGeubeCkWi3OM-qs+qAvKDjwTrNhS0uw@mail.gmail.com> (sfid-20121112_225234_421356_61D9339F)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 12:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-11-12 at 10:38 -0800, Thomas Pedersen wrote:
>
>> +     if (ieee80211_have_rx_timestamp(rx_status))
>> +             /* time when timestamp field was received */
>> +             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
>> +                                                    24 + 12 +
>> +                                                    elems->total_len + 4,
>> +                                                    24);
>
> This doesn't seem quite right, the FCS isn't accounted for correctly?

That's what the +4 is for. Is this wrong?

> I think it might be wortwhile to pass the SKB to the function instead of
> rx_status though, then it could get skb->len and check whether or not
> FCS was before the timestamp

How would you check this?

> (which, btw, you should mention in the documentation for the new flag!)

I'll make it clear MACTIME_END includes the FCS.

> And then I suspect the check for IEEE80211_HW_RX_INCLUDES_FCS is also
> incorrect -- even if the driver didn't report the FCS maybe the
> timestamping semantic was such that it was after the FCS?

Right, if the driver doesn't report the FCS, the radiotap code will
add an extra 4 bytes to account for this.

Thomas

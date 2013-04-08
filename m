Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63875 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935573Ab3DHTay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 15:30:54 -0400
Received: by mail-bk0-f46.google.com with SMTP id je9so3301866bkc.33
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 12:30:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365446248.25475.17.camel@jlt4.sipsolutions.net>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-3-git-send-email-thomas@cozybit.com> <1365446248.25475.17.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 8 Apr 2013 12:30:32 -0700
Message-ID: <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com> (sfid-20130408_213102_576564_FC66898C)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 8, 2013 at 11:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
>> Have ieee80211_queue_stopped() return a bitmap of enum
>> queue_stop_reasons while checking queue status. This is
>> handy when we care about the queue stop reason codes.
>
> Nack. The driver must not care about the reasons, they're purely
> internal to mac80211.

OK those functions are exported to the drivers. The 'enum
queue_stop_reason' is defined in ieee80211_i.h, so the driver wouldn't
be able to interpret them anyway?

Would you prefer a utility function internal to mac80211 which does
return the reason, or just the following pattern?

if (ieee80211_queue_stopped(hw, queue)) {
    qreason = hw_to_local(hw)->queue_stop_reasons[queue];
    if (qreason & ~(ALLOWED_QUEUE_STOP_REASONS))
        something;
}

Thanks,

-- 
Thomas

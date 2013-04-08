Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34098 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935803Ab3DHT5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 15:57:35 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk13so3255298bkc.17
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 12:57:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365449914.25475.20.camel@jlt4.sipsolutions.net>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-3-git-send-email-thomas@cozybit.com> <1365446248.25475.17.camel@jlt4.sipsolutions.net>
 <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com> <1365449914.25475.20.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 8 Apr 2013 12:57:14 -0700
Message-ID: <CAG6hwVOAwtngWU3uEueG7hZX3z5dxLLc8c8-Vd7Q+e93wM-UaQ@mail.gmail.com> (sfid-20130408_215744_691890_C570AD6D)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 8, 2013 at 12:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-04-08 at 12:30 -0700, Thomas Pedersen wrote:
>
>> OK those functions are exported to the drivers. The 'enum
>> queue_stop_reason' is defined in ieee80211_i.h, so the driver wouldn't
>> be able to interpret them anyway?
>
> Oh, you're way underestimating the creativity of driver authors :-)
>
>> Would you prefer a utility function internal to mac80211 which does
>> return the reason,
>
> That seems fine, although a bit more inefficient?
>
>> or just the following pattern?
>>
>> if (ieee80211_queue_stopped(hw, queue)) {
>>     qreason = hw_to_local(hw)->queue_stop_reasons[queue];
>>     if (qreason & ~(ALLOWED_QUEUE_STOP_REASONS))
>>         something;
>> }
>
> That seems racy? Even asking whether it's stopped is racy though, what
> are you even trying to accomplish?

Yeah, that's why I'd like to get the reason the first time.

_h_mesh_fwding() checks whether the outgoing queue is stopped, to
avoid piling frames on the pending queue if the outgoing medium is
busy. I guess the idea was to avoid queueing frames faster than the
hardware could unload them. Maybe this doesn't actually happen, but we
can be a little bit smarter about when to drop forwarded frames. Like
if skbs are just being added to the outgoing queue, we probably
shouldn't.

This patch and the next one show a small improvement in throughput and
loss % in the forwarding path.

-- 
Thomas

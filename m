Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2BNMqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 07:46:14 -0500
Received: by pbcun15 with SMTP id un15so407061pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 04:46:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329217171.3941.10.camel@jlt3.sipsolutions.net>
References: <CAGXE3d-ydmV8qrtihSHCNBtkTxT8M=JCACBZFuP+Ne3cQ1WVow@mail.gmail.com>
	<1329217171.3941.10.camel@jlt3.sipsolutions.net>
Date: Tue, 14 Feb 2012 13:46:14 +0100
Message-ID: <CAGXE3d9yp33bUu1Rzfur8Rt+uE_LZFZx_MAYN13E46_=Ftw3xQ@mail.gmail.com> (sfid-20120214_134624_209063_1E053535)
Subject: Re: DELBA processed in workqueue too slow?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 14, 2012 at 11:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-02-06 at 16:48 +0100, Helmut Schaa wrote:
>> Hi,
>>
>> since all action frames are handled in the iface workqueue the following
>> situation can cause problems on slow devices in AP mode:
>>
>> - data stream AP -> STA with established TX BA session
>> - peer sends a DELBA to tear the APs TX BA session down
>> - new frames are still send as AMPDU but the receiver doesn't BlockAck
>>   them anymore since it assumes the BA session is already teared down.
>> - DELBA gets processed
>
>> Hence, most frames between receiving the DELBA and actually processing
>> it are basically lost. This can easily make TCP streams getting stuck for a
>> few seconds :(
>
> Why are they lost? They haven't been acknowledged so wouldn't they be
> retransmitted?

Yes, they are retried till the retransmit timeout is reached, but they
are retried
as AMPDU again (rt2x00 does this in hw).

> In any case, it seems the easiest solution may be to stop queues?

Not sure, the action frame processing in the workqueue was added
last year in this patch:

commit bed7ee6e44cb7633a4f9821688a6c7ae977615ed
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jun 10 10:21:35 2010 +0200

    mac80211: always process blockack action from workqueue

    To prepare for making the ampdu_action callback
    sleep, make mac80211 always process blockack
    action frames from the skb queue. This gets rid
    of the current special case for managed mode
    interfaces as well.

Before that it was directly processed in the rx path.

> But to
> really make this fool-proof you'd also have to tell the driver to
> release all its internal buffers -- and you're never going to solve the
> race completely.

Correct, we will always have a small race here but getting it as small
as possible
seems reasonable to me :)

Maybe we could at least set HT_AGG_STATE_STOPPING already in the rx
path such that the aggregation logic won't continue sending AMPDUs
to the driver and instead buffers them till the work queue is processed ...

Helmut

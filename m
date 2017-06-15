Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34827 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdFORkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:40:11 -0400
Received: by mail-oi0-f52.google.com with SMTP id e11so11756190oia.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jun 2017 10:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c291bc94-d1cd-5fca-dba0-d1b617ea0cb8@candelatech.com>
References: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
 <CANUX_P2LrrNzLWRtOERnSyu0q=C4u26V+iJbpxqUssYb80PzEg@mail.gmail.com>
 <485de26b-87ae-6977-dbb2-bc98378d3aeb@candelatech.com> <CANUX_P1ppTkXfXS-3RcocB_GBf5earZgZPM3fMiFem2jpRoPZA@mail.gmail.com>
 <c291bc94-d1cd-5fca-dba0-d1b617ea0cb8@candelatech.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 15 Jun 2017 20:40:10 +0300
Message-ID: <CANUX_P157H0rNV3QmODKTejjYb4smwzMi2N9a9dmwbrZ-G2mkw@mail.gmail.com> (sfid-20170615_194016_933084_4DCAA070)
Subject: Re: Question on flushing and deauth frames
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> Keep in mind that this code is also called when roaming, any
>> additional operations will slow down the roaming process. Not all the
>
>
> This is a reason to not retransmit, but logically the flush(drop=false) is
> supposed to wait for the frame to be transmitted anyway, and at that point,
> tx-status should be immediately available.
>

I can't disagree here although waiting for the Tx status can be tricky
for the low level drivers that don't implement tx_status.

>> drivers support tx_status, but I think that this could be implemented
>> internally in ath10k. In iwlwifi, we just wait until the queues get
>> empty without dropping the packets.
>
>
> When you support virtual stations and a fat firmware, that can be tricky to
> implement.
>
> From your description, are you waiting on a single vdev, or multiple when
> you flush?

In the past, we had queues per vdev. So that we had to wait for the
queues of the vdev. Note that Intel is more focused on the BSS
scenario in which vdev = station pretty much. I understand that you
are more focused on the AP scenario, but that shouldn't really delete
stations all that often, right?

> If multiple, then waiting for tx status of just the deauth frame should be
> faster
> on average than waiting for the flush since you don't have to flush the
> other
> vdevs.

True. Well, on Intel devices, we work with Tx queues, and now we have
a Tx queue for each ra/tid. Yes it limits the number of peers we can
support, but as I said, we are less AP mode oriented.

>
> Whether drivers support a correct tx-status, I think all of them report
> *some* tx
> status...that is how mac80211 knows it can clean up the frame?  That would
> be enough
> to know that the frame at least went through the tx logic and thus was
> flushed.

It is an option. Maybe mac80211 could pass the pointer to the skb it
is waiting for in the flush(drop=false) call and that would make it
easier for you to wait for it internally in ath10k?

I'll let Johannes decide here :)

>
>> Of course, I am giving my *non authoritative* opinion :)
>
>
> I appreciate it none the less!
>
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>

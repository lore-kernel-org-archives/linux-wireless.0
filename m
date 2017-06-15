Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:36465 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdFOGSx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 02:18:53 -0400
Received: by mail-ot0-f172.google.com with SMTP id s7so3288432otb.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 23:18:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
References: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 15 Jun 2017 09:18:51 +0300
Message-ID: <CANUX_P2LrrNzLWRtOERnSyu0q=C4u26V+iJbpxqUssYb80PzEg@mail.gmail.com> (sfid-20170615_081901_060549_24AC91D4)
Subject: Re: Question on flushing and deauth frames
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> ath10k is a bit weird about flushing frames, and at least my variant of the wave-2
> firmware does not always put the deauth frame on the air when deleting stations.
>
> It will likely not be much fun to fix this.  I was wondering if the code below
> from ieee80211_set_disassoc() could (easily?) be made to wait for a tx-status of the deauth frame
> instead of trying to force a flush?

That's exactly what it does:

>
>        /*
>          * drop any frame before deauth/disassoc, this can be data or
>          * management frame. Since we are disconnecting, we should not
>          * insist sending these frames which can take time and delay
>          * the disconnection and possible the roaming.
>          */
>         if (tx)
>                 ieee80211_flush_queues(local, sdata, true);

Remove all the pending data frames from the queues to clear the way
for the deauth.
Note the drop=true

>
>         /* deauthenticate/disassociate now */
>         if (tx || frame_buf)
>                 ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
>                                                reason, tx, frame_buf);
>

Send the deauth.

>         /* flush out frame - make sure the deauth was actually sent */
>         if (tx)
>                 ieee80211_flush_queues(local, sdata, false);
>

Wait for the deauth (drop=false).
The question here is how ath10k implements the flush(, drop=false)

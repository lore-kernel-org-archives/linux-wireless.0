Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 1.mo69.mail-out.ovh.net ([178.33.251.173]:56619 "EHLO
        1.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbeCYUB7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Mar 2018 16:01:59 -0400
Received: from player763.ha.ovh.net (unknown [10.109.120.149])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id E42B89B93
        for <linux-wireless@vger.kernel.org>; Sun, 25 Mar 2018 21:45:18 +0200 (CEST)
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
To: Ben Greear <greearb@candelatech.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180324102921.9814-1-alexander.wetzel@web.de>
 <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
Message-ID: <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de> (sfid-20180325_220206_212068_56669A68)
Date: Sun, 25 Mar 2018 21:45:10 +0200
MIME-Version: 1.0
In-Reply-To: <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> What will happen to drivers like ath10k that cannot do software
encrypt/decrypt?
>
> ath10k can support multiple key-ids as far as I can tell,
> so maybe it would just never hit this code?

Still learning how that all fits together, but I'm sure any card using
mac80211 will also use ieee80211_key_replace, including ath10k.

We are in a race with the remote station there is no chance that we can
switch over exactly at the same time. If we can't fall pack to software
encryption we'll just have to drop some more packets.

I'm pretty sure mac80211 will just encrypt a frame in software and
send it to ath10 for processing once we have removed the key from the hw
in the same way as for any other card.
My expectation here would be, that the driver detects and drops the
pre-encrypted frames it no longer has a hw key for.

Unfortunately this is just an assumption, since I haven't found the code
handling this case in ath10k. And even if true this could well cause
some undesired warning messages.

I guess we should therefore make sure we do not send out any packets in
the critical time window.

Now stopping and flushing the queues seems to be bad idea which could
cause a real performance impact for on a busy AP with many stations and
rekeys enabled...
Luckily it looks like we can instead just set KEY_FLAG_TAINTED for the
old key to make sure we stop sending packets till the rekey is done.

That should cause ieee80211_tx_h_select_key to drop all packets without
a new per-packet check and also should cover potential undesired side
effects, isn't it?


Regards,

Alexander

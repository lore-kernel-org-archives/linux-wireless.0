Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49778 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965641AbeFOLdP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:33:15 -0400
Message-ID: <1529062392.10037.7.camel@sipsolutions.net> (sfid-20180615_133319_007854_E3EA5F34)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Fri, 15 Jun 2018 13:33:12 +0200
In-Reply-To: <20180515102202.2021-1-alexander.wetzel@web.de> (sfid-20180515_204001_215652_02257D78)
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
         (sfid-20180515_204001_215652_02257D78)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-15 at 12:22 +0200, Alexander Wetzel wrote:
> Rekeying a pairwise key with encryption offload and only keyid 0 has two
> potential races which can freeze the wlan conection till rekeyed again:
> 
>  1) For incomming packets:
>     If the local STA installs the key prior to the remote STA we still
>     have the old key active in the hardware for a short time after
>     mac80211 switched to the new key.
>     The card can still hand over packets decoded with the old key to
>     mac80211, bumping the new PN (IV) value to an incorrect high number and
>     tricking the local replay detection to drop all packets really sent
>     with the new key.
> 
>  2) For outgoing packets:
>     If mac80211 is providing the PN (IV) and hands over the cleartext
>     packets for encryption to the hardware immediately prior to a key
>     change the driver/card may process the queued packets after
>     switching to the new key.
>     This will immediatelly bump the PN (IV) value on the remote STA to
>     an incorrect high number, also freezing the connection.
> 
> Both issues can be prevented by first replacing the key in the HW and
> makeing sure no aggregation sessions are running during the rekey.

Getting back to this, am I understanding correctly that in the latter
(outgoing) case this would cause 

Also, I think you should probably describe better why the aggregation
session stuff is needed. I'm already thinking there times about it again
...


> +               ieee80211_sta_tear_down_BA_sessions(
> +                   sta, AGG_STOP_LOCAL_REQUEST);

minor indentation issue here

> +       ieee80211_flush_queues(key->local, key->sdata, false);
> +       ieee80211_key_disable_hw_accel(key);

I'm not sure all drivers implement drv_flush() [correctly], what happens
if they don't? I guess some packets end up being transmitted in clear
text or a dummy key, unless the hardware/firmware knows about this and
drops them?

Perhaps that means we should make this whole thing opt-in, and leave it
up to driver authors to first validate that they handle the flushing
correctly?


Regarding the code: the whole dance you do with ieee80211_key_link() and
ieee80211_key_replace() seems to be a little pointless because you still
add the key to debugfs and then free it, on errors that is?

johannes

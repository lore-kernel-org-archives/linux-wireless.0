Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 10.mo6.mail-out.ovh.net ([87.98.157.236]:37475 "EHLO
        10.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbeDHUtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Apr 2018 16:49:41 -0400
Received: from player778.ha.ovh.net (unknown [10.109.120.92])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 9A18314E59A
        for <linux-wireless@vger.kernel.org>; Sun,  8 Apr 2018 22:31:11 +0200 (CEST)
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180324102921.9814-1-alexander.wetzel@web.de>
 <1522156412.3050.18.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <8b502191-0af1-bfeb-a205-4dc52ae769a8@web.de> (sfid-20180408_224948_220708_8899D08F)
Date: Sun, 8 Apr 2018 22:31:01 +0200
MIME-Version: 1.0
In-Reply-To: <1522156412.3050.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Fundamentally, nothing stops this from happening, as we (still) don't
> have any synchronization between transmission and key configuration.
I'm currently working on that and nearly have a rfc version ready to
share. Unfortunately I still continue to find issues to iron out.
May be some more days to sort the latest and hopefully the last issue.

The current version is already fixing the issue with my ath9k AP but it
looks like it's now racing with eapol #4 and needs more tweaks.

> Also, in this case it seems pretty obvious how you can leak packets
> unencrypted, since the HW now no longer has a key. This might not even
> be fixable if the NIC cannot reject packets that are supposed to be
> encrypted to a key that's no longer valid in the HW.
>
Exactly. I'm planing to avoid that issue by just dropping (and flushing)
all packets while mac80211 replaces the keys. Queuing them in mac80211
should also be possible, but I abandoned that for now  - after figuring
out that the PS code currently using those queues allows only an AP (or
a mesh) to queue. Still looks doable, but too invasive for now.

> I don't really see how the unencrypted leak happens with the current
> code though, unless the driver somehow first invalidates the key and
> then installs a new one, and there's a race with this?

Well, current mac80211 code always handling a key replace in that order:
- set the new key in mac80211
- remove the key from hw
- delete the old key
- enable hw accel for new key

Problem here is, that when we remove the key from the hw we first drop
the key from the card and after clear KEY_FLAG_UPLOADED_TO_HARDWARE.
So yes, we have a short window where mac80211 incorrectly assumes the hw
is encrypting packets when it's not.

That is trivial to fix, we just have to remove the flag prior to calling
drv_set_key in ieee80211_key_disable_hw_accel.

This will of course hand over software encrypted packets to the driver
again, but this also happens when we enable hw encryption and therefore
should be pretty well tested with all drivers.

> 
> Ultimately, I don't think this patch is good enough. We clearly have a
> problem here with leaking unencrypted frames, if the device can't reject
> them (and I can't really fault it for that), so in order to really fix
> it we'd have to completely flush all software and hardware queues, and
> then start again with a new key - and for that we don't even need to
> disable HW crypto.

I agree, but we still have to disable the hw encryption in the final
solution, haven't we?
If not the remote STA may still send us some frames with the old IV and
key and our RX will decode and hand them over to mac80211. And mac80211
will bump the IV for the new key to the value the old had.

Or is there a way mac80211 can see which key was used to decode the
frame? I did not see anything, but did not dug deeper.

Alexander

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44146 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbeDIHZ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 03:25:59 -0400
Message-ID: <1523258757.3076.5.camel@sipsolutions.net> (sfid-20180409_092608_123293_9907C4F4)
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Apr 2018 09:25:57 +0200
In-Reply-To: <8b502191-0af1-bfeb-a205-4dc52ae769a8@web.de>
References: <20180324102921.9814-1-alexander.wetzel@web.de>
         <1522156412.3050.18.camel@sipsolutions.net>
         <8b502191-0af1-bfeb-a205-4dc52ae769a8@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-04-08 at 22:31 +0200, Alexander Wetzel wrote:

> Exactly. I'm planing to avoid that issue by just dropping (and flushing)
> all packets while mac80211 replaces the keys. 

That would again need driver support though, and I'm not sure all
drivers implement the flush method (correctly) today.

> Queuing them in mac80211
> should also be possible, but I abandoned that for now  - after figuring
> out that the PS code currently using those queues allows only an AP (or
> a mesh) to queue. Still looks doable, but too invasive for now.

Yeah, the whole queueing is messy for sure.

> > I don't really see how the unencrypted leak happens with the current
> > code though, unless the driver somehow first invalidates the key and
> > then installs a new one, and there's a race with this?
> 
> Well, current mac80211 code always handling a key replace in that order:
> - set the new key in mac80211
> - remove the key from hw
> - delete the old key
> - enable hw accel for new key
> 
> Problem here is, that when we remove the key from the hw we first drop
> the key from the card and after clear KEY_FLAG_UPLOADED_TO_HARDWARE.
> So yes, we have a short window where mac80211 incorrectly assumes the hw
> is encrypting packets when it's not.
> 
> That is trivial to fix, we just have to remove the flag prior to calling
> drv_set_key in ieee80211_key_disable_hw_accel.

Oh, ok. That's indeed not such a big deal then. This code was just never
really meant to work properly while operating on this key - typically it
either gets invoked when the connection is already no longer authorized,
or when swapping GTK where we only RX anyway, or on AP side when
swapping GTK the second time, but then that key has (usually) long been
unused.

> This will of course hand over software encrypted packets to the driver
> again, but this also happens when we enable hw encryption and therefore
> should be pretty well tested with all drivers.

No, it doesn't generally happen with all drivers, because we usually
install keys before we have a functioning datapath up. In the case of
ath10k, it's even not possible to send those frames, as has been pointed
out in this thread before.

> > Ultimately, I don't think this patch is good enough. We clearly have a
> > problem here with leaking unencrypted frames, if the device can't reject
> > them (and I can't really fault it for that), so in order to really fix
> > it we'd have to completely flush all software and hardware queues, and
> > then start again with a new key - and for that we don't even need to
> > disable HW crypto.
> 
> I agree, but we still have to disable the hw encryption in the final
> solution, haven't we?

I don't know. Honestly, I'm not even sure this problem is worth solving
right now. AFAICT it's a pretty special and fringe configuration to
enable PTK rekeying to start with, and the latest 802.11 allows using
non-zero key ID for PTKs, so we could implement that on both AP/client
sides instead, and thus really solve the problem without any races.

> If not the remote STA may still send us some frames with the old IV and
> key and our RX will decode and hand them over to mac80211. And mac80211
> will bump the IV for the new key to the value the old had.

Yes, this does happen.

> Or is there a way mac80211 can see which key was used to decode the
> frame? I did not see anything, but did not dug deeper.

Not right now. I guess you could add one, but it may be difficult to
even know. I think iwlwifi might have a "key color" bit it reports up
and that you could use (just swap it every time you overwrite the key),
but I guess not all hardware would have that.

johannes

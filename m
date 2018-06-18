Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59088 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935854AbeFRV1R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 17:27:17 -0400
Message-ID: <1529357234.3092.57.camel@sipsolutions.net> (sfid-20180618_232721_731440_D14626DB)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Mon, 18 Jun 2018 23:27:14 +0200
In-Reply-To: <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
         <1529062392.10037.7.camel@sipsolutions.net>
         <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > >  2) For outgoing packets:
> > >     If mac80211 is providing the PN (IV) and hands over the cleartext
> > >     packets for encryption to the hardware immediately prior to a key
> > >     change the driver/card may process the queued packets after
> > >     switching to the new key.
> > >     This will immediatelly bump the PN (IV) value on the remote STA to
> > >     an incorrect high number, also freezing the connection.
> > > 
> > > Both issues can be prevented by first replacing the key in the HW and
> > > makeing sure no aggregation sessions are running during the rekey.
> > 
> > Getting back to this, am I understanding correctly that in the latter
> > (outgoing) case this would cause 
> 
> I don't get the point here...Shall I flesh out the description of the
> exiting races in the code a bit more?

You couldn't, I didn't finish this sentence for some reason ... or wrote
and then deleted it by accident?

I meant to say:

Am I understanding correctly that in the latter (outgoing) case this
might cause unencrypted packets to be transmitted?

I talked about that more below.

> > Also, I think you should probably describe better why the aggregation
> > session stuff is needed. I'm already thinking there times about it again
> > ...
> 
> I'll rework the description and will go into more details.
> Here a first quick draft what I plan amend to the commit message. But
> this got kind of long:
> ...
> Both issues can be prevented by first replacing the key in the HW and
> making sure no aggregation sessions are running during the rekey.
> 
> The "core" of the fix is to change the old unicast key install sequence
>  - atomic switch over to the new key in mac80211
>  - remove the old key in the HW and mac80211
>  - add new key in the hw
> to
>  - mark the old key as tainted to drop TX packets trying to use it
>  - remove the old key in the HW and mac80211
>  - add new key to the HW
>  - atomic switch over to the new key in mac80211
> 
> Since the new key is not marked as tainted the last step will also
> enable TX again.
> 
> With the new procedure the HW will be unable to decode packets still
> encrypted with the old key prior to switching to the new key in
> mac80211. Locking down TX during the rekey makes sure that there are no
> outgoing packets mac80211 prepared for the old key the hw can encrypt
> with the new key.

> We can now decrypt and get incoming packets while mac80211 is still on
> the old key, but the worst (and most likely) case is now, that the
> replay detection will drop those packets till mac80211 also switch over.

This actually is somewhat problematic, at least for TKIP it could cause
countermeasures. Should we exclude TKIP here somehow?

I don't think we can disable countermeasures because then we could be
attacked in this time window without starting them, and we have a really
hard time distinguishing attacks and "fake" replays.

> Instead of checking PN from old key packets against the new key (and
> bump the PN for the new key, killing our connection) we are now checking
> the PN from new key packets against the old key (and drop a few packets
> during rekey only).
> 
> When using TX aggregation we get an additional race which can poison the
> remote station:
> When a TX aggregation session is running during the key replacement it's
> possible that one of the frames send out prior of the TX lock down (old
> key) got lost and will be repeated after the TX lock down is lifted,
> using the old skb prepared for the old key with the new installed key in
> the hardware. This would bump the PN counter of our peer to an incorrect
> value and breaking the RX for the remote station.

Right, this is what I had forgotten about already.

> > > +       ieee80211_flush_queues(key->local, key->sdata, false);
> > > +       ieee80211_key_disable_hw_accel(key);
> > 
> > I'm not sure all drivers implement drv_flush() [correctly], what happens
> > if they don't? I guess some packets end up being transmitted in clear
> > text or a dummy key, unless the hardware/firmware knows about this and
> > drops them?
> 
> Flushing the queues is not needed for to the logic and only a workaround
> for drivers like ath9k which can still send out packets for a key which
> was already deleted. When the driver guarantees that after the key
> deletion function returns to mac80211 that there will be no more packets
> send out prepared for the old key it can be removed.

What will happen for other kinds of packets though?

For iwlwifi, for example, the key material is added into the key. It
thus doesn't have this race in the first place, but it will definitely
send out packets after 

Btw - perhaps that means we should avoid the complicated mechanisms like
TX aggregation shutdown for keys that the driver marks as being safe?
Clearly for iwlwifi (at least CCMP and before, not with the longer keys
in GCMP-256) the race can't possibly happen.

In other drivers though, I worry that removing the key will *not* mean
that there are no more packets transmitted with it. If you have a key
cache in hardware then it might just be that marking the cache entry as
invalid means the encryption will be skipped when encountering a packet
to be transmitted with the key from a given (in the packet) key cache
index, and then the frame goes out unprotected?

> I tried to minimize the changes, but if we can consider an API change I
> would ask the drivers to provide a new function to switch directly from
> one key to another, without the need to delete it first. And to
> guarantee there, that after the function returns no packets with
> prepared for the old key can be sent out. Including retransmissions.

This would be pretty tricky for most drivers though.

> That way drivers like ath9k should be able to directly program the new
> key and drivers for cards where this is not saving time can simply call
> delete and add internally.

I don't think that's really all that much savings, time-wise? But it
might address the "unprotected TX" issue I worry about above.

> > Regarding the code: the whole dance you do with ieee80211_key_link() and
> > ieee80211_key_replace() seems to be a little pointless because you still
> > add the key to debugfs and then free it, on errors that is?
> 
> I hope the more verbose description above explains that part.
> The intend of the dance is to finalize the switch to the new key in the
> hardware prior to doing it in mac80211. It's probably possible to bypass
> more of the code, but I did not touch the logic besides what I needed,
> understand or verified to be harmless.

I'm just saying that

err = add_to_hardware();

add_to_debugfs();

if (err)
	remove_from_debugfs();

is pointless :-)

johannes

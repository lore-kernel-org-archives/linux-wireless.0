Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60702 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbeC0NNf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:13:35 -0400
Message-ID: <1522156412.3050.18.camel@sipsolutions.net> (sfid-20180327_151339_027603_E5210A84)
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 15:13:32 +0200
In-Reply-To: <20180324102921.9814-1-alexander.wetzel@web.de>
References: <20180324102921.9814-1-alexander.wetzel@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-03-24 at 11:29 +0100, Alexander Wetzel wrote:
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

Correct for both, yes, this is a known issue.

> Both issues can be prevented by deleting the key from the hardware prior
> to switching to the new key in mac80211, falling back to software
> encryption/decryption till the switch to the new key is completed.

This, however, is not true in general. It only works if the queues are
flushed quickly enough between removing the key and setting a new one.
Otherwise, the same is still possible, e.g. on TX:

 * many packets are in the (HW) queue
 * enqueue packet with PN=0x10000
 * turn off HW crypto
   [here I can actually see how you might now leak packets as
    unencrypted that are already in the queue]
 * install a new key
 * turn on HW crypto for the new key
 * process packet with PN=0x10000

Fundamentally, nothing stops this from happening, as we (still) don't
have any synchronization between transmission and key configuration.

Also, in this case it seems pretty obvious how you can leak packets
unencrypted, since the HW now no longer has a key. This might not even
be fixable if the NIC cannot reject packets that are supposed to be
encrypted to a key that's no longer valid in the HW.

I don't really see how the unencrypted leak happens with the current
code though, unless the driver somehow first invalidates the key and
then installs a new one, and there's a race with this?

Ultimately, I don't think this patch is good enough. We clearly have a
problem here with leaking unencrypted frames, if the device can't reject
them (and I can't really fault it for that), so in order to really fix
it we'd have to completely flush all software and hardware queues, and
then start again with a new key - and for that we don't even need to
disable HW crypto.


(FWIW, iwlwifi mostly avoids this problem on TX - at least for keys
other than GCMP-256 - by embedding the key material into the frame
itself, so we simply don't have such a race condition there)

johannes

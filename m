Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbeGIHNu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 03:13:50 -0400
Message-ID: <1531120427.3298.1.camel@sipsolutions.net> (sfid-20180709_091358_873917_57F9C20C)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Mon, 09 Jul 2018 09:13:47 +0200
In-Reply-To: <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
         <1529062392.10037.7.camel@sipsolutions.net>
         <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
         <1529357234.3092.57.camel@sipsolutions.net>
         <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
         <1530267147.3481.78.camel@sipsolutions.net>
         <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
         <1530611484.4735.18.camel@sipsolutions.net>
         <b1913512-7d33-cd9b-5eb5-4d7f367eb41a@web.de>
         <1530662787.4735.59.camel@sipsolutions.net>
         <da9c6878-56ff-3a63-07cf-dae7813173a2@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I'll try that, but will probably take another week. My main main work
> station got severe file system corruption, forcing me to reinstall it
> from scratch. I suspect it was something in the wireless testing kernel
> 4.18-rc1 (944ae08d4e71) related to either btrfs or the ssd disk but
> since I needed the system just started over and avoid to run 4.18 if I
> do not have a full backup...

Ouch. FWIW, it's possible to run inside a VM with PCI(e) devices
outside, at least on some machines.

> > > hostapd or wpa_supplicant are "ordering" mac80211 to install a new key
> > > and are implementing the state machine and are in a good position to
> > > handle the fallout... at least theoretically.
> > 
> > Ideally it would even know beforehand that we don't want to handle the
> > PTK rekeying, and then could reconnect instead of going through the
> > handshake.
> > 
> 
> Don't see how we could do that in the kernel, all the relevant
> information is handled in the state machine. I guess an API extension
> telling hostap/supplicant if we can handle rekeys or not would tbe he
> only way to avoid that.

Right. Not really much point for now I guess.

> > So I think we're probably better off accepting the set_key but not
> > actually using it, and instead disconnecting... even if that's awkward
> > and should come with a big comment :-)
> 
> Instead of returning an error I'll change the code to accept the rekey
> but do nothing with it. (Basically delete the new key and keep the old
> active).
> And of course calling ieee80211_set_disassoc() prior to return "success".

Right. Did you handle/consider modes other than BSS/P2P client btw?

> Let's see how the supplicant will react on a disassoc while doing a rekey...

Shouldn't matter to it, I'd think.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55114 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbeGDAGa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 20:06:30 -0400
Message-ID: <1530662787.4735.59.camel@sipsolutions.net> (sfid-20180704_020705_942849_B25B53D4)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Wed, 04 Jul 2018 02:06:27 +0200
In-Reply-To: <b1913512-7d33-cd9b-5eb5-4d7f367eb41a@web.de>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-03 at 21:54 +0200, Alexander Wetzel wrote:

> > I think easier would be to just disconnect ourselves? At least if we're
> > in managed mode...
> > 
> 
> I still have much to learn about 802.11, but so far I did not see way to
>  directly disconnect a STA. (Maybe spoofing a "signal lost" event or
> something like that, but I fear complications by losing the sync with
> the remote STA.) Is there any call/signal you have in mind I could test?

ieee80211_set_disassoc(), this can also send a frame out to indicate to
the AP that we're disconnecting instead.

> hostapd or wpa_supplicant are "ordering" mac80211 to install a new key
> and are implementing the state machine and are in a good position to
> handle the fallout... at least theoretically.

Ideally it would even know beforehand that we don't want to handle the
PTK rekeying, and then could reconnect instead of going through the
handshake.

> Instead I get a pop up asking for the PSK. Entering it reconnects
> normally. Cancel the prompt disconnect till a manual reconnect.
> I suspect NetworkManager is handling the rekey like the initial key
> install and then assumes the PSK is wrong. Hardly surprising but also
> highly visible to the users.

That's pretty awkward.

> But then only to those using the now broken rekey...

Yeah, but you don't necessarily control that - i.e. client device and AP
might have different owners :-)

> Using wpa_supplicant directly reconnects after ~15s.
> It also assumes the key is wrong and seems to rate limit the connection
> attempts. Here a log with wpa_supplicat running in the console and dmesg
> -wT output on top of that:

So I think we're probably better off accepting the set_key but not
actually using it, and instead disconnecting... even if that's awkward
and should come with a big comment :-)

johannes

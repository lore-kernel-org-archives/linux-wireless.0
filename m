Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:39200 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726788AbeITOyz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:55 -0400
Date: Thu, 20 Sep 2018 12:12:21 +0300
From: Jouni Malinen <j@w1.fi>
To: Mathy Vanhoef <vanhoefm@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: SAE authentication frames in client mode
Message-ID: <20180920091221.GA7326@w1.fi> (sfid-20180920_111249_719976_3F91F13E)
References: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com>
 <20180919182334.GA15542@w1.fi>
 <CAFXAJYwa2usdkuvyjdE79iEuzqbZy6J=LYM=UhdAmLbwFP4KLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFXAJYwa2usdkuvyjdE79iEuzqbZy6J=LYM=UhdAmLbwFP4KLA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2018 at 12:55:10AM +0200, Mathy Vanhoef wrote:
> That figure only appears to be an example. It doesn't say an exchange
> must ("shall") follow that order. So I don't see where the standard
> puts a constraint on how the authentication frames are exchanged.

I know this figure is not a normative requirement, but it is a
convenient location to point to for showing that specific sequence. I
did discuss this in the IEEE 802.11 working group when working on the
SAE implementation for infrastructure BSS case and the conclusion from
that discussion was that it is better to follow the common sequence of
STA->AP->STA round trips for the Authentication frames and have the STA
be the one taking care of retransmissions, if needed. I thought we ended
up clarifying that in the standard text somewhere as well, but that was
years ago and I do not remember how exactly this got documented. It is
possible that there would be benefit from adding a more explicit
requirement in REVmd. In any case, this sequence is the one that is
being implemented and enforced for implementations of WPA3.

> A related observation is that retransmissions of the Confirm message
> are done by the kernel? Unfortunately this means the Send-Confirm
> field is not being incremented (as per 12.4.8.6.5). In practice we
> indeed see that this field is not being incremented for retransmitted
> Confirm frames (when using wpa_supplicant). This means that if the
> first Confirm frame sent by the AP is lost, the handshake will fail,
> since the AP will not accept retransmissions with the same
> Send-Confirm counter (and hence won't retransmit its own Confirm
> frame).

For mac80111-based drivers, there is indeed retransmission cases in the
kernel implementation for authentication and association frames. SAE is
not the only case where those are somewhat pointless; similar issue
applies at least for FILS authentication where the timeout is too short
and the retry incorrect anyway. I have some local patches in mac80211
for testing purposes, but I have not yet found time to clean those up
for contribution.

For SAE, wpa_supplicant should really try to send out another Confirm if
no response from the AP is received. The mac80211 retries could be
removed as useless both for SAE and FILS. For now, the recovery from
this by starting authentication exchange from scratch which is likely
sufficient for covering robustness needs with all the link layer retries
making it sufficiently unlikely for the Authentication frames to be lost
completely.

-- 
Jouni Malinen                                            PGP id EFC895FA

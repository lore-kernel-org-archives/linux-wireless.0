Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot1-f51.google.com ([209.85.210.51]:43318 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387424AbeITSWk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 14:22:40 -0400
Received: by mail-ot1-f51.google.com with SMTP id u20-v6so9211564otk.10
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 05:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com>
 <20180919182334.GA15542@w1.fi> <CAFXAJYwa2usdkuvyjdE79iEuzqbZy6J=LYM=UhdAmLbwFP4KLA@mail.gmail.com>
 <20180920091221.GA7326@w1.fi>
In-Reply-To: <20180920091221.GA7326@w1.fi>
From: Mathy Vanhoef <vanhoefm@gmail.com>
Date: Thu, 20 Sep 2018 14:39:12 +0200
Message-ID: <CAFXAJYzT7nYEX-ScisqimA=u79B1obycS8msbhMo3TCa5bWa4A@mail.gmail.com> (sfid-20180920_143925_260809_1992F92A)
Subject: Re: SAE authentication frames in client mode
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        alfred.arnold@lancom.de, Philipp.Ebbecke@lancom.de,
        dharkins@lounge.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2018 at 11:12 AM Jouni Malinen <j@w1.fi> wrote:
> On Thu, Sep 20, 2018 at 12:55:10AM +0200, Mathy Vanhoef wrote:
> > That figure only appears to be an example. It doesn't say an exchange
> > must ("shall") follow that order. So I don't see where the standard
> > puts a constraint on how the authentication frames are exchanged.
>
> I know this figure is not a normative requirement, but it is a
> convenient location to point to for showing that specific sequence. I
> did discuss this in the IEEE 802.11 working group when working on the
> SAE implementation for infrastructure BSS case and the conclusion from
> that discussion was that it is better to follow the common sequence of
> STA->AP->STA round trips for the Authentication frames and have the STA
> be the one taking care of retransmissions, if needed. I thought we ended
> up clarifying that in the standard text somewhere as well, but that was
> years ago and I do not remember how exactly this got documented. It is
> possible that there would be benefit from adding a more explicit
> requirement in REVmd. In any case, this sequence is the one that is
> being implemented and enforced for implementations of WPA3.

Thanks for the information. The standard should indeed be more clear,
currently there doesn't seem to be a requirement to follow a specific
sequence of frames.

> > A related observation is that retransmissions of the Confirm message
> > are done by the kernel? Unfortunately this means the Send-Confirm
> > field is not being incremented (as per 12.4.8.6.5). In practice we
> > indeed see that this field is not being incremented for retransmitted
> > Confirm frames (when using wpa_supplicant). This means that if the
> > first Confirm frame sent by the AP is lost, the handshake will fail,
> > since the AP will not accept retransmissions with the same
> > Send-Confirm counter (and hence won't retransmit its own Confirm
> > frame).
>
> For mac80111-based drivers, there is indeed retransmission cases in the
> kernel implementation for authentication and association frames. SAE is
> not the only case where those are somewhat pointless; similar issue
> applies at least for FILS authentication where the timeout is too short
> and the retry incorrect anyway. I have some local patches in mac80211
> for testing purposes, but I have not yet found time to clean those up
> for contribution.
>
> For SAE, wpa_supplicant should really try to send out another Confirm if
> no response from the AP is received. The mac80211 retries could be
> removed as useless both for SAE and FILS. For now, the recovery from
> this by starting authentication exchange from scratch which is likely
> sufficient for covering robustness needs with all the link layer retries
> making it sufficiently unlikely for the Authentication frames to be lost
> completely.

If the mac80211 retransmissions fail, wpa_supplicant will abort the
authentication attempt (seems like sme_auth_timer is fired, and the
client deauthenticates from the network). So wpa_supplicant itself
will not attempt to send another Confirm frame with a higher
Send-Confirm?

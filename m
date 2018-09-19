Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot1-f41.google.com ([209.85.210.41]:42611 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725755AbeITEf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 00:35:29 -0400
Received: by mail-ot1-f41.google.com with SMTP id h26-v6so7467423otl.9
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 15:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com>
 <20180919182334.GA15542@w1.fi>
In-Reply-To: <20180919182334.GA15542@w1.fi>
From: Mathy Vanhoef <vanhoefm@gmail.com>
Date: Thu, 20 Sep 2018 00:55:10 +0200
Message-ID: <CAFXAJYwa2usdkuvyjdE79iEuzqbZy6J=LYM=UhdAmLbwFP4KLA@mail.gmail.com> (sfid-20180920_005820_885641_6939291F)
Subject: Re: SAE authentication frames in client mode
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > If that is the case, this would conflict with the SAE handshake as
> > defined in the 802.11-2016 standard. That's because when the AP
> > receives a Commit frame, the AP is allowed to send both a Commit and
> > Confirm frame (see 12.4.8.6.3). So according to the standard, the
> > client must accept a SAE Confirm authentication frame, even if it
> > hasn't yet transmitted its own Confirm frame. So this appears to be a
> > bug. Thoughts?
>
> While the SAE authentication exchange itself has such flexibility in the
> sequence of Commit/Confirm messages, there is a constraint in IEEE
> 802.11 on how the Authentication frames are exchanged in an
> infrastructure BSS between a non-AP STA and an AP. For SAE, this is
> explicitly requiring the exchange proceed in the sequence shown in
> Figure 4-29 (Example using SAE authentication), i.e., with the Commit
> messages exchanged first and the first Confirm message coming from STA
> to AP and the exchange concluded with the Confirm message from AP to
> STA. This matches the Linux kernel implementation.

That figure only appears to be an example. It doesn't say an exchange
must ("shall") follow that order. So I don't see where the standard
puts a constraint on how the authentication frames are exchanged.

A related observation is that retransmissions of the Confirm message
are done by the kernel? Unfortunately this means the Send-Confirm
field is not being incremented (as per 12.4.8.6.5). In practice we
indeed see that this field is not being incremented for retransmitted
Confirm frames (when using wpa_supplicant). This means that if the
first Confirm frame sent by the AP is lost, the handshake will fail,
since the AP will not accept retransmissions with the same
Send-Confirm counter (and hence won't retransmit its own Confirm
frame).

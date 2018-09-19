Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:35866 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbeITAI7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 20:08:59 -0400
Date: Wed, 19 Sep 2018 21:23:34 +0300
From: Jouni Malinen <j@w1.fi>
To: Mathy Vanhoef <vanhoefm@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: SAE authentication frames in client mode
Message-ID: <20180919182334.GA15542@w1.fi> (sfid-20180919_202953_192490_58203D02)
References: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2018 at 02:36:20PM +0200, Mathy Vanhoef wrote:
> It seems that in client mode, the Linux kernel only accepts an
> authentication frame after sending one itself. Is this interpretation
> correct?

For infrastructure station case, yes.

> If that is the case, this would conflict with the SAE handshake as
> defined in the 802.11-2016 standard. That's because when the AP
> receives a Commit frame, the AP is allowed to send both a Commit and
> Confirm frame (see 12.4.8.6.3). So according to the standard, the
> client must accept a SAE Confirm authentication frame, even if it
> hasn't yet transmitted its own Confirm frame. So this appears to be a
> bug. Thoughts?

While the SAE authentication exchange itself has such flexibility in the
sequence of Commit/Confirm messages, there is a constraint in IEEE
802.11 on how the Authentication frames are exchanged in an
infrastructure BSS between a non-AP STA and an AP. For SAE, this is
explicitly requiring the exchange proceed in the sequence shown in
Figure 4-29 (Example using SAE authentication), i.e., with the Commit
messages exchanged first and the first Confirm message coming from STA
to AP and the exchange concluded with the Confirm message from AP to
STA. This matches the Linux kernel implementation.

For mesh BSS cases, the SAE Confirm message can be sent out immediately
after having processed the Commit message, so the sequence there may end
up being different. That's also supported in the Linux implementation,
but this flexibility is not extended to the infrastructure case on
purpose.

-- 
Jouni Malinen                                            PGP id EFC895FA

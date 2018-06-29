Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41128 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753568AbeF2NLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 09:11:45 -0400
Received: by mail-lj1-f193.google.com with SMTP id a17-v6so4165579ljd.8
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 06:11:45 -0700 (PDT)
Date: Fri, 29 Jun 2018 15:11:41 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: alagusankar@silex-india.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] ath10k: sdio: use same endpoint id for all packets
 in a bundle
Message-ID: <20180629131141.GA26446@centauri.lan> (sfid-20180629_151203_205155_F4AA326B)
References: <20180620084222.3521-1-niklas.cassel@linaro.org>
 <20180620084222.3521-2-niklas.cassel@linaro.org>
 <87zhzdersm.fsf@codeaurora.org>
 <87vaa1erlj.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vaa1erlj.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 29, 2018 at 02:53:44PM +0300, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Niklas Cassel <niklas.cassel@linaro.org> writes:
> >
> >> All packets in a bundle should use the same endpoint id as the
> >> first lookahead.
> >>
> >> This matches how things are done is ath6kl, however,
> >> this patch can theoretically handle several bundles
> >> in ath10k_sdio_mbox_rx_process_packets().
> >>
> >> Without this patch we get lots of errors about invalid endpoint id:
> >>
> >> ath10k_sdio mmc2:0001:1: invalid endpoint in look-ahead: 224
> >> ath10k_sdio mmc2:0001:1: failed to get pending recv messages: -12
> >> ath10k_sdio mmc2:0001:1: failed to process pending SDIO interrupts: -12
> >>
> >> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> >> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> >
> > You have Alagu's s-o-b first so that implies Alagu is the author. So
> > should I add From header for Alagu and add you (Niklas) as
> > Co-Developed-by? Or vice versa?

Hello Kalle,

It is not always obvious how the combination of git-author
and Co-Developed-by should be:
http://lkml.iu.edu/hypermail/linux/kernel/1801.2/00988.html

Alagu deserves most credit, since I have simply taken parts
of a very big patch and split it into smaller pieces.
I tried to do the right thing by having his Signed-off-by first.

Let's go with your suggestion and add a From: header with
Alagu's email, and a Co-Developed-by tag with my email.
(Note that both Signed-off-bys are still needed according to
submitting-patches.rst)

Do you want me to resend the patches with these two lines
added, or can you fix them up manually?

Regards,
Niklas

> 
> Ah, the same issue is with all three patches. So whatever we decide,
> I'll do the same changes on all three.
> 
> -- 
> Kalle Valo

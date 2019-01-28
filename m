Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF28C282CB
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB7C2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfA1I05 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:26:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51786 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726647AbfA1I04 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 03:26:56 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1go2Fb-0002Wo-G5; Mon, 28 Jan 2019 10:26:41 +0200
Message-ID: <4f29fc396b9df90d39c4e46bf85c0d7f23dd9ddc.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 28 Jan 2019 10:26:36 +0200
In-Reply-To: <8736pd2nw4.fsf@codeaurora.org>
References: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
         <8736pd2nw4.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: wireless: prefix header search paths with
 $(srctree)/
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-28 at 10:21 +0200, Kalle Valo wrote:
> Masahiro Yamada <yamada.masahiro@socionext.com> writes:
> 
> > Currently, the Kbuild core manipulates header search paths in a
> > crazy
> > way [1].
> > 
> > To fix this mess, I want all Makefiles to add explicit $(srctree)/
> > to
> > the search paths in the srctree. Some Makefiles are already written
> > in
> > that way, but not all. The goal of this work is to make the
> > notation
> > consistent, and finally get rid of the gross hacks.
> > 
> > Having whitespaces after -I does not matter since commit
> > 48f6e3cf5bc6
> > ("kbuild: do not drop -I without parameter").
> > 
> > I also removed one header search path in:
> > 
> >   drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
> > 
> > I was able to compile without it.
> > 
> > [1]: https://patchwork.kernel.org/patch/9632347/
> > 
> > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > ---
> > 
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile | 4 ++--
> >  drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile | 6 +++-
> > --
> >  drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile | 4 +---
> >  drivers/net/wireless/intel/iwlwifi/dvm/Makefile           | 2 +-
> >  drivers/net/wireless/intel/iwlwifi/mvm/Makefile           | 2 +-
> >  drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile     | 2 +-
> >  drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile     | 2 +-
> >  7 files changed, 10 insertions(+), 12 deletions(-)
> 
> Luca, is it ok if I take this to wireless-drivers-next even though it
> touches iwlwifi makefiles?

Sure, it's much easier like that.

Acked-by: Luca Coelho <luciano.coelho@intel.com>

--
Cheers,
Luca.


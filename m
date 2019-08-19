Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B3CC3A5A2
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 13:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526F720843
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 13:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfHSNJA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:09:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36744 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727440AbfHSNI7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 09:08:59 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hzhP7-0007qY-TD; Mon, 19 Aug 2019 16:08:58 +0300
Message-ID: <6e207057abe66a389ad2145ba7e6a498d1640d01.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 19 Aug 2019 16:08:56 +0300
In-Reply-To: <8736hybmln.fsf@kamboji.qca.qualcomm.com>
References: <20190817065200.9701-1-luca@coelho.fi>
         <20190817065200.9701-23-luca@coelho.fi>
         <8736hybmln.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 22/22] iwlwifi: remove the code under IWLWIFI_PCIE_RTPM
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-08-18 at 16:59 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > This is never set.
> > 
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  drivers/net/wireless/intel/iwlwifi/Kconfig    | 14 ----
> >  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 71 -------------------
> >  .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 --
> >  3 files changed, 89 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
> > index 235349a33a3c..7dbc0d38bb3b 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> > +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> > @@ -92,20 +92,6 @@ config IWLWIFI_BCAST_FILTERING
> >  	  If unsure, don't enable this option, as some programs might
> >  	  expect incoming broadcasts for their normal operations.
> >  
> > -config IWLWIFI_PCIE_RTPM
> > -       bool "Enable runtime power management mode for PCIe devices"
> > -       depends on IWLMVM && PM && EXPERT
> > -       help
> > -         Say Y here to enable runtime power management for PCIe
> > -         devices.  If enabled, the device will go into low power mode
> > -         when idle for a short period of time, allowing for improved
> > -         power saving during runtime. Note that this feature requires
> > -         a tight integration with the platform. It is not recommended
> > -         to enable this feature without proper validation with the
> > -         specific target platform.
> > -
> > -	 If unsure, say N.
> 
> I would like to have more understanding why you are removing an existing
> Kconfig option? "Never set" tells nothing.

Okay, I'll expand this commit message a bit, but leave the core of the
explanation to the first patch.

--
Cheers,
Luca.


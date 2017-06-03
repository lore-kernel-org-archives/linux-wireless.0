Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41571 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdFCQ7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Jun 2017 12:59:54 -0400
Date: Sat, 3 Jun 2017 09:59:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after being unloaded once.
Message-ID: <20170603165950.GC29546@merlins.org> (sfid-20170603_185957_877400_0FA3BB56)
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org> <1496396575.9478.54.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496396575.9478.54.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 02, 2017 at 12:42:55PM +0300, Luca Coelho wrote:
> I kernel v4.9, we stopped supporting firmware versions smaller than 22
> for the 8260.  But unfortunately I made a mistake in the patch[1] when I
> removed support for those firmwares and I used 17, which is the lowest
> version for 7260 devices.
> 
> I have just sent out a patch[2] with a fix for that.
> 
> You can probably solve your problem by getting the latest firmware we
> have released, which is version 27.  You can get it from the linux-
> firmware.git repository[3].  Please try that and let us know how it
> goes.
 
Thanks. I think the other problem is that
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifihttps://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
says to use 'iwlwifi-8000-ucode-16.242414.0.tgz' for 4.3+ kenrels.
and strangely says "iwlwifi-8000-ucode-25.30.13.0.tgz" for 4.1+ kernels.

Unless I'm crazy, it didn't have -25 when I looked last time.
Is there a way to keep what I thought was the canonical page, up to date?

Firmware 27 seems to work, but I'm getting allocation error/warnings?

iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
Intel(R) Wireless WiFi driver for Linux
Copyright(c) 2003- 2015 Intel Corporation
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: capa flags index 3 larger than supported by driver
iwlwifi 0000:04:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 24 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 32 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 6 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 7 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 16 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
thermal thermal_zone3: failed to read out thermal zone (-5)
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 24 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 32 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 6 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 7 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 16 pages, ret: -12
cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

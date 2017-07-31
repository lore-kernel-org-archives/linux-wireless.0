Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35818 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdGaM7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 08:59:19 -0400
Date: Mon, 31 Jul 2017 13:59:02 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: AP mode with Broadcom 4330
Message-ID: <20170731125902.GW31807@n2100.armlinux.org.uk> (sfid-20170731_145926_849328_F426D0CB)
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
 <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 28, 2017 at 09:50:21PM +0200, Arend van Spriel wrote:
> I was going to agree with you, but having second thoughts. There are
> actually two use-cases that need to be handled properly. The regular AP
> case and the MBSS case. In case of MBSS the initial AP interface will
> have mbss set to false and subsequent AP interfaces will have mbss set
> to true, but in firmware this has to be configured inverted. That is
> what the code above is doing. However, this indeed breaks the regular AP
> case for firmwares that abuse that setting for testing purposes (no idea
> why that is in a released firmware).

Maybe detect the BCRM_TEST_SSID string in the firmware file (as it's
broken up amongst other data, it's not trivial) and disable mbss for
such firmware?  Alternatively, maybe blacklist mbss for some firmware
versions?

Do the firmware versions that include this "abuse" actually have
functional mbss?

There's also the obvious question: which firmware is recommended for
the 4330?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

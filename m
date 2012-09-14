Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:39703 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2INVxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 17:53:21 -0400
Message-ID: <5053A74D.6080200@wwwdotorg.org> (sfid-20120914_235324_820754_91D236E6)
Date: Fri, 14 Sep 2012 15:53:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: Re: [PATCH 07/10] brcmfmac: clear status for in-band interrupt in
 brcmf_sdbrcm_isr
References: <1347563526-12513-1-git-send-email-arend@broadcom.com> <1347563526-12513-8-git-send-email-arend@broadcom.com>
In-Reply-To: <1347563526-12513-8-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2012 01:12 PM, Arend van Spriel wrote:
> From: Franky Lin <frankyl@broadcom.com>
> 
> SDIO in-band interrupt is level sensitive according to SDIO standard.
> When the register interrupt handler gets called by SDIO stack it is
> running in non interrupt context and expected to clear the interrupt
> from the dongle. Therefore in-band and out-of-band interrupt need to
> be handled differently.

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

For reference, I took next-20120914, applied this patch series, applied
a few patches from Wei Ni to set up the SDIO HW on Tegra correctly, and
tested. The last time I tried this without any patches to the brcmfmac,
this test caused some system instability issues. This time around, I
observed no instability. I tested WPA PSK, ping (or flood ping) plus
playing audio through ALSA.

Is this series likely to make 3.7?

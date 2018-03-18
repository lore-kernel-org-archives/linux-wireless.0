Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:34480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbeCRUBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 16:01:32 -0400
Date: Sun, 18 Mar 2018 21:01:26 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Alexey Roslyakov <alexey.roslyakov@gmail.com>
Cc: kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [PATCH 1/2] brcmfmac: add new dt entries for SG SDIO settings
Message-ID: <20180318200126.GQ1188@lunn.ch> (sfid-20180318_210136_850313_F593CAAC)
References: <20180318184101.26951-1-alexey.roslyakov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180318184101.26951-1-alexey.roslyakov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	if (of_property_read_u16(np, "brcm,sd-head-align", &align) == 0)
> +		sdio->sd_head_align = align;

Hi Alexey

I think you can make this:

	of_property_read_u16(np, "brcm,sd-head-align", &sdio->sd_head_align);

of_property_read_u16() should not touch the destination variable if
the properties does not exist, or if there is an error.

    Andrew

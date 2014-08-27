Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36105 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920AbaH0Fyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 01:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <1408915485-8078-4-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
	<1408915485-8078-4-git-send-email-hauke@hauke-m.de>
Date: Wed, 27 Aug 2014 07:54:34 +0200
Message-ID: <CACna6rwJBDpg9VS4h5hfP4wtGRVwAdRUq5mELeA0OFWWzH9jsA@mail.gmail.com> (sfid-20140827_075439_187889_7F09D250)
Subject: Re: [RFC 2/7] bcm47xx-nvram: add new broadcom nvram driver with dt support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 August 2014 23:24, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> +On NorthStar ARM SoCs the NAND flash is available at 0x1c000000 and the
> +NOR flash is at 0x1e000000
> +
> +Example:
> +
> +nvram0: nvram@0 {
> +       compatible = "brcm,bcm47xx-nvram";
> +       reg = <0x1c000000 0x01000000>;
> +};

Could we avoid that? Type of flash can easily be checked in the code.
All we need to do is to read BCMA_IOST register of BCMA_CORE_NS_ROM
core.

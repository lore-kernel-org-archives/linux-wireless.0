Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4645 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaIMPNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2014 11:13:21 -0400
Message-ID: <54145F0E.8000506@broadcom.com> (sfid-20140913_171326_116221_B9B466AD)
Date: Sat, 13 Sep 2014 17:13:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: <linux-wireless@vger.kernel.org>, <zajec5@gmail.com>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>
Subject: Re: [PATCH 1/2] bcma: register bcma as device tree driver
References: <1410615446-7639-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1410615446-7639-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/14 15:37, Hauke Mehrtens wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.
>
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   Documentation/devicetree/bindings/bus/bcma.txt | 41 +++++++++++++
>   drivers/bcma/bcma_private.h                    | 16 +++++
>   drivers/bcma/host_soc.c                        | 82 ++++++++++++++++++++++++++
>   drivers/bcma/main.c                            | 10 ++++
>   include/linux/bcma/bcma.h                      |  2 +
>   5 files changed, 151 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
>
> This is based on wireless-testing and should go into that tree.
>
> changes since:
> RFC:
>   - reworded the irq description
>   - improved the example
>   - hocked into bcma_modeinit() and bcma_modexit()
>
> diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
> new file mode 100644
> index 0000000..17e095f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/bcma.txt
> @@ -0,0 +1,41 @@
> +Broadcom AIX SoC bcma bus driver

Hi Hauke,

First of all a typo used all over the place: AIX should be AXI.

The backplane in Broadcom SoC is ARM AXI with additional plugin option 
to make it discoverable. Indeed the IRQ info is not included, but I see 
no reason for specifying the register space for the cores in device-tree 
as that is discoverable by bcma.

Regards,
Arend

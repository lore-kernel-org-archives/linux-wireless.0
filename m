Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60930 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbbHJTVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:21:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: bcma: fix access to host_pdev for PCIe devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438540012-25292-1-git-send-email-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Message-Id: <20150810192106.B303B141199@smtp.codeaurora.org> (sfid-20150810_212111_718844_D6CCA3A9)
Date: Mon, 10 Aug 2015 19:21:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> bus->host_pdev is part of a union so bus->host_pdev != NULL is probably
> also true for PCIe devices, because there it accesses bus->host_pci. If
> we access the dev member at the offset defined in struct
> platform_device in struct pci_dev instead we probably get something
> else.
> 
> This patch adds a new function which returns the host dev struct and
> NULL if we do not have a host dev. When this gets registered on MIPS
> brcm47xx we do not have a host dev in some situations.
> This function could also be used in other places.
> 
> This problem was introduced in this commit:
> commit cae761b5a6bdc597ba476a040fdcd5b4bc559b85
> Author: Rafa? Mi?ecki <zajec5@gmail.com>
> Date:   Sun Jun 28 17:17:13 2015 +0200
> 
>     bcma: populate bus DT subnodes as platform_device-s
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

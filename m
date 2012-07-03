Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4758 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCHHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:07:35 -0400
Message-ID: <4FF29A29.2050901@broadcom.com> (sfid-20120703_090752_095621_C38A18EA)
Date: Tue, 3 Jul 2012 09:07:21 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 01/18] brcmsmac: remove PCIE() macro
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> Instead of checking if there is a PCIe core on the bus, better check if
> hosttype is PCIe.
> 
> In the original submission to staging PCIE() checked, if the bustype is
> PCI and the buscore is a PCIe core. Now we assume that all cores bcma
> supports are PCIe based, so we just have to check if the bustype is PCI.
> 
> The old code bcmsmac currently uses searches for a PCIe core on the bus
> and if there is one assumes that this is the buscore, which is wrong.
> Some SoCs have a PCIe core operating in host mode and this is not the
> bus core. The old code also caused a null pointer in
> ai_get_buscoretype() and ai_get_buscorerev() if buscore was not set
> because there was no PCIe core on the bus.
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Gr. AvS


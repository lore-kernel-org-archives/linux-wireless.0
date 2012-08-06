Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1811 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab2HFIua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 04:50:30 -0400
Message-ID: <501F853F.9010904@broadcom.com> (sfid-20120806_105034_498518_02B002C5)
Date: Mon, 6 Aug 2012 10:50:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: net: wireless: add brcm80211 drivers
References: <20120805195716.GA12400@elgon.mountain>
In-Reply-To: <20120805195716.GA12400@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2012 09:57 PM, Dan Carpenter wrote:
> Hi Arend,
> 
> The patch 5b435de0d786: "net: wireless: add brcm80211 drivers" from
> Oct 5, 2011, leads to the following warning:
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1699 brcmf_sdbrcm_readframes()
> 	 warn: is it ok to set 'rxseq' to -1?
> 
>   1697                          cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
>   1698                          brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
>   1699                          rxseq += cnt - 1;
>   1700                          rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
>   1701                          continue;
> 
> This isn't a warning, it's just one of the things I audit.
> brcmf_sdbrcm_rxglom() can return 0 so it's weird that we do
> "rxseq += 0 - 1;"  Was that intended?
> 
> regards,
> dan carpenter
> 
> 

Thanks, Dan

Probably it was not intended, but we need a closer look. At rxseq should
never be -1.

Gr. AvS


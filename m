Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3435 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab2ENHIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 03:08:09 -0400
Message-ID: <4FB0AF4B.9070606@broadcom.com> (sfid-20120514_090813_622392_38919A13)
Date: Mon, 14 May 2012 09:07:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: net: wireless: add brcm80211 drivers
References: <20120513174333.GB4280@elgon.mountain>
In-Reply-To: <20120513174333.GB4280@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/2012 07:43 PM, Dan Carpenter wrote:
> Hi Arend,
> 
> This code is not really new, but I thought I would email you anyway
> because I know you are responsive.  :)

Dito ;-)

> The patch 5b435de0d786: "net: wireless: add brcm80211 drivers" from 
> Oct 5, 2011, leads to the following Smatch complaint:
> 
> drivers/net/wireless/brcm80211/brcmsmac/ampdu.c:741 brcms_c_sendampdu()
> 	 warn: variable dereferenced before check 'p' (see line 739)
> 
> drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>    733                  /*
>    734                   * check to see if the next pkt is
>    735                   * a candidate for aggregation
>    736                   */
>    737                  p = pktq_ppeek(&qi->q, prec);
>    738			/* tx_info must be checked with current p */
>    739			tx_info = IEEE80211_SKB_CB(p);
>                                   ^^^^^^^^^^^^^^^^
> "p" is dereferenced inside the call to IEEE80211_SKB_CB().
> 
>    740	
>    741			if (p) {
>                            ^^^
> Checked too late.
> 
>    742				if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
>    743				    ((u8) (p->priority) == tid)) {
> 
> regards,
> dan carpenter
> 
> 

Thanks for running smatch. I will look in the current code base and fix
this. Just out of curiosity: Another static checker used regularly is
Coccinelle. What are the pros and cons of smatch compared to Coccinelle?

Gr. AvS


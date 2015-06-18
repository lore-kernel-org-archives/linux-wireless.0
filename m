Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:57351 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbbFRGNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 02:13:42 -0400
Message-ID: <1434608018.5481.4.camel@embedded.rocks> (sfid-20150618_081519_414649_D54E729B)
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No
 space left on device)
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Thu, 18 Jun 2015 08:13:38 +0200
In-Reply-To: <55803214.2030204@broadcom.com>
References: <1433766944.28058.16.camel@embedded.rocks>
				 <55758D7E.3000603@broadcom.com>
		 <1433771289.28058.24.camel@embedded.rocks>
		 <5575C6FA.6030104@broadcom.com>
		 <1433794640.28058.26.camel@embedded.rocks> <557605CC.6070907@broadcom.com>
	 <1434448766.21949.9.camel@embedded.rocks> <55803214.2030204@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Di, 2015-06-16 at 16:26 +0200, Arend van Spriel wrote:
> On 06/16/15 11:59, Jörg Krause wrote:
> > Hi Arend,
> > 
> > as I wrote in my previous mail ("brcmfmac: brcmf_p2p_create_p2pdev:
> > timeout occurred") I get a p2p0 interface when loading the brcmfmac
> > module with p2pon=1 (Linux kernel 4.0.5, BCM43362).
> > 
> > Unfortunatly, if I try to use the p2p0 interface with 
> > wpa_supplicant
> > 2.4 I get an error:
> > 
> >      Failed to create interface p2p-dev-p2p0: -28 (No space left on
> >      device)
> >      nl80211: Failed to create a P2P Device interface p2p-dev-p2p0
> >      P2P: Failed to enable P2P Device interface
> 
> Using p2pon=1 is old-school p2p, ie. it creates a regular netdev for 
> doing p2p management stuff. Problem is that brcmfmac also indicates 
> p2p 
> device support. We can remove p2pon parameter or not indicate p2p dev 
> 
> support when p2pon=1.

I used p2pon because the p2p0 interface is not created without it. It
fails with the error message "brcmf_p2p_create_p2pdev: timeout
occurred" as written in my previous mails. I would prefer not to use
it, so maybe we can find a solution how to get it working without it.

> 
> Can you patch brcmfmac and give it a try. Need to start 
> wpa_supplicant 
> for two interface and if I recall correctly p2p0 must be specified 
> first.

Can you give me a hint where to patch brcmfmac. Many thanks!

Best regards
Jörg Krause

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60883 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbbGWLGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 07:06:03 -0400
Message-ID: <1437649559.15337.1.camel@embedded.rocks> (sfid-20150723_130617_526164_1BB1BB0C)
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No
 space left on device)
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <arend@broadcom.com>
Cc: Arend van Spriel <aspriel@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Thu, 23 Jul 2015 13:05:59 +0200
In-Reply-To: <1436255260.27716.6.camel@embedded.rocks>
References: <1433766944.28058.16.camel@embedded.rocks>
	 <55758D7E.3000603@broadcom.com> <1433771289.28058.24.camel@embedded.rocks>
	 <5575C6FA.6030104@broadcom.com> <1433794640.28058.26.camel@embedded.rocks>
	 <557605CC.6070907@broadcom.com> <1434448766.21949.9.camel@embedded.rocks>
	 <55803214.2030204@broadcom.com> <1434608018.5481.4.camel@embedded.rocks>
	 <55828106.7060004@broadcom.com> <1434658050.2532.6.camel@embedded.rocks>
	 <55872A3C.7030704@gmail.com> <1435059083.4765.2.camel@embedded.rocks>
	 <55894C40.1070108@broadcom.com> <1436255260.27716.6.camel@embedded.rocks>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Di, 2015-07-07 at 09:47 +0200, Jörg Krause wrote:
> Hi Arend,
> 
> On Di, 2015-06-23 at 14:08 +0200, Arend van Spriel wrote:
> > On 06/23/15 13:31, Jörg Krause wrote:
> > > Hi Arend,
> > > 
> > > On So, 2015-06-21 at 23:18 +0200, Arend van Spriel wrote:
> > > > 
> > > > My bad. The patch removes p2pdev from interface modes, but it 
> > > > is
> > > > still
> > > > listed in the interface combinations and cfg80211 will complain 
> > > > 
> > > > about
> > > > it. Have to extend the patch. I better do that after a good 
> > > > nights
> > > > sleep.
> > > 
> > > Never mind! Did you had a good night sleep already :-) ?
> > 
> > Several ;-) Did not get to this earlier. Thanks for the reminder.
> > 
> > Had a closer look at wiphy_verify_combinations() and I am hopeful 
> > the 
> > 
> > attached patch will fix the wiphy_register() failure.
> > 
> 
> Sorry for late reply! I was busy on another topic...
> 
> I've applied your patch, but p2p interface is still not working. I
> attached the debug log from wpa_supplicant.
> 
> I tested with Linux Kernel 4.0.7 and wpa_supplicant 2.4.
> 
> This is my p2p_supplicant.conf:
>     ctrl_interface=/var/run/p2p_supplicant
>     update_config=1
> 
>     device_name=HBM10
>     device_type=1-0050F204-1
> 
>     p2p_go_ht40=1
> 
> Test with the p2p_find command:
>     # wpa_cli -p /var/run/p2p_supplicant p2p_find
>     Selected interface 'p2p0'
>     1928.165036: p2p0: Control interface command 'P2P_FIND'
>     FAIL
> 

ping :-) Any news on this?

Best regards
Jörg Krause

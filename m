Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45779 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaEVSpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 14:45:09 -0400
Date: Thu, 22 May 2014 14:30:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on regulatory settings.
Message-ID: <20140522183007.GE12779@tuxdriver.com> (sfid-20140522_204526_936321_E0B79282)
References: <537E2ABB.6030302@candelatech.com>
 <537E36E3.6040205@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537E36E3.6040205@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2014 at 10:41:55AM -0700, Ben Greear wrote:
> On 05/22/2014 09:50 AM, Ben Greear wrote:
> > Hello!
> > 
> > I'm having issues where when we add several ath10k NICs to a system,
> > the regulatory domain goes quite restricted..  There is an ath9k NIC
> > with eeprom over-ride hack, and user-space sets regdomain to 'US'.
> > 
> > Later, when registering ath10k, at least one of those NICs registeres
> > as 'TW'.  The ending domain looks like this:
> > 
> > [root@lf1011-13060017 ~]# iw reg get
> > country 98: DFS-UNSET
> > 	(2402 - 2472 @ 40), (N/A, 30)
> > 	(5270 - 5330 @ 40), (N/A, 17), DFS
> > 	(5735 - 5835 @ 80), (N/A, 30)
> > 
> > 
> > I tried adding a hack to ath10k to zero out the ar->ath_common.regulatory.current_rd,
> > but in fact it seems to be reported as zero to begin with.
> > 
> > I am obviously missing something.  Either my hacks to ath10k are not
> > sufficient, or possibly the system is getting regulatory info from
> > somewhere else?
> > 
> > Any ideas where else it might be getting the idea it should be in TW
> > domain?  Can it get this from beacons from other systems?

FWIW, yes it can get this information from beacons.

> Ahh, sneaky nasty code....it was being set based on the timezone
> of all things!

You're welcome... ;-)

> Looks like you can override this behaviour with the command
> below if you are of a mind to do so:
> 
> echo COUNTRY=US > /etc/sysconfig/regdomain

I don't know any better way to set a reasonable default for the
regulatory domain.  If you have other suggestions, I'd be interested
in hearing them.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

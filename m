Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46475 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaEVTaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 15:30:18 -0400
Date: Thu, 22 May 2014 15:22:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rick Farina <sidhayn@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on regulatory settings.
Message-ID: <20140522192249.GF12779@tuxdriver.com> (sfid-20140522_213023_004453_838FEFD9)
References: <537E2ABB.6030302@candelatech.com>
 <537E36E3.6040205@candelatech.com>
 <20140522183007.GE12779@tuxdriver.com>
 <537E4C81.3060001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537E4C81.3060001@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2014 at 03:14:09PM -0400, Rick Farina wrote:
> 
> 
> On 05/22/2014 02:30 PM, John W. Linville wrote:
> > On Thu, May 22, 2014 at 10:41:55AM -0700, Ben Greear wrote:
> >> On 05/22/2014 09:50 AM, Ben Greear wrote:
> >>> Hello!
> >>>
> >>> I'm having issues where when we add several ath10k NICs to a system,
> >>> the regulatory domain goes quite restricted..  There is an ath9k NIC
> >>> with eeprom over-ride hack, and user-space sets regdomain to 'US'.
> >>>
> >>> Later, when registering ath10k, at least one of those NICs registeres
> >>> as 'TW'.  The ending domain looks like this:
> >>>
> >>> [root@lf1011-13060017 ~]# iw reg get
> >>> country 98: DFS-UNSET
> >>> 	(2402 - 2472 @ 40), (N/A, 30)
> >>> 	(5270 - 5330 @ 40), (N/A, 17), DFS
> >>> 	(5735 - 5835 @ 80), (N/A, 30)
> >>>
> >>>
> >>> I tried adding a hack to ath10k to zero out the ar->ath_common.regulatory.current_rd,
> >>> but in fact it seems to be reported as zero to begin with.
> >>>
> >>> I am obviously missing something.  Either my hacks to ath10k are not
> >>> sufficient, or possibly the system is getting regulatory info from
> >>> somewhere else?
> >>>
> >>> Any ideas where else it might be getting the idea it should be in TW
> >>> domain?  Can it get this from beacons from other systems?
> > 
> > FWIW, yes it can get this information from beacons.
> > 
> >> Ahh, sneaky nasty code....it was being set based on the timezone
> >> of all things!
> > 
> > You're welcome... ;-)
> 
> To be fair, when I travel I rarely set my timezone at all, and when I do
> I normally make sure the offset is right and not much else.  It's easily
> possible to have timezone set for a country you aren't in just because
> the offset matches.
> 
> I'm not saying I have a better idea, but I am saying that timezone is
> very unreliable to determine position.

Yes, but no less reliable than nothing at all.  And if you _do_
set it properly, so much the better.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

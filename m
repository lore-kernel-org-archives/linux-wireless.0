Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33177 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3BUXxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 18:53:21 -0500
Message-ID: <5126B368.9010209@candelatech.com> (sfid-20130222_005325_365483_8B0BB9D3)
Date: Thu, 21 Feb 2013 15:53:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <sujith@msujith.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+: ath9k: tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL> <51255360.6060603@candelatech.com> <51257304.10109@candelatech.com> <20773.31380.740958.31338@gargle.gargle.HOWL> <5125B39F.3010200@candelatech.com> <51265AC3.5030304@candelatech.com> <5126A993.8060408@candelatech.com> <CAJ-Vmo=FC=jdJ9VyZtZy_nbdGhCCfJ9dhS3993fwneGhFjoBJg@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=FC=jdJ9VyZtZy_nbdGhCCfJ9dhS3993fwneGhFjoBJg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2013 03:49 PM, Adrian Chadd wrote:
> .. so the current code correctly soft fails all of those frames and
> puts them back onto the relevant software queues, right?

I might have been mistaken.  Further testing makes me think the
pending-frames are properly dealt with.  I see them show back up
in the tx-complete logic about 30 second after the first chip reset logic hits.

That seems quite long to me, but then again, it appears that without a chip
reset, they never show back up in the tx-complete logic at all (and thus
the hang).

I'm testing now with just the pending-frames lockup check with a plain
chip reset as work-around (and no fiddling with pending-frames counter).

Thanks,
Ben

>
>
> Adrian
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


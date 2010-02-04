Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab0BDX07 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 18:26:59 -0500
Subject: Re: [PATCH] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100204230355.281A32B0054@apps0.cs.toronto.edu>
References: <20100204230355.281A32B0054@apps0.cs.toronto.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 15:26:11 -0800
Message-ID: <1265325971.4290.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-04 at 18:03 -0500, Chris Siebenmann wrote:
> | >  I'm not sure what the machine's exact configuration is because
> | > I inherited it (the usual long cycle of passing older and older
> | > hardware around at work), but I believe it must; I certainly don't
> | > have anything plugged into any external slots or sockets.
> |
> | And just to confirm, what are the exact symptoms that you have with
> | "broken" kernels?  Just that connections can't be made, the card can't
> | find access points, etc? or?
> 
>  In the GUI, no wireless networks show up/are listed in the usual
> dropdown menu; this means that I can't go as far as even trying to
> connect to anything.  From the command line, 'iwlist wifi0 scanning'
> lists nothing.

Wait, wifi0?  You need to be using 'eth0' or 'eth1', whichever eth
device that 'iwconfig' reports.  wifi0 is a historical airo anomaly
that's only used for packet capture and sniffing of the 802.11 frames.
It should not be used for anything other than Wireshark basically.

Do you get the same behavior if you use the normal ethX interface of the
airo device?

Dan



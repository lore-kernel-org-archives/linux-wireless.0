Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57812 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZCYO06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 10:26:58 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
Date: Wed, 25 Mar 2009 15:34:29 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <73aaf0dd0903250550x37e6847x38be1f0dcc4b1bb3@mail.gmail.com> <200903251442.58712.chunkeey@web.de>
In-Reply-To: <200903251442.58712.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903251534.29549.chunkeey@web.de> (sfid-20090325_152702_267263_45781CE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 March 2009 14:42:58 Christian Lamparter wrote:
> On Wednesday 25 March 2009 13:50:44 Max Filippov wrote:
> > >> Sorry, I haven't been used to checkpatch.
> > > But your PATCH 1/2 sailed through without any complains. ;-)
> > Mere coincidence (:
> > 
> > > BTW: does p54spi really work now?
> > I haven't tested your patch yet, but with the one that I sent it does
> > work in IBSS mode.
> > My aim is to wind it up in mesh mode. This doesn't work, it cannot
> > establish peer link.
> > I'm going to investigate it. Does mesh mode work on conventional pci/usb p54?
> 
> hmm, yes... at least with wireless-testing from yesterday. (beaconing works too)
> 
> [ 9862.704138] mesh: running mesh housekeeping
> [ 9906.580204] phy3: Allocated STA 00:14:a5:45:33:ff
> [ 9906.581566] phy3: Inserted STA 00:14:a5:45:33:ff
> [ 9906.581581] Mesh plink: starting establishment with 00:14:a5:45:33:ff
> [ 9906.634055] Mesh plink (peer, state, llid, plid, event): 00:14:a5:45:33:ff 1 28312 0 1
> [ 9906.636888] Mesh plink (peer, state, llid, plid, event): 00:14:a5:45:33:ff 2 28312 55519 4
> [ 9906.636895] Mesh plink with 00:14:a5:45:33:ff ESTABLISHED
> 
> 64 bytes from 10.0.0.2: icmp_seq=449 ttl=64 time=1.81 ms
> 64 bytes from 10.0.0.2: icmp_seq=450 ttl=64 time=1.41 ms
> 64 bytes from 10.0.0.2: icmp_seq=451 ttl=64 time=3.52 ms
> ...
> 
> both peers have a p54 (one is pci, the other one usb)... I'll see if I can
> get my old ath5k back to verify that it works with other devices as well.

FYI, I just finished testing with a 5 node mesh network with various drivers
(ath5k, ar9170usb and p54 mesh network) and it looks like everything works
the way it should... ( testing was done with the current wireless-testing.git )

Is there anything else I can do, or something you want to know?

Regards,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56778 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZBYShu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 13:37:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Latest test  with open-source firmware
Date: Wed, 25 Feb 2009 19:36:10 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <49A56B1F.80702@lwfinger.net> <200902251846.31531.mb@bu3sch.de> <49A58F63.9090309@lwfinger.net>
In-Reply-To: <49A58F63.9090309@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200902251936.10658.mb@bu3sch.de> (sfid-20090225_193752_744242_D23B30E1)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 February 2009 19:35:15 Larry Finger wrote:
> Michael Buesch wrote:
> > On Wednesday 25 February 2009 17:00:31 Larry Finger wrote:
> >>
> >> The 00:26:24 event was the interface going offline. That happens with
> >> proprietary firmware, thus I think that problem is with the driver, rather than
> >> the firmware.
> > 
> > Are you sure it's a problem at all and not just simply failure to deliver
> > certain important management frames due to _extreme_ queue pressure?
> > Especially the tight RX queue will have effects like dropped frames.
> 
> No, I don't know. If I get the same problem with a queue depth of 64, is there
> any problem with increasing it to 128 for testing?

The RX queue length can have any size.
The TX queue length % 2 must be zero. But a BUILD_BUG_ON will trigger if it isn't.

-- 
Greetings, Michael.

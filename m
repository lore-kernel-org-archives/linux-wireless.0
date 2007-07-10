Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54419 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbXGJTre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 15:47:34 -0400
Date: Tue, 10 Jul 2007 12:47:17 -0700
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2.6] SoftMAC : fix duplicate display of channel in scan
Message-ID: <20070710194717.GA7310@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070710184155.GA6955@bougret.hpl.hp.com> <4693DD18.1010905@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4693DD18.1010905@lwfinger.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2007 at 02:25:12PM -0500, Larry Finger wrote:
> Jean,
> 
> Jean Tourrilhes wrote:
> >	Hi,
> >
> >	SoftMAC output the channel twice in the scan output. It should
> >display frequency and channel, but only once for each.
> >--------------------------------------------------------
> >          Cell 02 - Address: A2:00:04:XX:XX:XX
> >                    ESSID:"TheESSID"
> >                    Protocol:IEEE 802.11b
> >                    Mode:Ad-Hoc
> >->                  Channel:5
> >->                  Frequency:2.432 GHz (Channel 5)
> 
> The frequency output is needed by NetworkManager, which is why I added it. 
> At that time, I thought that some tool or other might be scanning the 
> output looking for "Channel:", not "Channel "; therefore I left both in.

	All of the other drivers display only a single line, and
SoftMAC is the odd one here. I think that have the info twice may
confuse some tools.
	I know that there are scripts that parse iwlist output,
however I'm not keen on the practice, as there are alternatives.

> If we are sure that removing the channel-only line will not break
> something, I'll be happy to send your patch upstream.

	Unfortunately, I can't guarantee that. I can only guarantee
that it will be similar to what other drivers do.

> Larry

	Have fun...

	Jean

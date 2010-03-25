Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45057 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0CYVNN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 17:13:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:13:13 -0700
Date: Thu, 25 Mar 2010 14:13:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Derek Smithies <derek@indranet.co.nz>
CC: Bruno Randolf <br1@einfach.org>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Message-ID: <20100325211311.GG7651@tux>
References: <20100325054603.10697.48915.stgit@tt-desk>
 <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 02:10:55PM -0700, Derek Smithies wrote:
> Hi,
> On Thu, 25 Mar 2010, Bruno Randolf wrote:
> > This is ANI for ath5k.
> Fantastic!!
>   I have used your initial ani patch set here, and it did help througput 
> etc.
> >
> > - Improve beacon averaging algorithm for IBSS: Maybe we should keep track of
> >  the average RSSI on a per-node basis and use the minimum of those in order
> >  not to loose far away nodes? The other option would be to limit the
> >  parameters we control similar to AP mode.
> 
> We have talked about this before. I thought that we agreed 
> that adhoc nodes may
>    a)be activated at any time
>    b)be positioned at an unknown distance apart
> 
> it therefore makes no sense to average the RSSI over the current nodes.
> If all the current nodes in the network are close by, the ani algorithm 
> will wind the sensitivity down. Consequently, if a remote node is 
> started, it will not be able to connect. Yet, the remote node should 
> have been able to connect as the slot times etc were long enough, 
> and the link budget is fine...
> 
> So yes, the only way to 
> > - Improve beacon averaging algorithm for IBSS:
> is to turn ani off. which means the issue you raised else where of 
> providing reasonable userland controls (not via debugfs) becomes 
> important.

If ANI helps IBSS so much then why not just default to turning it
off within the driver?

  Luis

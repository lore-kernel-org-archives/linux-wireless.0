Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYHDPi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 11:38:27 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1217825304.10989.20.camel@dv>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 11:34:20 -0400
Message-Id: <1217864060.3139.10.camel@localhost.localdomain> (sfid-20080804_173831_197189_AE5BB588)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 00:48 -0400, Pavel Roskin wrote:
> On Sat, 2008-08-02 at 11:14 +0100, kilroyd@googlemail.com wrote:
> > Pass the ESSID to the card.
> > 
> > This allows 'iwlist eth1 scan essid <essid>' to work, and will help
> > with routers setup not to broadcast the ESSID.
> 
> That's a nice thing to have, but it doesn't seem to work on x86_64 (I
> didn't try other platforms).  I tried wireless-tools 30.pre6 instead of
> 29, but it broke the output completely:
> 
> # iwlist eth1 scan 
> *** Please report to jt@hpl.hp.com your platform details
> *** and the following line :
> *** IW_EV_LCP_PK2_LEN = 4 ; IW_EV_POINT_PK2_LEN = 8
> 
> eth1      Scan completed :
>           Cell 01 - Address: 00:19:5B:56:FC:73
>                     ESSID:off/any/hidden
>                     Mode:Master
>                     Frequency=2.437 GHz (Channel 6)
>                     Signal level:-29 dBm  Noise level:-81 dBm
>                     Encryption key:E0
>                     Extra:
>           Cell 02 - Address: 00:15:6D:53:9A:CA
>                     ESSID:off/any/hidden
>                     Mode:Master
>                     Frequency:2.462 GHz (Channel 11)
>                     Signal level:-49 dBm  Noise level:-80 dBm
>                     Encryption key:E0
>                     Extra:
> 
> 
> > +			if (priv->scan_mode & IW_SCAN_THIS_ESSID) {
> 
> The debug output shows that the about condition is never true with
> either version of iwlist.  The command is:
> 
> iwlist eth1 scan essid foo

That code looks right, since srq->flags is getting copied into
priv->scan_mode.

Maybe the wireless-tools breakage you're experiencing is causing this to
fail on x86-64?  Are you using 64-bit wireless-tools and a 64-bit
kernel, or 32-bit wireless tools with a 64-bit kernel?

Dan


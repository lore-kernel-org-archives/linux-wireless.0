Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:50740 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYIBXaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 19:30:10 -0400
Date: Tue, 2 Sep 2008 16:06:21 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: Pavel Roskin <proski@gnu.org>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Message-ID: <20080902230621.GA28885@bougret.hpl.hp.com> (sfid-20080903_013016_183643_F79562C6)
Reply-To: jt@hpl.hp.com
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080805162238.GA6294@bougret.hpl.hp.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 05, 2008 at 09:22:38AM -0700, jt wrote:
> On Mon, Aug 04, 2008 at 11:34:20AM -0400, Dan Williams wrote:
> > On Mon, 2008-08-04 at 00:48 -0400, Pavel Roskin wrote:
> > > On Sat, 2008-08-02 at 11:14 +0100, kilroyd@googlemail.com wrote:
> > > > Pass the ESSID to the card.
> > > > 
> > > > This allows 'iwlist eth1 scan essid <essid>' to work, and will help
> > > > with routers setup not to broadcast the ESSID.
> > > 
> > > That's a nice thing to have, but it doesn't seem to work on x86_64 (I
> > > didn't try other platforms).  I tried wireless-tools 30.pre6 instead of
> > > 29, but it broke the output completely:
> > > 
> > > # iwlist eth1 scan 
> > > *** Please report to jt@hpl.hp.com your platform details
> > > *** and the following line :
> > > *** IW_EV_LCP_PK2_LEN = 4 ; IW_EV_POINT_PK2_LEN = 8
> > > 
> > > eth1      Scan completed :
> > >           Cell 01 - Address: 00:19:5B:56:FC:73
> > >                     ESSID:off/any/hidden
> > >                     Mode:Master
> > >                     Frequency=2.437 GHz (Channel 6)
> > >                     Signal level:-29 dBm  Noise level:-81 dBm
> > >                     Encryption key:E0
> > >                     Extra:
> > >           Cell 02 - Address: 00:15:6D:53:9A:CA
> > >                     ESSID:off/any/hidden
> > >                     Mode:Master
> > >                     Frequency:2.462 GHz (Channel 11)
> > >                     Signal level:-49 dBm  Noise level:-80 dBm
> > >                     Encryption key:E0
> > >                     Extra:
> > > 
> > > 
> > > > +			if (priv->scan_mode & IW_SCAN_THIS_ESSID) {
> > > 
> > > The debug output shows that the about condition is never true with
> > > either version of iwlist.  The command is:
> > > 
> > > iwlist eth1 scan essid foo
> > 
> > That code looks right, since srq->flags is getting copied into
> > priv->scan_mode.
> > 
> > Maybe the wireless-tools breakage you're experiencing is causing this to
> > fail on x86-64?  Are you using 64-bit wireless-tools and a 64-bit
> > kernel, or 32-bit wireless tools with a 64-bit kernel?
> > 
> > Dan
> 
> 	I still need to look into those 64 bit issues. That's the
> reason why WT-30 is still pending. The good news is that I now have a
> 64 bit box. The bad news is work and family.
> 	Have fun...
> 
> 	Jean

	By the way, the breakage of iwlist scan in Wireless Tools 30
on 64 bits should be fixed in 30.pre7.
	Have fun...

	Jean


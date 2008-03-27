Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43399 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755893AbYC0TRy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 15:17:54 -0400
From: Helge Deller <deller@gmx.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k aborts wireless connections
Date: Thu, 27 Mar 2008 20:17:49 +0100
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
References: <200803221129.59090.deller@gmx.de> <200803252111.05726.deller@gmx.de> <20080327115125.GA10265@hash.localnet>
In-Reply-To: <20080327115125.GA10265@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803272017.50126.deller@gmx.de> (sfid-20080327_191758_316136_B0FD4B0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 March 2008, Bob Copeland wrote:
> On Tue, Mar 25, 2008 at 09:11:05PM +0100, Helge Deller wrote:
> > On Tuesday 25 March 2008, Bob Copeland wrote:
> > > On Tue, Mar 25, 2008 at 2:16 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > > > Hello ppl, sory for the delay ;-)
> > > >
> > > >  Are you using encryption ? I haven't got such errors on my tests (it
> > > >  might be that my setup is really simple) so far...
> > > 
> > > I can't speak for Helge, but in my case yes - WPA-TKIP.
> > 
> > Same here. WPA-PSK & TKIP.
> 
> So, I turned off encryption here and did not get any "invalid Michael
> MIC" messages while doing a large apt-get upgrade overnight.  I do get 
> random pauses but nothing else in my dmesg.
> 
> Helge, can you confirm disabling encryption makes the reset go away?

Yes, I can confirm this.

Without encryption everything worked pretty OK.

I only faced one very small hickup, but ath5k reconnected immediately again, so I don't think this is a real problem:

wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x461 status=0 aid=1)
wlan1: associated
wlan1: No ProbeResp from current AP 00:50:18:3b:2b:04 - assume out of range
wlan1: Initial auth_alg=0
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated

Helge

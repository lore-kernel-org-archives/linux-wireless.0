Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:10475 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYC2X3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 19:29:10 -0400
Received: by an-out-0708.google.com with SMTP id d31so240557and.103
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 16:29:09 -0700 (PDT)
Message-ID: <40f31dec0803291629v540badd2xb31ab92d860d9ea2@mail.gmail.com> (sfid-20080329_232920_386131_9CDC1D51)
Date: Sun, 30 Mar 2008 01:29:09 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Helge Deller" <deller@gmx.de>
Subject: Re: ath5k aborts wireless connections
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
In-Reply-To: <200803272017.50126.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200803221129.59090.deller@gmx.de>
	 <200803252111.05726.deller@gmx.de>
	 <20080327115125.GA10265@hash.localnet>
	 <200803272017.50126.deller@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/27, Helge Deller <deller@gmx.de>:
> On Thursday 27 March 2008, Bob Copeland wrote:
>  > On Tue, Mar 25, 2008 at 09:11:05PM +0100, Helge Deller wrote:
>  > > On Tuesday 25 March 2008, Bob Copeland wrote:
>  > > > On Tue, Mar 25, 2008 at 2:16 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  > > > > Hello ppl, sory for the delay ;-)
>  > > > >
>  > > > >  Are you using encryption ? I haven't got such errors on my tests (it
>  > > > >  might be that my setup is really simple) so far...
>  > > >
>  > > > I can't speak for Helge, but in my case yes - WPA-TKIP.
>  > >
>  > > Same here. WPA-PSK & TKIP.
>  >
>  > So, I turned off encryption here and did not get any "invalid Michael
>  > MIC" messages while doing a large apt-get upgrade overnight.  I do get
>  > random pauses but nothing else in my dmesg.
>  >
>  > Helge, can you confirm disabling encryption makes the reset go away?
>
>
> Yes, I can confirm this.
>
>  Without encryption everything worked pretty OK.
>
>  I only faced one very small hickup, but ath5k reconnected immediately again, so I don't think this is a real problem:
>
>
>  wlan1: authenticated
>  wlan1: associate with AP 00:50:18:3b:2b:04
>
> wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x461 status=0 aid=1)
>  wlan1: associated
>  wlan1: No ProbeResp from current AP 00:50:18:3b:2b:04 - assume out of range
>
> wlan1: Initial auth_alg=0
>  wlan1: authenticate with AP 00:50:18:3b:2b:04
>  wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
>  wlan1: authenticated
>
>
> Helge
>

Since we use software encryption for now we 'll need to trace this
inside base.c or higher on the stack. Anyone with similar problems
with other drivers that use software encryption ???

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYCLNsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 09:48:41 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Dan Williams <dcbw@redhat.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <20080312182438.0B1F.40F06B3A@sm.sony.co.jp>
References: <20080312102148.0B08.40F06B3A@sm.sony.co.jp>
	 <1205310310.6387.56.camel@johannes.berg>
	 <20080312182438.0B1F.40F06B3A@sm.sony.co.jp>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 09:42:31 -0400
Message-Id: <1205329351.32049.8.camel@localhost.localdomain> (sfid-20080312_134855_676007_8DA28B50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-12 at 19:26 +0900, Masakazu Mokuno wrote:
> On Wed, 12 Mar 2008 09:25:10 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > 
> > > > Does this problem apply to probe responses as well?  (Do probe
> > > > responses from hidden SSID APs still exclude the SSID?  I would
> > > > guess not.)
> > > 
> > > There has been a problem in parsing IEs, so if the received probe
> > > responses include zero length IEs, they also suffer this bug.
> > > 
> > > > As long as you can still associate w/ hidden SSID APs, I don't see
> > > > a big problem.  Even if you can't, no information for those APs is
> > > > probably better than bad information, no?
> > > 
> > > I was anxious that the userland apps or the users may get confused.  Any
> > > other thing harmful is not found.
> > > OK, I withdraw this patch.
> > 
> > I think John actually meant that it would be better to have the patch
> > in. How does a "bad" scan result look like?
> 
> Usually the zero length IE, the SSID element, is the first one of IE
> list, all information in the successor elements is lost. What we can see
> is bssid.
> 
> The current firmware gives the following result.  The Corega (00:0A:79)
> AP was the one which sent zero length SSID if it was in hidden SSID mode.
> 
> > iwlist wlan0 scanning
> > wlan0     Scan completed :
> >           Cell 01 - Address: 00:06:25:C6:B9:A7
> >                     ESSID:"planexuser"
> >                     Channel=1
> >                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
> >                               11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
> >                               48 Mb/s; 54 Mb/s
> >                     Encryption key:on
> >                     Mode:Master
> >                     Signal level=100/100  
> >                     IE: IEEE 802.11i/WPA2 Version 1
> >                         Group Cipher : CCMP
> >                         Pairwise Ciphers (1) : CCMP
> >                         Authentication Suites (1) : PSK
> >           Cell 02 - Address: 00:0A:79:A5:D2:E2
> >                     ESSID:""
> >                     Channel:0
> >                     Encryption key:on
> >                     Mode:Master
> >                     Signal level=100/100  

Ewww.  You're 100% correct; we certainly shouldn't be sending a scan
result like this to userspace.  Therefore:

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> With fixed firmware:
> 
> > wlan0     Scan completed :
> >           Cell 01 - Address: 00:06:25:C6:B9:A7
> >                     ESSID:"planexuser"
> >                     Channel=1
> >                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
> >                               11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
> >                               48 Mb/s; 54 Mb/s
> >                     Encryption key:on
> >                     Mode:Master
> >                     Signal level=100/100  
> >                     IE: IEEE 802.11i/WPA2 Version 1
> >                         Group Cipher : CCMP
> >                         Pairwise Ciphers (1) : CCMP
> >                         Authentication Suites (1) : PSK
> >           Cell 02 - Address: 00:0A:79:A5:D2:E2
> >                     ESSID:""
> >                     Channel:1
> >                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
> >                               9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
> >                               48 Mb/s; 54 Mb/s
> >                     Encryption key:on
> >                     Mode:Master
> >                     Signal level=100/100  
> >                     IE: IEEE 802.11i/WPA2 Version 1
> >                         Group Cipher : CCMP
> >                         Pairwise Ciphers (1) : CCMP
> >                         Authentication Suites (1) : PSK
> > 
> 
> 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:55799 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbZGPGy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 02:54:57 -0400
Date: Thu, 16 Jul 2009 06:54:53 +0000
From: Joel Roth <joelz@pobox.com>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090716065453.GA3154@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
 <20090712203449.GA3058@sprite>
 <b6c5339f0907130708h3996b274qdcc7d7f6056a188c@mail.gmail.com>
 <20090714065414.GA16708@sprite> <20090716061457.GA1576@sprite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090716061457.GA1576@sprite>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 08:14:57PM -1000, Joel Roth wrote:
> On Mon, Jul 13, 2009 at 10:08:52AM -0400, Bob Copeland wrote:
> > On Sun, Jul 12, 2009 at 4:34 PM, Joel Roth<joelz@pobox.com> wrote:
> > > Vista advised me to:
> > >
> > > 1) turn on the hardware wifi switch <blush>
> > >
> > > 2) use the hotkey combination to enable wifi
> > 
> > It might be worth trying compat-wireless or 2.6.31-rcX.  Support
> > for reading the card's internal rfkill state was added in the
> > post-2.6.30 time-frame.
>  
> I installed compat-wireless against my 2.6.30.1 kernel,
> and also the iw command.
> 
> I've read some docs, however I'm not sure what the next step should be. 
> 
> My general idea is that I should be able to see a list of
> access points, however iwlist doesn't tell me anything new.
> 
> # iwlist wlan0 ap
> 
> wlan0     Interface doesn't have a list of Peers/Access-Points

After some RTFM'ing,

# iw wlan0 scan

BSS 00:40:05:c5:4f:19 (on wlan0) -- associated
	TSF: 9251942689 usec (0d, 02:34:11)
	freq: 2412
	beacon interval: 100
	capability: ESS PBCC (0x0041)
	signal: -40.00 dBm
	SSID: default
	Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0 
	DS Paramater set: channel 1
BSS 00:16:b6:db:fd:78 (on wlan0)
	TSF: 629448825249 usec (7d, 06:50:48)
	freq: 2437
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -105.00 dBm
	SSID: linksys
	Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
	DS Paramater set: channel 6
	ERP: Barker_Preamble_Mode
	Extended supported rates: 6.0 9.0 12.0 48.0 

# iw wlan0 connect default 

# dhclient wlan0

And voila! I have an IP address on wlan0.
I can't think of anything more that I need. :-)

Oh, maybe a pointer for others.

Perhaps I was just missing the iw 'connect' incantation?
'iwlist' was a complete red herring; didn't help me 
find my AP.

http://linuxwireless.org/en/users/Documentation was the only
site of several I visited mentioning 'iw' at all! 

And at linuxwireless, I find no example of using 'iw' to set
up a connection.  I'd be glad to contribute one.

Thanks Bob, Nick and others for your tips.


-- 
Joel Roth

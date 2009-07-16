Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-pb-sasl-sd.pobox.com ([64.74.157.63]:33231 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbZGPKNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 06:13:04 -0400
Date: Thu, 16 Jul 2009 00:07:43 -1000
From: Joel Roth <joelz@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joel Roth <joelz@pobox.com>, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090716100743.GC3867@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
 <20090712203449.GA3058@sprite>
 <b6c5339f0907130708h3996b274qdcc7d7f6056a188c@mail.gmail.com>
 <20090714065414.GA16708@sprite> <20090716061457.GA1576@sprite>
 <1247734019.19467.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1247734019.19467.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 10:46:59AM +0200, Johannes Berg wrote:
> On Wed, 2009-07-15 at 20:14 -1000, Joel Roth wrote:
> 
> > # iwlist wlan0 ap
> > 
> > wlan0     Interface doesn't have a list of Peers/Access-Points
> 
> # iwlist wlan0 scan
> 
> should have worked, but I'm glad you're making good use of iw :)

Hmm. It does work _now_, provided the interface is UP.

That may be thanks to having a recent kernel with the latest
compat-wireless drivers.

I was also misled by assuming iwlist's 'ap' option would
provide useful information. 

To summarize what I now know, the steps to follow for basic
wireless connectivity to an unencrypted network would be:

1. kernel and driver setup - use compat-wireless

2. set wireless interface to UP

	ifconfig <interface> up

3. find available networks using

	iw dev <interface> scan
 or 
	iwlist <interface> scan

4. connect to a network using 

	iw dev <interface> connect <SSID> 

5. acquire IP address, typically by

	dhclient <interface>

Regards,

Joel
 
> johannes



-- 
Joel Roth

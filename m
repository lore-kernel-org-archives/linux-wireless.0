Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eastrmmtao104.cox.net ([68.230.240.46]:46324 "EHLO
	eastrmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0HXBZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 21:25:18 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: lance lassetter <lance@lass205.info>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1282582845.13288.4.camel@wwguy-ubuntu>
References: <20100823110247.GA3198@infradead.org>
	 <1282572681.20674.3.camel@wwguy-ubuntu>
	 <20100823141432.GA29902@infradead.org>
	 <1282574533.12500.1.camel@wwguy-huron>
	 <20100823163259.GA15511@infradead.org>
	 <1282582845.13288.4.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 20:03:07 -0500
Message-ID: <1282611787.2446.7.camel@lass205.info>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-23 at 10:00 -0700, Guy, Wey-Yi wrote:
> On Mon, 2010-08-23 at 09:32 -0700, Christoph Hellwig wrote:
> > On Mon, Aug 23, 2010 at 07:42:13AM -0700, Guy, Wey-Yi wrote:
> > > Turn both iwlagn anf mac80211 debugging on when you compile kernel and
> > > use debug=0x43fff when you load the iwlagn module
> > 
> > Here's a log for the sequence of:
> > 
> > 	modprobe iwlagn debug=0x43fff
> > 	ifup wlan0
> > 
> > until dhclient times out.
> 
> Hi Christoph,
> 
> there is a important RTS/CTS patch
> 94597ab23ea10b3bdcba534be00a9f7b35791c07
> 
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commit;h=94597ab23ea10b3bdcba534be00a9f7b35791c07
> 
> 
> please apply and try
> 
> Thanks
> Wey

Hi,

Don't know if this is related but upon resume of a tuxonice kernel from
hibernation wireless is deauthenticated.  The router software runs 2.4
linux kernel.   The dmesg output is:

[ 3372.060428] wlan0: deauthenticated from 68:7f:74:26:dd:2e (Reason: 7)
[ 3372.065039] cfg80211: All devices are disconnected, going to restore
regulatory settings
[ 3372.065043] cfg80211: Restoring regulatory settings
[ 3372.065047] cfg80211: Calling CRDA to update world regulatory domain

I tried upgrading the router software to 2.6 kernel but due to wireless
stability issues on the router end I had to downgrade.

The kernel on the client is 2.6.35-tuxonice, the OS is Gentoo.  The only
kernel that I've tried that doesn't do this is 2.6.30-tuxonice-r11.
Anything greater than that is affected.

Lance

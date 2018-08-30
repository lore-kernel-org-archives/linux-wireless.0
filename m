Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727288AbeH3KfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 06:35:15 -0400
Date: Thu, 30 Aug 2018 14:34:32 +0800
From: Dave Young <dyoung@redhat.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: Intel Wireless 8265/8275 (rev 78) issue
Message-ID: <20180830063432.GA5201@dhcp-128-65.nay.redhat.com> (sfid-20180830_083506_897043_827F646E)
References: <20180829065442.GA3488@dhcp-128-65.nay.redhat.com>
 <6bb91f750e8d37d45da3c2cf1e7e5fc5d453ee8c.camel@coelho.fi>
 <20180830050632.GB2307@dhcp-128-65.nay.redhat.com>
 <fa12a23813cf096e217eac27835ed416ca0d1632.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa12a23813cf096e217eac27835ed416ca0d1632.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/18 at 08:55am, Luca Coelho wrote:
> On Thu, 2018-08-30 at 13:06 +0800, Dave Young wrote:
> > On 08/30/18 at 07:15am, Luca Coelho wrote:
> > > On Wed, 2018-08-29 at 14:54 +0800, Dave Young wrote:
> > > > [   74.123114] wlp61s0: authenticate with 00:1f:c6:82:0a:57
> > > > [   74.126099] wlp61s0: send auth to 00:1f:c6:82:0a:57 (try 1/3)
> > > > [   74.139740] wlp61s0: authenticated
> > > > [   74.140142] iwlwifi 0000:3d:00.0 wlp61s0: disabling HE/HT/VHT due to WEP/TKIP use
> > > > [   74.140146] iwlwifi 0000:3d:00.0 wlp61s0: disabling HT as WMM/QoS is not supported by the AP
> > > > [   74.140149] iwlwifi 0000:3d:00.0 wlp61s0: disabling VHT as WMM/QoS is not supported by the AP
> > > 
> > > Your AP seems to be configured to use WEP or TKIP, which is not allowed
> > > by IEEE802.11n, so we disable all the higher rates, as you can see
> > > here.  It should still work, but you will only get very basic rates
> > > (i.e. slow).
> > 
> > Luka, thanks for the suggestion,  moved AP to use WPA2-personal + AES.
> > seems I got only two features disabled this time:
> > [   20.949347] iwlwifi 0000:3d:00.0 wlp61s0: disabling HT as WMM/QoS is not supported by the AP
> > [   20.949351] iwlwifi 0000:3d:00.0 wlp61s0: disabling VHT as WMM/QoS is not supported by the AP
> > [   20.949622] wlp61s0: associate with 00:1f:c6:82:0a:57 (try 1/3)
> 
> There are many interoperability problems with old 11n APs that either
> support a draft version of the specs or simply have bugs in their
> implementations of the 11n specs.  When we detect these problems, we
> disable 11n rates, so connectivity will be slower, but it will at least
> remain connected.  This seems to be the case with your AP. :(

This seems not cause much slower connection.
But WMM indeed cause a very slow connection, thus I just leave WMM
disabled as before.

> 
> 
> > > > [ 2521.068469] wlp61s0: deauthenticating from 00:1f:c6:82:0a:57 by local choice (Reason: 3=DEAUTH_LEAVING)
> > > 
> > > Other than that I can't really see what is going on, except that
> > > something is deciding to disconnect here...
> > > 
> > > So, first thing I'd suggest would be to try to reconfigure your AP to
> > > use something else than WEP or TKIP, just to see if it improves in any
> > > way.
> > 
> > Will observe if it works or not. BTW, my old laptop Thinkpad T440s works
> > well with the same AP.
> 
> I hope it improves.  If not, we should debug it further.  It's a good
> thing not to use WEP and TKIP anyway, because they're not very secure
> anyway.

Ok, will provide feedback later, thanks!

> 
> 
> > > And BTW, is this a regression in recent kernels or has this always
> > > happened to you with this laptop/AP combination?
> > 
> > From my observation it just always happen, but hmm not 100% sure..
> 
> Okay, so we don't have enough information on this.  It doesn't matter. 
> What is the NIC on your old T440s?

It is Intel wireless 7260, but since the laptop is not at hand I can not
get lspci details.

> 
> --
> Cheers,
> Luca.
> 

Thanks
Dave

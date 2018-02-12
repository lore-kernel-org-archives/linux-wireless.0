Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751150AbeBLUBm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 15:01:42 -0500
Message-ID: <1518465698.30914.25.camel@coelho.fi> (sfid-20180212_210146_386552_A9962D4C)
From: Luca Coelho <luca@coelho.fi>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Feb 2018 22:01:38 +0200
In-Reply-To: <20180212185259.vuhee7ojgqyjdeeo@pali>
References: <20180130194926.lg3grfffcsruiz4j@pali>
         <1518461327.30914.17.camel@coelho.fi>
         <20180212185259.vuhee7ojgqyjdeeo@pali>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Centrino Advanced-N 6235 - Microcode SW error detected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-12 at 19:52 +0100, Pali Rohár wrote:
> On Monday 12 February 2018 20:48:47 Luca Coelho wrote:
> > On Tue, 2018-01-30 at 20:49 +0100, Pali Rohár wrote:
> > > Hello,
> > 
> > Hi Pali,
> > 
> > 
> > > for almost 3 years I have a problem with Intel wifi card Centrino
> > > Advanced-N 6235. Its firmware periodically crash and in dmesg I'm
> > > seeing
> > > a message "Microcode SW error detected".
> > > 
> > > Problem happens independently of kernel versions (I tried 3.8,
> > > 3.13,
> > > 3.18, 4.0, 4.9). Currently I'm using Debian Stretch and its 4.9
> > > version.
> > > 
> > > This wifi card is identified as:
> > > 
> > > $ lspci -s 03:00.0 -vv
> > > 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 
> > > 6235 (rev 24)
> > >         Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
> > 
> > [...]
> > 
> > > And here is example of dmesg error flood:
> > > 
> > > [26624.998823] iwlwifi 0000:03:00.0: Microcode SW error
> > > detected.  Restarting 0x2000000.
> > 
> > [...]
> > 
> > > [26624.999013] iwlwifi 0000:03:00.0: Loaded firmware version:
> > > 18.168.6.1
> > > [26624.999117] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
> > > [26624.999118] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
> > > [26624.999120] iwlwifi 0000:03:00.0: 0x000028AA |
> > > ADVANCED_SYSASSERT          
> > > [27464.823779] iwlwifi 0000:03:00.0: Loaded firmware version:
> > > 18.168.6.1
> > > [27464.823903] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
> > > [27464.823904] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
> > > [27464.823906] iwlwifi 0000:03:00.0: 0x000028AA |
> > > ADVANCED_SYSASSERT          
> > 
> > [...]
> > 
> > > This really looks like firmware problem. What can I do with these
> > > microcode errors? Can you help me?
> > 
> > Yes, this is a firmware problem.  But unfortunately this is a
> > really
> > old hardware (6 years old) and we don't support the firmware
> > anymore. 
> 
> Hi! That is pity :-(
> 
> > I'm sorry, but there is really nothing we can do.
> 
> So can I debug this problem myself? Is there any documentation or
> resources for this?

Nothing prevents you from trying to debug.  Maybe find the exact
situation when this happens and try to make a workaround in the driver.
 But unfortunately we don't have any public documentation for this
firmware, so you'll have to try to solve it in the driver entirely.

Sadly, I wouldn't have much hope in succeeding, since this is most
likely a purely firmware side bug which may be impossible to work
around in the driver. :(

Good luck!

--
Cheers,
Luca.

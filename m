Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53924 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754703AbdJRGQP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 02:16:15 -0400
Message-ID: <1508307368.5497.125.camel@coelho.fi> (sfid-20171018_081619_338730_BFFEEC9D)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Marc MERLIN <marc@merlins.org>, linux-wireless@vger.kernel.org,
        linuxwifi@intel.com
Date: Wed, 18 Oct 2017 09:16:08 +0300
In-Reply-To: <87infduk4b.fsf@purkki.adurom.net>
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
         <1496396575.9478.54.camel@coelho.fi> <20170603165950.GC29546@merlins.org>
         <20170816233844.qtigfurckdr44awa@merlins.org>
         <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
         <1508249157.5497.103.camel@coelho.fi>
         <20171017212319.eranorcigrmgcpyo@merlins.org>
         <1508276099.5497.122.camel@coelho.fi> <87infduk4b.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-18 at 07:59 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Tue, 2017-10-17 at 14:23 -0700, Marc MERLIN wrote:
> > > On Tue, Oct 17, 2017 at 05:05:57PM +0300, Luca Coelho wrote:
> > > > Hi,
> > > > 
> > > > On Tue, 2017-10-17 at 02:44 -0700, Marc MERLIN wrote:
> > > > > Was broken in 4.11, still broken in 4.12. This is crippling,
> > > > > I'm
> > > > > not
> > > > > running linux so that I have to reboot it to reload an intel
> > > > > wireless
> > > > > driver :-/
> > > > 
> > > > Can you report a bug in https://bugzilla.kernel.org so it's
> > > > easier
> > > > to
> > > > track this?
> > > > 
> > > > The problem seems to be that the rootport is not leaving D3 for
> > > > some
> > > > reason when the driver is loaded again.  Do you have
> > > > CONFIG_IWLWIFI_PCIE_RTPM enabled in your .config? (you
> > > > shouldn't)
> > > 
> > >  
> > > I don't know how or why, but I seem to:
> > > saruman:~# grep IWLWIFI /boot/config-4.12.10-amd64-preempt-sysrq-
> > > 20170406 
> > > CONFIG_IWLWIFI=m
> > > CONFIG_IWLWIFI_LEDS=y
> > > CONFIG_IWLWIFI_OPMODE_MODULAR=y
> > > # CONFIG_IWLWIFI_BCAST_FILTERING is not set
> > > CONFIG_IWLWIFI_PCIE_RTPM=y
> > > CONFIG_IWLWIFI_DEBUG=y
> > > CONFIG_IWLWIFI_DEVICE_TRACING=y
> > > 
> > > I'll remove that, thanks.
> > 
> > Cool, I think that might help.  If it doesn't, please report a bug
> > in
> > buzilla. ;)
> 
> But a Kconfig option should never break functionality, so IMHO this
> still sounds like a bug in iwlwifi.

The problem is that to get this to work, some changes need to be made
in the platform side.  In this case, the rootport is not configured
properly so it won't work.

We discussed this before and that's why this option now depends on
EXPERT.

--
Luca.

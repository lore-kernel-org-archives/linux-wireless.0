Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752167AbdJQVfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 17:35:05 -0400
Message-ID: <1508276099.5497.122.camel@coelho.fi> (sfid-20171017_233508_597411_6E2E0752)
From: Luca Coelho <luca@coelho.fi>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Wed, 18 Oct 2017 00:34:59 +0300
In-Reply-To: <20171017212319.eranorcigrmgcpyo@merlins.org>
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
         <1496396575.9478.54.camel@coelho.fi> <20170603165950.GC29546@merlins.org>
         <20170816233844.qtigfurckdr44awa@merlins.org>
         <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
         <1508249157.5497.103.camel@coelho.fi>
         <20171017212319.eranorcigrmgcpyo@merlins.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-17 at 14:23 -0700, Marc MERLIN wrote:
> On Tue, Oct 17, 2017 at 05:05:57PM +0300, Luca Coelho wrote:
> > Hi,
> > 
> > On Tue, 2017-10-17 at 02:44 -0700, Marc MERLIN wrote:
> > > Was broken in 4.11, still broken in 4.12. This is crippling, I'm
> > > not
> > > running linux so that I have to reboot it to reload an intel
> > > wireless
> > > driver :-/
> > 
> > Can you report a bug in https://bugzilla.kernel.org so it's easier
> > to
> > track this?
> > 
> > The problem seems to be that the rootport is not leaving D3 for
> > some
> > reason when the driver is loaded again.  Do you have
> > CONFIG_IWLWIFI_PCIE_RTPM enabled in your .config? (you shouldn't)
> 
>  
> I don't know how or why, but I seem to:
> saruman:~# grep IWLWIFI /boot/config-4.12.10-amd64-preempt-sysrq-
> 20170406 
> CONFIG_IWLWIFI=m
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLWIFI_OPMODE_MODULAR=y
> # CONFIG_IWLWIFI_BCAST_FILTERING is not set
> CONFIG_IWLWIFI_PCIE_RTPM=y
> CONFIG_IWLWIFI_DEBUG=y
> CONFIG_IWLWIFI_DEVICE_TRACING=y
> 
> I'll remove that, thanks.

Cool, I think that might help.  If it doesn't, please report a bug in
buzilla. ;)

--
Cheers,
Luca.

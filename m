Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44271 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760497AbdJQVXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 17:23:23 -0400
Date: Tue, 17 Oct 2017 14:23:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Message-ID: <20171017212319.eranorcigrmgcpyo@merlins.org> (sfid-20171017_232332_033337_6D2401BD)
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
 <1496396575.9478.54.camel@coelho.fi>
 <20170603165950.GC29546@merlins.org>
 <20170816233844.qtigfurckdr44awa@merlins.org>
 <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
 <1508249157.5497.103.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508249157.5497.103.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 05:05:57PM +0300, Luca Coelho wrote:
> Hi,
> 
> On Tue, 2017-10-17 at 02:44 -0700, Marc MERLIN wrote:
> > Was broken in 4.11, still broken in 4.12. This is crippling, I'm not
> > running linux so that I have to reboot it to reload an intel wireless
> > driver :-/
> 
> Can you report a bug in https://bugzilla.kernel.org so it's easier to
> track this?
> 
> The problem seems to be that the rootport is not leaving D3 for some
> reason when the driver is loaded again.  Do you have
> CONFIG_IWLWIFI_PCIE_RTPM enabled in your .config? (you shouldn't)
 
I don't know how or why, but I seem to:
saruman:~# grep IWLWIFI /boot/config-4.12.10-amd64-preempt-sysrq-20170406 
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_OPMODE_MODULAR=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set
CONFIG_IWLWIFI_PCIE_RTPM=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEVICE_TRACING=y

I'll remove that, thanks.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

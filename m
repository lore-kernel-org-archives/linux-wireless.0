Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:46090 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbeFEKoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 06:44:08 -0400
Date: Tue, 5 Jun 2018 03:44:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [RFT 3/6] wlcore: Add support for runtime PM
Message-ID: <20180605104404.GD5738@atomide.com> (sfid-20180605_124412_883234_C279E102)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com>
 <20180531171420.GQ5705@atomide.com>
 <fe42f9d6bb744cd39e38db8f51c0b74e@ti.com>
 <20180605042000.GA5738@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605042000.GA5738@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180605 04:22]:
> * Reizer, Eyal <eyalr@ti.com> [180603 06:07]:
> > I have noticed the following recovery a couple of times on my setup when the board was 
> > just sitting for a long time with just pings
> > It starts with a firmware recovery started from the interrupt handler but the recovery fails 
> 
> Sounds like the recovery needs some more work :)
> 
> > leaving the sdio stuck.
> > At this stage the only way to get out of it is unload/load of the driver modules.
> > Have you seen this on your side as well?
> 
> Hmm I don't think I've seen this one yet.
> 
> > 64 bytes from 192.168.100.1: seq=32772 ttl=64 time=9.644 ms
> > 64 bytes from 192.168.100.1: seq=32773 ttl=64 time=9.572 ms
> > 64 bytes from 192.168.100.1: seq=32774 ttl=64 time=10.974 ms
> > 64 bytes from 192.168.100.1: seq=32775 ttl=64 time=9.618 ms
> > [127899.040526] wlcore: ERROR SW watchdog interrupt received! starting recovery.
> 
> Do you know what does the SW watchdog means here? Does it mean the
> interrupt did not get delivered to wlcore? Or a spurious IRQ to wlcore?
> Or a timeout waiting for the ELP wake interrupt?

Also, can you check if patch "[RFT 7/6] wlcore: Make sure firmware is initialized
in wl1271_op_add_interface()" already fixes this issue if you did not have it
already applied?

Regards,

Tony

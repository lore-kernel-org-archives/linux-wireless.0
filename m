Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42644 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753920AbcEXFxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 01:53:07 -0400
Message-ID: <1464069167.30665.23.camel@coelho.fi> (sfid-20160524_075313_001511_A30A6D87)
From: Luca Coelho <luca@coelho.fi>
To: Ruben De Smet <ruben.de.smet@rubdos.be>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: linuxwifi@intel.com
Date: Tue, 24 May 2016 08:52:47 +0300
In-Reply-To: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be>
References: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel wifi card + TP-LINK AC1200 rev 1.2 = ???
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ruben,

Thanks for the detailed report!

On Mon, 2016-05-23 at 21:08 +0200, Ruben De Smet wrote:
> Hello,
> 
> My specs:
> =========
> 
> Wireless Access Point:
> ----------------------
> TP-LINK AC1200 rev1.2
> 
> PC1 (my laptop)
> ---
> 
> - Lenovo Thinkpad X250
> - 03:00.0 Network controller: Intel Corporation Wireless 7265 (rev
> 59)
> - Arch Linux (4.6.0-rc6-mainline, I need to update)
> - Confirm the bug under 4.5
> 
> PC2 (brother's laptop)
> ---
> Acer subnotebook
> Intel 7250 (iirc)
> Ubuntu 14.04 stock kernel
> 
> PC3 (htpc)
> ---
> Zotac HTPC (BI323)
> 01:00.0 Network controller: Intel Corporation Wireless 3160 (rev 83)
> Fedora 23 64 bit with boot-to-Kodi
> 
> 
> Newly Ordered PC (cannot confirm yet, could possibly test windows):
> ----------------
> Lenovo Thinkpad T450
> Intel 7/8250? Don't know yet, but I know it's Intel again.
> Will run Ubuntu 16.04 or 14.04. Not sure yet
> 
> 
> They all have in common:
> ========================
> - Linux, Intel wifi card and TP-LINK Archer AC router AC1200 rev 1.2.
> 
> 
> The problem(s?):
> ================
> 
> When near the TP-LINK access point, NetworkManager needs
> reconfirmation
> of password. On the htpc, this means loggin in on the console,
> `nmtui`,
> activate connection.
> 
> On the computers with DE, this means a dialog box opens asking for a
> password, which is already filed. Pressing enter connects to the
> network.
> 
> My laptop, as my brother's, tend to lose the connection now and then.
> When I checked `dmesg`, it said to be "lowering the transmission
> power
> as requested by the accesspoint by -xdB" (not those exact words, I
> can
> retrigger the exact error though), before losing the connection some
> seconds later.
> 
> Other tested (working) configurations:
> - TP-LINK Archer C2 (which is without AC iirc)
> - Good ol' Linksys WRT
> - eduroam at my uni
> - any other wifi point I've ever had access to.
> - Tested another PC with a lot older (Intel) WiFi card (with AC):
> same
> issue.
> 
> Not tested:
> - Windows (don't have any Windows pc with those cards near me atm)
> 
> I see two options here:
> - TP-LINK bug
> - Intel iwlwifi bug
> 
> Please advice on what I should test, which logs to send, ...

This sounds like an interoperability issue between your AP (AC1200) and
Intel's NICs.  Did you try any non-Intel NICs with the same AP?

The other AP you mentioned (Archer C2) also supports 802.11ac.  I have
one and haven't had problems with it (I use OpenWRT in it, though).

To go forward on this investigation, could you please create a bugzilla
entry at bugzilla.kernel.org as described in our debugging wikipage[1]?
Please provide at least dmesg and trace-cmd logs of the failing case to
start with.

Additionally, you could capture sniffer logs with one of your devices
while the other is having trouble so we can see what is going on.  Let
us know if you need help with that.

[1] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

--
Cheers,
Luca.
> 

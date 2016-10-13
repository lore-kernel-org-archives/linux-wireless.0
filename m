Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753761AbcJMMov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:44:51 -0400
Message-ID: <1476362653.3880.25.camel@coelho.fi> (sfid-20161013_144455_843726_88DDA38F)
From: Luca Coelho <luca@coelho.fi>
To: Paul Bolle <pebolle@tiscali.nl>, linux-wireless@vger.kernel.org,
        chris@rorvick.com
Cc: linuxwifi@intel.com, emmanuel.grumbach@intel.com,
        johannes@sipsolutions.net, kvalo@codeaurora.org,
        oren.givon@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2016 15:44:13 +0300
In-Reply-To: <1476362194.1999.11.camel@tiscali.nl>
References: <1476349269.3880.18.camel@coelho.fi>
         <20161013102155.14547-1-luca@coelho.fi>
         <1476358075.1999.5.camel@tiscali.nl> <1476358222.3880.21.camel@coelho.fi>
         <1476362194.1999.11.camel@tiscali.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: pcie: fix SPLC structure parsing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 14:36 +0200, Paul Bolle wrote:
> On Thu, 2016-10-13 at 14:30 +0300, Luca Coelho wrote:
> > I forgot to say... could you load the iwlwifi module with debug=0x01
> > (module parameter), so we can see the messages the driver is printing
> > when it doesn't find a proper structure?
> 
> 
> That makes a lot of noise! Here's the first 100 lines or so, that
> apparently are generated directly after modprobing iwlwifi.
> 
> After these 100 lines there's a ten second gap (I guess it took me ten
> seconds to actually use the wifi). I assume you don't care about that
> part of the debug messages.
> 
> Have fun!

Thanks, Paul!

Yeah, this is the "INFO" debugging level and it is a sort of fallback
bucket when there is nothing more specific.  Sorry for that.


> <7>[  767.691342] iwlwifi 0000:3a:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
> <7>[  767.691362] iwlwifi 0000:3a:00.0: U iwl_pcie_set_hw_ready hardware ready
> <7>[  767.692127] iwlwifi 0000:3a:00.0: U iwl_request_firmware attempting to load firmware 'iwlwifi-8000C-24.ucode'
> <7>[  767.692322] iwlwifi 0000:3a:00.0: U splc_get_pwr_limit No element for the WiFi domain returned by the SPLC method.

This is the line I was looking for. :) So everything looks fine now.
 Even though there is apparently something wrong with this part of the
ACPI table on you laptop, since it doesn't match our specifications.
 In any case, it's mostly harmless.

Thanks for the help!

--
Cheers,
Luca.

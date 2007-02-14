Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:26745 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751485AbXBNBSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 20:18:43 -0500
Message-ID: <45D25984.7080808@linux.intel.com>
Date: Tue, 13 Feb 2007 16:36:20 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: network manager vs. missing firmware
References: <1171392106.10344.100.camel@johannes.berg> <1171394598.5329.31.camel@localhost.localdomain>
In-Reply-To: <1171394598.5329.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:

> The simpler, the better I think; but it's complicated.  A sample of
> current drivers and when they call request_firmware() from a 2.6.19
> kernel:
> 
> on dev->open: atmel, prism54, bcm43xx (softmac)
> on dev->init: ipw2100, ipw2200

request_firmware is also used during mode changes (ie, BSS to IBSS to 
MONITOR)

Perhaps solving the larger problem of "the driver knows something is 
horribly wrong, but has no way to tell the user" would be good. 
Firmware not being there is bad.  There are also periodic failures or 
usage conditions that keep things from working.  Right now we might have 
failures due to:

	FIRMWARE missing
	RF KILL active

but maybe tomorrow we would have:

	Conflict with other active wifi device / coexistence

or any number of solution specific error codes that the vendor / driver 
writer would be able to articulate in a text string how to resolve.

Perhaps a simple cfg80211 interface for querying the interface status 
and and associated text string (if in an error condition).  Missing 
firmware or RF kill could have standard numbers and the text string 
could be standardized to return just the name of the firmware file expected.

Even if it didn't get standardized across all devices, NM or other 
utilities could provide a standard place for the user to look at the 
error and then google on it.  Right now, things break and the user can't 
figure out why without looking at the kernel log (which many users don't 
even know exist).

James

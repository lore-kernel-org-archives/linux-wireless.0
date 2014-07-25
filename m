Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33064 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760501AbaGYOSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 10:18:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by gateway1.nyi.internal (Postfix) with ESMTP id A761222413
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 10:10:55 -0400 (EDT)
Message-ID: <53D26552.2070201@fastmail.fm> (sfid-20140725_162411_478464_280FDD12)
Date: Fri, 25 Jul 2014 15:10:26 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
MIME-Version: 1.0
To: Ben Chan <benchan@chromium.org>, Greg KH <greg@kroah.com>
CC: devel@driverdev.osuosl.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, inaky@linux.intel.com
Subject: Re: How to replace control code in gdm72xx?
References: <53C6DF7C.8030109@fastmail.fm> <20140716204004.GA31349@kroah.com> <CAC5Y2nNfiZ_cdiitj07KsB_DbGTgO=PMUwHGaXwrXjQ-U1bLyA@mail.gmail.com>
In-Reply-To: <CAC5Y2nNfiZ_cdiitj07KsB_DbGTgO=PMUwHGaXwrXjQ-U1bLyA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2014 01:59 AM, Ben Chan wrote:
> 
> From what I read from the user-space code, the custom ioctl is to read
> the following information from the driver:
> 
> enum {
>     SIOC_DATA_FSM,           // Device/Connection State
>     SIOC_DATA_NETLIST,       // Network list
>     SIOC_DATA_CONNNSP,     // Connected NSP
>     SIOC_DATA_CONNCOMP,    // Connection completion info
>     SIOC_DATA_PROFILEID,    // WiMAX profile ID
>     SIOC_DATA_END
> };
> 

Sorry for the late reply, I was away. 

I had a look at the library's source to clear things out a bit. From what I see the driver is tightly coupled -actually dependent- to the library, as all control operations are performed by the latter. So without the library, the driver is pretty much of no use.

The way control works is that the driver acts as a middleman between the library and the hci. All operations are initiated and handled by the library, through the netlink channel. So the information mentioned above, eg SIOC_DATA_NETLIST, are requested by the library, by sending the appropriate command to the driver via netlink. The driver will forward the request to the hci and forward the response back to userspace.

Here is where the ioctl part interface into play. The ioctl interface supports two commands: SIOCS_DATA and SIOCG_DATA (set data / get data). The above can store and retrieve data from the driver, which in turn keeps this information in the nic.sdk_data array. This array maintains one element for each one of the SIOC_DATA_* mentioned above.

So once received and processed, the library will store the received data (eg the network list) in the driver's memory via the ioctl, just to retrieve it again later(!) With the exception of SIOC_FSM_XXX, the driver does not inspect or process the contents of these objects by any means (see gdm_wimax_ioctl() in gdm_wimax.c).

Now, I have no clue why it was written this way, but as per its current 
status all this might as well (and probably should) be stored locally, in userspace memory. So the ioctl part can be completely removed, and the driver will then be in conformance with the interface defined by the wimax stack, in wimax.h.

> 
> The driver has a corresponding user-space library, so I'd like to
> figure out a way to maintain backward compatibility if possible. But
> I'm happy to help make minor changes to  the user-space library in
> case we need to modify the ioctl / netlink part of the driver (caveat:
> I'm not the author of the driver or the user-space library).
> 

Why maintain backwards compatibility? The only part to change is the
communication layer between the library and the driver. The applications
using the library won't notice any difference.

IMO the right thing to do is to push whatever changes made to the library upstream. Which brings us to the question of who is the library's maintainer and where is it officially hosted?

If the answers to the above are "none" and "nowhere", then we have a bigger problem, as the updated driver will appear to be broken to anyone who hasn't been updated with the latest version of the library.

In conclusion, I am happy to fix the driver and even write a patch for the corresponding userspace parts, but only as long as:

* You are willing to help me with testing, as I do not own the hardware.

* My work will not be waisted. What I mean by that is, if the library has been distributed only to a few parties worldwide, then IMO we'd better delete the driver and let it be distributed along with the library, since they are interdependent anyway.

In any other case, I'd rather move on to some other driver that does not depend on third party stuff :)

Thanks,

Michalis

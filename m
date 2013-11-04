Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37526 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDNHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 08:07:50 -0500
Date: Mon, 4 Nov 2013 16:07:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
Message-ID: <20131104130728.GA20521@mwanda> (sfid-20131104_140753_824430_827D5C29)
References: <20131104115111.GM26669@mwanda>
 <52778D30.6030605@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52778D30.6030605@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 04, 2013 at 01:04:00PM +0100, Hauke Mehrtens wrote:
> On 11/04/2013 12:51 PM, Dan Carpenter wrote:
> > I've been trying to remember the trick to get BRCM to work and I can't
> > remember at all.  I'm using BCM4313.  I've enabled everything with BCMA
> > or BRCM in the config name.
> > 
> > The module loads and the device shows up if I type "ifconfig wlan0" but
> > network manager doesn't see it and wicd doesn't see it.  (These are old
> > versions of nm and wicd).
> > 
> > This used to work under 3.8 but I didn't save my .config...  :(
> 
> Are these old versions of nm and wicd only supporting the deprecated
> WEXT interface? If this is the case you have to set
> CONFIG_CFG80211_WEXT=y in your config.
> 

I have that enabled.

> You also need a firmware for this device /lib/firmware/brcm/bcm43xx-0.fw
> and /lib/firmware/brcm/bcm43xx_hdr-0.fw are needed.

I have the firmware.

> 
> When the device gets detected by brcmsmac, it is probably not a problem
> in the Broadcom driver.
> 
> > I've done a google search and it seems like the broadcom driver is still
> > a complete mess and you need to black list modules and hack everything
> > yourself on a per system basis?  Is that right?  Why can't we fix this
> > so it works?
> 
> When you want to use the property closed source Broadcom driver then you
> have to blacklist the in kernel drivers. When you want to use the in
> kernel drivers, BCM4313 should get detected and the modules should get
> loaded like it is done for every other PCIe device.

I don't have the closed source driver.

I'll do some more testing and get back on this.

regards,
dan carpenter


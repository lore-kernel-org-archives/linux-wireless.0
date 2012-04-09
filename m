Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58102 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2DIUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 16:15:13 -0400
Date: Mon, 9 Apr 2012 12:46:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, Larry.Finger@lwfinger.net,
	bhutchings@solarflare.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big network
 copies (page allocation failure)
Message-ID: <20120409194657.GA24754@merlins.org> (sfid-20120409_221525_338232_4DF5D719)
References: <20120409.143710.879746943062854492.davem@davemloft.net>
 <4F83316F.20504@lwfinger.net>
 <1333998672.3007.245.camel@edumazet-glaptop>
 <20120409.153452.1284163346306246866.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120409.153452.1284163346306246866.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2012 at 03:34:52PM -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 09 Apr 2012 21:11:12 +0200
> 
> > I think Marc posted stack traces showing problem on transmit side.
>  ...
> > I dont really understand how it can happen, with MTU=1500
> 
> Depending upon the configuration and the driver, wireless can need
> more headroom.  For encryption an extra 8 bytes are necessary, and the
> driver may request a variable amount of extra headroom via
> ->hw.extra_tx_headroom
> 
> What wireless device are we dealing with again?

Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2011 Intel Corporation
iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlwifi 0000:03:00.0: setting latency timer to 64
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057a4000
iwlwifi 0000:03:00.0: HW Revision ID = 0x0
iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
iwlwifi 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
iwlwifi 0000:03:00.0: Device SKU: 0Xf0
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels

along with iwlwifi-5000-5.ucode

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57696 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbXEWBqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 21:46:53 -0400
Message-ID: <46539D09.2050902@garzik.org>
Date: Tue, 22 May 2007 21:46:49 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <200705221806.07696.flamingice@sourmilk.net>
In-Reply-To: <200705221806.07696.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> However, I don't like it. Bringing the hardware up should be deferred as much 
> as possible to when the user actually brings the interface up. ipw2200 can 
> defer firmware loading to interface open time while still reading the mac 
> address from the eeprom.. why not ipw3945? (the ipw2200 driver doesn't 
> actually do this, but it should. I know it can.)

VERY good point.  This is the standard for ethernet drivers:

probe:
	basic hardware init, read MAC address from EEPROM
interface up:
	full hardware power-up, reset and init
	write MAC address to hardware
	request irq
	net stack up
interface down:
	net stack down
	hardware, power & irq down

And I would hope that wireless drivers would follow a similar pattern.

	Jeff



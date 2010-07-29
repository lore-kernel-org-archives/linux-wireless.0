Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab0G2Spi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:45:38 -0400
Date: Thu, 29 Jul 2010 14:44:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@wfinger.net>
Subject: Re: [PATCH] b43: update hw/fw version info in wiphy struct
Message-ID: <20100729184414.GE2424@tuxdriver.com>
References: <1280424853-18954-1-git-send-email-linville@tuxdriver.com>
 <4C51C2C4.7050207@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C51C2C4.7050207@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 08:04:52PM +0200, Michael Büsch wrote:
> On 07/29/2010 07:34 PM, John W. Linville wrote:
> >+	wiphy->hw_version = dev->dev->bus->chip_id;
> 
> Hm, well. Is hw_version of any use, actually? How does ethtool display
> it? I guess it does not use BCD (chip_id is BCD encoded).

It is available through the ETHTOOL_GREGS ioctl.  The userland ethtool
app can be extended to interpret the value for a specific driver.

> What about using the wireless-core revision? It is slightly more usable
> than the chip_id.

Patch v2 posted...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

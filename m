Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbYEUTG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 15:06:26 -0400
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile
	configuration.
From: David Woodhouse <dwmw2@infradead.org>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	carrano@laptop.org, dilinger@queued.net
In-Reply-To: <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 20:06:20 +0100
Message-Id: <1211396780.21380.368.camel@pmac.infradead.org> (sfid-20080521_210630_613202_053CDEB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 11:59 -0700, Javier Cardona wrote:
> 
> If the boottime is set smaller than the host boot time, the device
> will transition into standalone mode before it is detected by the
> host.  The only recovery when that happens is to either reset the
> device via an external reset line or to re-insert it. 

Nah, the driver will send it a CMD_802_11_RESET when it finds it not
responding properly to bootcmds, and it should be fine.

>  That lower boundary was just intended to avoid support issues of
> users seeing their devices disappear after a reboot.

I remember that well :)

-- 
dwmw2


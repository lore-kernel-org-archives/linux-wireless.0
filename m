Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44053 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0CWIzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 04:55:51 -0400
Received: by vws6 with SMTP id 6so739592vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 01:55:50 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Tue, 23 Mar 2010 09:55:39 +0100
Cc: Calvin Walton <calvin.walton@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu> <4BA7E79C.9070100@lwfinger.net>
In-Reply-To: <4BA7E79C.9070100@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003230955.39871.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 22:56:44 Larry Finger wrote:
> On 03/22/2010 01:28 AM, Calvin Walton wrote:
> > I'm curious, how would this firmware-loading scheme deal with having
> > multiple cards of this type installed? This seems like an unusual
> > situation, but it looks like this patch will cause all of the cards to
> > start up with the same MAC address due to the fixed filename.
> 
> I have a workaround for this problem based on the bus address of the
>  device.
> 
> > Instead of using a firmware file to load in the MAC address, might it be
> > possible to move the persistent MAC setting to a simple udev rule which
> > generates a persistent MAC address, saves it, then sets it each boot
> > using a command like "ip link set wlan0 address XX:XX:XX:XX:XX:XX" ?
> >
> > This would remove the need to have this "fake" firmware file available
> > at boot, provided that the driver can handle leaving the address
> > unconfigured until userspace gets around to setting it. As well, it
> > could be written to work with multiple cards easily, saving a different
> > MAC for each.
> 
> Does anyone have any suggestions on what characteristic could be used to
> generate a unique MAC address for a box in a udev rule? Unless someone
>  proposes a workable solution, I will push V3 of my patch with the bus
>  address change noted above.

Why not use random_ether_addr and only use the digits that you are interested 
in?
--
Florian

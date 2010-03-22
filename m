Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:11130 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab0CVV4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 17:56:49 -0400
Received: by ey-out-2122.google.com with SMTP id d26so523128eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 14:56:48 -0700 (PDT)
Message-ID: <4BA7E79C.9070100@lwfinger.net>
Date: Mon, 22 Mar 2010 16:56:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu>
In-Reply-To: <1269239303.12836.17.camel@ayu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2010 01:28 AM, Calvin Walton wrote:
> 
> I'm curious, how would this firmware-loading scheme deal with having
> multiple cards of this type installed? This seems like an unusual
> situation, but it looks like this patch will cause all of the cards to
> start up with the same MAC address due to the fixed filename.

I have a workaround for this problem based on the bus address of the device.

> Instead of using a firmware file to load in the MAC address, might it be
> possible to move the persistent MAC setting to a simple udev rule which
> generates a persistent MAC address, saves it, then sets it each boot
> using a command like "ip link set wlan0 address XX:XX:XX:XX:XX:XX" ?
> 
> This would remove the need to have this "fake" firmware file available
> at boot, provided that the driver can handle leaving the address
> unconfigured until userspace gets around to setting it. As well, it
> could be written to work with multiple cards easily, saving a different
> MAC for each.

Does anyone have any suggestions on what characteristic could be used to
generate a unique MAC address for a box in a udev rule? Unless someone proposes
a workable solution, I will push V3 of my patch with the bus address change
noted above.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:62225 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0CVG23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 02:28:29 -0400
Received: by qyk9 with SMTP id 9so3042223qyk.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 23:28:28 -0700 (PDT)
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
From: Calvin Walton <calvin.walton@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 02:28:23 -0400
Message-ID: <1269239303.12836.17.camel@ayu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 2010-03-20 at 19:14 -0500, Larry Finger wrote:
Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
> from the SPROM could be included in the kernel; however, this presents
> a problem in the generation of a unique, reproducible MAC address. The
> solution has been to create a utility that generates a virtual SPROM
> image with a random MAC address. This image is stored in the firmware
> area, and loaded using the asyncronous firmware load facility.

I'm curious, how would this firmware-loading scheme deal with having
multiple cards of this type installed? This seems like an unusual
situation, but it looks like this patch will cause all of the cards to
start up with the same MAC address due to the fixed filename.

Instead of using a firmware file to load in the MAC address, might it be
possible to move the persistent MAC setting to a simple udev rule which
generates a persistent MAC address, saves it, then sets it each boot
using a command like "ip link set wlan0 address XX:XX:XX:XX:XX:XX" ?

This would remove the need to have this "fake" firmware file available
at boot, provided that the driver can handle leaving the address
unconfigured until userspace gets around to setting it. As well, it
could be written to work with multiple cards easily, saving a different
MAC for each.

Some thoughts for your consideration,
-- 
Calvin Walton <calvin.walton@gmail.com>


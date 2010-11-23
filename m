Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:64575 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab0KWRva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 12:51:30 -0500
Subject: Re: No scan results from wl1271-sdio
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Josh Watts <JWatts@d3engineering.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AB927C5B3615784183753F31BCC83EA38C58FE29@AD.d3.local>
References: <AB927C5B3615784183753F31BCC83EA38C58FE29@AD.d3.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 19:51:20 +0200
Message-ID: <1290534680.5617.11.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Josh,

On Tue, 2010-11-23 at 10:34 -0500, ext Josh Watts wrote:
> I've been trying to get the wl1271-sdio driver to work, and so far I've
> managed to get the device to start up, but am unable to see any access
> points. I'm using the latest head from Luciano's wl12xx tree, and for
> firmware I'm using the files committed to linux-firmware by Shahar Levi
> (wl1271-fw.bin version 6.1.0.0.343). I'm wondering if there's maybe some
> minor component or setting that I'm missing (like radio-enable, or
> perhaps limit to 802.11a, etc)?

If you got that far, the scan "should" work. ;) My main guess is that
your device is not calibrated properly (the NVS that Shahar provided is
a "default" one and may work, but the results will vary wildly depending
on your RF).

Which device are you using? If you bought a end-user device, you may
find the appropriate NVS lying somewhere in the filesystem.  If you're
working on a new device, you will need to get it calibrated.
Unfortunately we don't have a publicly available application to do that
yet (but there's one under work).


> With all debug information turned on in the driver, I see plenty of
> communication going back and forth w/o any (noticeable) errors, but I
> don't see any sign of magic strings such as any of the ESSIDs I expect
> to see in the area.

Please send the debug information to us and we may be able to figure
something out from the logs.  You probably don't need DEBUG_SDIO,
because that one will dump a *lot* of stuff that will probably not help
here...

-- 
Cheers,
Luca.


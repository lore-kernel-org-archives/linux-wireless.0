Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:53768 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYIFU5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 16:57:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so979081wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 13:56:59 -0700 (PDT)
Message-ID: <69e28c910809061356s44cc1c0clcc009736e45f2737@mail.gmail.com> (sfid-20080906_225707_687417_9C0D8F9D)
Date: Sat, 6 Sep 2008 22:56:59 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Greg White" <pcguy11@live.com>
Subject: Re: rt2x00 and packet injection
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BAY118-W35E84AAD3187213E9B24F6DB5B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY118-W35E84AAD3187213E9B24F6DB5B0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 6, 2008 at 9:37 PM, Greg White <pcguy11@live.com> wrote:
> I tried aircrack-ng and 2.6.27-rc3 and the two don't want to work together.  Yes I dowloaded and compiled iw and libnl.  I have to use the driver from http://homepages.tu-darmstadt.de/~p_larbig/wlan/ to get aircrack-ng to work right.  Any suggestions?
>
> Thanks,

There is another requirement to use aircrack-ng/aireplay-ng (or any
other osdep-based injector) with a mac80211-based driver: you must use
the latest version (1.0-rc1 or newer) of aircrack-ng. Also, the
monitor interface (mon0) must be created with airmon-ng - some drivers
will refuse to inject on wlan0, even if it's set to monitor mode. In
addition, the interfaces must always be on the same channel (as there
is only 1 radio), so it's important that both interfaces remain on the
desired channel.

BTW which sub-driver are you trying to use? rt73usb?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

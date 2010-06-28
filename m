Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53681 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0F1AiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 20:38:17 -0400
Received: by vws19 with SMTP id 19so445713vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jun 2010 17:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006221651.24853.Sebastian.Smolorz@gmx.de>
References: <201006221651.24853.Sebastian.Smolorz@gmx.de>
Date: Sun, 27 Jun 2010 20:38:16 -0400
Message-ID: <AANLkTilsEl-smRtQEU8obOO6GDoWzKYHyFYQYO5Lfpps@mail.gmail.com>
Subject: Re: [PATCH 0/2] at76c50x-usb.c: Fix broken authentication process
From: Jason Andryuk <jandryuk@gmail.com>
To: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 22, 2010 at 10:51 AM, Sebastian Smolorz
<Sebastian.Smolorz@gmx.de> wrote:
> Fix authentication process of wireless driver at76c50x-usb.c which was broken
> since kernel 2.6.31

Thanks for working on this, but unfortunately it does not work with my
Linksys WUSB11.  Does it work for you?

[  168.420082] usb 4-1: new full speed USB device using uhci_hcd and address 2
[  168.719582] Atmel at76x USB Wireless LAN Driver 0.17 loading
[  168.743011] usb 4-1: using firmware atmel_at76c503-i3861.bin
(version 0.90.0-44)
[  168.746784] phy1: Selected rate control algorithm 'minstrel'
[  168.747410] phy1: USB 4-1:1.0, MAC 00:06:25:00:6a:7a, firmware 0.90.0-2
[  168.747413] phy1: regulatory domain 0x10: FCC (USA)
[  168.747434] usbcore: registered new interface driver at76c50x-usb
[  168.803980] udev: renamed network interface wlan0 to wlan3
[  168.837883] ADDRCONF(NETDEV_UP): wlan3: link is not ready
[  274.423484] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
[  274.622558] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
[  274.822600] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
[  275.022557] wlan3: direct probe to 00:13:46:08:8a:6e timed out
[  284.694487] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
[  284.900075] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
[  285.105548] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
[  285.302565] wlan3: direct probe to 00:13:46:08:8a:6e timed out
[  294.954450] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
[  295.152564] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
[  295.352559] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
[  295.552556] wlan3: direct probe to 00:13:46:08:8a:6e timed out

> +       /* The following code lines are important when the device is going to
> +        * authenticate with a new bssid. The driver must send CMD_JOIN before
> +        * an authentication frame is transmitted. For this to succeed, the
> +        * correct bssid of the AP must be known. As mac80211 does not inform
> +        * drivers about the bssid prior to the authentication process the
> +        * following workaround is necessary. If the TX frame is an
> +        * authentication frame extract the bssid and send the CMD_JOIN. */
> +       if (mgmt->frame_control & cpu_to_le16(IEEE80211_STYPE_AUTH)) {
> +               if (compare_ether_addr(priv->bssid, mgmt->bssid)) {
> +                       memcpy(priv->bssid, mgmt->bssid, ETH_ALEN);
> +                       ieee80211_queue_work(hw, &priv->work_join_bssid);
> +                       return NETDEV_TX_BUSY;
> +               }
> +       }
> +

The check for IEEE80211_STYPE_AUTH may be insufficient since direct
probe is sent with frame control IEEE80211_STYPE_PROBE_REQ.  Maybe a
better check would be comparing struct ieee80211_work.type to
IEEE80211_WORK_DIRECT_PROBE or IEEE80211_WORK_AUTH?  I am not sure if
that is accessible in the driver's tx function though.

With the frame_control check modified for either IEEE80211_STYPE_AUTH
or IEEE80211_STYPE_PROBE_REQ, it is still unsuccessful.
at76_work_join_bssid is called between the first and second direct
probe attempt.  However, the CMD_JOIN command is not in the log.
Presumably that occurs because the BSSID pulled from the PROBE_REQ is
ff:ff:ff:ff:ff:ff which fails the is_valid_ether_addr(priv->bssid)
check in at76_work_join_bssid.

http://lxr.linux.no/#linux+v2.6.34/include/linux/etherdevice.h#L100

I'm glad someone is working on this.

Jason

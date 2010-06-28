Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751210Ab0F1PqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 11:46:14 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Jason Andryuk <jandryuk@gmail.com>
Subject: Re: [PATCH 0/2] at76c50x-usb.c: Fix broken authentication process
Date: Mon, 28 Jun 2010 17:46:59 +0200
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org
References: <201006221651.24853.Sebastian.Smolorz@gmx.de> <AANLkTilsEl-smRtQEU8obOO6GDoWzKYHyFYQYO5Lfpps@mail.gmail.com>
In-Reply-To: <AANLkTilsEl-smRtQEU8obOO6GDoWzKYHyFYQYO5Lfpps@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006281747.00128.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk wrote:
> On Tue, Jun 22, 2010 at 10:51 AM, Sebastian Smolorz
> 
> <Sebastian.Smolorz@gmx.de> wrote:
> > Fix authentication process of wireless driver at76c50x-usb.c which was
> > broken since kernel 2.6.31
> 
> Thanks for working on this, but unfortunately it does not work with my
> Linksys WUSB11.

Thanks for testing the patch.

> Does it work for you?

It does but I must admit that I did not test the direct probing, only the 
authentication. 

Which kernel version did you patch?

> 
> [  168.420082] usb 4-1: new full speed USB device using uhci_hcd and
> address 2 [  168.719582] Atmel at76x USB Wireless LAN Driver 0.17
> loading
> [  168.743011] usb 4-1: using firmware atmel_at76c503-i3861.bin
> (version 0.90.0-44)
> [  168.746784] phy1: Selected rate control algorithm 'minstrel'
> [  168.747410] phy1: USB 4-1:1.0, MAC 00:06:25:00:6a:7a, firmware
> 0.90.0-2 [  168.747413] phy1: regulatory domain 0x10: FCC (USA)
> [  168.747434] usbcore: registered new interface driver at76c50x-usb
> [  168.803980] udev: renamed network interface wlan0 to wlan3
> [  168.837883] ADDRCONF(NETDEV_UP): wlan3: link is not ready
> [  274.423484] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
> [  274.622558] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
> [  274.822600] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
> [  275.022557] wlan3: direct probe to 00:13:46:08:8a:6e timed out
> [  284.694487] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
> [  284.900075] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
> [  285.105548] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
> [  285.302565] wlan3: direct probe to 00:13:46:08:8a:6e timed out
> [  294.954450] wlan3: direct probe to 00:13:46:08:8a:6e (try 1)
> [  295.152564] wlan3: direct probe to 00:13:46:08:8a:6e (try 2)
> [  295.352559] wlan3: direct probe to 00:13:46:08:8a:6e (try 3)
> [  295.552556] wlan3: direct probe to 00:13:46:08:8a:6e timed out
> 
> > +       /* The following code lines are important when the device is
> > going to +        * authenticate with a new bssid. The driver must
> > send CMD_JOIN before +        * an authentication frame is
> > transmitted. For this to succeed, the +        * correct bssid of the
> > AP must be known. As mac80211 does not inform +        * drivers about
> > the bssid prior to the authentication process the +        * following
> > workaround is necessary. If the TX frame is an +        *
> > authentication frame extract the bssid and send the CMD_JOIN. */ +    
> >   if (mgmt->frame_control & cpu_to_le16(IEEE80211_STYPE_AUTH)) { +    
> >           if (compare_ether_addr(priv->bssid, mgmt->bssid)) { +      
> >                 memcpy(priv->bssid, mgmt->bssid, ETH_ALEN); +        
> >               ieee80211_queue_work(hw, &priv->work_join_bssid); +    
> >                   return NETDEV_TX_BUSY;
> > +               }
> > +       }
> > +
> 
> The check for IEEE80211_STYPE_AUTH may be insufficient since direct
> probe is sent with frame control IEEE80211_STYPE_PROBE_REQ.  Maybe a
> better check would be comparing struct ieee80211_work.type to
> IEEE80211_WORK_DIRECT_PROBE or IEEE80211_WORK_AUTH?  I am not sure if
> that is accessible in the driver's tx function though.

No, it's not accessible by the driver.

> 
> With the frame_control check modified for either IEEE80211_STYPE_AUTH
> or IEEE80211_STYPE_PROBE_REQ, it is still unsuccessful.
> at76_work_join_bssid is called between the first and second direct
> probe attempt.  However, the CMD_JOIN command is not in the log.
> Presumably that occurs because the BSSID pulled from the PROBE_REQ is
> ff:ff:ff:ff:ff:ff which fails the is_valid_ether_addr(priv->bssid)
> check in at76_work_join_bssid.

The problem is that when probed directly, no (real) bssid is coded in the 
frame, only the multicast address. So with a frame of type 
IEEE80211_STYPE_PROBE_REQ we have no chance to decode the bssid because 
mac80211 doesn't give us the needed information. I think in the case of 
direct probing we are lost, only the authentication works with the patch I 
sent. Another solution would be to change mac80211 but that would be a 
special solution for just one driver. It's questionable if this is a viable 
way. On the other hand it would be great to have a working driver again.

-- 
Sebastian

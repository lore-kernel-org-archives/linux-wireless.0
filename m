Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49830 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933864AbZINUX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 16:23:56 -0400
Received: by fxm17 with SMTP id 17so1122292fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 13:23:58 -0700 (PDT)
Subject: Re: [PATCH3]Add analog switch support
From: Thomas Ilnseher <illth@gmx.de>
To: John Linville <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1252958183.4696.25.camel@luzifer.localnet>
References: <1252956934.4696.23.camel@luzifer.localnet>
	 <69e28c910909141243i5551c87bsfd0c9e767cfa254@mail.gmail.com>
	 <1252958183.4696.25.camel@luzifer.localnet>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 22:22:57 +0200
Message-Id: <1252959777.4696.29.camel@luzifer.localnet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can now confirm that the patch below DOES compile, and even works.

Here is the dmesg output on my router:

root@OpenWrt:/tmp# dmesg 
b43-phy1: Broadcom 5354 WLAN found (core revision 13)
b43-phy1 debug: Found PHY: Analog 6, Type 5, Revision 0
b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 1
phy1: Selected rate control algorithm 'minstrel'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
b43 ssb0:3: firmware: requesting b43/ucode13.fw
b43 ssb0:3: firmware: requesting b43/lp0initvals13.fw
b43 ssb0:3: firmware: requesting b43/lp0bsinitvals13.fw
b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy1 debug: b2062: Using crystal tab entry 19200 kHz.
b43-phy1 debug: Chip initialized
b43-phy1 debug: 64-bit DMA initialized
Registered led device: b43-phy1::tx
Registered led device: b43-phy1::rx
b43-phy1 debug: Wireless interface started
b43-phy1 debug: Adding Interface type 2
wlan0: direct probe to AP XXXXXXXX (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP XXXXXXXX (try 1)
wlan0: authenticated
wlan0: associate with AP XXXXXXXX (try 1)
wlan0: RX AssocResp from XXXXXXXX (capab=0x431 status=0 aid=1)
wlan0: associated
b43-phy1 debug: Using hardware based encryption for keyidx: 0, mac: XXXXXXXX


root@OpenWrt:/tmp# iwconfig 2> /dev/null
wlan0     IEEE 802.11bg  ESSID:"tommy"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: XX:XX:XX:XX:XX:XX   
          Bit Rate=11 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=3 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0





On Mo, 2009-09-14 at 21:56 +0200, Thomas Ilnseher wrote:
> On Mo, 2009-09-14 at 21:43 +0200, Gábor Stefanik wrote:
> > Always send patches to John Linville, and CC linux-wireless.
> Ok, the last try ...
> 
> As I've seen Gàbor's patch, I noticed that my previous patch was
> bullshit. This patch should work:
> 
> (see: http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore)
> 
> Signed-off-by: Thomas Ilnseher <illth@gmx.de>
> 
> diff -uNr b/drivers/net/wireless/b43/phy_lp.c
> a/drivers/net/wireless/b43/phy_lp.c
> --- b/drivers/net/wireless/b43/phy_lp.c 2009-09-14 06:14:18.000000000
> +0200
> +++ a/drivers/net/wireless/b43/phy_lp.c 2009-09-14 21:03:15.158507573
> +0200
> @@ -2228,6 +2228,16 @@
>         return B43_TXPWR_RES_DONE;
>  }
>  
> +void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
> +{
> +       if (on) {
> +               b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xfff8);
> +       } else {
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x0007);
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x0007);
> +       }
> +}
> +
>  const struct b43_phy_operations b43_phyops_lp = {
>         .allocate               = b43_lpphy_op_allocate,
>         .free                   = b43_lpphy_op_free,
> @@ -2239,7 +2249,7 @@
>         .radio_read             = b43_lpphy_op_radio_read,
>         .radio_write            = b43_lpphy_op_radio_write,
>         .software_rfkill        = b43_lpphy_op_software_rfkill,
> -       .switch_analog          = b43_phyop_switch_analog_generic,
> +       .switch_analog          = b43_lpphy_op_switch_analog,
>         .switch_channel         = b43_lpphy_op_switch_channel,
>         .get_default_chan       = b43_lpphy_op_get_default_chan,
>         .set_rx_antenna         = b43_lpphy_op_set_rx_antenna,
> 
> 
> 


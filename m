Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:39377 "EHLO parrot.pmhahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbbBTKP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 05:15:57 -0500
Date: Fri, 20 Feb 2015 11:07:02 +0100
From: Philipp Matthias Hahn <pmhahn@pmhahn.de>
To: wlanfae <wlanfae@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: rtl8192cu: unreliable connection
Message-ID: <20150220100702.GA7400@pmhahn.de> (sfid-20150220_111601_960456_58865420)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an rtl8192cu based USB WLAN dongle from D-Link, which works very
unreliable for me.
It is not directly recognized by my 3.18.7 linux kernel and I currently have

> # cat /etc/modprobe.d/wlan-pmhahn.conf 
> install rtl8192cu /sbin/modprobe --ignore-install rtl8192cu $CMDLINE_OPTS ; echo "2001 330D" >/sys/bus/usb/drivers/rtl8192cu/new_id
> options rtl8192cu swenc=1

I'm able to transmit some data, but normally after some time
opening new TCP connections (especially SSL/TLS encrypted ones) fail.
Ping on the other hand does not show any significant problems:

> 953 packets transmitted, 950 received, 0% packet loss, time 953130ms
> rtt min/avg/max/mdev = 43.433/75.560/457.843/34.281 ms

dmesg shows this repeating pattern:
> [  132.185612] rtl8192cu: MAC auto ON okay!
> [  132.218366] rtl8192cu: Tx queue select: 0x05
> [  133.583883] wlan0: authenticate with c0:25:06:ac:54:90
> [  133.599402] wlan0: send auth to c0:25:06:ac:54:90 (try 1/3)
> [  133.620267] wlan0: authenticated
> [  133.621021] wlan0: associate with c0:25:06:ac:54:90 (try 1/3)
> [  133.625534] wlan0: RX AssocResp from c0:25:06:ac:54:90 (capab=0x431 status=0 aid=3)
> [  133.625559] rtl8192cu:rtl92cu_set_hw_reg():<0-0> switch case not processed
> [  133.625565] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [  133.626745] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [  133.626751] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [  133.626769] wlan0: associated
> [ 2553.461180] wlan0: deauthenticating from c0:25:06:ac:54:90 by local choice (Reason: 3=DEAUTH_LEAVING)
> [ 2553.461737] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2553.476041] cfg80211: Calling CRDA to update world regulatory domain
> [ 2553.484929] cfg80211: World regulatory domain updated:
> [ 2553.484932] cfg80211:  DFS Master region: unset
> [ 2553.484933] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 2553.484935] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2553.484937] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2553.484939] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2553.484942] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> [ 2553.484944] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> [ 2553.484946] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [ 2553.484948] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2553.484950] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 2562.569359] wlan0: authenticate with c0:25:06:ac:54:90
> [ 2562.584177] wlan0: send auth to c0:25:06:ac:54:90 (try 1/3)
> [ 2562.593924] wlan0: authenticated
> [ 2562.595018] wlan0: associate with c0:25:06:ac:54:90 (try 1/3)
> [ 2562.623431] wlan0: RX AssocResp from c0:25:06:ac:54:90 (capab=0x431 status=0 aid=3)
> [ 2562.623459] rtl8192cu:rtl92cu_set_hw_reg():<0-0> switch case not processed
> [ 2562.623468] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2562.625029] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2562.625034] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2562.625053] wlan0: associated
> [ 2566.667513] wlan0: deauthenticated from c0:25:06:ac:54:90 (Reason: 2=PREV_AUTH_NOT_VALID)
> [ 2566.672628] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2566.689055] cfg80211: Calling CRDA to update world regulatory domain
> [ 2566.692128] cfg80211: World regulatory domain updated:
> [ 2566.692131] cfg80211:  DFS Master region: unset
> [ 2566.692132] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 2566.692135] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2566.692137] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2566.692139] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2566.692141] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> [ 2566.692143] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> [ 2566.692145] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [ 2566.692147] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2566.692149] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 2567.566395] wlan0: authenticate with c0:25:06:ac:54:90
> [ 2567.591386] wlan0: send auth to c0:25:06:ac:54:90 (try 1/3)
> [ 2567.629133] wlan0: authenticated
> [ 2567.630070] wlan0: associate with c0:25:06:ac:54:90 (try 1/3)
> [ 2567.660368] wlan0: RX AssocResp from c0:25:06:ac:54:90 (capab=0x431 status=0 aid=3)
> [ 2567.660387] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2567.660404] rtl8192cu:rtl92cu_set_hw_reg():<0-0> switch case not processed
> [ 2567.660406] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2567.661988] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2567.661994] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2567.662024] wlan0: associated
> [ 2572.908712] wlan0: deauthenticated from c0:25:06:ac:54:90 (Reason: 2=PREV_AUTH_NOT_VALID)
> [ 2572.913573] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2572.930075] cfg80211: Calling CRDA to update world regulatory domain
> [ 2572.932805] cfg80211: World regulatory domain updated:
> [ 2572.932807] cfg80211:  DFS Master region: unset
> [ 2572.932809] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [ 2572.932811] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2572.932813] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2572.932815] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2572.932817] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> [ 2572.932820] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> [ 2572.932822] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [ 2572.932824] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [ 2572.932826] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [ 2573.807378] wlan0: authenticate with c0:25:06:ac:54:90
> [ 2573.832330] wlan0: send auth to c0:25:06:ac:54:90 (try 1/3)
> [ 2573.835813] wlan0: authenticated
> [ 2573.836045] wlan0: associate with c0:25:06:ac:54:90 (try 1/3)
> [ 2573.862830] wlan0: RX AssocResp from c0:25:06:ac:54:90 (capab=0x431 status=0 aid=3)
> [ 2573.862857] rtl8192cu:rtl92cu_set_hw_reg():<0-0> switch case not processed
> [ 2573.862865] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2573.863933] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2573.863938] rtl8192c_common:rtl92c_fill_h2c_cmd(): return H2C cmd because of Fw download fail!!!
> [ 2573.863955] wlan0: associated

# lsusb  -s 1:13 -v
> Bus 001 Device 013: ID 2001:330d D-Link Corp. 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0        64
>   idVendor           0x2001 D-Link Corp.
>   idProduct          0x330d 
>   bcdDevice            2.00
>   iManufacturer           1 Realtek
>   iProduct                2 802.11n WLAN Adapter
>   iSerial                 3 00e04c000001
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           46
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)

Any helpful ideas?

Thanks in advance.

Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de

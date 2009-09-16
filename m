Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:48616 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830AbZIPTZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 15:25:54 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1699099fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:25:57 -0700 (PDT)
Subject: [PATCH 0/2] b43: improve TX power handling for LP PHYs
From: Thomas Ilnseher <illth@gmx.de>
To: John Linville <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 21:25:58 +0200
Message-Id: <1253129158.2989.34.camel@note>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I implemented the functions:
"lpphy_update_tx_power_npt"
and
"lpphy_set_tx_power_control",

and together, both improve the bitrate of my device:


wlan0     IEEE 802.11bg  ESSID:"tommy"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: XXX 
          Bit Rate=54 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=10 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

without these patches, I maxed out at about 24 Mbit/s.




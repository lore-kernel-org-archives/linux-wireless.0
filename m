Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:52489 "EHLO mail1.wpi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZCFX2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 18:28:03 -0500
Received: from SMTP.WPI.EDU (SMTP.WPI.EDU [130.215.36.186])
	by mail1.wpi.edu (8.14.3/8.14.3) with ESMTP id n26N1Qvn007310
	for <linux-wireless@vger.kernel.org>; Fri, 6 Mar 2009 18:01:26 -0500
Received: from angus.ind.WPI.EDU (ANGUS.IND.WPI.EDU [130.215.130.21])
	by SMTP.WPI.EDU (8.14.2/8.14.2) with ESMTP id n26N1PYZ017876
	for <linux-wireless@vger.kernel.org>; Fri, 6 Mar 2009 18:01:26 -0500
	(envelope-from cra@WPI.EDU)
Received: from angus.ind.WPI.EDU (angus.ind.WPI.EDU [127.0.0.1])
	by angus.ind.WPI.EDU (8.14.2/8.14.2) with ESMTP id n26N1P4q030414
	for <linux-wireless@vger.kernel.org>; Fri, 6 Mar 2009 18:01:25 -0500
Received: (from cra@localhost)
	by angus.ind.WPI.EDU (8.14.2/8.14.2/Submit) id n26N1OYp030413
	for linux-wireless@vger.kernel.org; Fri, 6 Mar 2009 18:01:24 -0500
Date: Fri, 6 Mar 2009 18:01:24 -0500
From: Chuck Anderson <cra@WPI.EDU>
To: linux-wireless@vger.kernel.org
Subject: iwlagn won't scan 5 GHz band
Message-ID: <20090306230124.GU10097@angus.ind.WPI.EDU> (sfid-20090307_002809_666732_188CA002)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please Cc: me on replies as I'm not subscribed.  Thanks.

I have a 4965, using kernel-2.6.29-0.197.rc7.fc11.x86_64 (Intel(R) 
Wireless WiFi Link AGN driver for Linux, 1.3.27kds).  I can connect to 
802.11n on 2.4 GHz, but it never finds the 5 GHz cell of the AP.  Is 5 
GHz 802.11n supported yet?  For that matter, shouldn't I be seeing the 
802.11a from my APs?  How do I get this thing to scan the A/N 5 GHz 
band?

Thanks.

#iwlist wlan0 channel

wlan0     11 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          Channel 05 : 2.432 GHz
          Channel 06 : 2.437 GHz
          Channel 07 : 2.442 GHz
          Channel 08 : 2.447 GHz
          Channel 09 : 2.452 GHz
          Channel 10 : 2.457 GHz
          Channel 11 : 2.462 GHz
          Current Frequency:2.437 GHz (Channel 6)


I turned on the debug flag and verified that the driver is seeing 5.2 
GHz band channels as allowed:

Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Initializing regulatory info from EEPROM
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Parsing data for 56 channels.
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 36 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 40 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 44 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 48 [5.2GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar  6 17:45:08 l kernel: ieee80211 phy5: U iwl_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:45072 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1IJFno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 01:43:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id 72D0D9A
	for <linux-wireless@vger.kernel.org>; Sat, 10 Sep 2011 07:43:43 +0200 (CEST)
Date: Sat, 10 Sep 2011 07:43:43 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-wireless@vger.kernel.org
Subject: problem with intel 5300
Message-ID: <alpine.DEB.2.00.1109100736280.13538@uplift.swm.pp.se> (sfid-20110910_074349_159366_AEE5A6AD)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi.

I've had my Lenovo Thinkpad X200 with Intel 5300 wifi card for almost 3 
years, running ubuntu 8.04 and then going upp through the versions. Up to 
and including 10.10 with its 2.6.35 kernel, things have been working 
fairly ok. Now with 11.04 with 2.6.38 I've had a lot more wifi problems. 
Below is a log from the latest time it stopped working and I had to reboot 
to get it working again.

Any ideas what might be going wrong?

Linux laptop 2.6.38-11-generic-pae #49-Ubuntu SMP Mon Aug 29 21:07:33 UTC 2011 i686 i686 i386 GNU/Linux

03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300

I also have to disable .11n with:

$ cat /etc/modprobe.d/intel-5300-iwlagn-disable11n.conf
options iwlagn 11n_disable=1

because if I don't, then it basically doesn't work at all (I can provide 
more information on this if someone is interested). My access point is a 
D-link DIR-855 and I'm on 5Ghz.

     Sep  6 20:15:01 swm-laptop kernel: [178718.504068] iwlagn 
0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 500ms.
     Sep  6 20:15:02 swm-laptop kernel: [178718.504080] iwlagn 
0000:03:00.0: set power fail, ret = -110
     Sep  6 20:15:02 swm-laptop kernel: [178719.504050] iwlagn 
0000:03:00.0: Error sending REPLY_QOS_PARAM: time out after 500ms.
     Sep  6 20:15:02 swm-laptop kernel: [178719.504055] iwlagn 
0000:03:00.0: Failed to update QoS
     Sep  6 20:15:03 swm-laptop kernel: [178720.004571] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:03 swm-laptop kernel: [178720.004584] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:03 swm-laptop kernel: [178720.504111] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:03 swm-laptop kernel: [178720.504123] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:04 swm-laptop kernel: [178721.004066] iwlagn 
0000:03:00.0: Error sending REPLY_ADD_STA: time out after 500ms.
     Sep  6 20:15:04 swm-laptop kernel: [178721.004076] ieee80211 phy0: 
failed to remove key (0, 00:21:91:dc:94:57) from hardware (-110)
     Sep  6 20:15:04 swm-laptop kernel: [178721.504058] iwlagn 
0000:03:00.0: Error sending REPLY_REMOVE_STA: time out after 500ms.
     Sep  6 20:15:04 swm-laptop kernel: [178721.504071] iwlagn 
0000:03:00.0: Error removing station 00:21:91:dc:94:57
     Sep  6 20:15:05 swm-laptop kernel: [178722.004084] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:05 swm-laptop kernel: [178722.004097] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:07 swm-laptop kernel: [178724.012038] iwlagn 
0000:03:00.0: fail to flush all tx fifo queues
     Sep  6 20:15:07 swm-laptop kernel: [178724.512069] iwlagn 
0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 500ms.
     Sep  6 20:15:08 swm-laptop kernel: [178724.512076] iwlagn 
0000:03:00.0: set power fail, ret = -110
     Sep  6 20:15:08 swm-laptop kernel: [178725.012134] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:08 swm-laptop kernel: [178725.012147] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:08 swm-laptop kernel: [178725.512068] iwlagn 
0000:03:00.0: Error sending REPLY_ADD_STA: time out after 500ms.
     Sep  6 20:15:08 swm-laptop kernel: [178725.512086] ieee80211 phy0: 
failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
     Sep  6 20:15:08 swm-laptop kernel: [178725.532246] cfg80211: All 
devices are disconnected, going to restore regulatory settings
     Sep  6 20:15:08 swm-laptop kernel: [178725.532258] cfg80211: Restoring 
regulatory settings
     Sep  6 20:15:08 swm-laptop kernel: [178725.532268] cfg80211: Calling 
CRDA to update world regulatory domain
     Sep  6 20:15:08 swm-laptop kernel: [178725.556193] cfg80211: Ignoring 
regulatory request Set by core since the driver uses its own custom 
regulatory domain
     Sep  6 20:15:08 swm-laptop kernel: [178725.556199] cfg80211: World 
regulatory domain updated:
     Sep  6 20:15:08 swm-laptop kernel: [178725.556201] cfg80211: 
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
     Sep  6 20:15:08 swm-laptop kernel: [178725.556204] cfg80211: 
(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     Sep  6 20:15:08 swm-laptop kernel: [178725.556206] cfg80211: 
(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
     Sep  6 20:15:08 swm-laptop kernel: [178725.556209] cfg80211: 
(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
     Sep  6 20:15:08 swm-laptop kernel: [178725.556212] cfg80211: 
(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     Sep  6 20:15:08 swm-laptop kernel: [178725.556214] cfg80211: 
(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     Sep  6 20:15:09 swm-laptop kernel: [178726.132056] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:09 swm-laptop kernel: [178726.132063] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:09 swm-laptop kernel: [178726.632100] iwlagn 
0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 500ms.
     Sep  6 20:15:10 swm-laptop kernel: [178726.632112] iwlagn 
0000:03:00.0: set power fail, ret = -110
     Sep  6 20:15:10 swm-laptop kernel: [178727.132073] iwlagn 
0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
     Sep  6 20:15:10 swm-laptop kernel: [178727.132086] iwlagn 
0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
     Sep  6 20:15:10 swm-laptop kernel: [178727.504021] iwlagn 
0000:03:00.0: Queue 9 stuck for 10000 ms.
     Sep  6 20:15:10 swm-laptop kernel: [178727.504027] iwlagn 
0000:03:00.0: On demand firmware reload
     Sep  6 20:15:11 swm-laptop kernel: [178727.632057] iwlagn 
0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
     Sep  6 20:15:11 swm-laptop kernel: [178727.636027] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: last message repeated 16 times
     Sep  6 20:15:11 swm-laptop kernel: [178727.942512] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178727.960945] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178727.979119] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178727.997201] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178727.997201] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.033459] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.051594] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.069670] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.087962] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.106091] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.124203] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.142265] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.160338] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.178380] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.196435] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.196435] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.232512] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.250577] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.268631] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.286722] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.304804] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.322846] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.340895] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.358932] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.377024] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.395070] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.413112] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.431164] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.449204] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.467285] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.485344] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.503427] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.521534] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.539606] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.557702] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.575790] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.593851] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.611912] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.629957] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.648044] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.666112] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:11 swm-laptop kernel: [178728.684178] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:13 swm-laptop kernel: [178729.810551] thinkpad_acpi: EC 
reports that Thermal Table has changed
     Sep  6 20:15:16 swm-laptop kernel: [178733.696027] iwlagn 
0000:03:00.0: Could not load the INST uCode section
     Sep  6 20:15:16 swm-laptop kernel: [178733.696032] iwlagn 
0000:03:00.0: Unable to set up bootstrap uCode: -110
     Sep  6 20:15:16 swm-laptop kernel: [178733.700014] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:17 swm-laptop kernel: [178733.718158] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:17 swm-laptop kernel: [178733.736301] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:17 swm-laptop kernel: [178733.754347] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:17 swm-laptop kernel: [178733.772415] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:17 swm-laptop kernel: [178733.790465] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.804029] iwlagn 
0000:03:00.0: Could not load the INST uCode section
     Sep  6 20:15:22 swm-laptop kernel: [178738.804036] iwlagn 
0000:03:00.0: Unable to set up bootstrap uCode: -110
     Sep  6 20:15:22 swm-laptop kernel: [178738.808008] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.826068] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.844147] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.862282] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.880490] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:22 swm-laptop kernel: [178738.898646] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178743.912014] iwlagn 
0000:03:00.0: Could not load the INST uCode section
     Sep  6 20:15:27 swm-laptop kernel: [178743.912019] iwlagn 
0000:03:00.0: Unable to set up bootstrap uCode: -110
     Sep  6 20:15:27 swm-laptop kernel: [178743.916005] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178743.939804] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178743.952161] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178743.970259] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178743.988331] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:27 swm-laptop kernel: [178744.006822] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.020036] iwlagn 
0000:03:00.0: Could not load the INST uCode section
     Sep  6 20:15:32 swm-laptop kernel: [178749.020041] iwlagn 
0000:03:00.0: Unable to set up bootstrap uCode: -110
     Sep  6 20:15:32 swm-laptop kernel: [178749.024025] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.042108] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.060181] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.078255] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.096327] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:32 swm-laptop kernel: [178749.114391] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:37 swm-laptop kernel: [178754.128042] iwlagn 
0000:03:00.0: Could not load the INST uCode section
     Sep  6 20:15:37 swm-laptop kernel: [178754.128047] iwlagn 
0000:03:00.0: Unable to set up bootstrap uCode: -110
     Sep  6 20:15:37 swm-laptop kernel: [178754.132025] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:37 swm-laptop kernel: last message repeated 16 times
     Sep  6 20:15:37 swm-laptop kernel: [178754.438968] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:37 swm-laptop kernel: [178754.457086] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:37 swm-laptop kernel: [178754.475153] iwlagn 
0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
     Sep  6 20:15:37 swm-laptop kernel: [178754.489270] iwlagn 
0000:03:00.0: Unable to initialize device after 5 attempts.
     Sep  6 20:15:37 swm-laptop kernel: [178754.489293] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:38 swm-laptop kernel: [178754.971442] EXT4-fs (dm-0): 
re-mounted. Opts: errors=remount-ro,discard,commit=0
     Sep  6 20:15:38 swm-laptop kernel: [178755.490274] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:39 swm-laptop kernel: [178756.491726] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:40 swm-laptop kernel: [178757.492170] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:41 swm-laptop kernel: [178758.493486] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:42 swm-laptop kernel: [178759.494825] iwlagn 
0000:03:00.0: Request scan called when driver not ready.
     Sep  6 20:15:43 swm-laptop kernel: [178760.496306] iwlagn 
0000:03:00.0: Request scan called when driver not ready.

  -- 
Mikael Abrahamsson    email: swmike@swm.pp.se

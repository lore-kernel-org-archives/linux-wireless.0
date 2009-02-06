Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:23111 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754060AbZBFWbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 17:31:45 -0500
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n16MXII16135
	for <linux-wireless@vger.kernel.org>; Fri, 6 Feb 2009 23:33:18 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n16MVfe2031752
	for <linux-wireless@vger.kernel.org>; Fri, 6 Feb 2009 23:31:41 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 39760433966
	for <linux-wireless@vger.kernel.org>; Fri,  6 Feb 2009 23:31:41 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lQPgm8CKwM0i for <linux-wireless@vger.kernel.org>;
	Fri,  6 Feb 2009 23:31:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id E684C433E22
	for <linux-wireless@vger.kernel.org>; Fri,  6 Feb 2009 23:31:34 +0100 (CET)
Message-ID: <20090206233134.11116cap9kcroxgc@neo.wg.de> (sfid-20090206_233151_748427_0C38B906)
Date: Fri, 06 Feb 2009 23:31:34 +0100
From: Jan Schneider <jan@horde.org>
To: linux-wireless@vger.kernel.org
Subject: iwlagn: Microcode SW error detected.
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've seen in a post from January that someone already had this problem  
but couldn't reproduce it.
I can't reliably reproduce, but I see this more often than I like.  
When this happens, it usually doesn't help to reload the kernel  
module. Sometimes it helps to use the rfkill switch though.

Here's a log with debug=0x43fff:

Feb  6 21:32:20 tank kernel: [11142.667719] iwlagn 0000:0c:00.0:  
Microcode SW error detected.  Restarting 0x2000000.
Feb  6 21:32:20 tank kernel: [11142.725640] Registered led device:  
iwl-phy0::radio
Feb  6 21:32:20 tank kernel: [11142.725789] Registered led device:  
iwl-phy0::assoc
Feb  6 21:32:20 tank kernel: [11142.725840] Registered led device:  
iwl-phy0::RX
Feb  6 21:32:20 tank kernel: [11142.725876] Registered led device:  
iwl-phy0::TX

That's unfortunately not more than without debug.

Here are follow-up retries from the module to restart itself:

Feb  6 21:38:31 tank kernel: [11514.361232] wlan0: deauthenticated (Reason: 2)
Feb  6 21:38:31 tank kernel: [11514.361257] HW problem - can not stop  
rx aggregation for tid 0
Feb  6 21:38:31 tank kernel: [11514.372228] mac80211-phy0: failed to  
remove key(0, ffff8800d9100b40) from hardware (-22)
Feb  6 21:38:32 tank kernel: [11515.360263] wlan0: direct probe to AP  
ffff880119882a20 try 1
Feb  6 21:38:32 tank kernel: [11515.362305] wlan0 direct probe responded
Feb  6 21:38:32 tank kernel: [11515.362315] wlan0: authenticate with  
AP ffff880119882a20
Feb  6 21:38:32 tank kernel: [11515.364878] wlan0: authenticated
Feb  6 21:38:32 tank kernel: [11515.364885] wlan0: associate with AP  
ffff880119882a20
Feb  6 21:38:32 tank kernel: [11515.368128] wlan0: RX ReassocResp from  
ffff8800cac28016 (capab=0x431 status=0 aid=1)
Feb  6 21:38:32 tank kernel: [11515.368137] wlan0: associated
Feb  6 21:38:34 tank kernel: [11517.377006] iwlagn 0000:0c:00.0:  
Microcode SW error detected.  Restarting 0x2000000.
Feb  6 21:38:34 tank kernel: [11517.421241] Registered led device:  
iwl-phy0::radio
Feb  6 21:38:34 tank kernel: [11517.421711] Registered led device:  
iwl-phy0::assoc
Feb  6 21:38:34 tank kernel: [11517.422034] Registered led device:  
iwl-phy0::RX
Feb  6 21:38:34 tank kernel: [11517.422336] Registered led device:  
iwl-phy0::TX
Feb  6 21:48:31 tank kernel: [12114.362612] wlan0: deauthenticated (Reason: 2)
Feb  6 21:48:31 tank kernel: [12114.362636] HW problem - can not stop  
rx aggregation for tid 0
Feb  6 21:48:31 tank kernel: [12114.381137] mac80211-phy0: failed to  
remove key(0, ffff88002e06a740) from hardware (-22)
Feb  6 21:48:32 tank kernel: [12115.360108] wlan0: direct probe to AP  
ffff880119882a20 try 1
Feb  6 21:48:32 tank kernel: [12115.361948] wlan0 direct probe responded
Feb  6 21:48:32 tank kernel: [12115.361957] wlan0: authenticate with  
AP ffff880119882a20
Feb  6 21:48:32 tank kernel: [12115.372072] wlan0: authenticated
Feb  6 21:48:32 tank kernel: [12115.372082] wlan0: associate with AP  
ffff880119882a20
Feb  6 21:48:32 tank kernel: [12115.375111] wlan0: RX ReassocResp from  
ffff8800bfb0c016 (capab=0x431 status=0 aid=1)
Feb  6 21:48:32 tank kernel: [12115.375123] wlan0: associated
Feb  6 21:48:34 tank kernel: [12116.976224] iwlagn 0000:0c:00.0:  
Microcode SW error detected.  Restarting 0x2000000.
Feb  6 21:48:34 tank kernel: [12117.025630] Registered led device:  
iwl-phy0::radio
Feb  6 21:48:34 tank kernel: [12117.027965] Registered led device:  
iwl-phy0::assoc
Feb  6 21:48:34 tank kernel: [12117.030202] Registered led device:  
iwl-phy0::RX
Feb  6 21:48:34 tank kernel: [12117.032351] Registered led device:  
iwl-phy0::TX

This happens every 10 minutes.

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/


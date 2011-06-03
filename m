Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:33680 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab1FCUQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 16:16:48 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QSanW-0001aP-6M
	for linux-wireless@vger.kernel.org; Fri, 03 Jun 2011 22:16:46 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QSanU-00036Y-UR
	for linux-wireless@vger.kernel.org; Fri, 03 Jun 2011 22:16:44 +0200
Date: Fri, 3 Jun 2011 22:16:44 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: sta_find_ibss (active_ibss=1) in a loop?
Message-ID: <20110603201644.GA7836@zenon.in.qult.net> (sfid-20110603_221651_789574_377D0667)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm still investigating on that problem but have such a hard time reproducing
it that I thought maybe someone here could help.

I have a testbed of three nodes in IBSS (using carl9170 from compat-wireless'
latest snapshot), that happen to go into suspend-to-ram quite often.
Sometimes it appears one of the nodes just can't "see" some other node.
Then tcpdump doesn't see it either, but another vif in monitor mode sees
everyone just fine.

I activated as much debug options as I could and I saw something quite strange
in the kernel messages (just after the node goes back from suspend-to-ram):

  [16226.464987] ieee80211 phy14: device no longer idle - in use
  [16226.465043] wlan1: sta_find_ibss (active_ibss=0)
  [16226.465055]    sta_find_ibss: selected 83:12:97:63:54:f2 current
  00:00:00:00:00:00
  [16226.465063] wlan1: Selected IBSS BSSID 83:12:97:63:54:f2 based on
  configured SSID
  [16226.632608] ieee80211 phy14: Adding new IBSS station 00:26:f2:ed:60:f9
  (dev=wlan1)
  [16226.632648] ieee80211 phy14: Allocated STA 00:26:f2:ed:60:f9
  [16226.633549] ieee80211 phy14: Added IBSS STA 00:26:f2:ed:60:f9
  [16226.633598] wlan1: No active IBSS STAs - trying to scan for other IBSS
  networks with same SSID (merge)
  [16226.633626] ieee80211 phy14: Finished adding IBSS STA 00:26:f2:ed:60:f9
  [16226.948957] ieee80211 phy14: Adding new IBSS station 00:24:b2:5c:bb:b5
  (dev=wlan1)
  [16226.949004] ieee80211 phy14: Allocated STA 00:24:b2:5c:bb:b5
  [16226.950495] ieee80211 phy14: Added IBSS STA 00:24:b2:5c:bb:b5
  [16226.950593] ieee80211 phy14: Finished adding IBSS STA 00:24:b2:5c:bb:b5
  [16228.050250] wlan1: updated supp_rates set for 00:24:b2:5c:bb:b5 based on
  beacon/probe_resp (0x1 -> 0xfff)
  [16229.180184] ieee80211 phy14: Removed STA 00:24:b2:5c:bb:b5
  [16229.180339] ieee80211 phy14: Destroyed STA 00:24:b2:5c:bb:b5
  [16229.196176] ieee80211 phy14: Removed STA 00:26:f2:ed:60:f9
  [16229.196322] ieee80211 phy14: Destroyed STA 00:26:f2:ed:60:f9
  [16229.199085] ieee80211 phy14: Adding new IBSS station 00:26:f2:ed:60:f9
  (dev=wlan1)
  [16229.199113] ieee80211 phy14: Allocated STA 00:26:f2:ed:60:f9
  [16229.199845] ieee80211 phy14: Added IBSS STA 00:26:f2:ed:60:f9
  [16229.212204] ieee80211 phy14: device now idle
  [16229.212222] ieee80211 phy14: Finished adding IBSS STA 00:26:f2:ed:60:f9
  [16229.212909] ieee80211 phy14: device no longer idle - in use
  [16229.212956] wlan1: sta_find_ibss (active_ibss=1)
  [16229.277675] wlan1: sta_find_ibss (active_ibss=1)
  [16229.311661] wlan1: sta_find_ibss (active_ibss=1)
  [16229.379920] wlan1: sta_find_ibss (active_ibss=1)
  [16229.414232] wlan1: sta_find_ibss (active_ibss=1)
  ...

the following is just a long stream of sta_find_ibss (active_ibss=1).

>From that point on, the interface sees 00:26:f2:ed:60:f9 but not
00:24:b2:5c:bb:b5.  BTW, why are both neighbors removed?  When this problem is
not appearing, both neighbors are still removed, but they're both added
immediately after that (and there's no stream of sta_find_ibss).  Here only
00:26:f2:ed:60:f9 is added back.

As I read the code in net/mac80211/ibss.c to try to understand how things
work, I noticed the following in ieee80211_sta_find_ibss().  Apparently the
function does nothing if the call to ieee80211_sta_active_ibss() returns
non-zero, i.e. the last received frame from a known station was too recent.

So I wonder, what happens if state somehow becomes IEEE80211_IBSS_MLME_SEARCH
and a neighbor station is sending plenty of frames.  Apparently we don't come
out of this state, since we don't get a chance to set it back to
IEEE80211_IBSS_MLME_JOINED.

Am I obviously missing something here?

I can't confirm right now that this is indeed what's happening, but I'll post
more information as soon as possible.  Besides, if anyone has any suggestion
regarding what additional debug info could be useful, please go ahead.

Thanks,

Ignacy

-- 
NO CARRIER

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34563 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab1AMTrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 14:47:43 -0500
Message-ID: <4D2F56DB.50507@candelatech.com>
Date: Thu, 13 Jan 2011 11:47:39 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on deauth, reason 4, for hostapd.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to figure out why my stations sometimes deauth for
reason 4 (which I understand to mean 'inactivity').

I instrumented the hostapd logs a bit, and I see this the output
below.  Basically, there appears to be no inactivity problems, and
as far as I can tell, hostapd isn't forcing the deauth, but is rather
dealing with it from somewhere else.

This is on latest wireless-testing, with ath9k as both VAP and Stations.

Any ideas for where to look?

1294947307.409263: vap0:   Station: 00:0c:42:61:00:1c has been active 0 sec ago
1294947307.409932: vap0:   Station: 00:0c:42:61:00:1b has been active 0 sec ago
1294947307.412581: vap0:   Station: 00:0c:42:61:00:1a has been active 0 sec ago
1294947307.413316: vap0:   Station: 00:0c:42:61:00:19 has been active 0 sec ago
1294947307.417073: vap0:   Station: 00:0c:42:61:00:18 has been active 0 sec ago
1294947307.417753: vap0:   Station: 00:0c:42:61:00:17 has been active 0 sec ago
1294947307.418725: vap0:   Station: 00:0c:42:61:00:16 has been active 0 sec ago
1294947307.421179: vap0:   Station: 00:0c:42:61:00:15 has been active 0 sec ago
1294947307.423661: vap0:   Station: 00:0c:42:61:00:14 has been active 0 sec ago
1294947307.424647: vap0:   Station: 00:0c:42:61:00:13 has been active 0 sec ago
1294947307.428565: vap0:   Station: 00:0c:42:61:00:12 has been active 0 sec ago
1294947307.431005: vap0:   Station: 00:0c:42:61:00:11 has been active 0 sec ago
1294947307.431826: vap0:   Station: 00:0c:42:61:00:10 has been active 0 sec ago
1294947307.434342: vap0:   Station: 00:0c:42:61:00:0f has been active 0 sec ago
1294947307.435146: vap0:   Station: 00:0c:42:61:00:0e has been active 0 sec ago
1294947307.442511: vap0:   Station: 00:0c:42:61:00:0d has been active 0 sec ago
1294947307.443336: vap0:   Station: 00:0c:42:61:00:0c has been active 0 sec ago
1294947307.445830: vap0:   Station: 00:0c:42:61:00:0b has been active 0 sec ago
1294947307.446537: vap0:   Station: 00:0c:42:61:00:0a has been active 0 sec ago
1294947307.449161: vap0:   Station: 00:0c:42:61:00:09 has been active 0 sec ago
1294947307.450024: vap0:   Station: 00:0c:42:61:00:08 has been active 0 sec ago
1294947307.455319: vap0:   Station: 00:0c:42:61:00:07 has been active 0 sec ago
1294947307.562973: vap0:   Station: 00:0c:42:61:cf:85 has been active 0 sec ago
1294947314.245006: vap0:   Station: 00:0c:42:61:00:03 has been active 0 sec ago
1294947314.245214: vap0:   Station: 00:0c:42:61:00:05 has been active 0 sec ago
1294947322.175976: vap0:   Station: 00:0c:42:61:00:2e has been active 0 sec ago
1294947325.635492: vap0:   Station: 00:0c:42:61:00:2f has been active 0 sec ago
1294947327.247077: vap0:   Station: 00:76:56:76:01:03 has been active 0 sec ago
1294947374.830568: vap0:   Station: 00:0c:42:61:00:02 has been active 0 sec ago
1294947577.430357: vap0: mgmt::deauth
1294947577.430418: vap0: deauthentication: STA=00:0c:42:61:00:1c reason_code=4
1294947577.430435: vap0: AP-STA-DISCONNECTED 00:0c:42:61:00:1c
1294947577.430473: 1294947577.430508: vap0: wpa_driver_nl80211_set_key: ifindex=15 alg=0 addr=0x95ab720 key_idx=0 set_tx=1 seq_len=0 key_len=0
1294947577.430527: vap0:    addr=00:0c:42:61:00:1c

The station machine has these wifi events printed:

2011-01-13 11:39:37.440  sta27 (phy #0): deauth 00:0c:42:61:00:1c -> 00:99:99:99:99:01 reason 4: Disassociated due to inactivity
2011-01-13 11:39:37.440  sta27 (phy #0): disconnected (local request)
2011-01-13 11:39:37.546  sta27 (phy #0): scan started
2011-01-13 11:39:37.743  sta27 (phy #0): scan finished: 2437, ""
2011-01-13 11:39:37.985  sta27 (phy #0): auth 00:99:99:99:99:01 -> 00:0c:42:61:00:1c status: 0: Successful
2011-01-13 11:39:38.003  sta27: new station 00:99:99:99:99:01
2011-01-13 11:39:38.145  sta27 (phy #0): assoc 00:99:99:99:99:01 -> 00:0c:42:61:00:1c status: 0: Successful
2011-01-13 11:39:38.145  sta27 (phy #0): connected to 00:99:99:99:99:01


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


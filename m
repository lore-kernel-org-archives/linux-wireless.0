Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55745 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1EERCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 13:02:34 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p45H2X9t016830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 5 May 2011 10:02:34 -0700
Message-ID: <4DC2D829.6000706@candelatech.com> (sfid-20110505_190237_448517_8A288D65)
Date: Thu, 05 May 2011 10:02:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Ath9k stations not authenticating in -rc6 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has anyone successfully associated a wpa station in -rc6
using ath9k?

I haven't done much debugging yet, but it appears something broke
between .38 and .39-rc6.

I'm seeing events like this in .39-rc6:

2011-05-05 08:55:15.080  wlan0 (phy #0): scan started
2011-05-05 08:55:15.135  wlan0 (phy #0): scan finished: 5200, ""
2011-05-05 08:55:15.139  wlan0 (phy #0): auth 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:55:15.140  wlan0: new station 30:46:9a:10:0b:9c
2011-05-05 08:55:15.205  wlan0 (phy #0): assoc 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:55:15.205  wlan0 (phy #0): connected to 30:46:9a:10:0b:9c
2011-05-05 08:55:19.236  wlan0: unknown event 20
2011-05-05 08:55:19.236  wlan0 (phy #0): deauth 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 reason 2: Previous authentication no longer valid
2011-05-05 08:55:19.236  wlan0 (phy #0): disconnected (by AP) reason: 2: Previous authentication no longer valid
2011-05-05 08:55:19.276  phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
2011-05-05 08:55:19.363  regulatory domain change: set to US by a user request
2011-05-05 08:55:24.284  wlan0 (phy #0): scan started
2011-05-05 08:55:24.374  wlan0 (phy #0): scan finished: 5200, ""
2011-05-05 08:55:24.379  wlan0 (phy #0): auth 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:55:24.379  wlan0: new station 30:46:9a:10:0b:9c
2011-05-05 08:55:24.389  wlan0 (phy #0): assoc 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:55:24.444  wlan0 (phy #0): connected to 30:46:9a:10:0b:9c
2011-05-05 08:55:28.410  wlan0: unknown event 20
2011-05-05 08:55:28.426  wlan0 (phy #0): deauth 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 reason 2: Previous authentication no longer valid
2011-05-05 08:55:28.426  wlan0 (phy #0): disconnected (by AP) reason: 2: Previous authentication no longer valid
2011-05-05 08:55:28.506  phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
2011-05-05 08:55:28.608  regulatory domain change: set to US by a user request
...

In .38-wl, it just works (all I did was reboot to a different kernel):


2011-05-05 08:58:27.385  wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 
5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
2011-05-05 08:58:27.385  wlan0 (phy #0): auth 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:58:27.385  wlan0: new station 30:46:9a:10:0b:9c
2011-05-05 08:58:27.385  wlan0 (phy #0): assoc 30:46:9a:10:0b:9c -> 00:0c:42:61:cf:85 status: 0: Successful
2011-05-05 08:58:27.385  wlan0 (phy #0): connected to 30:46:9a:10:0b:9c


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml04.kpnxchange.com ([213.75.38.153]:28420 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874AbYJBUUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 16:20:31 -0400
Message-ID: <48E52D07.8050900@kpnplanet.nl> (sfid-20081002_222035_260539_19D08D89)
Date: Thu, 02 Oct 2008 22:20:23 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: mcgrof@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Regulatory Framework & rt2x00.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

I'm working on making rt2x00 use the regulatory framework to report its 
EEPROM region settings to mac80211, and I have stumbled upon an issue 
that I don't really know how to solve with the current regulatory 
framework code.

The problem I'm facing is that many of the Ralink devices have 2 region 
settings in their EEPROM, one for 802.11a networks, and one for 
802.11[bgn] networks. So far I have only seen devices where these two 
settings contain the same region indication, but I don't know whether 
this is the case for all devices.

At this point in time I use the regulatory_hint function at driver 
start-up time to communicate the region setting that matches the 
configured band, but that would (probably) not hold up when the user 
reconfigures the mode.

So, at this point in time I have the following questions:
1. How would I be able to communicate both these settings to the 
regulatory framework?
2. Should I re-use regulator_hint whenever the configured band changes?
3. Would a driver supplied region override a user configured setting 
(via iw/crda)?

I would appreciate your help in solving this issue.

---
Gertjan van Wingerde
rt2x00 project developer
http://rt2x00.serialmonkey.com/

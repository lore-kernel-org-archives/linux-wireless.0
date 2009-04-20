Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:52185 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbZDTOrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 10:47:51 -0400
Received: from [76.91.220.157] (helo=[192.168.1.21])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1Lvumk-0005Q4-Ek
	for linux-wireless@vger.kernel.org; Mon, 20 Apr 2009 07:47:50 -0700
Message-ID: <49EC8B10.7020006@symas.com> (sfid-20090420_164755_546097_828EC85F)
Date: Mon, 20 Apr 2009 07:47:44 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k roaming for no obvious reason
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been seeing this for a couple of months now, and updating to the latest 
wireless-testing git hasn't improved things:

 >>>
Apr 20 07:31:12 violino NetworkManager: <debug> [1240237872.002673] 
periodic_update(): Roamed from BSSID 00:12:17:26:56:10 (HighlandSun) to (none) 
((none))
Apr 20 07:31:18 violino NetworkManager: <debug> [1240237878.004208] 
periodic_update(): Roamed from BSSID (none) ((none)) to 00:12:17:26:56:10 
(HighlandSun)
Apr 20 07:32:12 violino NetworkManager: <debug> [1240237932.003138] 
periodic_update(): Roamed from BSSID 00:12:17:26:56:10 (HighlandSun) to (none) 
((none))
Apr 20 07:32:18 violino NetworkManager: <debug> [1240237938.004280] 
periodic_update(): Roamed from BSSID (none) ((none)) to 00:12:17:26:56:10 
(HighlandSun)
<<<

This is on an HP dv5z laptop, lspci shows
08:00.0 Network controller: Atheros Communications Inc. AR928X Wireless 
Network Adapter (PCI-Express) (rev 01)

It's about 10 feet from a Linksys WRT54G and there's nothing blocking the line 
of sight. I'm running a 2.6.29.1 kernel at the moment; used the 
compat-wireless git to build the wireless stack.

At random intervals (15-20 minutes or so) it loses the association completely 
and NetworkManager asks me to re-authenticate. This behavior seems to have 
gotten worse in the current snapshot. Has anyone else seen this, any ideas?
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

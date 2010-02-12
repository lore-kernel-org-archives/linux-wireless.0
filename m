Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55797 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0BLIIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 03:08:25 -0500
Received: by fxm7 with SMTP id 7so2296349fxm.28
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2010 00:08:23 -0800 (PST)
Message-ID: <4B750C6E.9000208@gmail.com>
Date: Fri, 12 Feb 2010 09:08:14 +0100
From: Daniel Golle <daniel.golle@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: some ideas about pseudo_adhoc (as rtl8187 cannot do beacon generation)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!
i've got an rtl8187l and want to use it in Ad-Hoc mode (actually 
pseudo_adhoc would actually even be enough!). i researched a little bit 
and found out that ad-hoc-, master- and mesh-mode are unsupported due to 
the lack of beacon generation support in the mac80211 version of the 
rtl8187 driver.
as the softmac card probably doesn't support generating beacons in 
firmware, does that mean we need to setup a beacon generation fork 
repeatedly calling
ieee80211_beacon_get
and then sending the beacon? (very roughly, i'm guessing after reading 
any 802.11 code for 20 minutes)
probably a timing-critical task which needs to bypass the usual buffers 
and such i can imagine...

anyway. pseudo_adhoc (i.e. ad-hoc without beacons) is a nice thing and 
works great for use with user-space mesh-routing solutions such as OLSR, 
batman or babel. however, i guess as pseudo_adhoc is violating the 
standards (though it is very usefull) it might never be supported by 
anything else than proprietary drivers made by Atheros (afaik).

so. i want to use this hardware (RTL8187L) for this task (OLSR). any 
ideas? where should i start wasting my brain-time?

ot: anyone ever tried compiling the FullMAC r8187 driver (aircrack) for 
Atheros/MIPS systems?

cheers

daniel

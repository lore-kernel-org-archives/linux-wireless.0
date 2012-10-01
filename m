Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59885 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2JATne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 15:43:34 -0400
Message-ID: <5069ED50.4050307@etit.tu-chemnitz.de> (sfid-20121001_214401_534723_29DE8446)
Date: Mon, 01 Oct 2012 12:21:52 -0700
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: broadcast buffer / TIM map in mesh mode
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working on a mesh powersave implementation. One requirement for 
that is to buffer broadcasts, set the TIM map and count powersave 
neighbors. All of these routines are currently bound to the AP-specific 
ieee80211_if_ap structure.
Do you have any recommendations how to properly implement this for mesh 
interfaces?

a) allocate/free ieee80211_if_ap in 
iface.c:ieee80211_do_open/ieee80211_do_stop and bind to sdata->bss pointer?
b) include ieee80211_if_ap into ieee80211_if_mesh structure and use 
sdata->bss?
c) completely different?

Also, what is the purpose of the sdata->bss pointer? It seems to be used 
at times and not at others.

I have currently implemented a) here 
https://github.com/cozybit/open80211s/commit/66c40d36087c502f8c52b84861faad6f483ffeb8 
as part of a series 
https://github.com/cozybit/open80211s/compare/38555f9d78...ft-powersave .

Regards,
Marco


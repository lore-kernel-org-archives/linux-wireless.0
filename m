Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59001 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXLTTiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 14:38:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: mac80211: rc algos broken
Date: Thu, 20 Dec 2007 20:35:45 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200712202020.51320.mb@bu3sch.de>
In-Reply-To: <200712202020.51320.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712202035.45909.mb@bu3sch.de> (sfid-20071220_193806_204751_751626F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 December 2007 20:20:51 Michael Buesch wrote:
> RC algos are broken in current wireless-2.6.
> PID fails to load because it can not find any debugfs
> related symbols (debugfs is mounted and works fine). I tried adding
> an #include <linux/debugfs.h> to the code, but it doesn't help.
> 
> mac80211 also fails to load _any_ rc algorithm.
> Both, PID and simple are compiled (after disabling debugfs stuff)
> and mac80211 fails to find, load or whatever any of them.
> The message "Failed to load rc algo blabla you know it" appears.
> 
> Thanks a lot for fixing this ;)
> 

Grepping the code it seems that nobody is ever calling
ieee80211_rate_control_register(). I guess that it kind of a fatal problem. ;)

-- 
Greetings Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tomasu.net ([192.241.222.217]:39826 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaGBCvL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 22:51:11 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: Peter Wu <peter@lekensteyn.nl>
Reply-To: thomas@fjellstrom.ca
Cc: linux-wireless@vger.kernel.org
Subject: Re: Linux iwlwifi 801.11n speeds
Date: Tue, 01 Jul 2014 20:51:08 -0600
Message-ID: <1670596.rIHpxMZ2dp@balsa> (sfid-20140702_045114_904089_173B6807)
In-Reply-To: <2751617.yrMEdml3a5@al>
References: <2766921.O7z3bAoKY3@balsa> <2751617.yrMEdml3a5@al>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 01 Jul 2014 10:23:43 AM Peter Wu wrote:
> # Enable AMPDU (otherwise there is a performance regression from 80
> # Mbit/s to 20 Mbit/s). Introduced with v3.13-10103-g205e221 ("iwlwifi:
> # disable TX AMPDU by default for iwldvm").

Ah, that did it. Thank you! I didn't see that option (8) in my search. Lots of 
people disabling 802.11n completely, but that's kind of the opposite of what I 
want :)

Do you, or anyone else here know what the actual issue is with some cards that 
caused this change to be made? I saw one reference to a device reset happening 
occasionally. I can say I have not seen such crashes or resets. If I do, I'll 
report asap. Maybe it's related to various other settings hitting some odd 
corner case in the wifi firmware.

Question is, why is it enabled in windows if it causes so many problems that 
linux has to disable it by default? Do the windows drivers include fixed 
firmware? Or maybe a more complex quirks list? It'd be interesting to see what 
the two drivers do differently.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

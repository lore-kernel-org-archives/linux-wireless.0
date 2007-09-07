Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44513
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbXIGPFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 11:05:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43 sparse warnings with __CHECK_ENDIAN__
Date: Fri, 7 Sep 2007 17:05:00 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1189099962.28781.102.camel@johannes.berg>
In-Reply-To: <1189099962.28781.102.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200709071705.00705.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 September 2007, Johannes Berg wrote:
> drivers/net/wireless/b43/xmit.c:124:9: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/b43/xmit.c:124:9:    expected restricted unsigned int [usertype] <noident>
> drivers/net/wireless/b43/xmit.c:124:9:    got unsigned char 
> drivers/net/wireless/b43/xmit.c:126:9: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/b43/xmit.c:126:9:    expected restricted unsigned int [usertype] <noident>
> drivers/net/wireless/b43/xmit.c:126:9:    got int 
> drivers/net/wireless/b43/xmit.c:127:11: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/b43/xmit.c:127:11:    expected unsigned int [unsigned] [usertype] x
> drivers/net/wireless/b43/xmit.c:127:11:    got restricted unsigned int [usertype] <noident>
> drivers/net/wireless/b43/pio.c:63:8: warning: cast to restricted type
> drivers/net/wireless/b43/pio.c:551:14: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/b43/pio.c:551:14:    expected unsigned short [unsigned] [short] <noident>
> drivers/net/wireless/b43/pio.c:551:14:    got restricted unsigned short [usertype] [force] <noident>
> drivers/net/wireless/b43/pio.c:558:19: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/b43/pio.c:558:19:    expected unsigned short [unsigned] [short] <noident>
> drivers/net/wireless/b43/pio.c:558:19:    got restricted unsigned short [usertype] [force] <noident>
> drivers/net/wireless/b43/pio.c:561:12: warning: cast to restricted type
> drivers/net/wireless/b43/pio.c:561:12: warning: cast from restricted type
> drivers/net/wireless/b43/pio.c:586:30: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/b43/pio.c:586:30:    expected unsigned short [unsigned] [short] [usertype] <noident>
> drivers/net/wireless/b43/pio.c:586:30:    got restricted unsigned short [usertype] [force] <noident>

Thanks. I did a patch fixing almost all sparse warnings in b43.
The remaining warning in phy.c will be fixed later.
http://bu3sch.de/patches/wireless-dev/20070907-1702/patches/005-b43-fix-sparse-errors.patch

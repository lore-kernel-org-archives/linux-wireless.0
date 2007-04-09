Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:65416 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965826AbXDIVLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 17:11:17 -0400
Message-ID: <461AAC33.4030409@lwfinger.net>
Date: Mon, 09 Apr 2007 16:12:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <1176120428.2693.12.camel@localhost.localdomain> <461A6092.20701@lwfinger.net> <200704091316.23661.flamingice@sourmilk.net>
In-Reply-To: <200704091316.23661.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> rt2x00 does not use qual. All other drivers in tree that use qual 
> (zd1211rw-mac80211, rtl8187) use the current convention.
> 
> I don't see anything in those 4 points that would argue against the current 
> conventions in mac80211. In fact, it sounds like you are arguing for it since 
> jssi, which you said is linear, goes to qual (after my patch is applied) 
> which wants a linear number.

The code is internally consistent. Now it is only the usage of the (r)ssi name to describe the 
logarithmic numbers that is confusing. Would you entertain a patch that changed (r)ssi to level in 
the structs and drivers to reduce the confusion? I have such a patch that works with 
bcm43xx-mac80211. In addition, all other drivers compile.

Larry

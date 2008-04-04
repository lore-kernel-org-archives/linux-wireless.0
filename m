Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52590 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYDDPR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 11:17:58 -0400
Subject: Re: [PATCH] rtl8187b work in progress...
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <200804041107.59990.herton@mandriva.com.br>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
	 <200804012340.01354.herton@mandriva.com.br> <1207280003.2585.15.camel@dv>
	 <200804041107.59990.herton@mandriva.com.br>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 11:17:56 -0400
Message-Id: <1207322276.2157.4.camel@dv> (sfid-20080404_161801_892809_576A6A5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-04 at 11:07 -0300, Herton Ronaldo Krzesinski wrote:

> Yes, I will later do a patch against linux-wireless, I only posted it as a 
> work in progress. But before I post an updated patch I want to fix it first 
> to use changes made by John (like not duplicating the functions etc.) and 
> there is another fundamental problem that I must first fix: it works and 
> scans for aps, but for some reason I don't get authentication from access 
> point (while normal 8187 gets data with IEEE80211_STYPE_AUTH in 8187b for 
> some reason don't...).

It may be useful to check if the AP is sending that packet.  If it does,
I would check the rate and the channel and compare them to the packets
the driver can receive.  I would also check the driver with another AP.
If it's indeed on the receiving side of the driver, a crosscheck against
the softmac driver could be helpful.

Good luck fixing it, but if it still doesn't work, I'd like to see your
patch posted anyway.

-- 
Regards,
Pavel Roskin

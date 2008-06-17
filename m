Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39521 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYFQQRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:17:37 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K8dsB-0001mA-NU
	for linux-wireless@vger.kernel.org; Tue, 17 Jun 2008 16:17:31 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2008 16:17:31 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2008 16:17:31 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
Date: Tue, 17 Jun 2008 17:17:23 +0100
Message-ID: <g38o2j$1uh$1@ger.gmane.org> (sfid-20080617_181742_447297_198DA5E5)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the latest Linus kernel some kinds of connections over my wireless
link have been hanging. By this I mean, for example:

$ ssh <somewhere>
[Wait a while]
Connection reset by <somewhere>

This also affects some http requests such as loading slashdot but not
others (perhaps small ones?) such as twitter API http requests. It does
not seem to affect connections to other machines on my LAN, only ones
over the internet.

I've tried tcpdumping to get more info but when I run tcpdump the
connections work again (if a tiny bit slower).

I've bisected this bug down to 608961a5eca8d3c6bd07172febc27b5559408c5d
"mac80211: Use skb_header_cloned() on TX path." and naively reverting
this change seems to make the bug go away.

I'm using the rt2500pci module and wpa supplicant. My setup is:

  Laptop -- Wireless AP -- Router -- Cable Modem -- The Internet

and my card is a "RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)".

Please let me know if you need any more info or if there's a more
focussed test case I could try.

--
Andy Price


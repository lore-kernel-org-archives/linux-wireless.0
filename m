Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36616
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXGQSZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 14:25:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rtl8187: ensure priv->hwaddr is always valid
Date: Tue, 17 Jul 2007 20:25:19 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707151709.55429.flamingice@sourmilk.net> <1184578463.3773.1.camel@johannes.berg>
In-Reply-To: <1184578463.3773.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707172025.19979.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 16 July 2007 11:34, Johannes Berg wrote:
> On Sun, 2007-07-15 at 17:09 -0700, Michael Wu wrote:
> >  
> > -	priv->hwaddr = conf->mac_addr;
> > +	priv->hwaddr = conf->mac_addr ? conf->mac_addr : dev->wiphy->perm_addr;
> 
> Do you allow monitor mode? If so, this isn't correct unless the hardware
> is explicitly told to not do anything (most hw doesn't and we use a zero
> mac addr for that). conf->mac_addr is NULL in monitor mode for a reason:
> we don't want to have any mac address so we don't ACK packets.

I'd suggest changing this behaviour in the stack, as this bug will
be made again for new drivers in the future.
What about pointing mac_addr to a 00:00:00:00:00 const static mac address,
instead of passing a NULL pointer?

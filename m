Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36096
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbXFTVz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 17:55:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: driver bugs with changed mac address
Date: Wed, 20 Jun 2007 23:52:16 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
References: <1182333938.3714.53.camel@johannes.berg>
In-Reply-To: <1182333938.3714.53.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200706202352.16975.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 June 2007 12:05:38 Johannes Berg wrote:
> Hi,
> 
> I was just looking through some bcm43xx code and noticed that when you
> set a different mac address for some interface, then it is stored to
> wl->mac_addr but this is only ever used in
> bcm43xx_write_mac_bssid_templates and not in bcm43xx_wireless_core_init.
> 
> iwlwifi on the other hand completely ignores the mac address after
> printing it out.
> 
> Also in bcm43xx, when the interface is removed again wl->mac_addr isn't
> set to NULL when the interface that the MAC belonged to is deleted, so
> that the mac address stays programmed on the card and we continue to ACK
> packets for that MAC address.
> 
> In zd1211, we start with hwaddr = dev->wiphy->perm_addr which isn't
> correct either, for a pure monitor mode we want to start with a zero mac
> addr to avoid acking packets. Also, zd1211rw will end up having a NULL
> hwaddr when a monitor interface is added, most likely segfaulting in
> zd_write_mac_addr then.
> 
> The NULL mac address will also happen to rtl818x and possibly p54 (at
> least when that gets monitor mode support)
> 
> Whew. So much for our little mac address audit.
> 
> johannes
> 

Nice catch, thanks!

This should fix it on bcm43xx:
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=dbf39fd9f4cc4edc35ed7ab349c55137ea35aea0

-- 
Greetings Michael.

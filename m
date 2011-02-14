Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:51837 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab1BNMKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:10:17 -0500
Date: Mon, 14 Feb 2011 14:10:13 +0200
From: Jouni Malinen <j@w1.fi>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA for Ethernet?
Message-ID: <20110214121013.GA6431@jm.kir.nu>
References: <loom.20110211T163104-102@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20110211T163104-102@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 11, 2011 at 03:39:03PM +0000, jpo234 wrote:
> is it possible to use the mac80211 (software) encryption infrastructure to
> encrypt data over non 802.11 interfaces? If not, how hard would this be?
> 
> IPsec and other VPN solutions are "tunnel centric" instead of "interface
> centric". I'm looking for a way to say "All inbound and outbound traffic through
> this interface must be encrypted with the following key.", just like WPA-PSK.

Are you looking for a custom solution that would not work with anyone
else or a standard solutions like MACsec that Henry already mentioned?
You could obviously make the kernel do some custom hacks like trying to
fit IEEE 802.11 encryption into other network types, but it would sound
more reasonable to work on a standard solution..

CCMP is designed for IEEE 802.11 header and as such, it does not really
work as-is with other network types. WPA-PSK 4-way handshake could be
used to manage keys with some small changes, but this would be very much
a custom solution.

-- 
Jouni Malinen                                            PGP id EFC895FA

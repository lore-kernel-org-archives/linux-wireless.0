Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55959 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932671Ab0BPHqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 02:46:14 -0500
Date: Tue, 16 Feb 2010 09:46:02 +0200
From: Jouni Malinen <j@w1.fi>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Ignore replay for IBSS interfaces
Message-ID: <20100216074602.GA19876@jm.kir.nu>
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
 <1266225762.3758.1.camel@jlt3.sipsolutions.net>
 <4B79CD81.3090300@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B79CD81.3090300@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2010 at 11:41:05PM +0100, Benoit PAPILLAULT wrote:
> Right. This patch disable replay protection. RSN is indeed the
> correct solution, but it's out of reach for me (no time, no skills).
> As such, I thought that WPA-NONE could be useful in the interim.

I do not think it is acceptable to introduce anything that disables
replay protection.

> Jouni : I would appreciate your input here. What's the status of
> IBSS RSN? How much time/skills would be required to implement it?

The key management side (4-way handshakes) should all be in place now
and the main missing part is in being able to configure all the GTKs
(one per peer) and use the GTKs properly (i.e., match the key per addr2
when addr1 is broadcast/multicast). A good initial step would be to
hardcode mac80211 to use software encryption and extend that to support
multiple GTKs. Once that is working, we can see whether some of the
drivers would be able to do CCMP in hardware for such key configuration.

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36397 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3D1MvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 08:51:23 -0400
Message-ID: <517D1B45.9020302@openwrt.org> (sfid-20130428_145126_809841_7ACE3742)
Date: Sun, 28 Apr 2013 14:51:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] ath9k: collect statistics about Rx-Dup and Rx-STBC
 packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
> Collect statistics about recived duplicate and STBC packets.
> This information should help see if STBC is actually working.
> 
> Tested on ar9285;
> 
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
I thought about this patch some more, and I'm wondering what's the point
in doing this? These statistics are going to be completely useless for
most people and they'll waste some memory/cpu cycles, especially on
small-cache devices. I think it's much more useful to simply pass the
information to mac80211 via rx flags and get them added to the radiotap
header.
I'd like to keep the number of 'poor man's debug hacks' in the driver to
a minimum, and there are some other things that I think should be
removed: rx_frags and rx_beacons in struct ath_rx_stats, the tx/rx MAC
sampling hack, and pretty much anything else that can be just as easily
accessed from mac80211 through regular interfaces.

- Felix

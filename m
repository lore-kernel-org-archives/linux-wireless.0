Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56419 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZK1MGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 07:06:37 -0500
Message-ID: <4B111249.7080105@openwrt.org>
Date: Sat, 28 Nov 2009 13:06:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: 8an@praha12.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC] API for setting ACK timeout
References: <200911261826.08576.8an@praha12.net> <4B103971.2020308@free.fr>
In-Reply-To: <4B103971.2020308@free.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benoit PAPILLAULT wrote:
> Hello Lukas,
> 
> I think that's a good idea indeed. I think the relationship between ACK
> timeout, CTS timeout and slottime and distance should be common (ie
> implemented at mac80211 level) since the formula is not so trivial to me
> (at least, I've seen several formulas flying around). Then, each driver
> needs to convert ACK timeout since the HW registers probably takes into
> account some specific MAC hw time.
> 
> Moreover, the formula is not the same for 2.4 GHz and 5 GHz.
> 
> madwifi had a patch for automatically finding the best ACK timeout,
> maybe it could be ported to mac80211 as well.
That patch is a rather ugly hack which involves doing statistics on the
number of retransmissions while changing the distance setting. It has a
tendency to crank up the ack timeout whenever there is some loss or
interference on the link, thereby making the effects of the interference
even worse. I don't think this should be added to mac80211.
At some point, I will try to come up with an implementation for ath9k
which doesn't involve such voodoo, but instead compares the tx timestamp
of some data packets against the rx timestamp of ack packets. I don't
know if this will work, but IMHO it's worth a try.

- Felix

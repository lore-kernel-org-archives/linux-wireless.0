Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47463 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab0DHTny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:43:54 -0400
Date: Thu, 8 Apr 2010 22:43:49 +0300
From: Jouni Malinen <j@w1.fi>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Any news regarding multicast rate configuration?
Message-ID: <20100408194349.GA27848@jm.kir.nu>
References: <282382.19639.qm@web51406.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <282382.19639.qm@web51406.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:45:15AM -0700, Joerg Pommnitz wrote:
> sometime ago I asked about a way to configure the multicast
> data rate for mac80211 based drivers. At the time the answer
> was, that the groundwork was in place but that this still
> needed an API that would make this feature accessible for
> users.
> Is there any progress in this regard? What needs to be done?

If you are fine with disabling the lowest rates for both unicast and
multicast frames, then yes, you should be able to do this with
NL80211_CMD_SET_TX_BITRATE_MASK. As an example, removing rates 1, 2,
5.5, and 11 Mbps from the mask would make multicast frames go out at 6
Mbps in case of 802.11g.
 
-- 
Jouni Malinen                                            PGP id EFC895FA

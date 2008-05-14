Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32519 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYENEqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 00:46:42 -0400
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200805140127.22302.mb@bu3sch.de>
References: <48294F0B.4040908@f-box.org> <200805131119.09964.mb@bu3sch.de>
	 <482A08A5.3000204@f-box.org>  <200805140127.22302.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 14 May 2008 00:46:40 -0400
Message-Id: <1210740400.2721.56.camel@rd> (sfid-20080514_064645_149919_863E3754)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 01:27 +0200, Michael Buesch wrote:

> Where does this "wrong buffer size" message come from, and what does it mean?

net/mac80211/rx.c

There are two instances of that message, both in ieee80211_rx_h_amsdu(),
and both in the code path that returns RX_DROP_UNUSABLE.

I guess the code complains about some invalid frames and drops them.
Somebody with a better knowledge of the code should write better
descriptions and make the messages different.

-- 
Regards,
Pavel Roskin

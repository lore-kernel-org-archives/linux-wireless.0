Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40412 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3FCKCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 06:02:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20908.26870.629833.926468@gargle.gargle.HOWL> (sfid-20130603_120208_963806_707BC41E)
Date: Mon, 3 Jun 2013 15:29:18 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] ath9k: add STBC Rx flags (repost untill some one asnwers)
In-Reply-To: <1370246279-6536-1-git-send-email-linux@rempel-privat.de>
References: <1370246279-6536-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> One more repost of old patches. I need, please, at least some kind of answer:
> "we don't wont patches from you" or "you are doing some thing wrong".

Both the patches have already been merged in wireless-testing.

commit b0a1ae976d6cd40ff90ba87883e17eb2610dae3d
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Fri May 24 20:30:59 2013 +0200

    ath9k: check for Rx-STBC flag and pass it to ieee80211
    
    This patch make use of STBC flag in DMA RX descriptor.
    Only devices after ar9280 can provide this information.
    
    If card support it we will set HAVE_STBC flag, to show
    clint programm thet STBC is supported but not received.
    
    Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit ab276103357637fb26cc851369b5abbdc42afbf4
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Fri May 24 12:18:30 2013 +0200

    ath9k: remove useless flag conversation.
    
    some flags used only outside of ath9k - In this case we can use
    "enum mac80211_rx_flags" and pass it upstream without extra
    conversation.
    
    Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Sujith

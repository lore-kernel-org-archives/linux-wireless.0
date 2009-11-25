Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35229 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727AbZKYUAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 15:00:37 -0500
Date: Wed, 25 Nov 2009 14:47:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2 8/8] rt2x00: Properly request tx headroom for
	alignment operations.
Message-ID: <20091125194746.GG7800@tuxdriver.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <1259012694-14869-3-git-send-email-gwingerde@gmail.com> <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 10:44:54PM +0100, Gertjan van Wingerde wrote:
> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
> small" error message when a frame needs to be properly aligned before
> transmitting it.
> This is because the space needed to ensure proper alignment isn't
> requested from mac80211.
> Fix this by adding sufficient amount of alignment space to the amount
> of headroom requested for TX frames.
> 
> Reported-by: David Ellingsworth <david@identd.dyndns.org>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

  CC [M]  drivers/net/wireless/rt2x00/rt2x00dev.o
drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_probe_hw’:
drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: ‘IEEE80211_TX_STATUS_HEADROOM’ undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: (Each undeclared identifier is reported only once
drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: for each function it appears in.)

Did I miss a patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

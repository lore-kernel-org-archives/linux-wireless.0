Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:57383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYGVXR2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:28 -0400
Date: Tue, 22 Jul 2008 16:14:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>
Subject: [patch 01/47] b43legacy: Do not return TX_BUSY from op_tx
Message-ID: <20080722231406.GB8282@suse.de> (sfid-20080723_011732_289639_A3C29BB8)
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080722231342.GA8282@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.

Upstream commit is
eb803e419ca6be06ece2e42027bb4ebd8ec09f91

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/b43legacy/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2350,8 +2350,10 @@ static int b43legacy_op_tx(struct ieee80
 	} else
 		err = b43legacy_dma_tx(dev, skb, ctl);
 out:
-	if (unlikely(err))
-		return NETDEV_TX_BUSY;
+	if (unlikely(err)) {
+		/* Drop the packet. */
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
 

-- 

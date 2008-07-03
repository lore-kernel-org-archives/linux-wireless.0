Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57352 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYGCMMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 08:12:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [PATCH stable] b43: Do not return TX_BUSY from op_tx
Date: Thu, 3 Jul 2008 10:31:45 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200807030104.30100.mb@bu3sch.de> <87y74jtqz8.fsf@nokia.com>
In-Reply-To: <87y74jtqz8.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807031031.45955.mb@bu3sch.de> (sfid-20080703_141240_408789_D701059A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 July 2008 08:35:23 Kalle Valo wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> > +drop_packet:
> > +	/* We can not transmit this packet. Drop it. */
> > +	dev_kfree_skb_any(skb);
> >  	return NETDEV_TX_OK;
> 
> So no need to call ieee80211_tx_status() in this case? I'm just
> curious about this, nothing else.

I don't think we must call tx_status for dropped or lost packets.

-- 
Greetings Michael.

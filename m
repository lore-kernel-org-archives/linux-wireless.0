Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37441 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYGCGgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 02:36:05 -0400
To: "Michael Buesch" <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH stable] b43: Do not return TX_BUSY from op_tx
References: <200807030104.30100.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 03 Jul 2008 09:35:23 +0300
In-Reply-To: <200807030104.30100.mb@bu3sch.de> (ext Michael Buesch's message of "Thu\, 3 Jul 2008 01\:04\:29 +0200")
Message-ID: <87y74jtqz8.fsf@nokia.com> (sfid-20080703_085917_271227_5FFBCFE5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> +drop_packet:
> +	/* We can not transmit this packet. Drop it. */
> +	dev_kfree_skb_any(skb);
>  	return NETDEV_TX_OK;

So no need to call ieee80211_tx_status() in this case? I'm just
curious about this, nothing else.

-- 
Kalle Valo

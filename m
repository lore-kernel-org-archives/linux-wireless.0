Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXJHNOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 09:14:50 -0400
Subject: Re: [PATCH] libertas: fixes for slow hardware
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710081118.27468.hs4233@mail.mn-solutions.de>
References: <200710081118.27468.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 09:15:16 -0400
Message-Id: <1191849316.2703.26.camel@localhost.localdomain> (sfid-20071008_141455_442349_6DF23973)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-08 at 11:18 +0200, Holger Schurig wrote:
> This fixes issues where either the CF module is slow (and needs 
> more time while downloading the firmware) or where the host 
> computer is slow, so that some card interrupts arrive while
> the system was still downloading the firmware.
> 
> Signed-off-by: Vitaly V. Bursov <vitalyvb@ukr.net>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

@@ -405,6 +405,7 @@ static struct sk_buff *if_cs_receive_dat
        skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
        if (!skb)
                goto out;
+       skb->dev = priv->dev;
        skb_put(skb, len);
        skb_reserve(skb, 2);/* 16 byte align */
        data = skb->data;

This hunk is not necessary, the skb->dev gets set in
libertas_upload_rx_packet() when calling eth_type_trans().  If using a
kernel <= 2.6.21, setting skb->dev should be handled by
libertas_upload_rx_packet() for you later on.

Dan



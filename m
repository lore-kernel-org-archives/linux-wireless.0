Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45881 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082Ab0BYRsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:48:23 -0500
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation.
 (without fallback change)
From: Pavel Roskin <proski@gnu.org>
To: prahal@yahoo.com
Cc: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <4B85FA66.2020503@yahoo.com>
References: <4B85FA66.2020503@yahoo.com>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 12:48:12 -0500
Message-Id: <1267120092.25296.31.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have tested both patches on the real hardware, and I don't see any
regressions.  Unfortunately, the issue with interrupts is still there,
so ping stops after 11 packets, which limited my ability to test the
change extensively.  That said, I was able to use wpa_supplicant and
dhcp to get an IP address using the patched driver in the station mode.

wpa_supplicant worked most of the time.  I believe the occasional
failures are due to a preexisting memory corruption issue (I reported
earlier that addr3 can be corrupted in probe requests).

Unfortunately, the patches include corrupt whitespace, so they had to be
applied by "patch -l".  Also, there are trailing tabs in two places.
That's not a big deal, but it's better avoided.  Please consider using
git or stgit to send patches.

> +	for (i=0; i<256; i++) {

checkpatch.pl complains about spacing.  There should be spaces around
"=" and "<"

> +		txwi = (__le32 *)(entry->skb->data -
> +				  rt2x00dev->hw->extra_tx_headroom);

I really don't see any point in introducing wrong code in one patch and
fixing it in another.  I would just join the patches.

When bisecting for a problem, landing at a broken commit can lead to a
lot of wasted time.

> +		rt2x00_desc_read(txwi, 1, &word);
> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> +
> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");

Can we make this sanity check optional?

-- 
Regards,
Pavel Roskin

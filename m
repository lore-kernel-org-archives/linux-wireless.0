Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46132 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbcBAM2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:28:15 -0500
Subject: Re: mt76 tx status
To: Johannes Stezenbach <js@sig21.net>
References: <20160131222441.GA20283@sig21.net>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56AF4F56.5080901@openwrt.org> (sfid-20160201_132821_895783_5B26D285)
Date: Mon, 1 Feb 2016 13:28:06 +0100
MIME-Version: 1.0
In-Reply-To: <20160131222441.GA20283@sig21.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-31 23:24, Johannes Stezenbach wrote:
> Hi Felix,
> 
> I noticed in mt76x2_mac_poll_tx_status() you are reading
> MT_TX_STAT_FIFO before reading MT_TX_STAT_FIFO_EXT,
> however I have a hunch that reading MT_TX_STAT_FIFO clobbers
> the corresponding MT_TX_STAT_FIFO_EXT since MT_TX_STAT_FIFO
> has the valid bit, and both registers together seem to implement
> reading a 64bit FIFO entry.  I.e. you need to read
> MT_TX_STAT_FIFO_EXT first otherwise you get a mix from
> two FIFO entries.
> 
> I played a bit with the vendor driver for the mt7610u
> and confirmed that multiple reads from MT_TX_STAT_FIFO_EXT
> return the same value until MT_TX_STAT_FIFO is read.
> (Note the mt7610u vendor driver does not define FIFO_EXT_SUPPORT
> but the FIFO seems to exist in hardware.  The mt7612u vendor driver
> code reads the MT_TX_STAT_FIFO_EXT first.)
Hi Johannes,

When I wrote that particular part of the code, I still had a lot of
other bugs regarding aggregation and rate probing. Back then, somehow I
got better results reading FIFO before FIFO_EXT.
I just did a few experiments to not only verify that reading FIFO
clobbers FIFO_EXT, but also to ensure that the data from reading
FIFO_EXT first really belongs to the value read from FIFO.

I tested this by checking if the MT_TXWI_PKTID_PROBE flag in the pktid
field (in FIFO_EXT) corresponds to a different rate being selected.

My test results pretty much confirm your findings, so I've committed and
pushed a fix.

Thanks,

- Felix

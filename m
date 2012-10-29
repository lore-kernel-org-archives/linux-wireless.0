Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44512 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab2J2Mek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 08:34:40 -0400
Message-ID: <508E77DA.8050708@openwrt.org> (sfid-20121029_133444_256040_35DA1835)
Date: Mon, 29 Oct 2012 13:34:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] ath9k: Test for TID only in BlockAcks while checking
 tx status
References: <1351513520-23536-1-git-send-email-sven@narfation.org>
In-Reply-To: <1351513520-23536-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-29 1:25 PM, Sven Eckelmann wrote:
> The ath9k xmit functions for AMPDUs can send frames as non-aggregate in case
> only one frame is currently available. The client will then answer using a
> normal Ack instead of a BlockAck. This acknowledgement has no TID stored and
> therefore the hardware is not able to provide us the corresponding TID.
> 
> The TID set by the hardware in the tx status descriptor has to be seen as
> undefined and not as a valid TID value for normal acknowledgements. Doing
> otherwise results in a massive amount of retransmissions and stalls of
> connections.
> 
> Users may experience low bandwidth and complete connection stalls in
> environments with transfers using multiple TIDs.
> 
> This regression was introduced in b11b160defc48e4daa283f785192ea3a23a51f8e
> ("ath9k: validate the TID in the tx status information").
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Nice catch, thanks!
Acked-by: Felix Fietkau <nbd@openwrt.org>

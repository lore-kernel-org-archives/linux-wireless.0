Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753505AbdLMPUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 10:20:25 -0500
Date: Wed, 13 Dec 2017 16:20:18 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20171213152017.GA3554@redhat.com> (sfid-20171213_162122_517096_83AC1428)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
In-Reply-To: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 11, 2017 at 09:51:29PM +0100, Enrico Mioso wrote:
> Hello guys, and sorry for the big CC list.
> I would like to point out about a bug who survived for years - at least from 2015 until now, regarding the Ralink driver getting stuck, and in some cases not being able to recover.
> The problem manifested with an MT7620A chip, and the wireless card inside the WL-330N3G device.
> The error message is in rt2x00/rt2x00queue.c .
> 
> This bug was discussed, and a patch proposed, in this thread:
> https://lists.openwrt.org/pipermail/openwrt-devel/2015-September/thread.html#35778
> 
> I would like to help if possible - I have the have both an Archer MR200, and the WL330n3G hardware.
> BTW, the Archer MR200 is a nice MT7610 device, and the problem manifests itself, see:
> https://forum.openwrt.org/viewtopic.php?id=64293&p=6
> 
> Any help, hint, anything would be apreciated.
> thank you to all.

First I would try to remove this patch:
http://git.lede-project.org/?p=source.git;a=blob;f=package/kernel/mac80211/patches/600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
and see if it makes things better. However I think for the stuck problem
we need tx status timeout mechanism similar like for rt2800usb.

Attached patch can mitigate "Dropping frame due to full tx queue" 
errors. I did not test it, so it can be totally broken.

Regards
Stanislaw

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_pause_queue_without_droping_lock.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index ecc96312a370..c8a6f163102f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -152,16 +152,6 @@ void rt2x00mac_tx(struct ieee80211_hw *hw,
 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
 		goto exit_fail;
 
-	/*
-	 * Pausing queue has to be serialized with rt2x00lib_txdone(). Note
-	 * we should not use spin_lock_bh variant as bottom halve was already
-	 * disabled before ieee80211_xmit() call.
-	 */
-	spin_lock(&queue->tx_lock);
-	if (rt2x00queue_threshold(queue))
-		rt2x00queue_pause_queue(queue);
-	spin_unlock(&queue->tx_lock);
-
 	return;
 
  exit_fail:
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index a2c1ca5c76d1..39d523bbb661 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -714,6 +714,13 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_kick_tx_queue(queue, &txdesc);
 
+	/*
+	 * Pausing queue has to be serialized with rt2x00lib_txdone(), so we
+	 * do this under queue->tx_lock. Bottom halve was already disabled
+	 * before ieee80211_xmit() call.
+	 */
+	if (rt2x00queue_threshold(queue))
+		rt2x00queue_pause_queue(queue);
 out:
 	spin_unlock(&queue->tx_lock);
 	return ret;

--17pEHd4RhPHOinZp--

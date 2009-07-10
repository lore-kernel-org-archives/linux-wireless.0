Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63362 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbZGJWcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 18:32:41 -0400
Received: from [192.168.0.22] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay2.cesmail.net (Postfix) with ESMTPSA id BF8B034C6D
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 18:41:29 -0400 (EDT)
Subject: ieee80211_tx_status() on injected packets
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 18:32:39 -0400
Message-Id: <1247265159.6399.31.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've been testing mac80211 with kmemcheck.  By injecting specially
crafted packets, I could trigger a warning in ieee80211_tx_status() on
this line:

        frag = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;

It turns out hdr->seq_ctrl is beyond the end of the skb.  Adding printk
confirms it:

hdr=0xffff88012aa04868, &hdr->seq_ctrl=0xffff88012aa0487e,
skb->data=0xffff88012aa04868, skb->data + skb->len=0xffff88012aa0487c

The packets that produce the warning have the radiotap header length
increased by 10.

Here's the annotated dump of the packet:

/* Original radiotap header, but the length should be 0e, not 18 */
00 00 18 00 03 00 00 00 00 02 6c 09 a0 00
/* mac80211 treats this as part of the radiotap header */
08 03 00 00 01 0c cc 00 00 00
/* frame control */
00 11
/* duration */
6b 39
/* addr1 */
40 19 11 04 28 00
/* addr2 */
00 00 10 00 00 00
/* addr3 - incomplete */
00 00 00 00
/* sequence control - beyond the skb end */

I'm using rt73usb to inject.  ieee80211_tx_status() is scheduled by
ieee80211_tx_status_irqsafe(), which is called in rt2x00dev.c.

If we allow to inject malformed packets, we shouldn't assume them to be
valid 802.11 packets unless we can verify it.  And even then, maybe it's
better to bypass ieee80211_tx_status() for injected packets, as it can
influence statistics and rate control algorithms in unpredictable ways.

-- 
Regards,
Pavel Roskin

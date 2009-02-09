Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55752 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbZBIWUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:20:05 -0500
Message-ID: <4990AC02.6030703@lwfinger.net> (sfid-20090209_232010_599733_BFA6A289)
Date: Mon, 09 Feb 2009 16:19:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jorge Munoz <jorgeroden1@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 in Toshiba L300 linux troubles
References: <6ad5d99d0902091343v693173f2w61ff60a216bb15e9@mail.gmail.com>
In-Reply-To: <6ad5d99d0902091343v693173f2w61ff60a216bb15e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jorge Munoz wrote:
> I'm a L300 Toshiba user, this laptop has a rtl8187 wifi card (Bus 007
> Device 003: ID 0bda:8198 Realtek Semiconductor Corp.).
> Running down  Ubuntu 8.10 kernel 2.6.27.9-generic based distro
> (www.molinux.info <http://www.molinux.info>), wifi does not work
> correctly, it fall down in few minutes. We can improve this behaviour by
> fixing bit rate ($iwconfig wlan0 rate 12M fixed).
> Now there is a new kernel 2.6.27-11-generic. I would like to know if
> there are improvements about this bug.
> All my colleagues from my region (Castilla La Mancha, Spain) have the
> same laptop (28.000 were delivered by spanish goverment). We have
> created a patch to fix the bit rate and I don't know if it's necessary
> maintain it.
>  I'll be grateful for your support.

There have been patches for the RTL8187B in recent kernels that have
been sent to stable; however, I don't follow the updates to Ubuntu
kernels and do not know if they have been applied there.

The main patch that did the most to improve stability for the rtl8187
devices was:

================

commit 2fcbab044a3faf4d4a6e269148dd1f188303b206
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Fri Jan 23 11:46:32 2009 -0600

    rtl8187: Add termination packet to prevent stall

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 6ad6bac..22bc07e 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -273,6 +273,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)

 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
 			  buf, skb->len, rtl8187_tx_cb, skb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_anchor_urb(urb, &priv->anchored);
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc < 0) {



Larry


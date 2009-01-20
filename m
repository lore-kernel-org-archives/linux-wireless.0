Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38164 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762914AbZATUuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:50:14 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 20 Jan 2009 21:50:17 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901200032.42202.chunkeey@web.de> <497631A8.9030903@gmail.com>
In-Reply-To: <497631A8.9030903@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JkjdJXN7OjxdBb2"
Message-Id: <200901202150.17233.chunkeey@web.de> (sfid-20090120_215043_315651_2B850585)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_JkjdJXN7OjxdBb2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 20 January 2009 21:18:48 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Tuesday 20 January 2009 00:17:13 Artur Skawina wrote:
> > if your device finally works. (Well "works" is maybe a bit too much, 
> > as you'll probably run into other bugs, e.g truesize bug or the "shot rc", or
> > more problems with powersaving station that only have apsd).
> 
> It seems to work quite well, i'm seeing the occasional truesize warning and
> haven't yet figured out why the client won't reconnect before hostapds
> ap_max_inactivity timeout triggers, but other than that everything seems fine.

So, p54usb first generation needs the ZERO_PACKET flag as well?
(e.g a patch like the attached p54usb-net2280-zeropacket.diff ?)

Regards,
	Chr

--Boundary-00=_JkjdJXN7OjxdBb2
Content-Type: text/x-diff;
  charset="utf-8";
  name="p54usb-net2280-zeropacket.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54usb-net2280-zeropacket.diff"

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index da3e918..4617bc2 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -332,12 +332,13 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 	 * free what's inside the transfer_buffer after the callback routine
 	 * has completed.
 	 */
-	int_urb->transfer_flags |= URB_FREE_BUFFER;
+	int_urb->transfer_flags |= URB_FREE_BUFFER | URB_ZERO_PACKET;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  hdr, skb->len + sizeof(*hdr), FREE_AFTER_TX(skb) ?
 			  p54u_tx_cb : p54u_tx_dummy_cb, skb);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_anchor_urb(int_urb, &priv->submitted);
 	err = usb_submit_urb(int_urb, GFP_ATOMIC);

--Boundary-00=_JkjdJXN7OjxdBb2--

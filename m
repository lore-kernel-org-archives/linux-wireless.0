Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46968 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYLQQhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:37:45 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Wed, 17 Dec 2008 17:36:37 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net> <200812171520.40104.chunkeey@web.de> <49492245.9010500@lwfinger.net>
In-Reply-To: <49492245.9010500@lwfinger.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WqSSJt8e/JCHwsK"
Message-Id: <200812171736.38289.chunkeey@web.de> (sfid-20081217_173750_688958_52DEBC97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_WqSSJt8e/JCHwsK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 17 December 2008 17:01:09 Larry Finger wrote:
> Christian Lamparter wrote:
> > Ohh, it always gets better. ;)
> > Anyway, I'll see what I can do tomorrow. 
> > 
> > In the meantime, I remembered that I put a heat sink on my chip a while ago,
> > but I'm not sure if this had any effect here... But back in the summer, it allowed me
> > fix the iperf stalls I had, but that was after days with 60Gb traffic...
> 
> That would be a good idea; however, it is winter in my hemisphere (I don't care
> what the calender says.), and the room is cool. In addition, my device is a Dell
> Wireless 1450, which comes with a pretty hefty heat sink on its own.

Your had already one? Perhaps, I got a very old one then. (Rev A01)
 
> I'll throw printk's into every place I can think of and try to provide more info.
maybe this printk could shed some light into the dark... 
(In station mode: "status" should be either 0(ACKed) or 1(not ACKed/timeout)
and (2 [ device is sleeping -  but we don't set the PSM yet, so this is not expected])

Regards,
	Chr

--Boundary-00=_WqSSJt8e/JCHwsK
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54test.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54test.diff"

diff -Nurp p54-free-on-tx/p54common.c p54-eee/p54common.c
--- p54-free-on-tx/p54common.c	2008-12-14 14:49:03.000000000 +0100
+++ p54-eee/p54common.c	2008-12-17 17:28:44.153744168 +0100
@@ -800,6 +800,12 @@ static void p54_rx_frame_sent(struct iee
 		info->status.ack_signal = p54_rssi_to_dbm(dev,
 				(int)payload->ack_rssi);
 		skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+		if (payload->status) {
+			struct ieee80211_hdr *hd = (void*) skb->data; 
+			printk(KERN_DEBUG "frame_control:%x status %d\n",
+			       hd->frame_control,
+			       payload->status);
+			}
 		ieee80211_tx_status_irqsafe(dev, entry);
 		goto out;
 	}

--Boundary-00=_WqSSJt8e/JCHwsK--

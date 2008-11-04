Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:37129 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028AbYKDA0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 19:26:36 -0500
Date: Tue, 4 Nov 2008 00:26:34 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly ack tx pkts
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <664192.60694.qm@web23102.mail.ird.yahoo.com> (sfid-20081104_012641_539505_6FFF760A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- On Fri, 31/10/08, Larry Finger
> <Larry.Finger@lwfinger.net> wrote:
> 
> > With these patches installed, my RTL8187B device was
> stuck
> > at 1 Mbs using the
> > 'pid' algorithm. 

I back-ported the 2nd rate-change patch 
"feedback transmitted packets using tx close descriptor for 8187B"
on its own to 2.6.27 and its behavior is similiar to the earlier rate-control patch but without "tranmit queue full" dmesg flood; and my trans rate goes up and down between 11Mb to 48Mb. So it looks like the rate limitation you are experiencing is either due to the conf_tx patch, the rest of 2.6.27<->2.6.28 wireless changes, or this little snipplet which I had to change for the back port, since the rates[0].* seems to be newly introduced in 2.6.28/wireless-testing.

----------------------------------------------------
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -494,7 +494,9 @@ static void rtl8187b_status_cb(struct urb *urb)
             __skb_unlink(skb, &priv->b_tx_status.queue);
             if (tok)
                 info->flags |= IEEE80211_TX_STAT_ACK;
-            info->status.rates[0].count = pkt_rc + 1;
+            else
+              info->status.excessive_retries = 1;
+            info->status.retry_count = pkt_rc;
 
             ieee80211_tx_status_irqsafe(hw, skb);
         }
-----------------------------------------------------
I don't know what's the significance of this (and the "+1" above), but I made this change based on the first rate-change patch :-).

So you can add <test-by> me for the 2nd patch of these two; the conf_tx callback patch seems to depend on some fairly recently wireless-testing/2.6.28.x changes?

Hin-Tak


      

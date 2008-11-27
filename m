Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56420 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYK0OmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 09:42:25 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Date: Thu, 27 Nov 2008 15:42:23 +0100
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <200811242124.16358.chunkeey@web.de> <f76a32050811270605s606cc0acjd419987235db44f4@mail.gmail.com> <1227795234.3809.94.camel@johannes.berg>
In-Reply-To: <1227795234.3809.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PHrLJMxuWcpWm7+"
Message-Id: <200811271542.23390.chunkeey@web.de> (sfid-20081127_154230_108608_56D03838)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_PHrLJMxuWcpWm7+
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 27 November 2008 15:13:54 Johannes Berg wrote:
> On Thu, 2008-11-27 at 15:05 +0100, Stefan Steuerwald wrote:
> > I'm unfamiliar with kernel dev procedure. I assume you guys are trying
> > to get confirmation for that and/or submit patches? 
> 
> I've already submitted my patch to John, I suppose Christian will submit
> his and add you as Tested-by.
p54-sta-flags-v3.diff will be submitted on friday/saturday (probably together
with the WEP/TKIP & CCMP offload patch, which could be very useful for
embedded systems accesspoints too)...

But I don't know what to do with set-and-clear.diff 
(I guess it's still one of the three patches, or?, I've attached it again,
in case johannes missed it? ).
Is it really necessary or does your application work without it?

> > If you need me for
> > any of that, I'll be there anytime. Also, a hint on whether to send
> > pizzas or iPods would be appreciated ;-) .
Johannes,

Isn't there a donation page on the wiki yet? I thought there is such
a thing already?!

Regards,
	Chr



--Boundary-00=_PHrLJMxuWcpWm7+
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="set-and-clear.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="set-and-clear.diff"

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..077fdb7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -657,7 +657,8 @@ static void ap_sta_ps_start(struct sta_info *sta)
 	DECLARE_MAC_BUF(mac);
 
 	atomic_inc(&sdata->bss->num_sta_ps);
-	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
+	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL |
+				WLAN_STA_CLEAR_PS_FILT);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -674,7 +675,8 @@ static int ap_sta_ps_end(struct sta_info *sta)
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
-	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	set_and_clear_sta_flags(sta, WLAN_STA_CLEAR_PS_FILT,
+				WLAN_STA_PS | WLAN_STA_PSPOLL);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);

--Boundary-00=_PHrLJMxuWcpWm7+--

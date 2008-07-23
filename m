Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48335 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbYGWPc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 11:32:28 -0400
Message-ID: <48874F09.7060400@lwfinger.net> (sfid-20080723_173231_370872_A4F565A7)
Date: Wed, 23 Jul 2008 10:32:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
 rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>	 <200807221613.34434.herton@mandriva.com.br>	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>	 <4886C50E.6040304@lwfinger.net> <1216824917.13587.9.camel@johannes.berg>
In-Reply-To: <1216824917.13587.9.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-07-23 at 00:43 -0500, Larry Finger wrote:
>> Johannes,
>>
>> In the current wireless-testing (v2.6.26-rc9-14207-ga520bdb), rtl8187 is broken. 
>> In most cases, it is unable to complete a connection. Occasionally, it will 
>> authenticate and even get an IP using DHCP; however, only a few pings get 
>> through to the AP before the connection fails completely.
>>
>> Using bisection, this problem was traced to:
>>
>> ==================================================
>> commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Thu Jul 10 11:21:26 2008 +0200
>>
>>      mac80211: fix TX sequence numbers
> 
>> The validity of the bisection was confirmed by reverse application of the patch. 
>> The resulting driver worked.
>>
>> The appears that rtl8187 needs some kind of modification such as b43, b43legacy, 
>> and rt2x00 got in the original patch. I'll be studying the changes to the other 
>> drivers to see if I can find the problem, but I will appreciate your help when 
>> you get a chance. Perhaps after your trip to Canada is over.
> 
> Oh, crap. If you look at the patch, it removes the sequence numbers for
> non-TID frames, and puts them back into rt2x00 because I thought rt2x00
> was the only driver that needed software sequence numbering. It looks
> like rtl8187 and zd1211 might need that too, so we need to copy the
> rt2x00 code that I put into that particular patch to those drivers.

I tried something like that, but it didn't work. Maybe you can see what is wrong 
here:


Index: wireless-testing/drivers/net/wireless/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl8187.h
@@ -100,6 +100,7 @@ struct rtl8187_priv {
  	struct usb_device *udev;
  	u32 rx_conf;
  	u16 txpwr_base;
+	u16 seqno;
  	u8 asic_rev;
  	u8 is_rtl8187b;
  	enum {
Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
  {
  	struct rtl8187_priv *priv = dev->priv;
  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
  	unsigned int ep;
  	void *buf;
  	struct urb *urb;
@@ -198,6 +199,14 @@ static int rtl8187_tx(struct ieee80211_h
  		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
  	}

+	/* XXX: This sequence is an attempt to match what happens in r2x00. */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
+
  	if (!priv->is_rtl8187b) {
  		struct rtl8187_tx_hdr *hdr =
  			(struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));

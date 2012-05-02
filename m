Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43002 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2EBM6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 08:58:33 -0400
Received: by yhmm54 with SMTP id m54so636181yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 05:58:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA0405C.8050101@lwfinger.net>
References: <4FA0405C.8050101@lwfinger.net>
Date: Wed, 2 May 2012 15:58:32 +0300
Message-ID: <CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com> (sfid-20120502_145837_109381_E4951E35)
Subject: Re: Wireless problem in 3.4-rc5
From: Eliad Peller <eliad@wizery.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Larry,

On Tue, May 1, 2012 at 10:58 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> After upgrading to 3.4-rc5 from wireless-testing, one of my boxes fails to
> scan and gets a "Network down" message for all wireless devices. The code in
> 3.4-rc4 was OK, thus I bisected to find the offending commit. The one that
> broke my wireless is commit 3a25a8c entitled "mac80211: add improved HW
> queue control".
>
> On my main laptop, this patch causes no problems. On a 3rd box, a BCM4312
> (b43) is OK, but an RTL8187L (rtl8187) also fails in the same manner.
>
> The problem is not in the configuration as I copied the one from the box
> that works to the one that fails, and it still fails. The only difference is
> that the working system has 2 CPUs and the ones that fail are uni-processor;
> however, if I boot with maxcpus=1, my main machine still works.
>
> Any suggestions of things to try will be appreciated.
>
i'm not sure this is related to the problem you're facing, but the
commit above seems to have some bug in which a packet might get
enqueued on invalid queue (0xff) - please try this patch (compile
tested only):

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3557354..ee815a9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2106,7 +2106,8 @@ static int ieee80211_mgmt_tx(struct wiphy
*wiphy, struct net_device *dev,

 	IEEE80211_SKB_CB(skb)->flags = flags;

-	if (flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL &&
+	    flags & IEEE80211_TX_CTL_TX_OFFCHAN)
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;

@@ -2151,8 +2152,9 @@ static int ieee80211_mgmt_tx(struct wiphy
*wiphy, struct net_device *dev,
 		/* modify cookie to prevent API mismatches */
 		*cookie ^= 2;
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
-		IEEE80211_SKB_CB(skb)->hw_queue =
-			local->hw.offchannel_tx_hw_queue;
+		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+			IEEE80211_SKB_CB(skb)->hw_queue =
+				local->hw.offchannel_tx_hw_queue;
 		local->hw_roc_skb = skb;
 		local->hw_roc_skb_for_status = skb;
 		mutex_unlock(&local->mtx);


Eliad.

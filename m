Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51702 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030619AbXEAPZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 11:25:28 -0400
Date: Tue, 1 May 2007 17:25:13 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: d80211: How does TX flow control work?
Message-ID: <20070501172513.2519f64b@logostar.upir.cz>
In-Reply-To: <46374C4C.50106@web.de>
References: <459A5945.80909@web.de>
	<20070103185203.2754e059@griffin.suse.cz>
	<459BF179.6000906@web.de>
	<20070103191853.4f440b8b@griffin.suse.cz>
	<459BFB05.9040608@web.de>
	<45A03825.9080807@web.de>
	<45A2A728.1070404@web.de>
	<1175029130.5151.6.camel@johannes.berg>
	<460B7CAA.4020604@web.de>
	<4637195E.5050907@web.de>
	<20070501124733.47c45dd0@logostar.upir.cz>
	<46371B71.2090508@web.de>
	<1178017466.3483.20.camel@johannes.berg>
	<46373B94.4080307@web.de>
	<1178026008.4157.0.camel@johannes.berg>
	<46374C4C.50106@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 May 2007 16:18:52 +0200, Jan Kiszka wrote:
> Already tried this lethal command? Works "fine" here...
> 
> #tc qdisc del dev wmaster0 root

I cannot reproduce it too.

Could you please (_without_ applying the attached patch):

- reproduce it with the latest wireless-dev (sorry, there were some changes
  in the networking core, we need to be sure this is not fixed already)
- send the dmesg output and/or any relevant logs?

If the problem still persists, could you please try again with the
following patch applied?

(Btw, you don't need to clone wireless-dev, just make another branch in
your local git tree and pull wireless-dev into it. That way you should
download a few hundred kilobytes only.)

Thanks,

 Jiri


Subject: [PATCH] mac80211: disallow transmitting when 802.11 qdisc is removed

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/ieee80211.c |    9 +++++++++
 1 files changed, 9 insertions(+)

--- mac80211.orig/net/mac80211/ieee80211.c
+++ mac80211/net/mac80211/ieee80211.c
@@ -1435,6 +1435,15 @@ static int ieee80211_master_start_xmit(s
 	int headroom;
 	int ret;
 
+	if (unlikely(!ieee80211_qdisc_installed(dev))) {
+		netif_stop_queue(dev);
+		if (net_ratelimit())
+			printk(KERN_ERR "%s: ieee80211 qdisc not installed\n",
+			       dev->name);
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
 	/*
 	 * copy control out of the skb so other people can use skb->cb
 	 */


-- 
Jiri Benc
SUSE Labs

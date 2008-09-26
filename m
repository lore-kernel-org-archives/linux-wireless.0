Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbYIZIrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 04:47:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 01:47:47 -0700
Date: Fri, 26 Sep 2008 01:47:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Message-ID: <20080926084738.GA6331@tesla> (sfid-20080926_104751_875121_193C3984)
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net> <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com> <48DC51AF.6000900@lwfinger.net> <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com> <43e72e890809260043n1b31dea9yaad2e7a2d80ed819@mail.gmail.com> <1ba2fa240809260111i217ff844q73036685e6d74aee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240809260111i217ff844q73036685e6d74aee@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 01:11:53AM -0700, Tomas Winkler wrote:
> On Fri, Sep 26, 2008 at 10:43 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Fri, Sep 26, 2008 at 12:06 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >> On Thu, Sep 25, 2008 at 8:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >>> Tomas Winkler wrote:
> >>>> wild guess try to revert:
> >>>> 'mac80211: make master iface not wireless'
> >>>
> >>> You win the prize. Bisection shows that
> >>> 84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit
> >>>
> >>> commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
> >>> Author: Johannes Berg <johannes@sipsolutions.net>
> >>> Date:   Tue Sep 16 14:18:59 2008 +0200
> >>>
> >>>    mac80211: make master iface not wireless
> >>>
> >>>
> >>> The actual crash is in the following routine from include/net/wireless.h:
> >>>
> >>> /**
> >>>  * wiphy_priv - return priv from wiphy
> >>>  */
> >>> static inline void *wiphy_priv(struct wiphy *wiphy)
> >>> {
> >>>        BUG_ON(!wiphy);
> >>>        return &wiphy->priv;
> >>> }
> >>>
> >>> I'm still looking to see where it goes wrong.
> >>
> >> Actually wouldn't you get a stack trace here?
> >
> > Yeah not sure I tested against !wiphy on its callers and didn't find a
> > case where it hit. I don't think this is it.
> 
> u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
> {
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>         struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> --- this is the line

--- This is the fix

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 6748ded..7d114bd 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -75,8 +75,16 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 /* Indicate which queue to use.  */
 static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_master_priv *mpriv;
+
+	/* this is not for wiphys, just for mdev */
+	BUG_ON (dev->ieee80211_ptr);
+
+	mpriv = netdev_priv(dev);
+	local = mpriv->local;
+
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
 		/* management frames go on AC_VO queue, but are sent
@@ -114,12 +122,19 @@ static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_master_priv *mpriv;
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
 
+	/* this is not for wiphys, just for mdev */
+	BUG_ON (dev->ieee80211_ptr);
+
+	mpriv = netdev_priv(dev);
+	local = mpriv->local;
+
 	queue = classify80211(skb, dev);
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;

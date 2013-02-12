Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710Ab3BLP7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:59:22 -0500
Message-ID: <1360684754.29913.2.camel@jlt4.sipsolutions.net> (sfid-20130212_165925_774884_678C37B3)
Subject: Re: [konusllaptop] [PATCH 1/1] Fix WPA with VLAN on AP side with ps
 client
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 12 Feb 2013 16:59:14 +0100
In-Reply-To: <1360684532.29913.1.camel@jlt4.sipsolutions.net> (sfid-20130212_165543_919575_FBCCF880)
References: <1360683806-15238-1-git-send-email-michael-dev@fami-braun.de>
	 <1360683806-15238-2-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130212_165247_002980_F5F59D43) <1360684532.29913.1.camel@jlt4.sipsolutions.net>
	 (sfid-20130212_165543_919575_FBCCF880)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 16:55 +0100, Johannes Berg wrote:
> On Tue, 2013-02-12 at 16:43 +0100, Michael Braun wrote:
> > When sending a broadcast while at least on of the connected stations is
> > sleeping, it gets queued and send after a DTIM beacon is sent.
> > If the packet was to be sent on a vlan interface, the vif used for dequeing
> > from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
> > required to use the correct per-vlan broadcast/multicast key.
> > 
> > This patch fixes this by restoring the per-vlan sdata using the skb->dev entry.
> > ---
> >  net/mac80211/tx.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index 2ef0e19..93681f5 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -2770,7 +2770,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
> >  				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
> >  		}
> >  
> > -		if (!ieee80211_tx_prepare(sdata, &tx, skb))
> > +		struct ieee80211_sub_if_data *frame_sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
> > +		if (!ieee80211_tx_prepare(frame_sdata, &tx, skb))
> 
> Please make your code warning-free and adhere to CodingStyle.

Also please provide a proper patch subject (i.e. "mac80211: fix ...")

johannes


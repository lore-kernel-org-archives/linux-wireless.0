Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab3BLQkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:40:11 -0500
Message-ID: <1360687205.29913.6.camel@jlt4.sipsolutions.net> (sfid-20130212_174015_632385_109B80FF)
Subject: Re: [PATCHv2 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 12 Feb 2013 17:40:05 +0100
In-Reply-To: <1360687114.29913.5.camel@jlt4.sipsolutions.net> (sfid-20130212_173850_784059_F68F7C1F)
References: <1360687038-17610-1-git-send-email-michael-dev@fami-braun.de>
	 <1360687038-17610-2-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130212_173731_351014_1564560C) <1360687114.29913.5.camel@jlt4.sipsolutions.net>
	 (sfid-20130212_173850_784059_F68F7C1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 17:38 +0100, Johannes Berg wrote:
> On Tue, 2013-02-12 at 17:37 +0100, Michael Braun wrote:
> > When sending a broadcast while at least on of the connected stations is
> > sleeping, it gets queued and send after a DTIM beacon is sent.
> > If the packet was to be sent on a vlan interface, the vif used for dequeing
> > from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
> > required to use the correct per-vlan broadcast/multicast key.
> > 
> > This patch fixes this by restoring the per-vlan sdata using the skb->dev entry.
> > 
> > Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> > 
> > V2: fix compile warning
> 
> That "V2" should be after the ---, but in any case:
> 
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -2728,6 +2728,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
> >  	struct ps_data *ps;
> >  	struct ieee80211_tx_info *info;
> >  	struct ieee80211_chanctx_conf *chanctx_conf;
> > +	struct ieee80211_sub_if_data *frame_sdata;
> 
> There's already an sdata variable, why not write *sdata, *frame_sdata?

Actually you could even just use it since it's not needed after getting
the "ps" pointer.

johannes


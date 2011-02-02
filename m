Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47955 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BBR17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 12:27:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 09:27:39 -0800
Date: Wed, 2 Feb 2011 22:57:07 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] mac80211: do not restart ps timer during scan or
 offchannel
Message-ID: <20110202172706.GA4712@vmraj-lnx.users.atheros.com>
References: <1296581526-3004-1-git-send-email-rmanoharan@atheros.com>
 <1296651590.5671.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1296651590.5671.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 06:29:50PM +0530, Johannes Berg wrote:
> On Tue, 2011-02-01 at 23:02 +0530, Rajkumar Manoharan wrote:
> > While leaving oper channel, STA informs sleep state to AP to
> > stop sending data. Till sending ack for the nullfunc, AP
> > continues to send the data to STA which restarts ps_timer that
> > is causing unnecessary nullfunc exchange on timer expiry
> > when the STA was already moved to offchannel. So don't restart ps_timer
> > on data reception during scan. This issue was identified by
> > the following warning.
> > 
> > WARNING: at net/mac80211/tx.c:661 invoke_tx_handlers+0xf07/0x1330 [mac80211]
> > wlan0: Dropped data frame as no usable bitrate found while scanning and
> > associated. Target station: 00:03:7f:0b:a6:1b on 5 GHz band
> > Call Trace:
> >   [<ffffffffa0413ba7>] invoke_tx_handlers+0xf07/0x1330 [mac80211]
> >   [<ffffffffa0414056>] ieee80211_tx+0x86/0x2c0 [mac80211]
> >   [<ffffffffa0414345>] ieee80211_xmit+0xb5/0x1d0 [mac80211]
> >   [<ffffffffa04037e0>] ieee80211_dynamic_ps_enable_work+0x0/0xb0 [mac80211]
> >   [<ffffffffa04158cf>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
> >   [<ffffffffa04026e6>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
> >   [<ffffffffa0403885>] ieee80211_dynamic_ps_enable_work+0xa5/0xb0 [mac80211]
> 
> But I suppose even during a HW scan we don't want mac80211 to
> modify PS state anyway, so I guess it's fine.
Yes. I meant that. Thanks for the review.

--
Rajkumar

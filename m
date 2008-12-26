Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38082 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYLZT5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 14:57:43 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/3] p54: fix WARN_ON at line 2247 of net/mac80211/rx.c
Date: Fri, 26 Dec 2008 20:57:27 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <200812261909.46094.chunkeey@web.de> <4955274D.30600@lwfinger.net>
In-Reply-To: <4955274D.30600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812262057.27962.chunkeey@web.de> (sfid-20081226_205750_110177_3B53A60D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 December 2008 19:49:49 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch hopefully fixes a mac80211<->p54 interaction problem, which was
> > described by Larry Finger (ref: http://marc.info/?l=linux-wireless&m=123009889327707 )
> > 
> > I guess the warning was triggered by pending frames in the receive queue,
> > while we're doing a band change 5GHz.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > ---
> > Larry,
> > 
> > Are you still hammering your p54usb, or have you finished testing p54(usb)'s stability?
> > Because I'm waiting for your confirmation for this one. hohohoho.
> 
> Merry Christmas (belated). Yes, this patch stopped the warnings, which started
> as a result of using the US, rather than world, regdom.
heh, do you have any 5Ghz APs in your neighborhood?

> There are some things p54usb cannot handle such as a simultaneous git pull and
> full kernel compilation with the source volumes mounted with NFS. That could be
> thermal, although I'm still worried about the O(1) allocations of skb's on
> machines with 4K page size. Should I prepare a patch to reduce rx_mtu in the
> critical cases?
Yes please! But why only for critical cases?

The NITRO features are useless anyway, so why don't limit rx_mtu to:
rx_mtu = priv->tx_hdr_len /* USB devices */ + sizeof(struct p54_rx_data) + 4 /* rx alignment */ + IEEE80211_MAX_RTS_THRESHOLD;
(Note: In theory IEEE80211_MAX_FRAG_THRESHOLD should be used instead of RTS_THRESHOLD, but its only 7 bytes more.)

Regards,
	Chr

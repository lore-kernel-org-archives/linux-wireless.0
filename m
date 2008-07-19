Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:16941 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYGSOce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:32:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so253351nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:32:32 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 deadlock detection triggering with rt61pci
Date: Sat, 19 Jul 2008 16:47:13 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1216197369.3422.5.camel@johannes.berg> <200807182120.47252.IvDoorn@gmail.com>
In-Reply-To: <200807182120.47252.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807191647.13517.IvDoorn@gmail.com> (sfid-20080719_163251_466215_0387C6BD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 July 2008, Ivo van Doorn wrote:
> Hi,
> 
> > I'm not sure whether this still happens in current versions or not, but
> > kerneloops is reporting a number of mac80211 warnings due to the TX
> > deadlock detection:
> > http://www.kerneloops.org/searchweek.php?search=ieee80211_master_start_xmit
> > 
> > The rt2x00 mac code seems fine, did it change recently which could
> > explain this warning triggering?
> 
> Interesting, the TX code did change for 2.6.27 recently with the DMA changes
> by GertJan, I think the Fedora kernels which are showing the above panics already
> contain those patches,
> 
> John, Does Fedora kernel 2.6.25.10-86.fc9.x86_64 contain rt2x00 2.1.8?
> 
> I also have some reports about a queue corruption in rt61pci and although I haven't
> figured out how that corruption is caused, I do think the above panics might somehow
> be related.

It might be me, but looking at those traces, aren't they triggered by:

static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
{
...
		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
			goto drop;
...
}

Which would suggest that when MAC80211_QOS is disabled, the skb_queue_mapping
still returns something higher then 1.

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:25152 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762248AbYDURXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:23:47 -0400
Received: by nf-out-0910.google.com with SMTP id g13so584512nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:23:44 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/9] rt2x00: Use rt2x00 queue numbering
Date: Mon, 21 Apr 2008 19:30:31 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com> <200804211900.47216.IvDoorn@gmail.com> <1208798232.26186.121.camel@johannes.berg>
In-Reply-To: <1208798232.26186.121.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804211930.31340.IvDoorn@gmail.com> (sfid-20080421_192440_047304_71763CFA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 April 2008, Johannes Berg wrote:
> Hi Ivo,
> 
> On Mon, 2008-04-21 at 19:00 +0200, Ivo van Doorn wrote:
> > Use the rt2x00 queue enumeration as much as possible,
> > removing the usage of the mac80211 queue numbering
> > wherever it is possible.
> > 
> > This makes it easier for mac80211 to change it queue
> > identification scheme without having to deal with
> > big changes in the rt2x00 code.
> 
> Cool, thanks a lot. One small note:
> 
> > +static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int queue)
> > +{
> > +	/* Regular TX queues are mapped directly */
> > +	if (queue < NUM_TX_DATA_QUEUES)
> > +		return queue;
> > +	else if (queue == IEEE80211_TX_QUEUE_BEACON)
> > +		return QID_BEACON;
> > +	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
> > +		return QID_ATIM;
> > +	return QID_OTHER;
> 
> Are you actually using TX_QUEUE_AFTER_BEACON? That queue number is a
> historical accident (imho) and not used, we actually use the
> IEEE80211_TXCTL_SEND_AFTER_DTIM tx control flag.

Actually both the checks for IEEE80211_TX_QUEUE_BEACON and IEEE80211_TX_QUEUE_AFTER_BEACON
are fake and only present for completeness.
rt2x00 does check for IEEE80211_TXCTL_SEND_AFTER_DTIM and will resolve it to QID_ATIM
if that queue is supported by the hardware (rt2400pci and rt2500pci) and resolves it to the control->queue
in all other cases.

> Also, with the QoS patch, those queue numbers should finally go away and
> mac80211 will not pass anything but the data queues, hence, this small
> inline would probably be reduced to "return queue;" by the patch.

This function only exists to move the translation in a single location.
When the translation isn't needed anymore because skb_get_queue_mapping(skb)
or something else is used, then this function can be removed completely. :)

Ivo

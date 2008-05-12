Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:44871 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbYELMPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 08:15:32 -0400
Received: by ug-out-1314.google.com with SMTP id h2so674183ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 05:15:28 -0700 (PDT)
To: johannes@sipsolutions.net
Subject: Re: [RFT/C 7/7] mac80211: move TX info into skb->cb
Date: Mon, 12 May 2008 14:26:12 +0200
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
References: <20080510221845.340428000@sipsolutions.net> <20080510221908.875473000@sipsolutions.net> <20080512.021145.265455571.davem@davemloft.net>
In-Reply-To: <20080512.021145.265455571.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805121426.12656.IvDoorn@gmail.com> (sfid-20080512_141536_167357_C5D6DF72)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 May 2008, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 11 May 2008 00:18:52 +0200
> 
> > This patch converts mac80211 and all drivers to have transmit
> > information and status in skb->cb rather than allocating extra
> > memory for it and copying all the data around. To make it fit,
> > a union is used where only data that is necessary for all steps
> > is kept outside of the union.
> > 
> > A number of fixes were done by Ivo, as well as the rt2x00 part
> > of this patch.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Please create an IEEE80211_SKB_CB() or similar macro to wrap
> these casts around with, like all other SKB CB users do.

Johannes, I have such a function in rt2x00queue.h:

static inline struct ieee80211_tx_info* get_skb_tx_info(struct sk_buff *skb)
{
	return (struct ieee80211_tx_info *)skb->cb;
}

You could rename it and move that one into mac80211.h

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:7069 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbXHUKN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:13:59 -0400
Received: by nf-out-0910.google.com with SMTP id g13so844055nfb
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 03:13:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 28/30] rt2x00: Always check if mac80211 requested TX status update
Date: Tue, 21 Aug 2007 12:21:23 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com> <200708192036.37330.IvDoorn@gmail.com> <1187630496.6923.0.camel@johannes.berg>
In-Reply-To: <1187630496.6923.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708211221.24172.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 20 August 2007, Johannes Berg wrote:
> On Sun, 2007-08-19 at 20:36 +0200, Ivo van Doorn wrote:
> 
> > During txdone always check for the IEEE80211_TXCTL_REQ_TX_STATUS flag
> > to determine if ieee80211_tx_status_irqsafe should be called or not.
> > When the flag is not set, just cleanup the skb and don't bother
> > mac80211 with it.
> 
> Never mind that I'd love to remove the REQ_TX_STATUS flag, this is not
> really the best thing to do since rate control will basically ignore
> this frame if you don't hand it back to mac80211.

Ok, I'll revert that check for rt2x00 2.0.8

Thanks,

Ivo

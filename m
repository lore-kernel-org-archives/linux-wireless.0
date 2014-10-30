Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12483 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbaJ3JWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 05:22:10 -0400
Date: Thu, 30 Oct 2014 14:54:09 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: handle ieee80211 header and payload tracing
 separately
Message-ID: <20141030092408.GA20221@qca.qualcomm.com> (sfid-20141030_102214_363834_473530CB)
References: <1414591778-19040-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1414595144.1827.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1414595144.1827.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2014 at 04:05:44PM +0100, Johannes Berg wrote:
> On Wed, 2014-10-29 at 19:39 +0530, Rajkumar Manoharan wrote:
> 
> > +	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);
> 
> > +	trace_ath10k_rx_hdr(ar, hdr, hdr_len);
> > +	trace_ath10k_rx_payload(ar, skb->data + hdr_len, skb->len - hdr_len);
> 
> Another note, since you're taking my suggestion :-)
> 
> It would be worth hiding that inside the tracepoint's assign function,
> so instead of passing data/len here you'd pass the full skb, or the full
> skb data/skb len, like this:
> 
> ar, skb->data, skb->len
> 
> to both tracers. Then inside the tracer you can do the hdrlen check, and
> that way move the code into the tracing so it's not hit when tracing is
> disabled.
> 
Nice. Let me send v2. Thanks once again.

-Rajkumar

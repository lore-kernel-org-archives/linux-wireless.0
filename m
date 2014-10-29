Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38451 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbaJ2PF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:05:56 -0400
Message-ID: <1414595144.1827.5.camel@jlt4.sipsolutions.net> (sfid-20141029_160600_117307_D1DE256A)
Subject: Re: [PATCH] ath10k: handle ieee80211 header and payload tracing
 separately
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 29 Oct 2014 16:05:44 +0100
In-Reply-To: <1414591778-19040-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141029_151355_898518_23CAA0BF)
References: <1414591778-19040-1-git-send-email-rmanohar@qti.qualcomm.com>
	 (sfid-20141029_151355_898518_23CAA0BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 19:39 +0530, Rajkumar Manoharan wrote:

> +	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);

> +	trace_ath10k_rx_hdr(ar, hdr, hdr_len);
> +	trace_ath10k_rx_payload(ar, skb->data + hdr_len, skb->len - hdr_len);

Another note, since you're taking my suggestion :-)

It would be worth hiding that inside the tracepoint's assign function,
so instead of passing data/len here you'd pass the full skb, or the full
skb data/skb len, like this:

ar, skb->data, skb->len

to both tracers. Then inside the tracer you can do the hdrlen check, and
that way move the code into the tracing so it's not hit when tracing is
disabled.

johannes


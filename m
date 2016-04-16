Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60435 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbcDPW3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 18:29:34 -0400
Message-ID: <1460845772.2075.31.camel@sipsolutions.net> (sfid-20160417_002937_039506_B9708557)
Subject: Re: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	codel@lists.bufferbloat.net, apenwarr@gmail.com
Date: Sun, 17 Apr 2016 00:29:32 +0200
In-Reply-To: <1460636302-31161-5-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141633_010548_89F4FC06)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-5-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160414_141633_010548_89F4FC06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
> 
> +				struct ieee80211_vif *vif;
> +
> +				/* When packets are enqueued on txq
> it's easy
> +				 * to re-construct the vif pointer.
> There's no
> +				 * more space in tx_info so it can
> be used to
> +				 * store the necessary enqueue time
> for packet
> +				 * sojourn time computation.
> +				 */
> +				u64 enqueue_time;
> +			};

I wonder if we could move something like the hw_key into tx_control
instead?

johannes

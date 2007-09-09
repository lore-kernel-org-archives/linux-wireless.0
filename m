Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:54398 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbXIIKFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 06:05:31 -0400
Date: Sun, 9 Sep 2007 12:05:30 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: zd-mac80211: Fix TX status reports.
Message-ID: <20070909100530.GB12021@deine-taler.de>
References: <200709082341.31720.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709082341.31720.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:

> Automatic rate scaling does not work on the zd-mac80211 driver.
> The driver does not properly report succeed and failed frames
> to mac80211.
> 
> We need to indicate failed frames with the excessive_retries field
> (Should we also fake report some high retry count here?)
> Otherwise the rc algo is not able to scale down.
> 
> Remove the conditional in REQ_TX_STATUS, as mac80211 handles that internally.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Just a general remark: The ZD1211 device doesn't support TX status
reporting directly. The driver emulates this by getting ACK
packets and transmission failures reported. The driver simply
reports them in sequence to transmitted packets without having a
reliable way to verify that the ACK packet or the failure report
actually belongs to the packet for which the status is reported.
This is error-prone. A typical problem are several correct ACKs
received for the same packet. In such a situation the driver loses
the synchronization of status and transmitted packets. If the
mac80211 stack uses the returned status for more than statistics,
this may cause bugs.

The mac80211 stack currently requires the driver to support
semantics it has no way to support correctly without harming
performance. (There is the option to transmit one packet and wait
a fixed time to report the success of the packet.)

It should also be noted that requiring the device to report ACK
packets to the host takes USB bandwidth away and increases also
the interrupt load on the host. There is a measurable impact
depending on the type of USB interface and the speed of the host
processor.

An alternative option could be that the mac80211 stack would call
a non-atomic function of the driver to report the total count of
transmitted packets and the number of successful transmissions.
The driver could even use counters maintained by the device to
support this. In specific cases where a status is required and
performance is not an issue (association) a reliable status report
mode could be supported, but this would add complexity to the
driver. I understand that this would require invasive changes to
the mac80211 stack, but I believe this change would be the right
thing.

> Johannes, to me it seems that there's also a bug in mac80211.
> I never get a frame with the REQ_TX_STATUS bit set, so frames
> will always end up on the "unreliable" tx status queue.

It appears that the patch tries to fix this by ignoring
REQ_TX_STATUS. See below.

> @@ -356,19 +357,18 @@ static int init_tx_skb_control_block(str
>   * If no status information has been requested, the skb is freed.
>   */
>  static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
> -	              struct ieee80211_tx_status *status)
> +	              struct ieee80211_tx_status *status,
> +		      bool success)
>  {
>  	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
>  		skb->cb;
>  
>  	ZD_ASSERT(cb->control != NULL);
> -	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
> -		memcpy(&status->control, cb->control, sizeof(status->control));
> -		clear_tx_skb_control_block(skb);
> -		ieee80211_tx_status_irqsafe(hw, skb, status);
> -	} else {
> -		kfree_tx_skb(skb);
> -	}
> +	memcpy(&status->control, cb->control, sizeof(status->control));
> +	if (!success)
> +		status->excessive_retries = 1;
> +	clear_tx_skb_control_block(skb);
> +	ieee80211_tx_status_irqsafe(hw, skb, status);
>  }


-- 
Uli Kunitz

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36258
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbXIILBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 07:01:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: zd-mac80211: Fix TX status reports.
Date: Sun, 9 Sep 2007 12:58:56 +0200
Cc: Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200709082341.31720.mb@bu3sch.de> <20070909100530.GB12021@deine-taler.de>
In-Reply-To: <20070909100530.GB12021@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709091259.00237.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 September 2007 12:05:30 Ulrich Kunitz wrote:
> Just a general remark: The ZD1211 device doesn't support TX status
> reporting directly. The driver emulates this by getting ACK
> packets and transmission failures reported. The driver simply
> reports them in sequence to transmitted packets without having a
> reliable way to verify that the ACK packet or the failure report
> actually belongs to the packet for which the status is reported.
> This is error-prone. A typical problem are several correct ACKs
> received for the same packet. In such a situation the driver loses
> the synchronization of status and transmitted packets. If the
> mac80211 stack uses the returned status for more than statistics,
> this may cause bugs.
[snip]
> An alternative option could be that the mac80211 stack would call
> a non-atomic function of the driver to report the total count of
> transmitted packets and the number of successful transmissions.
> The driver could even use counters maintained by the device to
> support this. In specific cases where a status is required and
> performance is not an issue (association) a reliable status report
> mode could be supported, but this would add complexity to the
> driver. I understand that this would require invasive changes to
> the mac80211 stack, but I believe this change would be the right
> thing.

Basically, the TX status report is only useful for the rate control
algorithm. So it's basically "only" statistics. But we have to
get these statistics approximately right to get the RC algo working
correctly. That is what this patch does. With it, the RC algo properly
scales up and down if the signal gets better or worse.

> > Johannes, to me it seems that there's also a bug in mac80211.
> > I never get a frame with the REQ_TX_STATUS bit set, so frames
> > will always end up on the "unreliable" tx status queue.
> 
> It appears that the patch tries to fix this by ignoring
> REQ_TX_STATUS. See below.

Well, I think the driver should ignore that flag in any case, as
mac80211 does handle it internally.
Especially on devices like the zd, which don't support TX status
reporting in hw, we should gather as much information as possible
and pass it to mac80211 to get the RC algorithm working.
mac80211 will handle the unrequested status requests with more care,
so that's OK.

> > @@ -356,19 +357,18 @@ static int init_tx_skb_control_block(str
> >   * If no status information has been requested, the skb is freed.
> >   */
> >  static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
> > -	              struct ieee80211_tx_status *status)
> > +	              struct ieee80211_tx_status *status,
> > +		      bool success)
> >  {
> >  	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
> >  		skb->cb;
> >  
> >  	ZD_ASSERT(cb->control != NULL);
> > -	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
> > -		memcpy(&status->control, cb->control, sizeof(status->control));
> > -		clear_tx_skb_control_block(skb);
> > -		ieee80211_tx_status_irqsafe(hw, skb, status);
> > -	} else {
> > -		kfree_tx_skb(skb);
> > -	}
> > +	memcpy(&status->control, cb->control, sizeof(status->control));
> > +	if (!success)
> > +		status->excessive_retries = 1;
> > +	clear_tx_skb_control_block(skb);
> > +	ieee80211_tx_status_irqsafe(hw, skb, status);
> >  }
> 
> 



-- 
Greetings Michael.

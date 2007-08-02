Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40499
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbXHBT7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 15:59:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC V3] bcm43xx-mac80211: Provide information to allow transmission rate decreases
Date: Thu, 2 Aug 2007 21:59:44 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <46b1fa6d.d4l4DujAaAR2ORZf%Larry.Finger@lwfinger.net> <200708021805.17004.mb@bu3sch.de> <46B23422.3050207@lwfinger.net>
In-Reply-To: <46B23422.3050207@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708022159.44422.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007, Larry Finger wrote:
> Michael Buesch wrote:
> > On Thursday 02 August 2007, Larry Finger wrote:
> >> Michael,
> >>
> >> I couldn't find any long/short indication in the header, so I added a bool that
> >> is set when the frame is sent.
> > 
> > This is not going to work.
> > 
> > But we can do this differently.
> > You can do something like:
> > 
> > if (!status->acked && !tx_control->noack)
> > 	excessive_retries = 1;
> > 
> > So we don't need to care about the retry count.
> > 
> > Anyway. I don't know why we need excessive_retries _at_ _all_.
> > The rc algorithm does already know if the frame succeed or failed
> > anyway.
> 
> Is this what you had in mind?
> 
> Larry
> 
> 
> @@ -1311,6 +1311,9 @@ void bcm43xx_dma_handle_txstatus(struct
>                           */
>                          if (status->acked)
>                                  meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
> +                       else
> +                               if (!(meta->txstat.flags & IEEE80211_TXCTL_NO_ACK))
> +                                       meta->txstat.excessive_retries = 1;
>                          meta->txstat.retry_count = status->frame_count - 1;
>                          ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
>                          /* skb is freed by ieee80211_tx_status_irqsafe() */


Yeah, looks good. If you correctly diff that up, I'll queue it up for
the next submission to John.

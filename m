Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53129 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095AbXHBTof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 15:44:35 -0400
Message-ID: <46B23422.3050207@lwfinger.net>
Date: Thu, 02 Aug 2007 14:44:34 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC V3] bcm43xx-mac80211: Provide information to allow transmission  rate decreases
References: <46b1fa6d.d4l4DujAaAR2ORZf%Larry.Finger@lwfinger.net> <200708021805.17004.mb@bu3sch.de>
In-Reply-To: <200708021805.17004.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 02 August 2007, Larry Finger wrote:
>> Michael,
>>
>> I couldn't find any long/short indication in the header, so I added a bool that
>> is set when the frame is sent.
> 
> This is not going to work.
> 
> But we can do this differently.
> You can do something like:
> 
> if (!status->acked && !tx_control->noack)
> 	excessive_retries = 1;
> 
> So we don't need to care about the retry count.
> 
> Anyway. I don't know why we need excessive_retries _at_ _all_.
> The rc algorithm does already know if the frame succeed or failed
> anyway.

Is this what you had in mind?

Larry


@@ -1311,6 +1311,9 @@ void bcm43xx_dma_handle_txstatus(struct
                          */
                         if (status->acked)
                                 meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+                       else
+                               if (!(meta->txstat.flags & IEEE80211_TXCTL_NO_ACK))
+                                       meta->txstat.excessive_retries = 1;
                         meta->txstat.retry_count = status->frame_count - 1;
                         ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
                         /* skb is freed by ieee80211_tx_status_irqsafe() */

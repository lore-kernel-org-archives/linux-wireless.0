Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab2CPMoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:44:14 -0400
Subject: Re: [mac80211] UAPSD: WLAN_STA_PS flag  cleared prematurely?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F630757.6070901@etit.tu-chemnitz.de>
References: <4F630757.6070901@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 13:44:12 +0100
Message-ID: <1331901852.6753.2.camel@jlt3.sipsolutions.net> (sfid-20120316_134417_721543_CB1C9BF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 10:26 +0100, Marco Porsch wrote:
> Hi all,
> 
> in sta_info.c : ieee80211_sta_ps_deliver_response the 
> IEEE80211_TX_STATUS_EOSP is set for all to-be-sent frames, not only for 
> the last. But only the last buffered frame actually gets the EOSP flag.
> 
> 
> /* set EOSP for the frame */
> if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
>      qoshdr && skb_queue_empty(&frames))
> 	*qoshdr |= IEEE80211_QOS_CTL_EOSP;
> 
> info->flags |= IEEE80211_TX_STATUS_EOSP |
>         IEEE80211_TX_CTL_REQ_TX_STATUS;
> 
> 
> Consequence is, that the WLAN_STA_SP flag gets cleared (multiple times) 
> in ieee80211_tx_status before the last frame with EOSP has been sent.
> Is this correct?

Looks like the bug is above, the EOSP/TX_STATUS should only be set for
the last frame?

johannes


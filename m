Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:49536 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764933AbZAOTmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 14:42:38 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Thu, 15 Jan 2009 20:42:42 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901151953.49053.chunkeey@web.de> <496F8A83.8000605@gmail.com>
In-Reply-To: <496F8A83.8000605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901152042.42372.chunkeey@web.de> (sfid-20090115_204256_663053_4ABBFB24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 20:12:03 Artur Skawina wrote:
> Christian Lamparter wrote:
> >> tried reproducing (using the old w-t/pending pull) on different machine,
> >> but no oops or crash there...
> >> (similar connectivity issues though, such as connecting only works
> >> exactly once after starting hostapd, to reconnect i have to restart
> >> hostapd)
> > hmm, maybe Windows Mobile uses another PS mechanism, e.g WMM-PS.
> 
> hmm, i'll have to set up another device to sniff the traffic i guess.
probably... or do you have another client with a mac80211 driver?

> >> Upgraded to current wireless-testing/pending on the problematic box
> >> and almost immediately got [1]. No slab corruption this time (at least
> >> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.
> >>
> >> artur
> > yes that's a bug, p54_set_tim must use GFP_ATOMIC, do you want to post the patch?
> 
> nah, too trivial :) fwiw i used this:
well, it should be "done", right? :-)

just add "John W. Linville" <linville@tuxdriver.com>" to the cc,
change the subject line to "[PATCH] p54: set_tim must be atomic."
and put a Signed-off-by: your name <your@mail> in the mail body and a "---" to seperate the commit message
and then the patch. And it will be in the next round of -rcX fixes.
 
> diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> index 635b423..579bc6c 100644
> --- a/drivers/net/wireless/p54/p54common.c
> +++ b/drivers/net/wireless/p54/p54common.c
> @@ -1295,7 +1295,7 @@ static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
>  	struct p54_tim *tim;
>  
>  	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*tim),
> -			    P54_CONTROL_TYPE_TIM, GFP_KERNEL);
> +			    P54_CONTROL_TYPE_TIM, GFP_ATOMIC);
>  	if (!skb)
>  		return -ENOMEM;

Regards,
	Chr

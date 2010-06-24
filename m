Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57291 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab0FXQUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 12:20:39 -0400
Received: by fxm3 with SMTP id 3so493490fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 09:20:37 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Thu, 24 Jun 2010 18:20:03 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com> <1277394714.3870.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1277394714.3870.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006241820.03539.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 24 Juni 2010 schrieb Johannes Berg:
>  a) You get a new beacon from mac80211 each time you send it. Then you
>     don't have to worry about the set_tim() callback at all -- don't
>     assign it!
> 
>  b) You need to get a new beacon frame from mac80211 only when it
>     changes. You can do this from set_tim(). HOWEVER: since you're not
>     getting a new one from mac80211 all the time anyway, you NEED to
>     have the driver or firmware overwrite the DTIM count, like b43's
>     firmware for example will do.
> 
> Ok so maybe there are more possibilities like the firmware filling the
> TIM IE differently and you would use set_tim() differently then.
> 
> However, *fundamentally*, any time you don't get a new skb from mac80211
> for each transmitted beacon you NEED to overwrite the DTIM count in it.

So, to answer my own question:

mac80211 behaves as designed and we need to fix rt2x00 to correctly update
the DTIM parameters when we stick to the set_tim callback for updating the
beacon template (option b).

Or we would implement option a) to get a new beacon prior to transmission
and would get a correct DTIM count from mac80211.

Thanks for the clarification,
Helmut

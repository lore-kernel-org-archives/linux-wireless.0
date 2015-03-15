Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:32926 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbCORSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 13:18:13 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Florian Westphal <fw@strlen.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH next] drivers: wireless: carl9170: shrink carl9170_tx_info
Date: Sun, 15 Mar 2015 18:17:56 +0100
Message-ID: <2002983.Zu6fLi5xz6@debian64> (sfid-20150315_181818_584510_ECF0ACD0)
In-Reply-To: <20150314175532.GH14761@breakpoint.cc>
References: <1426261045-22373-1-git-send-email-fw@strlen.de> <1689955.Ikz24aORLX@debian64> <20150314175532.GH14761@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, March 14, 2015 06:55:32 PM Florian Westphal wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Friday, March 13, 2015 04:37:25 PM Florian Westphal wrote:
> > > its embededded inside rate_driver_data of the ieee80211_tx_info struct,
> > > which in turn is stored in skb->cb[].
> > > 
> > > In order to shrink cb, we need to shrink ieee80211_tx_info which means
> > > to downsize all users first.
> > > 
> > > Alternatively, one might be able to remove kref but
> > > its less intrusive/simpler to use u32 for timeout handling.
> > > 
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > u32 jiffies... that's a lot of pointing (well not so much) and really 
> > ugly casting (a lot). I guess it would be easier to just use a "per-queue"
> > timeout watchdog like almost everybody else. This way, the driver will
> > be ready for the next skb->cb shrink as well.
> > 
> > carl9170_tx_ampdu_timeout can be completely removed.
> 
> Maybe, but there is only so much I am willing to do with "compile
> tested only" patches...
well, reinventing jiffies_32 is just a ugly hack and not "intrusive/simpler"
than removing kref here.

Please try again. Don't worry about testing, I'm sure this is not a problem
and someone will test the patches with the hw on 32-bit and 64-bit platforms.

Regards,
  Christian

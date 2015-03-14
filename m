Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59400 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbbCNRzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 13:55:35 -0400
Date: Sat, 14 Mar 2015 18:55:32 +0100
From: Florian Westphal <fw@strlen.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Florian Westphal <fw@strlen.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH next] drivers: wireless: carl9170: shrink carl9170_tx_info
Message-ID: <20150314175532.GH14761@breakpoint.cc> (sfid-20150314_185542_856026_C022EDBE)
References: <1426261045-22373-1-git-send-email-fw@strlen.de>
 <1689955.Ikz24aORLX@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1689955.Ikz24aORLX@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> On Friday, March 13, 2015 04:37:25 PM Florian Westphal wrote:
> > its embededded inside rate_driver_data of the ieee80211_tx_info struct,
> > which in turn is stored in skb->cb[].
> > 
> > In order to shrink cb, we need to shrink ieee80211_tx_info which means
> > to downsize all users first.
> > 
> > Alternatively, one might be able to remove kref but
> > its less intrusive/simpler to use u32 for timeout handling.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> u32 jiffies... that's a lot of pointing (well not so much) and really 
> ugly casting (a lot). I guess it would be easier to just use a "per-queue"
> timeout watchdog like almost everybody else. This way, the driver will
> be ready for the next skb->cb shrink as well.
> 
> carl9170_tx_ampdu_timeout can be completely removed.

Maybe, but there is only so much I am willing to do with "compile
tested only" patches...

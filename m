Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65408 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYLSO1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:27:48 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 06:27:48 -0800
Date: Fri, 19 Dec 2008 19:55:49 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP as
	pairwise cipher
Message-ID: <20081219142549.GA22031@vasanth-lnx.users.atheros.com> (sfid-20081219_152752_453632_3878D052)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <1229692655.3601.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1229692655.3601.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 06:47:34PM +0530, Johannes Berg wrote:
> On Fri, 2008-12-19 at 18:40 +0530, Vasanthakumar Thiagarajan wrote:
> > IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
> > Connect in non-ht mode if either of these ciphers is cofigured as
> > pairwise.

> >  net/mac80211/ieee80211_i.h |    1 +
> >  net/mac80211/mlme.c        |    9 ++++++++-
> >  net/mac80211/wext.c        |    5 ++++-
> >  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> Needs to touch cfg.c too, I think? 

I think you are referring to populating ucast_cipher in 
add_key() hook in cfg.c but we need the pairwise cipher before
starting the association in HT mode.

>I'd also prefer to avoid using the
> wext constants throughout mac80211.

ok.
> 
> johannes

Thanks for your comments.

Vasanth



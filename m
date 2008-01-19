Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:37645 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756210AbYASCnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 21:43:40 -0500
From: bruno randolf <bruno@thinktube.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/4] ath5k: debug level improvements
Date: Sat, 19 Jan 2008 11:43:51 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <20080118125018.6342.94435.stgit@one> <4790A1CA.2010004@gmail.com>
In-Reply-To: <4790A1CA.2010004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801191143.52210.bruno@thinktube.com> (sfid-20080119_024344_342633_228F41C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 January 2008 21:55:38 Jiri Slaby wrote:
> On 01/18/2008 01:50 PM, Bruno Randolf wrote:
> > * use only one debug level for beacon debugging: unify ATH5K_DEBUG_BEACON
> > and ATH5K_DEBUG_BEACON_PROC
> >
> > * remove debug level ATH5K_DEBUG_FATAL. doesn't make sense as a debug
> > level - if it's fatal it should be logged as an error.
> >
> > * fancier printing of debug levels. cat /debugfs/ath5k/phy0/debug
> >
> > * allow debug levels to be changed by echoing their name into
> > /debugfs/ath5k/phy0/debug. this will toggle the state, when it was off it
> > will be turned on and vice versa.
> >
> > drivers/net/wireless/ath5k/base.c:      Changes-licensed-under:
> > 3-Clause-BSD drivers/net/wireless/ath5k/debug.c:    
> > Changes-licensed-under: GPL drivers/net/wireless/ath5k/debug.h:    
> > Changes-licensed-under: GPL
> >
> > Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> > ---
>
> [...]
>
> > +#define TOGGLE_BIT(_x, _m) (_x) = (_x) & (_m) ? (_x) & ~(_m) : (_x) |
> > (_m)
>
> simple XOR :)?
>
> _x ^= _m;

oh yeah, looks much better :)
thanks! 

bruno

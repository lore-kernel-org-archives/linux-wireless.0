Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2JISmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:42:21 -0400
Message-ID: <1349808165.4683.15.camel@jlt4.sipsolutions.net> (sfid-20121009_204225_434460_F893E8C2)
Subject: Re: [PATCH v3 7/7] mac80211: add DFS support to monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 09 Oct 2012 20:42:45 +0200
In-Reply-To: <CAK80WHY=YiKBcLgZFJjEEVFk6ncHniPXzWWvKywEGVNLm4C8Kw@mail.gmail.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-8-git-send-email-victorg@ti.com>
	 <1347276361.4272.20.camel@jlt4.sipsolutions.net>
	 <CAK80WHY=YiKBcLgZFJjEEVFk6ncHniPXzWWvKywEGVNLm4C8Kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 15:54 +0200, Goldenshtein, Victor wrote:
> On Mon, Sep 10, 2012 at 2:26 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
> >> AP mode uses monitor interfaces to transmit
> >> management frames which were blocked for "radar
> >> channels" until now.
> >>
> >> Stop dropping packets if we are on 'radar channel'
> >> and the DFS is enabled.
> >
> > Umm, no? Check for dfs_en_tx().
> >
> 
> no need, the AP is started only after the dfs_en_tx().

but this is on monitor mode, no? and monitor mode isn't used just for
AP. In fact, AP no longer even uses monitor mode, so you don't need this
at all since you should be working with a new hostapd version that will
get the DFS feature ... and then you're working on a current version
that already no longer uses monitor mode for DFS. Both kernel & hostapd
have to be new enough, so monitor mode won't be used...

johannes


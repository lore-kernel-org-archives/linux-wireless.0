Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29284 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0ACGEj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 01:04:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 22:04:39 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Message-ID: <19264.14181.214609.819450@gargle.gargle.HOWL>
Date: Sun, 3 Jan 2010 11:51:25 +0530
To: Bob Copeland <me@bobcopeland.com>
CC: <lucisandor@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] var/log/messages filling quickly
In-Reply-To: <b6c5339f0912301049r773e083do6afd182eb7ad993c@mail.gmail.com>
References: <c775b4470912300642o2457d712m20dfb48c4c3508df@mail.gmail.com>
	<b6c5339f0912301049r773e083do6afd182eb7ad993c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Wed, Dec 30, 2009 at 9:42 AM, Lucian  andor <lucisandor@gmail.com> wrote:
> > Hi all,
> > I run an Ad-hoc network, using a SuSE 11.2 computer, kernel 2.6.32-5.5
> > from SuSE (probably modifed by them.) If I turn off all the other
> > computers in the network, the ath5k/kernel combination writes 20 times
> > per second to the system log /var/log/messages:
> >
> > Dec 28 14:10:31 battlecruiser kernel: [  929.933020] wlan0: No active
> > IBSS STAs - trying to scan for other IBSS networks with same SSID
> > (merge)
> 
> Turn off CONFIG_MAC80211_IBSS_DEBUG in the kernel config
> (or ask SuSE to do the same).  You can't turn it off at
> runtime, but you could turn off kernel debug messages in
> syslogd.
> 
> However, this is only supposed to happen every 30s if I
> read the code right.  Maybe someone on linux-wireless
> knows how this can happen?

This patch (in Linus' tree) apparently didn't make it to 2.6.32.

commit 450aae3d7b60a970f266349a837dfb30a539198b
Author: Sujith <Sujith.Manoharan@atheros.com>
Date:   Mon Nov 2 12:33:23 2009 +0530

    mac80211: Fix IBSS merge

    Currently, in IBSS mode, a single creator would go into
    a loop trying to merge/scan. This happens because the IBSS timer is
    rearmed on finishing a scan and the subsequent
    timer invocation requests another scan immediately.

    This patch fixes this issue by checking if we have just completed
    a scan run trying to merge with other IBSS networks.

    Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Sujith

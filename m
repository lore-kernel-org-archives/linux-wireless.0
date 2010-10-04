Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37822 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0JDSfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 11:35:25 -0700
Message-ID: <AANLkTimUdaUkpXmNt5mPkCdWmHvBbXWA6smAP4U80yc4@mail.gmail.com>
Subject: Re: 2.6.36-rc6-git2: Reported regressions from 2.6.35
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: justinmattock@gmail.com, Bob Copeland <me@bobcopeland.com>,
	Pavel Machek <pavel@ucw.cz>, linux@brodo.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below are the 802.11 and Bluetooth ones:

On Sun, Oct 3, 2010 at 2:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=19392
> Subject         : WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2010-09-28 22:30 (6 days old)
> Message-ID      : <AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=128571307018635&w=2

WTF -- this ended up in a bisect pointing to some PCMCIA patch! Justin:

  * does this happen with wireless-testing.git ?
  * Did you do the bisect on the entire kernel? What git tree are you
using to bisect?

Did you simply bring up the interface and then suspsend? Did you not
add a new interface in between this? ath5k's add_interace has:

        if (sc->vif) {
                ret = 0;
                goto end;
        }

But why does it just allow this to go through without complaining if
multiple vifs are not supported?


>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17061
> Subject         : 2.6.36-rc1 on zaurus: bluetooth regression
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2010-08-21 15:24 (44 days old)
> Message-ID      : <20100821152445.GA1536@ucw.cz>
> References      : http://marc.info/?l=linux-kernel&m=128240433828087&w=2

I see no updates to this since August. There are boat load of PCMCIA
changes recently, is bisect possible here?


> Regressions with patches
> ------------------------


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17722
> Subject         : 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
> Submitter       : Thomas Meyer <thomas@m3y3r.de>
> Date            : 2010-08-31 20:14 (34 days old)
> Message-ID      : <201008312214.52473.thomas@m3y3r.de>
> References      : http://marc.info/?l=linux-kernel&m=128328580504227&w=2
>                  http://www.spinics.net/lists/netdev/msg140769.html
> Handled-By      : Florian Mickler <florian@mickler.org>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=31671

This seems fixed.

  Luis
